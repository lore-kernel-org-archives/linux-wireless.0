Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f172.google.com ([209.85.192.172]:35731 "EHLO
        mail-pf0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752689AbdGGAxH (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Jul 2017 20:53:07 -0400
Received: by mail-pf0-f172.google.com with SMTP id c73so8815999pfk.2
        for <linux-wireless@vger.kernel.org>; Thu, 06 Jul 2017 17:53:06 -0700 (PDT)
Date: Thu, 6 Jul 2017 17:53:03 -0700
From: Brian Norris <briannorris@chromium.org>
To: jeffy <jeffy.chen@rock-chips.com>
Cc: Amitkumar Karwar <akarwar@marvell.com>,
        linux-wireless@vger.kernel.org, Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>, rajatja@google.com,
        dmitry.torokhov@gmail.com, Bjorn Helgaas <bhelgaas@google.com>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: Re: [v4,3/3] mwifiex: Enable WoWLAN for both sdio and pcie
Message-ID: <20170707005302.GA17921@google.com> (sfid-20170707_025312_942087_20F2B281)
References: <1479216964-3328-3-git-send-email-akarwar@marvell.com>
 <595A207D.3000804@rock-chips.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <595A207D.3000804@rock-chips.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 03, 2017 at 06:46:21PM +0800, Jeffy Chen wrote:
> Hi guys,
> 
> with this patch, the pci device's irq might be override by this
> wakeup irq when not using msi:

Hmm, good point. I believe I noticed this one at some point and then
didn't get to investigate further...

It kind of seems like we inadvertently conflicted with the PCI OF
interrupt spec [1]. There, the "interrupts" property for a device (if
present) is supposed to represent INT{A...D} with values of {1...4}.
IIUC, there should only be a single entry in this property.

If we were to extend this properly, I guess that would mean we'd need a
second "interrupts" entry, with a different parent. I think we can use
"interrupts-extended" for that.

So we'd need to document an optional "interrupt-names" for Marvell, and
have the driver try that first. The rough outline would be something
like this.

For the device tree (e.g., rk3399-gru):

-			interrupt-parent = <&gpio0>;
-			interrupts = <8 IRQ_TYPE_LEVEL_LOW>;
+			interrupts-extended = <&pcie0 1>, <&gpio0 8 IRQ_TYPE_LEVEL_LOW>;
+			interrupt-names = "int-A", "wake";

Then mwifiex would need to check "byname" before trying "by index":

	adapter->irq_wakeup = of_irq_get_byname(adapter->dt_node, "wake");
	if (!adapter->irq_wakeup) {
		adapter->irq_wakeup = irq_of_parse_and_map(adapter->dt_node, 0);
		if (!adapter->irq_wakeup) {
			dev_dbg(dev, "fail to parse irq_wakeup from device tree\n");
			goto err_exit;
		}
	}

Or if we want to suggest the original binding was wrong and that we
should just ignore existing device trees that tried to use it, we can
skip the by-index fallback.

Brian

[1] Documentation/devicetree/bindings/pci/pci.txt points to
http://www.firmware.org/1275/practice/imap/imap0_9d.pdf
except that link is also dead now. I found the same doc here:
https://www.openfirmware.info/data/docs/rec.intmap.d09.pdf
Might want to update the binding doc... I've sent a patch for that
separately.
