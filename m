Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f217.google.com ([209.85.220.217]:51040 "EHLO
	mail-fx0-f217.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751713AbZHSN1K (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Aug 2009 09:27:10 -0400
Received: by fxm17 with SMTP id 17so3790590fxm.37
        for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2009 06:27:11 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1250687066.1067.25.camel@johannes.local>
References: <69e28c910908181329r4b6b7cc8w3c9c0d79dda3730c@mail.gmail.com>
	<4A8BBB02.4020203@huijgen.tk> <69e28c910908190428s46f3d25dnb2f2d8591f99618f@mail.gmail.com>
	<4A8BF35E.1090507@huijgen.tk> <1250687066.1067.25.camel@johannes.local>
From: =?ISO-8859-1?Q?G=E1bor_Stefanik?= <netrolller.3d@gmail.com>
Date: Wed, 19 Aug 2009 15:26:51 +0200
Message-ID: <69e28c910908190626s46fd0bfer5cc9dec9c5bb1c24@mail.gmail.com>
Subject: Re: [ANN] b43 LP-PHY support (BCM4310/4312/4315) working (partially)!
To: Mark Huijgen <mark.sf.net@huijgen.tk>,
	Johannes Berg <johannes@sipsolutions.net>,
	Larry Finger <Larry.Finger@lwfinger.net>
Cc: Broadcom Wireless <bcm43xx-dev@lists.berlios.de>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 19, 2009 at 3:04 PM, Johannes Berg<johannes@sipsolutions.net> wrote:
> On Wed, 2009-08-19 at 14:43 +0200, Mark Huijgen wrote:
>
>> After running the included python script, patching the cutter and
>> extracting firmware, I now get ucode version 478.104 in dmesg. Next test
>> is also without the 2 patches. Following log is from modprobe+ifconfig
>> wlan0 up:
>
> Not really surprising, the firmware is for the MAC _only_, it doesn't
> really ever touch the PHY, so it's very unlikely to matter.
>
> johannes
>

Actually, the output does change with the new firmware.

Current outputs:
1. Patches not applied, old firmware, default chan = 1: the channel
switch to 7 during calibration works, but nothing else.
2. Patches applied, old firmware, default chan = 1: no channels work
(not even the channel 7 switch in the calibration routine), ifup
fails.
3. Patches not applied, new firmware, default chan = 1 (I got this
from Larry in private mail): only channels 7 and 8 work, but ifup
works(?).
(4. Patches applied, new firmware, default chan = 1: please test!)
(5. Patches not applied, old firmware, default chan = 7: probably ifup
succeeds, but only channel 7 works. Not tested.)
(6. Patches applied, old firmware, default chan = 7: unknown, probably
doesn't work at all.)
(7. Patches not applied, new firmware, default chan = 7: Unknown.)
8. Patches applied, new firmware, default chan = 7: interface comes
up, scans (but only channels 6 and above show results), associates to
WPA AP on channel 11 and gets DHCP address (meaning, both TX and RX
working)!

Notice that 2 and 8 only differ in the FW ver and the default channel,
and in 8 (with new firmware), the switch to channel 7 during RC
calibration (before the switch to default channel) works - in 2, it
fails. Looks like the routines reverse-engineered from the newer
driver depend on the firmware included in that driver; or maybe the
old firmware simply doesn't properly handle LP-PHY. Initvals are also
a possible candidate for this. (Larry, what do you think about this?)

Mark, could you produce a dmesg output with the new firmware, patches
applied, and channel set to 1? Post the output of dmesg after scanning
& probably associating, if possible. (Scan/assoc may produce messages
in dmesg.)

(The news about TX working is great by the way!)

-- 
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
