Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from regular1.263xmail.com ([211.150.99.138]:42098 "EHLO
        regular1.263xmail.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753296AbdGGDEn (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 6 Jul 2017 23:04:43 -0400
Message-ID: <595EFA40.1080405@rock-chips.com> (sfid-20170707_050447_430169_FE7CE0CA)
Date: Fri, 07 Jul 2017 11:04:32 +0800
From: jeffy <jeffy.chen@rock-chips.com>
MIME-Version: 1.0
To: Brian Norris <briannorris@chromium.org>
CC: Amitkumar Karwar <akarwar@marvell.com>,
        linux-wireless@vger.kernel.org, Cathy Luo <cluo@marvell.com>,
        Nishant Sarmukadam <nishants@marvell.com>, rajatja@google.com,
        dmitry.torokhov@gmail.com, Bjorn Helgaas <bhelgaas@google.com>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: Re: [v4,3/3] mwifiex: Enable WoWLAN for both sdio and pcie
References: <1479216964-3328-3-git-send-email-akarwar@marvell.com> <595A207D.3000804@rock-chips.com> <20170707005302.GA17921@google.com>
In-Reply-To: <20170707005302.GA17921@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi brian,

On 07/07/2017 08:53 AM, Brian Norris wrote:
> On Mon, Jul 03, 2017 at 06:46:21PM +0800, Jeffy Chen wrote:
>> Hi guys,
>>
>> with this patch, the pci device's irq might be override by this
>> wakeup irq when not using msi:
>
> Hmm, good point. I believe I noticed this one at some point and then
> didn't get to investigate further...
>
> It kind of seems like we inadvertently conflicted with the PCI OF
> interrupt spec [1]. There, the "interrupts" property for a device (if
> present) is supposed to represent INT{A...D} with values of {1...4}.
> IIUC, there should only be a single entry in this property.
>
> If we were to extend this properly, I guess that would mean we'd need a
> second "interrupts" entry, with a different parent. I think we can use
> "interrupts-extended" for that.
>
> So we'd need to document an optional "interrupt-names" for Marvell, and
> have the driver try that first. The rough outline would be something
> like this.
>
> For the device tree (e.g., rk3399-gru):
>
> -			interrupt-parent = <&gpio0>;
> -			interrupts = <8 IRQ_TYPE_LEVEL_LOW>;
> +			interrupts-extended = <&pcie0 1>, <&gpio0 8 IRQ_TYPE_LEVEL_LOW>;
> +			interrupt-names = "int-A", "wake";
This is a great idea.

And how about also add a property to tell of_pci_irq to ignore of irq 
and force using PCI_INTERRUPT_PIN? Since there might be devices don't 
use pci irq, but using other irq(wowlan for example).

Then we can specify this property and add a name("wake") to the wifi 
wake irq here. And interrupts-extended would still be an available option.

>
> Then mwifiex would need to check "byname" before trying "by index":
>
> 	adapter->irq_wakeup = of_irq_get_byname(adapter->dt_node, "wake");
> 	if (!adapter->irq_wakeup) {
> 		adapter->irq_wakeup = irq_of_parse_and_map(adapter->dt_node, 0);
> 		if (!adapter->irq_wakeup) {
> 			dev_dbg(dev, "fail to parse irq_wakeup from device tree\n");
> 			goto err_exit;
> 		}
> 	}
>
> Or if we want to suggest the original binding was wrong and that we
> should just ignore existing device trees that tried to use it, we can
> skip the by-index fallback.
>
> Brian
>
> [1] Documentation/devicetree/bindings/pci/pci.txt points to
> http://www.firmware.org/1275/practice/imap/imap0_9d.pdf
> except that link is also dead now. I found the same doc here:
> https://www.openfirmware.info/data/docs/rec.intmap.d09.pdf
> Might want to update the binding doc... I've sent a patch for that
> separately.
>
>
>
