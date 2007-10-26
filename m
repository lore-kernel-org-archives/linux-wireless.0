Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:40657 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750972AbXJZOKm (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Oct 2007 10:10:42 -0400
Message-ID: <4721F55F.1030303@sgi.com> (sfid-20071026_151046_476915_C044A490)
Date: Fri, 26 Oct 2007 16:10:39 +0200
From: Jes Sorensen <jes@sgi.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Dan Williams <dcbw@redhat.com>, yi.zhu@intel.com,
	linux-wireless@vger.kernel.org,
	Tomas Winkler <tomas.winkler@intel.com>
Subject: Re: iwl4965 detection problem
References: <47209C0C.5010505@sgi.com> <1193319925.5542.8.camel@localhost.localdomain> <4720A509.2070708@sgi.com> <1193333545.2111.8.camel@localhost.localdomain> <47219FE6.70900@sgi.com> <20071026123044.GB23415@tuxdriver.com> <4721E17E.2020908@sgi.com>
In-Reply-To: <4721E17E.2020908@sgi.com>
Content-Type: multipart/mixed;
 boundary="------------040306000807090901070801"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------040306000807090901070801
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Jes Sorensen wrote:
> At least it's consistent here as opposed to sometimes.
> 
> One thing I noted is that rmmod often takes a few seconds, no idea
> if it has any value?

Ok,

I think I have an idea at whats going on - loading the module with debug
info revealed that it ended up straight in the interrupt handler the
moment the driver called request_irq(), but obviously before it was
ready to handle the interrupt in question. The net result was that it
didn't get to the loading of the ucode.

Unloading the module meant a call was made to iwl_disable_interrupts()
so on the next load, all pending interrupts in the chip had been cleared
and we didn't see this spurious interrupt.

I haven't had a chance to build the driver with this change, ie. it's
untested, but I have a suspicion that this patch might do the job.

Cheers,
Jes



--------------040306000807090901070801
Content-Type: text/plain;
 name="iwl4965-irq-fix.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="iwl4965-irq-fix.diff"

Disable interrupts in the iwl4965 before calling request_irq() for
the case that the previous OS or the BIOS left a pending interrupt in
the chip. This behavior has been observed on some laptops such as T61
Thinkpads and Toshiba Portege R500

Signed-off-by: Jes Sorensen <jes@sgi.com>

--- linux/drivers/net/wireless/iwlwifi/iwl4965-base.c~	2007-10-26 06:49:02.000000000 +0200
+++ linux/drivers/net/wireless/iwlwifi/iwl4965-base.c	2007-10-26 16:03:40.387241088 +0200
@@ -9090,6 +9090,8 @@
 	priv->power_mode = IWL_POWER_AC;
 	priv->user_txpower_limit = IWL_DEFAULT_TX_POWER;
 
+	iwl_disable_interrupts(priv);
+
 	pci_enable_msi(pdev);
 
 	err = request_irq(pdev->irq, iwl_isr, IRQF_SHARED, DRV_NAME, priv);

--------------040306000807090901070801--
