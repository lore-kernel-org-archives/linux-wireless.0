Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f206.google.com ([209.85.219.206]:64214 "EHLO
	mail-ew0-f206.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753763AbZHZWLb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Aug 2009 18:11:31 -0400
Received: by ewy2 with SMTP id 2so649853ewy.17
        for <linux-wireless@vger.kernel.org>; Wed, 26 Aug 2009 15:11:32 -0700 (PDT)
MIME-Version: 1.0
Date: Wed, 26 Aug 2009 23:11:31 +0100
Message-ID: <3ace41890908261511i3056c049kca82831015ff2aa0@mail.gmail.com>
Subject: hal, rfkill and compat-wireless (Re: [RFC/RFT] rtl8187: Implement
	rfkill support)
From: Hin-Tak Leung <hintak.leung@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	hal@lists.freedesktop.org
Cc: htl10@users.sourceforge.net,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Herton Ronaldo Krzesinski <herton@mandriva.com.br>,
	linux-wireless@vger.kernel.org,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

(added list hal to To:, since it has become relevant; previous
exchanges of the thread on linux-wireless)

On Wed, Aug 26, 2009 at 5:29 PM, Hin-Tak Leung<hintak.leung@gmail.com> wrote:
> On Wed, Aug 26, 2009 at 3:34 PM, Johannes Berg<johannes@sipsolutions.net> wrote:
>> On Wed, 2009-08-26 at 13:33 +0000, Hin-Tak Leung wrote:
>>
>>> > Or wait ... are you using compat-wireless?
>>>
>>> Yes, I am. I mentioned this and did wonder if the _backport/ part
>>> in /sys/class is important.
>>
>> Sorry, didn't see.
>>
>> Anyway, that's pretty clearly the reason -- Luis added NETDEV_PRE_UP to
>> some compat*.h but obviously the kernel won't ever call that notifier,
>> so cfg80211 doesn't get a chance to reject the IFUP. No idea how to
>> handle that -- it'll be working fine in a regular tree.
>>
>> Luis, the only way to handle that would be to manually call the PRE_UP
>> notifier from mac80211's subif_open() and if that returns an error
>> (warning: the calling convention is weird) return the error... that's
>> weird but would work.
>>
>> johannes
>>
>
> Hmm, got a bit side-tracked. But hal doesn't know the device having a
> killswitch is still wrong somewhere?
> (i.e. am wondering where we should advertise that ability, or how hal
> works that out)
>
> Hin-Tak
>

I looked into hal and I can now say that it is certainly not
compat-wireless "rfkill_backport"-aware; apparently all it does is
monitoring entries under /sys/class that it knows about. I made a
quick hack:
-----------
diff --git a/hald/linux/device.c b/hald/linux/device.c
index 2eca1ef..61e94b7 100644
--- a/hald/linux/device.c
+++ b/hald/linux/device.c
@@ -4621,7 +4621,7 @@ static DevHandler dev_handler_power_supply =

 static DevHandler dev_handler_rfkill =
 {
-       .subsystem    = "rfkill",
+       .subsystem    = "rfkill_backport",
        .add          = rfkill_add,
        .compute_udi  = rfkill_compute_udi,
        .refresh      = rfkill_refresh,
-----------------
so that it looks for /sys/class/rfkill_backport instead of rfkill ,
and restarting hald, and lshal finally shows the killswitch. And
NetworkManager also becomes aware of the rfkill state and no longer
re-enable the device:

---------------
Aug 26 22:08:36 localhost NetworkManager: <info>  HAL disappeared
.
Aug 26 22:08:43 localhost NetworkManager: <info>  HAL re-appeared
Aug 26 22:08:43 localhost NetworkManager: <info>  Found radio
killswitch /org/freedesktop/Hal/devices/usb_device_bda_8197_00e04c000001_if0_rfkill_phy0_wlan
Aug 26 22:09:16 localhost kernel: rtl8187: wireless radio switch turned off
Aug 26 22:09:20 localhost NetworkManager: <info>  Wireless now
disabled by radio killswitch
.
Aug 26 22:13:21 localhost kernel: rtl8187: wireless radio switch turned on
Aug 26 22:13:27 localhost NetworkManager: <info>  Wireless now enabled
by radio killswitch
-------------

So, to summarise, from 2.6.31 onwards, cfg80211 should enforce the
rfkill state from within the kernel no matter what hal/NM does; on
non-bleeding edge systems, hal works out rfkill states from
'/sys/class/rfkill' and let NM know. if you have a non-bleeding edge
system but want to try compat-wireless anyway, hal simply doesn't know
about rfkill_backport and NM re-enables the device when one plays with
the rfkill switch.

I guess there are two ways to go about this:
(1) make compat-wireless unload and replace the as-shipped rfkill
module completely and populate /sys/class/rfkill .
(2) make hal monitor and treat /sys/class/rfkill_backport the same way
and in addition to /sys/class/rfkill .

So I went about (2) and just duplicated the rfkill entry like this,
and it seems to work - anybody from hal wants to take this in?
--------------
diff --git a/hald/linux/device.c b/hald/linux/device.c
index 2eca1ef..feb198e 100644
--- a/hald/linux/device.c
+++ b/hald/linux/device.c
@@ -4628,6 +4628,15 @@ static DevHandler dev_handler_rfkill =
        .remove       = dev_remove
 };

+static DevHandler dev_handler_rfkill_backport =
+{
+       .subsystem    = "rfkill_backport",
+       .add          = rfkill_add,
+       .compute_udi  = rfkill_compute_udi,
+       .refresh      = rfkill_refresh,
+       .remove       = dev_remove
+};
+
 static DevHandler dev_handler_scsi = {
 	.subsystem   = "scsi",
 	.add         = scsi_add,
@@ -4817,6 +4826,7 @@ static DevHandler *dev_handlers[] = {
 	&dev_handler_ps3_system_bus,
 	&dev_handler_pseudo,
 	&dev_handler_rfkill,
+	&dev_handler_rfkill_backport,
 	&dev_handler_scsi,
 	&dev_handler_scsi_generic,
 	&dev_handler_scsi_host,
------------------------------
