Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:16300 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751394AbZAUPjH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Jan 2009 10:39:07 -0500
Date: Wed, 21 Jan 2009 16:41:31 +0100
From: Samuel Ortiz <samuel.ortiz@intel.com>
To: Sedat Dilek <sedat.dilek@googlemail.com>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>,
	"Chatre, Reinette" <reinette.chatre@intel.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [ipw3945-devel] [PATCH 4/5] iwl3945: Use iwl-rfkill
Message-ID: <20090121154120.GC3459@sortiz.org> (sfid-20090121_163913_777940_3FA5E933)
References: <1232516035-25524-4-git-send-email-reinette.chatre@intel.com> <1232516035-25524-5-git-send-email-reinette.chatre@intel.com> <200901210801.23236.helmut.schaa@gmail.com> <2d0a357f0901210532v3ac57896ia3a75c9911267edb@mail.gmail.com>
MIME-Version: 1.0
In-Reply-To: <2d0a357f0901210532v3ac57896ia3a75c9911267edb@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Sedat,

On Wed, Jan 21, 2009 at 06:32:05AM -0700, Sedat Dilek wrote:
> Hi,
> 
> I applied Helmut's complain towards rfkill-changes into a patch (see below).
> Together with the latest iwlwifi-driver-updates (01_19_2009 + 01_20_2009) I played around with the WLAN-LED-button of my notebook.
> 
> Turning the LED off, I got the following error-message:
> [...]
> Jan 21 14:13:32 seduxbox kernel: iwl3945 0000:10:00.0: Error sending REPLY_LEDS_CMD: enqueue_hcmd failed: -5
> [...]
A couple questions:
- Are you running the latest wireless-testing ?
- Can you reproduce this error (I can't) ?


> What does error-code "-5" mean?
That's -EIO, see iwl_enqueue_hcmd() in iwl-tx.c.

Cheers,
Samuel.


> Is this maybe a 2.6.29 kernel issue?
> 
> Turning LED on, the wlan-connection is established automatically and Internet connection works fine again.
> 
> Full report is attached.
> 
> Kind Regards,
> Sedat
> 
> ----- SNIP -----
> 
> Index: linux-2.6/drivers/net/wireless/iwlwifi/iwl-core.c
> ===================================================================
> --- linux-2.6.orig/drivers/net/wireless/iwlwifi/iwl-core.c.orig
> +++ linux-2.6/drivers/net/wireless/iwlwifi/iwl-core.c
> @@ -1481,7 +1481,8 @@
>          IWL_DEBUG(IWL_DL_RF_KILL,
>                "HW and/or SW RF Kill no longer active, restarting "
>                "device\n");
> -        if (!test_bit(STATUS_EXIT_PENDING, &priv->status))
> +        if (!test_bit(STATUS_EXIT_PENDING, &priv->status) &&
> +            test_bit(STATUS_ALIVE, &priv->status))
>              queue_work(priv->workqueue, &priv->restart);
>      } else {
>          /* make sure mac80211 stop sending Tx frame */
> 
> ----- SNAP -----
> 
> On Wed, Jan 21, 2009 at 8:01 AM, Helmut Schaa <helmut.schaa@googlemail.com<mailto:helmut.schaa@googlemail.com>> wrote:
> Hi,
> 
> Am Mittwoch, 21. Januar 2009 schrieb Reinette Chatre:
> > From: Samuel Ortiz <samuel.ortiz@intel.com<mailto:samuel.ortiz@intel.com>>
> >
> > Here again, the rfkill routines are duplicated between agn and 3945. Let's
> > move the agn one to iwlcore, and so we can get rid of the 3945 ones.
> 
> [...]
> 
> > +void iwl_bg_rf_kill(struct work_struct *work)
> > +{
> > +     struct iwl_priv *priv = container_of(work, struct iwl_priv, rf_kill);
> > +
> > +     wake_up_interruptible(&priv->wait_command_queue);
> > +
> > +     if (test_bit(STATUS_EXIT_PENDING, &priv->status))
> > +             return;
> > +
> > +     mutex_lock(&priv->mutex);
> > +
> > +     if (!iwl_is_rfkill(priv)) {
> > +             IWL_DEBUG(IWL_DL_RF_KILL,
> > +                       "HW and/or SW RF Kill no longer active, restarting "
> > +                       "device\n");
> > +             if (!test_bit(STATUS_EXIT_PENDING, &priv->status))
> > +                     queue_work(priv->workqueue, &priv->restart);
> 
> I've changed this check in both rf-kill patches (3945 and agn) to
> 
> if (!test_bit(STATUS_EXIT_PENDING, &priv->status) &&
>    test_bit(STATUS_ALIVE, &priv->status))
> 
> in order to avoid restarting the adapter when notified about rfkill changes
> by interrupt/polling.
> 
> I guess this is just an oversight, right?
> 
> Thanks,
> Helmut
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org<mailto:majordomo@vger.kernel.org>
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

Content-Description: report_iwlwifi_rfkill_2.6.29-rc2-git1-iniza-4.txt
> ----- BEGIN LED OFF -----
> 
> Jan 21 14:13:27 seduxbox kernel: iwl3945 0000:10:00.0: Radio Frequency Kill Switch is On:
> Jan 21 14:13:27 seduxbox kernel: Kill switch must be turned off for wireless networking to work.
> Jan 21 14:13:28 seduxbox kernel: usb 1-2: USB disconnect, address 2
> Jan 21 14:13:28 seduxbox kernel: sierra ttyUSB0: Sierra USB modem converter now disconnected from ttyUSB0
> Jan 21 14:13:28 seduxbox kernel: sierra ttyUSB1: Sierra USB modem converter now disconnected from ttyUSB1
> Jan 21 14:13:28 seduxbox kernel: sierra ttyUSB2: Sierra USB modem converter now disconnected from ttyUSB2
> Jan 21 14:13:28 seduxbox kernel: sierra 1-2:1.0: device disconnected
> Jan 21 14:13:32 seduxbox kernel: wlan0: No ProbeResp from current AP 00:04:0e:e4:00:3d - assume out of range
> Jan 21 14:13:32 seduxbox kernel: iwl3945 0000:10:00.0: Error sending REPLY_LEDS_CMD: enqueue_hcmd failed: -5
> 
> ----- END LED OFF -----
> 
> 
> ----- BEGIN LED ON -----
> 
> Jan 21 14:14:47 seduxbox kernel: Registered led device: iwl-phy0:radio
> Jan 21 14:14:47 seduxbox kernel: Registered led device: iwl-phy0:assoc
> Jan 21 14:14:47 seduxbox kernel: Registered led device: iwl-phy0:RX
> Jan 21 14:14:47 seduxbox kernel: Registered led device: iwl-phy0:TX
> Jan 21 14:14:50 seduxbox kernel: usb 1-2: new full speed USB device using uhci_hcd and address 3
> Jan 21 14:14:50 seduxbox kernel: usb 1-2: New USB device found, idVendor=03f0, idProduct=1e1d
> Jan 21 14:14:50 seduxbox kernel: usb 1-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
> Jan 21 14:14:50 seduxbox kernel: usb 1-2: Product: HP hs2300 HSDPA Broadband Wireless Module
> Jan 21 14:14:50 seduxbox kernel: usb 1-2: Manufacturer: HP
> Jan 21 14:14:50 seduxbox kernel: usb 1-2: configuration #1 chosen from 1 choice
> Jan 21 14:14:50 seduxbox kernel: sierra 1-2:1.0: Sierra USB modem converter detected
> Jan 21 14:14:50 seduxbox kernel: usb 1-2: Sierra USB modem converter now attached to ttyUSB0
> Jan 21 14:14:50 seduxbox kernel: usb 1-2: Sierra USB modem converter now attached to ttyUSB1
> Jan 21 14:14:50 seduxbox kernel: usb 1-2: Sierra USB modem converter now attached to ttyUSB2
> Jan 21 14:15:18 seduxbox kernel: wlan0: authenticate with AP 00:04:0e:e4:00:3d
> Jan 21 14:15:18 seduxbox kernel: wlan0: authenticate with AP 00:04:0e:e4:00:3d
> Jan 21 14:15:18 seduxbox kernel: wlan0: authenticated
> Jan 21 14:15:18 seduxbox kernel: wlan0: associate with AP 00:04:0e:e4:00:3d
> Jan 21 14:15:18 seduxbox kernel: wlan0: RX ReassocResp from 00:04:0e:e4:00:3d (capab=0x411 status=0 aid=1)
> Jan 21 14:15:18 seduxbox kernel: wlan0: associated
> 
> ----- END LED ON -----
> 


-- 
Intel Open Source Technology Centre
http://oss.intel.com/
---------------------------------------------------------------------
Intel Corporation SAS (French simplified joint stock company)
Registered headquarters: "Les Montalets"- 2, rue de Paris, 
92196 Meudon Cedex, France
Registration Number:  302 456 199 R.C.S. NANTERRE
Capital: 4,572,000 Euros

This e-mail and any attachments may contain confidential material for
the sole use of the intended recipient(s). Any review or distribution
by others is strictly prohibited. If you are not the intended
recipient, please contact the sender and delete all copies.

