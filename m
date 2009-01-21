Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f20.google.com ([209.85.219.20]:59447 "EHLO
	mail-ew0-f20.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752525AbZAUSbV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 21 Jan 2009 13:31:21 -0500
Received: by ewy13 with SMTP id 13so1703052ewy.13
        for <linux-wireless@vger.kernel.org>; Wed, 21 Jan 2009 10:31:18 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20090121175537.GF3459@sortiz.org>
References: <1232516035-25524-4-git-send-email-reinette.chatre@intel.com>
	 <1232516035-25524-5-git-send-email-reinette.chatre@intel.com>
	 <200901210801.23236.helmut.schaa@gmail.com>
	 <2d0a357f0901210532v3ac57896ia3a75c9911267edb@mail.gmail.com>
	 <20090121154120.GC3459@sortiz.org>
	 <2d0a357f0901210857p2c3503fdwa2be5d87ee4b15e8@mail.gmail.com>
	 <20090121175537.GF3459@sortiz.org>
Date: Wed, 21 Jan 2009 19:31:17 +0100
Message-ID: <2d0a357f0901211031t7fb85bc0x6fd51ce89c50edc4@mail.gmail.com> (sfid-20090121_193126_022583_8088D8B7)
Subject: Re: [ipw3945-devel] [PATCH 4/5] iwl3945: Use iwl-rfkill
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: Samuel Ortiz <samuel.ortiz@intel.com>
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>,
	"Chatre, Reinette" <reinette.chatre@intel.com>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

THX for the detailed explanations.

-SD

On Wed, Jan 21, 2009 at 6:58 PM, Samuel Ortiz <samuel.ortiz@intel.com> wrote:
> Hi Sedat,
>
> On Wed, Jan 21, 2009 at 09:57:16AM -0700, Sedat Dilek wrote:
>>
>> >> What does error-code "-5" mean?
>> > That's -EIO, see iwl_enqueue_hcmd() in iwl-tx.c.
>> >
>>
>> drivers/net/wireless/iwlwifi/iwl-tx.c says:
>> [...]
>> iwl_enqueue_hcmd - enqueue a uCode command
>> [...]
>> The function returns < 0 values to indicate the operation is failed.
>> [...]
>>
>> So is this a ucode-problem?
> No, the problem is the following one:
> 1) You're associated with an AP
> 2) You turn the rf kill switch on
> 3) mac80211 detects the AP is not there anymore
> 4) iwl3945 calls the association led handler, which tries to send a
> REPLY_LEDS_CMD host command.
> 5) Since we're RF killed, enqueue_hcmd cancels the command sending and returns
> -EIO.
>
> This is not a bug, as we dont want to be sending host commands while being RF
> killed.
> I bet you can reproduce this behaviour on wireless-testing without the 2
> latest iwlwifi patch sets.
>
> Cheers,
> Samuel.
>
>>
>> Kind regards,
>> Sedat
>>
>> > Cheers,
>> > Samuel.
>> >
>> >
>> >> Is this maybe a 2.6.29 kernel issue?
>> >>
>> >> Turning LED on, the wlan-connection is established automatically and Internet connection works fine again.
>> >>
>> >> Full report is attached.
>> >>
>> >> Kind Regards,
>> >> Sedat
>> >>
>> >> ----- SNIP -----
>> >>
>> >> Index: linux-2.6/drivers/net/wireless/iwlwifi/iwl-core.c
>> >> ===================================================================
>> >> --- linux-2.6.orig/drivers/net/wireless/iwlwifi/iwl-core.c.orig
>> >> +++ linux-2.6/drivers/net/wireless/iwlwifi/iwl-core.c
>> >> @@ -1481,7 +1481,8 @@
>> >>          IWL_DEBUG(IWL_DL_RF_KILL,
>> >>                "HW and/or SW RF Kill no longer active, restarting "
>> >>                "device\n");
>> >> -        if (!test_bit(STATUS_EXIT_PENDING, &priv->status))
>> >> +        if (!test_bit(STATUS_EXIT_PENDING, &priv->status) &&
>> >> +            test_bit(STATUS_ALIVE, &priv->status))
>> >>              queue_work(priv->workqueue, &priv->restart);
>> >>      } else {
>> >>          /* make sure mac80211 stop sending Tx frame */
>> >>
>> >> ----- SNAP -----
>> >>
>> >> On Wed, Jan 21, 2009 at 8:01 AM, Helmut Schaa <helmut.schaa@googlemail.com<mailto:helmut.schaa@googlemail.com>> wrote:
>> >> Hi,
>> >>
>> >> Am Mittwoch, 21. Januar 2009 schrieb Reinette Chatre:
>> >> > From: Samuel Ortiz <samuel.ortiz@intel.com<mailto:samuel.ortiz@intel.com>>
>> >> >
>> >> > Here again, the rfkill routines are duplicated between agn and 3945. Let's
>> >> > move the agn one to iwlcore, and so we can get rid of the 3945 ones.
>> >>
>> >> [...]
>> >>
>> >> > +void iwl_bg_rf_kill(struct work_struct *work)
>> >> > +{
>> >> > +     struct iwl_priv *priv = container_of(work, struct iwl_priv, rf_kill);
>> >> > +
>> >> > +     wake_up_interruptible(&priv->wait_command_queue);
>> >> > +
>> >> > +     if (test_bit(STATUS_EXIT_PENDING, &priv->status))
>> >> > +             return;
>> >> > +
>> >> > +     mutex_lock(&priv->mutex);
>> >> > +
>> >> > +     if (!iwl_is_rfkill(priv)) {
>> >> > +             IWL_DEBUG(IWL_DL_RF_KILL,
>> >> > +                       "HW and/or SW RF Kill no longer active, restarting "
>> >> > +                       "device\n");
>> >> > +             if (!test_bit(STATUS_EXIT_PENDING, &priv->status))
>> >> > +                     queue_work(priv->workqueue, &priv->restart);
>> >>
>> >> I've changed this check in both rf-kill patches (3945 and agn) to
>> >>
>> >> if (!test_bit(STATUS_EXIT_PENDING, &priv->status) &&
>> >>    test_bit(STATUS_ALIVE, &priv->status))
>> >>
>> >> in order to avoid restarting the adapter when notified about rfkill changes
>> >> by interrupt/polling.
>> >>
>> >> I guess this is just an oversight, right?
>> >>
>> >> Thanks,
>> >> Helmut
>> >> --
>> >> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> >> the body of a message to majordomo@vger.kernel.org<mailto:majordomo@vger.kernel.org>
>> >> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> >>
>> >
>> > Content-Description: report_iwlwifi_rfkill_2.6.29-rc2-git1-iniza-4.txt
>> >> ----- BEGIN LED OFF -----
>> >>
>> >> Jan 21 14:13:27 seduxbox kernel: iwl3945 0000:10:00.0: Radio Frequency Kill Switch is On:
>> >> Jan 21 14:13:27 seduxbox kernel: Kill switch must be turned off for wireless networking to work.
>> >> Jan 21 14:13:28 seduxbox kernel: usb 1-2: USB disconnect, address 2
>> >> Jan 21 14:13:28 seduxbox kernel: sierra ttyUSB0: Sierra USB modem converter now disconnected from ttyUSB0
>> >> Jan 21 14:13:28 seduxbox kernel: sierra ttyUSB1: Sierra USB modem converter now disconnected from ttyUSB1
>> >> Jan 21 14:13:28 seduxbox kernel: sierra ttyUSB2: Sierra USB modem converter now disconnected from ttyUSB2
>> >> Jan 21 14:13:28 seduxbox kernel: sierra 1-2:1.0: device disconnected
>> >> Jan 21 14:13:32 seduxbox kernel: wlan0: No ProbeResp from current AP 00:04:0e:e4:00:3d - assume out of range
>> >> Jan 21 14:13:32 seduxbox kernel: iwl3945 0000:10:00.0: Error sending REPLY_LEDS_CMD: enqueue_hcmd failed: -5
>> >>
>> >> ----- END LED OFF -----
>> >>
>> >>
>> >> ----- BEGIN LED ON -----
>> >>
>> >> Jan 21 14:14:47 seduxbox kernel: Registered led device: iwl-phy0:radio
>> >> Jan 21 14:14:47 seduxbox kernel: Registered led device: iwl-phy0:assoc
>> >> Jan 21 14:14:47 seduxbox kernel: Registered led device: iwl-phy0:RX
>> >> Jan 21 14:14:47 seduxbox kernel: Registered led device: iwl-phy0:TX
>> >> Jan 21 14:14:50 seduxbox kernel: usb 1-2: new full speed USB device using uhci_hcd and address 3
>> >> Jan 21 14:14:50 seduxbox kernel: usb 1-2: New USB device found, idVendor=03f0, idProduct=1e1d
>> >> Jan 21 14:14:50 seduxbox kernel: usb 1-2: New USB device strings: Mfr=1, Product=2, SerialNumber=0
>> >> Jan 21 14:14:50 seduxbox kernel: usb 1-2: Product: HP hs2300 HSDPA Broadband Wireless Module
>> >> Jan 21 14:14:50 seduxbox kernel: usb 1-2: Manufacturer: HP
>> >> Jan 21 14:14:50 seduxbox kernel: usb 1-2: configuration #1 chosen from 1 choice
>> >> Jan 21 14:14:50 seduxbox kernel: sierra 1-2:1.0: Sierra USB modem converter detected
>> >> Jan 21 14:14:50 seduxbox kernel: usb 1-2: Sierra USB modem converter now attached to ttyUSB0
>> >> Jan 21 14:14:50 seduxbox kernel: usb 1-2: Sierra USB modem converter now attached to ttyUSB1
>> >> Jan 21 14:14:50 seduxbox kernel: usb 1-2: Sierra USB modem converter now attached to ttyUSB2
>> >> Jan 21 14:15:18 seduxbox kernel: wlan0: authenticate with AP 00:04:0e:e4:00:3d
>> >> Jan 21 14:15:18 seduxbox kernel: wlan0: authenticate with AP 00:04:0e:e4:00:3d
>> >> Jan 21 14:15:18 seduxbox kernel: wlan0: authenticated
>> >> Jan 21 14:15:18 seduxbox kernel: wlan0: associate with AP 00:04:0e:e4:00:3d
>> >> Jan 21 14:15:18 seduxbox kernel: wlan0: RX ReassocResp from 00:04:0e:e4:00:3d (capab=0x411 status=0 aid=1)
>> >> Jan 21 14:15:18 seduxbox kernel: wlan0: associated
>> >>
>> >> ----- END LED ON -----
>> >>
>> >
>> >
>> > --
>> > Intel Open Source Technology Centre
>> > http://oss.intel.com/
>> > ---------------------------------------------------------------------
>> > Intel Corporation SAS (French simplified joint stock company)
>> > Registered headquarters: "Les Montalets"- 2, rue de Paris,
>> > 92196 Meudon Cedex, France
>> > Registration Number:  302 456 199 R.C.S. NANTERRE
>> > Capital: 4,572,000 Euros
>> >
>> > This e-mail and any attachments may contain confidential material for
>> > the sole use of the intended recipient(s). Any review or distribution
>> > by others is strictly prohibited. If you are not the intended
>> > recipient, please contact the sender and delete all copies.
>> >
>> >
>
>
>
> --
> Intel Open Source Technology Centre
> http://oss.intel.com/
> ---------------------------------------------------------------------
> Intel Corporation SAS (French simplified joint stock company)
> Registered headquarters: "Les Montalets"- 2, rue de Paris,
> 92196 Meudon Cedex, France
> Registration Number:  302 456 199 R.C.S. NANTERRE
> Capital: 4,572,000 Euros
>
> This e-mail and any attachments may contain confidential material for
> the sole use of the intended recipient(s). Any review or distribution
> by others is strictly prohibited. If you are not the intended
> recipient, please contact the sender and delete all copies.
>
>
