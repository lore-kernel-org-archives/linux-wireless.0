Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.191]:41353 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751133AbYKAI6P (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 1 Nov 2008 04:58:15 -0400
Received: by nf-out-0910.google.com with SMTP id d3so702923nfc.21
        for <linux-wireless@vger.kernel.org>; Sat, 01 Nov 2008 01:58:12 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: crash with rt61pci when resuming with card ejected
Date: Sat, 1 Nov 2008 09:58:09 +0100
Cc: linux-wireless <linux-wireless@vger.kernel.org>
References: <1225361553.3690.3.camel@johannes.berg> <200810312301.39373.IvDoorn@gmail.com> <1225491085.3550.5.camel@johannes.berg>
In-Reply-To: <1225491085.3550.5.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200811010958.09194.IvDoorn@gmail.com> (sfid-20081101_095820_696536_BA0818FB)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Friday 31 October 2008, Johannes Berg wrote:
> On Fri, 2008-10-31 at 23:01 +0100, Ivo van Doorn wrote:
> 
> > > Now it crashes in config_pairwise_key or something like that, I can send
> > > you the image if you want.
> > 
> > No need. :)
> > I assume mac80211 calls set_key() to disable all hardware keys when
> > ieee80211_unregister_hw() is being called. I'll cook up a patch to catch
> > that as well.
> 
> Yep, that's it, it does it by way of turning off all interfaces,
> removing all stations etc. Of course, if it would implement
> suspend/resume properly then it would have removed the keys already
> before suspend and be putting them back at resume...

Could you try this patch? It doesn't matter if it is on top or as a replacement
of my previous patch.

This patch should also fix suspend/resume handling in general, I suddenly realized
there was quite a big bug in there regarding EEPROM/CSR handling. 

Thanks,

Ivo

---
diff --git a/drivers/net/wireless/rt2x00/rt2x00pci.c b/drivers/net/wireless/rt2x00/rt2x00pci.c
index adf2876..d2c6bc9 100644
--- a/drivers/net/wireless/rt2x00/rt2x00pci.c
+++ b/drivers/net/wireless/rt2x00/rt2x00pci.c
@@ -350,8 +350,6 @@ int rt2x00pci_suspend(struct pci_dev *pci_dev, pm_message_t state)
 	if (retval)
 		return retval;
 
-	rt2x00pci_free_reg(rt2x00dev);
-
 	pci_save_state(pci_dev);
 	pci_disable_device(pci_dev);
 	return pci_set_power_state(pci_dev, pci_choose_state(pci_dev, state));
@@ -371,10 +369,6 @@ int rt2x00pci_resume(struct pci_dev *pci_dev)
 		return -EIO;
 	}
 
-	retval = rt2x00pci_alloc_reg(rt2x00dev);
-	if (retval)
-		return retval;
-
 	retval = rt2x00lib_resume(rt2x00dev);
 	if (retval)
 		goto exit_free_reg;
diff --git a/drivers/net/wireless/rt2x00/rt2x00usb.c b/drivers/net/wireless/rt2x00/rt2x00usb.c
index b73a7e0..6198cf3 100644
--- a/drivers/net/wireless/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/rt2x00/rt2x00usb.c
@@ -597,8 +597,6 @@ int rt2x00usb_suspend(struct usb_interface *usb_intf, pm_message_t state)
 	if (retval)
 		return retval;
 
-	rt2x00usb_free_reg(rt2x00dev);
-
 	/*
 	 * Decrease usbdev refcount.
 	 */
@@ -616,10 +614,6 @@ int rt2x00usb_resume(struct usb_interface *usb_intf)
 
 	usb_get_dev(interface_to_usbdev(usb_intf));
 
-	retval = rt2x00usb_alloc_reg(rt2x00dev);
-	if (retval)
-		return retval;
-
 	retval = rt2x00lib_resume(rt2x00dev);
 	if (retval)
 		goto exit_free_reg;
