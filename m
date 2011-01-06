Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:63471 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752155Ab1AFHJN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Jan 2011 02:09:13 -0500
Received: by iwn9 with SMTP id 9so16001774iwn.19
        for <linux-wireless@vger.kernel.org>; Wed, 05 Jan 2011 23:09:12 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <AANLkTimaWy33vYaM=bCPd0VooyR9QVw99YB1fSOj42Fo@mail.gmail.com>
References: <AANLkTim0AM3=T=TMu79ZQi79+CKANamBcz620n2xm8bW@mail.gmail.com>
	<201101041946.56978.helmut.schaa@googlemail.com>
	<AANLkTik0uZBVOCnA__UHZLDtw+NNWqK-sEBf1XnyYGYV@mail.gmail.com>
	<AANLkTi=KFG-7GPw2=6VTZqEceEcJM6OdWoTQaN_83NqP@mail.gmail.com>
	<AANLkTikREOFV+WGWgo9yh9bTrz346kF0muKE8gs5N+km@mail.gmail.com>
	<AANLkTikCcgEiqeJLDn0Pes_2=usj6ZXo7hhL48MBnH_-@mail.gmail.com>
	<AANLkTin0W1_Tjr1zj0D0U+VeBpoGFRmB9iCdOfnMB-nR@mail.gmail.com>
	<AANLkTimCsvR2zBfS+oCudhcUz68qPJhXM9-eu1L-FWHp@mail.gmail.com>
	<AANLkTimdEcj4k09ZyHQTXnbaeNj4CCrAm=mRTw+R5j6L@mail.gmail.com>
	<AANLkTimaWy33vYaM=bCPd0VooyR9QVw99YB1fSOj42Fo@mail.gmail.com>
Date: Wed, 5 Jan 2011 23:09:12 -0800
Message-ID: <AANLkTi=-raYOK7p2e+3B2vRG2L+wJ6TApHj4LHd2NP53@mail.gmail.com>
Subject: Re: [rt2x00-users] Linksys WUSB600N v1 disconnecting from AP
From: Aleksandar Milivojevic <alex@milivojevic.org>
To: Wolfgang Kufner <wolfgang.kufner@gmail.com>
Cc: Luis Correia <buga@loide.net>,
	"Luis R. Rodriguez" <lrodriguez@atheros.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com,
	Helmut Schaa <helmut.schaa@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Some good news, and some bad news.

First off, the logs included in this email are relatively verbose.  So
if anybody knows the moderator of rt2x00 group, this will need
approval to get posted as email is likely going to end up longer than
the limit of 40kB.

After selecting only rt2x00 drivers, compat-wireless compiled, giving
me updated rt2x00, cfg80211 and mac80211 drivers.  Using them,
'country 98' stuff was gone and everything was working great and
blazing fast.  However, after less then 10 minutes, the connection to
my AP was dropped again.  Looking at log files, there is a lot of
switching of regulatory domains and adjustments of which frequencies
are allowed.  However, these don't seem to have be an issue, as
connection to AP was fully functional for many minutes after
regulatory domain stuff was set, and subsequent logs relating to
setting regulatory domains are triggered by re-connection attempts to
AP only after the connection failed (basically, going back and forth
from "world" to US as connection attempts were being made).  I
included all logs just in case.  The logs also claim the beacon was
found on 5745 MHz (Ch 149), and I don't see that frequency reported as
disabled anywhere in the logs.

I've collected logs from both Linux side, and from the AP (Apple
Airport Extreme).  Here's what was logged on Linux side (Ubuntu logged
normal and debug messages into two different files):

Initially, everything looks nice:

Jan  5 20:51:30 toporko kernel: [   20.909139] cfg80211: Calling CRDA
to update world regulatory domain
Jan  5 20:51:30 toporko kernel: [   20.978919] cfg80211: World
regulatory domain updated:
Jan  5 20:51:30 toporko kernel: [   20.978927] cfg80211:
(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Jan  5 20:51:30 toporko kernel: [   20.978933] cfg80211:     (2402000
KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jan  5 20:51:30 toporko kernel: [   20.978938] cfg80211:     (2457000
KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Jan  5 20:51:30 toporko kernel: [   20.978942] cfg80211:     (2474000
KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Jan  5 20:51:30 toporko kernel: [   20.978946] cfg80211:     (5170000
KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jan  5 20:51:30 toporko kernel: [   20.978951] cfg80211:     (5735000
KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jan  5 20:51:30 toporko kernel: [   20.978979] cfg80211: Calling CRDA
for country: US
Jan  5 20:51:30 toporko kernel: [   21.062261] cfg80211: Regulatory
domain changed to country: US
Jan  5 20:51:30 toporko kernel: [   21.062268] cfg80211:
(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Jan  5 20:51:30 toporko kernel: [   21.062273] cfg80211:     (2402000
KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
Jan  5 20:51:30 toporko kernel: [   21.062277] cfg80211:     (5170000
KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 1700 mBm)
Jan  5 20:51:30 toporko kernel: [   21.062281] cfg80211:     (5250000
KHz - 5330000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jan  5 20:51:30 toporko kernel: [   21.062286] cfg80211:     (5490000
KHz - 5600000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jan  5 20:51:30 toporko kernel: [   21.062290] cfg80211:     (5650000
KHz - 5710000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jan  5 20:51:30 toporko kernel: [   21.062294] cfg80211:     (5735000
KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 3000 mBm)

20:52:00 corresponds to the time when first association event is
logged by AP (see logs from AP below):

Jan  5 20:52:00 toporko kernel: [   51.238753]
ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
Jan  5 20:52:00 toporko kernel: [   51.240874] cfg80211: Calling CRDA
for country: US
Jan  5 20:52:00 toporko kernel: [   51.249676] cfg80211: Regulatory
domain changed to country: US
Jan  5 20:52:00 toporko kernel: [   51.249679] cfg80211:
(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Jan  5 20:52:00 toporko kernel: [   51.249683] cfg80211:     (2402000
KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
Jan  5 20:52:00 toporko kernel: [   51.249688] cfg80211:     (5170000
KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 1700 mBm)
Jan  5 20:52:00 toporko kernel: [   51.249692] cfg80211:     (5250000
KHz - 5330000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jan  5 20:52:00 toporko kernel: [   51.249696] cfg80211:     (5490000
KHz - 5600000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jan  5 20:52:00 toporko kernel: [   51.249701] cfg80211:     (5650000
KHz - 5710000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jan  5 20:52:00 toporko kernel: [   51.249705] cfg80211:     (5735000
KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 3000 mBm)

At 20:52:22, AP logs and disassociation event, shortly followed by an
association event.  Linux side has to say:

Jan  5 20:52:22 toporko kernel: [   72.946432] cfg80211: Calling CRDA
to update world regulatory domain
Jan  5 20:52:22 toporko kernel: [   72.956781] cfg80211: World
regulatory domain updated:
Jan  5 20:52:22 toporko kernel: [   72.956784] cfg80211:
(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Jan  5 20:52:22 toporko kernel: [   72.956788] cfg80211:     (2402000
KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jan  5 20:52:22 toporko kernel: [   72.956793] cfg80211:     (2457000
KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Jan  5 20:52:22 toporko kernel: [   72.956797] cfg80211:     (2474000
KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Jan  5 20:52:22 toporko kernel: [   72.956801] cfg80211:     (5170000
KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jan  5 20:52:22 toporko kernel: [   72.956806] cfg80211:     (5735000
KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jan  5 20:52:22 toporko kernel: [   72.956837] cfg80211: Calling CRDA
for country: US
Jan  5 20:52:22 toporko kernel: [   72.977063] cfg80211: Regulatory
domain changed to country: US
Jan  5 20:52:22 toporko kernel: [   72.977066] cfg80211:
(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Jan  5 20:52:22 toporko kernel: [   72.977070] cfg80211:     (2402000
KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
Jan  5 20:52:22 toporko kernel: [   72.977075] cfg80211:     (5170000
KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 1700 mBm)
Jan  5 20:52:22 toporko kernel: [   72.977079] cfg80211:     (5250000
KHz - 5330000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jan  5 20:52:22 toporko kernel: [   72.977084] cfg80211:     (5490000
KHz - 5600000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jan  5 20:52:22 toporko kernel: [   72.977088] cfg80211:     (5650000
KHz - 5710000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jan  5 20:52:22 toporko kernel: [   72.977092] cfg80211:     (5735000
KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 3000 mBm)
Jan  5 20:52:25 toporko kernel: [   75.927369] cfg80211: Calling CRDA
for country: US
Jan  5 20:52:25 toporko kernel: [   75.954521] cfg80211: Regulatory
domain changed to country: US
Jan  5 20:52:25 toporko kernel: [   75.954524] cfg80211:
(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Jan  5 20:52:25 toporko kernel: [   75.954528] cfg80211:     (2402000
KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
Jan  5 20:52:25 toporko kernel: [   75.954533] cfg80211:     (5170000
KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 1700 mBm)
Jan  5 20:52:25 toporko kernel: [   75.954537] cfg80211:     (5250000
KHz - 5330000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jan  5 20:52:25 toporko kernel: [   75.954542] cfg80211:     (5490000
KHz - 5600000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jan  5 20:52:25 toporko kernel: [   75.954546] cfg80211:     (5650000
KHz - 5710000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jan  5 20:52:25 toporko kernel: [   75.954551] cfg80211:     (5735000
KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 3000 mBm)

At this point, everything works fine for about 7-8 minutes, the
following lines start repeating over and over again in the
/var/log/messages (the pattern is one switch to "world" followed by
two messages of switching to US).  At the same time, the AP also
starts logging a lot of disassociation/association events.

Jan  5 21:00:15 toporko kernel: [  545.128569] cfg80211: Calling CRDA
to update world regulatory domain
Jan  5 21:00:15 toporko kernel: [  545.139964] cfg80211: World
regulatory domain updated:
Jan  5 21:00:15 toporko kernel: [  545.139966] cfg80211:
(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Jan  5 21:00:15 toporko kernel: [  545.139971] cfg80211:     (2402000
KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jan  5 21:00:15 toporko kernel: [  545.139975] cfg80211:     (2457000
KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Jan  5 21:00:15 toporko kernel: [  545.139979] cfg80211:     (2474000
KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Jan  5 21:00:15 toporko kernel: [  545.139983] cfg80211:     (5170000
KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jan  5 21:00:15 toporko kernel: [  545.139988] cfg80211:     (5735000
KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jan  5 21:00:15 toporko kernel: [  545.140424] cfg80211: Calling CRDA
for country: US
Jan  5 21:00:15 toporko kernel: [  545.162143] cfg80211: Regulatory
domain changed to country: US
Jan  5 21:00:15 toporko kernel: [  545.162146] cfg80211:
(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Jan  5 21:00:15 toporko kernel: [  545.162151] cfg80211:     (2402000
KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
Jan  5 21:00:15 toporko kernel: [  545.162156] cfg80211:     (5170000
KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 1700 mBm)
Jan  5 21:00:15 toporko kernel: [  545.162160] cfg80211:     (5250000
KHz - 5330000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jan  5 21:00:15 toporko kernel: [  545.162165] cfg80211:     (5490000
KHz - 5600000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jan  5 21:00:15 toporko kernel: [  545.162170] cfg80211:     (5650000
KHz - 5710000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jan  5 21:00:15 toporko kernel: [  545.162174] cfg80211:     (5735000
KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 3000 mBm)
Jan  5 21:00:19 toporko kernel: [  549.886738] cfg80211: Calling CRDA
for country: US
Jan  5 21:00:19 toporko kernel: [  549.899715] cfg80211: Regulatory
domain changed to country: US
Jan  5 21:00:19 toporko kernel: [  549.899718] cfg80211:
(start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Jan  5 21:00:19 toporko kernel: [  549.899723] cfg80211:     (2402000
KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2700 mBm)
Jan  5 21:00:19 toporko kernel: [  549.899728] cfg80211:     (5170000
KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 1700 mBm)
Jan  5 21:00:19 toporko kernel: [  549.899732] cfg80211:     (5250000
KHz - 5330000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jan  5 21:00:19 toporko kernel: [  549.899737] cfg80211:     (5490000
KHz - 5600000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jan  5 21:00:19 toporko kernel: [  549.899741] cfg80211:     (5650000
KHz - 5710000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Jan  5 21:00:19 toporko kernel: [  549.899745] cfg80211:     (5735000
KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 3000 mBm)

Around 21:12, the Linux side gives up.

File /var/log/debug had much more detailed info and likely much more
noise.  I'll include it last.  First, here is how things looked like
from the AP's perspective.  The logs from the AP indicate a lot of
association/disassociation events from WUSB600N (it's MAC address is
00:1c:10:ea:2a:cb).

This is initial connection to the AP:

Jan 05 20:52:01 Severity:5      Associated with station 00:1c:10:ea:2a:cb
Jan 05 20:52:02 Severity:5      Installed unicast CCMP key for
supplicant 00:1c:10:ea:2a:cb

Then after about 20 seconds, there's and disassociate event, however
connection is re-established few seconds later:

Jan 05 20:52:22 Severity:5      Disassociated with station 00:1c:10:ea:2a:cb
Jan 05 20:52:24 Severity:5      Rotated TKIP group key.
Jan 05 20:52:25 Severity:5      Associated with station 00:1c:10:ea:2a:cb
Jan 05 20:52:25 Severity:5      Installed unicast CCMP key for
supplicant 00:1c:10:ea:2a:cb

Then there's nothing in the logs for about next 7-8 minutes.  At this
point, there's bunch of disassociate/associate events logged by AP:

Jan 05 21:00:15 Severity:5      Disassociated with station 00:1c:10:ea:2a:cb
Jan 05 21:00:17 Severity:5      Rotated TKIP group key.
Jan 05 21:00:19 Severity:5      Associated with station 00:1c:10:ea:2a:cb
Jan 05 21:00:22 Severity:5      Installed unicast CCMP key for
supplicant 00:1c:10:ea:2a:cb
Jan 05 21:03:38 Severity:5      Disassociated with station 00:1c:10:ea:2a:cb
Jan 05 21:03:39 Severity:5      Rotated TKIP group key.
Jan 05 21:03:42 Severity:5      Associated with station 00:1c:10:ea:2a:cb
Jan 05 21:03:45 Severity:5      Installed unicast CCMP key for
supplicant 00:1c:10:ea:2a:cb
Jan 05 21:03:51 Severity:5      Disassociated with station 00:1c:10:ea:2a:cb
Jan 05 21:03:52 Severity:5      Rotated TKIP group key.
Jan 05 21:03:55 Severity:5      Associated with station 00:1c:10:ea:2a:cb
Jan 05 21:03:55 Severity:5      Installed unicast CCMP key for
supplicant 00:1c:10:ea:2a:cb
Jan 05 21:06:04 Severity:5      Disassociated with station 00:1c:10:ea:2a:cb
Jan 05 21:06:05 Severity:5      Rotated TKIP group key.
Jan 05 21:06:08 Severity:5      Associated with station 00:1c:10:ea:2a:cb
Jan 05 21:06:11 Severity:5      Installed unicast CCMP key for
supplicant 00:1c:10:ea:2a:cb
Jan 05 21:06:48 Severity:5      Disassociated with station 00:1c:10:ea:2a:cb
Jan 05 21:06:48 Severity:5      Rotated TKIP group key.
Jan 05 21:06:53 Severity:5      Associated with station 00:1c:10:ea:2a:cb
Jan 05 21:06:53 Severity:5      Installed unicast CCMP key for
supplicant 00:1c:10:ea:2a:cb
Jan 05 21:08:46 Severity:5      Disassociated with station 00:1c:10:ea:2a:cb
Jan 05 21:08:47 Severity:5      Rotated TKIP group key.
Jan 05 21:08:51 Severity:5      Associated with station 00:1c:10:ea:2a:cb
Jan 05 21:08:51 Severity:5      Installed unicast CCMP key for
supplicant 00:1c:10:ea:2a:cb

Then all is quiet in the logs on AP side, and after some additional
time, AP also gives up:

Jan 05 21:17:26 Severity:5      Idle timeout for station 00:1c:10:ea:2a:cb
Jan 05 21:17:26 Severity:5      Disassociating with station
00:1c:10:ea:2a:cb (reserved 4).
Jan 05 21:17:26 Severity:5      Disassociated with station 00:1c:10:ea:2a:cb
Jan 05 21:17:26 Severity:5      Rotated TKIP group key.

Finally, here is what Linux side logged in its /var/log/debug.  It's
rather verbose and long.  I noticed some frequencies being disabled
over and over that don't look like they should have been disabled.
First section corresponds to initialization, before first actual
connection to AP seem to have been made:

Jan  5 20:51:30 toporko kernel: [   20.909354] cfg80211: Pending
regulatory request, waiting for it to be processed...
Jan  5 20:51:30 toporko kernel: [   21.650908] cfg80211: Updating
information on frequency 2412 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:51:30 toporko kernel: [   21.650916] cfg80211: 2402000 KHz -
2472000 KHz @  KHz), (300 mBi, 2700 mBm)
Jan  5 20:51:30 toporko kernel: [   21.650920] cfg80211: Updating
information on frequency 2417 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:51:30 toporko kernel: [   21.650925] cfg80211: 2402000 KHz -
2472000 KHz @  KHz), (300 mBi, 2700 mBm)
Jan  5 20:51:30 toporko kernel: [   21.650929] cfg80211: Updating
information on frequency 2422 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:51:30 toporko kernel: [   21.650933] cfg80211: 2402000 KHz -
2472000 KHz @  KHz), (300 mBi, 2700 mBm)
Jan  5 20:51:30 toporko kernel: [   21.650937] cfg80211: Updating
information on frequency 2427 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:51:30 toporko kernel: [   21.650941] cfg80211: 2402000 KHz -
2472000 KHz @  KHz), (300 mBi, 2700 mBm)
Jan  5 20:51:30 toporko kernel: [   21.650945] cfg80211: Updating
information on frequency 2432 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:51:30 toporko kernel: [   21.650950] cfg80211: 2402000 KHz -
2472000 KHz @  KHz), (300 mBi, 2700 mBm)
Jan  5 20:51:30 toporko kernel: [   21.650953] cfg80211: Updating
information on frequency 2437 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:51:30 toporko kernel: [   21.650958] cfg80211: 2402000 KHz -
2472000 KHz @  KHz), (300 mBi, 2700 mBm)
Jan  5 20:51:30 toporko kernel: [   21.650962] cfg80211: Updating
information on frequency 2442 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:51:30 toporko kernel: [   21.650966] cfg80211: 2402000 KHz -
2472000 KHz @  KHz), (300 mBi, 2700 mBm)
Jan  5 20:51:30 toporko kernel: [   21.650970] cfg80211: Updating
information on frequency 2447 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:51:30 toporko kernel: [   21.650974] cfg80211: 2402000 KHz -
2472000 KHz @  KHz), (300 mBi, 2700 mBm)
Jan  5 20:51:30 toporko kernel: [   21.650978] cfg80211: Updating
information on frequency 2452 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:51:30 toporko kernel: [   21.650982] cfg80211: 2402000 KHz -
2472000 KHz @  KHz), (300 mBi, 2700 mBm)
Jan  5 20:51:30 toporko kernel: [   21.650986] cfg80211: Updating
information on frequency 2457 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:51:30 toporko kernel: [   21.650991] cfg80211: 2402000 KHz -
2472000 KHz @  KHz), (300 mBi, 2700 mBm)
Jan  5 20:51:30 toporko kernel: [   21.650994] cfg80211: Updating
information on frequency 2462 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:51:30 toporko kernel: [   21.650999] cfg80211: 2402000 KHz -
2472000 KHz @  KHz), (300 mBi, 2700 mBm)
Jan  5 20:51:30 toporko kernel: [   21.651003] cfg80211: Disabling freq 2467 MHz
Jan  5 20:51:30 toporko kernel: [   21.651005] cfg80211: Disabling freq 2472 MHz
Jan  5 20:51:30 toporko kernel: [   21.651008] cfg80211: Disabling freq 2484 MHz
Jan  5 20:51:30 toporko kernel: [   21.651011] cfg80211: Updating
information on frequency 5180 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:51:30 toporko kernel: [   21.651016] cfg80211: 5170000 KHz -
5250000 KHz @  KHz), (300 mBi, 1700 mBm)
Jan  5 20:51:30 toporko kernel: [   21.651020] cfg80211: Updating
information on frequency 5190 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:51:30 toporko kernel: [   21.651024] cfg80211: 5170000 KHz -
5250000 KHz @  KHz), (300 mBi, 1700 mBm)
Jan  5 20:51:30 toporko kernel: [   21.651028] cfg80211: Updating
information on frequency 5200 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:51:30 toporko kernel: [   21.651032] cfg80211: 5170000 KHz -
5250000 KHz @  KHz), (300 mBi, 1700 mBm)
Jan  5 20:51:30 toporko kernel: [   21.651036] cfg80211: Updating
information on frequency 5220 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:51:30 toporko kernel: [   21.651041] cfg80211: 5170000 KHz -
5250000 KHz @  KHz), (300 mBi, 1700 mBm)
Jan  5 20:51:30 toporko kernel: [   21.651044] cfg80211: Updating
information on frequency 5230 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:51:30 toporko kernel: [   21.651049] cfg80211: 5170000 KHz -
5250000 KHz @  KHz), (300 mBi, 1700 mBm)
Jan  5 20:51:30 toporko kernel: [   21.651053] cfg80211: Updating
information on frequency 5240 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:51:30 toporko kernel: [   21.651057] cfg80211: 5170000 KHz -
5250000 KHz @  KHz), (300 mBi, 1700 mBm)
Jan  5 20:51:30 toporko kernel: [   21.651061] cfg80211: Updating
information on frequency 5260 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:51:30 toporko kernel: [   21.651065] cfg80211: 5250000 KHz -
5330000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 20:51:30 toporko kernel: [   21.651069] cfg80211: Updating
information on frequency 5270 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:51:30 toporko kernel: [   21.651074] cfg80211: 5250000 KHz -
5330000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 20:51:30 toporko kernel: [   21.651077] cfg80211: Updating
information on frequency 5280 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:51:30 toporko kernel: [   21.651082] cfg80211: 5250000 KHz -
5330000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 20:51:30 toporko kernel: [   21.651085] cfg80211: Updating
information on frequency 5300 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:51:30 toporko kernel: [   21.651090] cfg80211: 5250000 KHz -
5330000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 20:51:30 toporko kernel: [   21.651094] cfg80211: Updating
information on frequency 5310 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:51:30 toporko kernel: [   21.651098] cfg80211: 5250000 KHz -
5330000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 20:51:30 toporko kernel: [   21.651102] cfg80211: Updating
information on frequency 5320 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:51:30 toporko kernel: [   21.651106] cfg80211: 5250000 KHz -
5330000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 20:51:30 toporko kernel: [   21.651110] cfg80211: Updating
information on frequency 5500 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:51:30 toporko kernel: [   21.651115] cfg80211: 5490000 KHz -
5600000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 20:51:30 toporko kernel: [   21.651118] cfg80211: Updating
information on frequency 5510 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:51:30 toporko kernel: [   21.651123] cfg80211: 5490000 KHz -
5600000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 20:51:30 toporko kernel: [   21.651127] cfg80211: Updating
information on frequency 5520 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:51:30 toporko kernel: [   21.651131] cfg80211: 5490000 KHz -
5600000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 20:51:30 toporko kernel: [   21.651135] cfg80211: Updating
information on frequency 5540 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:51:30 toporko kernel: [   21.651139] cfg80211: 5490000 KHz -
5600000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 20:51:30 toporko kernel: [   21.651143] cfg80211: Updating
information on frequency 5550 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:51:30 toporko kernel: [   21.651148] cfg80211: 5490000 KHz -
5600000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 20:51:30 toporko kernel: [   21.651151] cfg80211: Updating
information on frequency 5560 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:51:30 toporko kernel: [   21.651156] cfg80211: 5490000 KHz -
5600000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 20:51:30 toporko kernel: [   21.651159] cfg80211: Updating
information on frequency 5580 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:51:30 toporko kernel: [   21.651164] cfg80211: 5490000 KHz -
5600000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 20:51:30 toporko kernel: [   21.651168] cfg80211: Updating
information on frequency 5590 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:51:30 toporko kernel: [   21.651172] cfg80211: 5490000 KHz -
5600000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 20:51:30 toporko kernel: [   21.651175] cfg80211: Disabling freq 5600 MHz
Jan  5 20:51:30 toporko kernel: [   21.651178] cfg80211: Disabling freq 5620 MHz
Jan  5 20:51:30 toporko kernel: [   21.651181] cfg80211: Disabling freq 5630 MHz
Jan  5 20:51:30 toporko kernel: [   21.651183] cfg80211: Disabling freq 5640 MHz
Jan  5 20:51:30 toporko kernel: [   21.651187] cfg80211: Updating
information on frequency 5660 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:51:30 toporko kernel: [   21.651191] cfg80211: 5650000 KHz -
5710000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 20:51:30 toporko kernel: [   21.651195] cfg80211: Updating
information on frequency 5670 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:51:30 toporko kernel: [   21.651199] cfg80211: 5650000 KHz -
5710000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 20:51:30 toporko kernel: [   21.651203] cfg80211: Updating
information on frequency 5680 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:51:30 toporko kernel: [   21.651208] cfg80211: 5650000 KHz -
5710000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 20:51:30 toporko kernel: [   21.651211] cfg80211: Updating
information on frequency 5700 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:51:30 toporko kernel: [   21.651216] cfg80211: 5650000 KHz -
5710000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 20:51:30 toporko kernel: [   21.651220] cfg80211: Updating
information on frequency 5745 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:51:30 toporko kernel: [   21.651224] cfg80211: 5735000 KHz -
5835000 KHz @  KHz), (300 mBi, 3000 mBm)
Jan  5 20:51:30 toporko kernel: [   21.651228] cfg80211: Updating
information on frequency 5755 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:51:30 toporko kernel: [   21.651232] cfg80211: 5735000 KHz -
5835000 KHz @  KHz), (300 mBi, 3000 mBm)
Jan  5 20:51:30 toporko kernel: [   21.651236] cfg80211: Updating
information on frequency 5765 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:51:30 toporko kernel: [   21.651241] cfg80211: 5735000 KHz -
5835000 KHz @  KHz), (300 mBi, 3000 mBm)
Jan  5 20:51:30 toporko kernel: [   21.651244] cfg80211: Updating
information on frequency 5785 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:51:30 toporko kernel: [   21.651249] cfg80211: 5735000 KHz -
5835000 KHz @  KHz), (300 mBi, 3000 mBm)
Jan  5 20:51:30 toporko kernel: [   21.651253] cfg80211: Updating
information on frequency 5795 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:51:30 toporko kernel: [   21.651257] cfg80211: 5735000 KHz -
5835000 KHz @  KHz), (300 mBi, 3000 mBm)
Jan  5 20:51:30 toporko kernel: [   21.651261] cfg80211: Updating
information on frequency 5805 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:51:30 toporko kernel: [   21.651265] cfg80211: 5735000 KHz -
5835000 KHz @  KHz), (300 mBi, 3000 mBm)
Jan  5 20:51:30 toporko kernel: [   21.651269] cfg80211: Updating
information on frequency 5825 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:51:30 toporko kernel: [   21.651274] cfg80211: 5735000 KHz -
5835000 KHz @  KHz), (300 mBi, 3000 mBm)
Jan  5 20:51:30 toporko kernel: [   21.651277] cfg80211: Disabling freq 5835 MHz
Jan  5 20:51:30 toporko kernel: [   21.651279] cfg80211: Disabling freq 5845 MHz
Jan  5 20:51:30 toporko kernel: [   21.651282] cfg80211: Disabling freq 5855 MHz
Jan  5 20:51:30 toporko kernel: [   21.651285] cfg80211: Disabling freq 5865 MHz
Jan  5 20:51:30 toporko kernel: [   21.651287] cfg80211: Disabling freq 5920 MHz
Jan  5 20:51:30 toporko kernel: [   21.651290] cfg80211: Disabling freq 5940 MHz
Jan  5 20:51:30 toporko kernel: [   21.651292] cfg80211: Disabling freq 5960 MHz
Jan  5 20:51:30 toporko kernel: [   21.651295] cfg80211: Disabling freq 5980 MHz
Jan  5 20:51:30 toporko kernel: [   21.651298] cfg80211: Disabling freq 6040 MHz
Jan  5 20:51:30 toporko kernel: [   21.651300] cfg80211: Disabling freq 6060 MHz
Jan  5 20:51:30 toporko kernel: [   21.651303] cfg80211: Disabling freq 6080 MHz
Jan  5 20:51:30 toporko kernel: [   21.867812] ieee80211 phy0:
Selected rate control algorithm 'minstrel_ht'
Jan  5 20:51:30 toporko kernel: [   21.869759] Registered led device:
rt2800usb-phy0::radio
Jan  5 20:51:30 toporko kernel: [   21.869969] Registered led device:
rt2800usb-phy0::assoc
Jan  5 20:51:30 toporko kernel: [   21.870157] Registered led device:
rt2800usb-phy0::quality
Jan  5 20:51:34 toporko kernel: [   25.276905] cfg80211: Found new
beacon on frequency: 5745 MHz (Ch 149) on phy0

Then there's nothing network related until around the time AP logged
first association event:

Jan  5 20:51:58 toporko kernel: [   49.602189] wlan0: authenticate
with 00:1e:52:79:e9:ff (try 1)
Jan  5 20:51:58 toporko kernel: [   49.602709] wlan0: authenticated
Jan  5 20:52:00 toporko kernel: [   51.208576] wlan0: associate with
00:1e:52:79:e9:ff (try 1)
Jan  5 20:52:00 toporko kernel: [   51.209332] wlan0: RX AssocResp
from 00:1e:52:79:e9:ff (capab=0x511 status=0 aid=2)
Jan  5 20:52:00 toporko kernel: [   51.209338] wlan0: associated
Jan  5 20:52:00 toporko kernel: [   51.249270] cfg80211: Updating
information on frequency 2412 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:00 toporko kernel: [   51.249278] cfg80211: 2402000 KHz -
2472000 KHz @  KHz), (300 mBi, 2700 mBm)
Jan  5 20:52:00 toporko kernel: [   51.249283] cfg80211: Updating
information on frequency 2417 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:00 toporko kernel: [   51.249287] cfg80211: 2402000 KHz -
2472000 KHz @  KHz), (300 mBi, 2700 mBm)
Jan  5 20:52:00 toporko kernel: [   51.249291] cfg80211: Updating
information on frequency 2422 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:00 toporko kernel: [   51.249296] cfg80211: 2402000 KHz -
2472000 KHz @  KHz), (300 mBi, 2700 mBm)
Jan  5 20:52:00 toporko kernel: [   51.249299] cfg80211: Updating
information on frequency 2427 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:00 toporko kernel: [   51.249304] cfg80211: 2402000 KHz -
2472000 KHz @  KHz), (300 mBi, 2700 mBm)
Jan  5 20:52:00 toporko kernel: [   51.249308] cfg80211: Updating
information on frequency 2432 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:00 toporko kernel: [   51.249312] cfg80211: 2402000 KHz -
2472000 KHz @  KHz), (300 mBi, 2700 mBm)
Jan  5 20:52:00 toporko kernel: [   51.249316] cfg80211: Updating
information on frequency 2437 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:00 toporko kernel: [   51.249320] cfg80211: 2402000 KHz -
2472000 KHz @  KHz), (300 mBi, 2700 mBm)
Jan  5 20:52:00 toporko kernel: [   51.249324] cfg80211: Updating
information on frequency 2442 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:00 toporko kernel: [   51.249328] cfg80211: 2402000 KHz -
2472000 KHz @  KHz), (300 mBi, 2700 mBm)
Jan  5 20:52:00 toporko kernel: [   51.249332] cfg80211: Updating
information on frequency 2447 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:00 toporko kernel: [   51.249337] cfg80211: 2402000 KHz -
2472000 KHz @  KHz), (300 mBi, 2700 mBm)
Jan  5 20:52:00 toporko kernel: [   51.249340] cfg80211: Updating
information on frequency 2452 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:00 toporko kernel: [   51.249345] cfg80211: 2402000 KHz -
2472000 KHz @  KHz), (300 mBi, 2700 mBm)
Jan  5 20:52:00 toporko kernel: [   51.249348] cfg80211: Updating
information on frequency 2457 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:00 toporko kernel: [   51.249353] cfg80211: 2402000 KHz -
2472000 KHz @  KHz), (300 mBi, 2700 mBm)
Jan  5 20:52:00 toporko kernel: [   51.249357] cfg80211: Updating
information on frequency 2462 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:00 toporko kernel: [   51.249361] cfg80211: 2402000 KHz -
2472000 KHz @  KHz), (300 mBi, 2700 mBm)
Jan  5 20:52:00 toporko kernel: [   51.249365] cfg80211: Disabling freq 2467 MHz
Jan  5 20:52:00 toporko kernel: [   51.249367] cfg80211: Disabling freq 2472 MHz
Jan  5 20:52:00 toporko kernel: [   51.249370] cfg80211: Disabling freq 2484 MHz
Jan  5 20:52:00 toporko kernel: [   51.249374] cfg80211: Updating
information on frequency 5180 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:00 toporko kernel: [   51.249378] cfg80211: 5170000 KHz -
5250000 KHz @  KHz), (300 mBi, 1700 mBm)
Jan  5 20:52:00 toporko kernel: [   51.249382] cfg80211: Updating
information on frequency 5190 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:00 toporko kernel: [   51.249386] cfg80211: 5170000 KHz -
5250000 KHz @  KHz), (300 mBi, 1700 mBm)
Jan  5 20:52:00 toporko kernel: [   51.249390] cfg80211: Updating
information on frequency 5200 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:00 toporko kernel: [   51.249394] cfg80211: 5170000 KHz -
5250000 KHz @  KHz), (300 mBi, 1700 mBm)
Jan  5 20:52:00 toporko kernel: [   51.249398] cfg80211: Updating
information on frequency 5220 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:00 toporko kernel: [   51.249402] cfg80211: 5170000 KHz -
5250000 KHz @  KHz), (300 mBi, 1700 mBm)
Jan  5 20:52:00 toporko kernel: [   51.249406] cfg80211: Updating
information on frequency 5230 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:00 toporko kernel: [   51.249411] cfg80211: 5170000 KHz -
5250000 KHz @  KHz), (300 mBi, 1700 mBm)
Jan  5 20:52:00 toporko kernel: [   51.249414] cfg80211: Updating
information on frequency 5240 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:00 toporko kernel: [   51.249419] cfg80211: 5170000 KHz -
5250000 KHz @  KHz), (300 mBi, 1700 mBm)
Jan  5 20:52:00 toporko kernel: [   51.249423] cfg80211: Updating
information on frequency 5260 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:00 toporko kernel: [   51.249427] cfg80211: 5250000 KHz -
5330000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 20:52:00 toporko kernel: [   51.249431] cfg80211: Updating
information on frequency 5270 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:00 toporko kernel: [   51.249435] cfg80211: 5250000 KHz -
5330000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 20:52:00 toporko kernel: [   51.249439] cfg80211: Updating
information on frequency 5280 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:00 toporko kernel: [   51.249443] cfg80211: 5250000 KHz -
5330000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 20:52:00 toporko kernel: [   51.249447] cfg80211: Updating
information on frequency 5300 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:00 toporko kernel: [   51.249452] cfg80211: 5250000 KHz -
5330000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 20:52:00 toporko kernel: [   51.249455] cfg80211: Updating
information on frequency 5310 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:00 toporko kernel: [   51.249460] cfg80211: 5250000 KHz -
5330000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 20:52:00 toporko kernel: [   51.249463] cfg80211: Updating
information on frequency 5320 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:00 toporko kernel: [   51.249468] cfg80211: 5250000 KHz -
5330000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 20:52:00 toporko kernel: [   51.249472] cfg80211: Updating
information on frequency 5500 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:00 toporko kernel: [   51.249476] cfg80211: 5490000 KHz -
5600000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 20:52:00 toporko kernel: [   51.249480] cfg80211: Updating
information on frequency 5510 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:00 toporko kernel: [   51.249484] cfg80211: 5490000 KHz -
5600000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 20:52:00 toporko kernel: [   51.249488] cfg80211: Updating
information on frequency 5520 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:00 toporko kernel: [   51.249492] cfg80211: 5490000 KHz -
5600000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 20:52:00 toporko kernel: [   51.249496] cfg80211: Updating
information on frequency 5540 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:00 toporko kernel: [   51.249501] cfg80211: 5490000 KHz -
5600000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 20:52:00 toporko kernel: [   51.249504] cfg80211: Updating
information on frequency 5550 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:00 toporko kernel: [   51.249509] cfg80211: 5490000 KHz -
5600000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 20:52:00 toporko kernel: [   51.249513] cfg80211: Updating
information on frequency 5560 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:00 toporko kernel: [   51.249517] cfg80211: 5490000 KHz -
5600000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 20:52:00 toporko kernel: [   51.249521] cfg80211: Updating
information on frequency 5580 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:00 toporko kernel: [   51.249525] cfg80211: 5490000 KHz -
5600000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 20:52:00 toporko kernel: [   51.249529] cfg80211: Updating
information on frequency 5590 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:00 toporko kernel: [   51.249533] cfg80211: 5490000 KHz -
5600000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 20:52:00 toporko kernel: [   51.249537] cfg80211: Disabling freq 5600 MHz
Jan  5 20:52:00 toporko kernel: [   51.249539] cfg80211: Disabling freq 5620 MHz
Jan  5 20:52:00 toporko kernel: [   51.249542] cfg80211: Disabling freq 5630 MHz
Jan  5 20:52:00 toporko kernel: [   51.249544] cfg80211: Disabling freq 5640 MHz
Jan  5 20:52:00 toporko kernel: [   51.249548] cfg80211: Updating
information on frequency 5660 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:00 toporko kernel: [   51.249552] cfg80211: 5650000 KHz -
5710000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 20:52:00 toporko kernel: [   51.249556] cfg80211: Updating
information on frequency 5670 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:00 toporko kernel: [   51.249560] cfg80211: 5650000 KHz -
5710000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 20:52:00 toporko kernel: [   51.249564] cfg80211: Updating
information on frequency 5680 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:00 toporko kernel: [   51.249568] cfg80211: 5650000 KHz -
5710000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 20:52:00 toporko kernel: [   51.249572] cfg80211: Updating
information on frequency 5700 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:00 toporko kernel: [   51.249577] cfg80211: 5650000 KHz -
5710000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 20:52:00 toporko kernel: [   51.249580] cfg80211: Updating
information on frequency 5745 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:00 toporko kernel: [   51.249585] cfg80211: 5735000 KHz -
5835000 KHz @  KHz), (300 mBi, 3000 mBm)
Jan  5 20:52:00 toporko kernel: [   51.249589] cfg80211: Updating
information on frequency 5755 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:00 toporko kernel: [   51.249593] cfg80211: 5735000 KHz -
5835000 KHz @  KHz), (300 mBi, 3000 mBm)
Jan  5 20:52:00 toporko kernel: [   51.249597] cfg80211: Updating
information on frequency 5765 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:00 toporko kernel: [   51.249601] cfg80211: 5735000 KHz -
5835000 KHz @  KHz), (300 mBi, 3000 mBm)
Jan  5 20:52:00 toporko kernel: [   51.249605] cfg80211: Updating
information on frequency 5785 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:00 toporko kernel: [   51.249609] cfg80211: 5735000 KHz -
5835000 KHz @  KHz), (300 mBi, 3000 mBm)
Jan  5 20:52:00 toporko kernel: [   51.249613] cfg80211: Updating
information on frequency 5795 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:00 toporko kernel: [   51.249618] cfg80211: 5735000 KHz -
5835000 KHz @  KHz), (300 mBi, 3000 mBm)
Jan  5 20:52:00 toporko kernel: [   51.249621] cfg80211: Updating
information on frequency 5805 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:00 toporko kernel: [   51.249626] cfg80211: 5735000 KHz -
5835000 KHz @  KHz), (300 mBi, 3000 mBm)
Jan  5 20:52:00 toporko kernel: [   51.249630] cfg80211: Updating
information on frequency 5825 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:00 toporko kernel: [   51.249634] cfg80211: 5735000 KHz -
5835000 KHz @  KHz), (300 mBi, 3000 mBm)
Jan  5 20:52:00 toporko kernel: [   51.249637] cfg80211: Disabling freq 5835 MHz
Jan  5 20:52:00 toporko kernel: [   51.249640] cfg80211: Disabling freq 5845 MHz
Jan  5 20:52:00 toporko kernel: [   51.249642] cfg80211: Disabling freq 5855 MHz
Jan  5 20:52:00 toporko kernel: [   51.249645] cfg80211: Disabling freq 5865 MHz
Jan  5 20:52:00 toporko kernel: [   51.249648] cfg80211: Disabling freq 5920 MHz
Jan  5 20:52:00 toporko kernel: [   51.249650] cfg80211: Disabling freq 5940 MHz
Jan  5 20:52:00 toporko kernel: [   51.249653] cfg80211: Disabling freq 5960 MHz
Jan  5 20:52:00 toporko kernel: [   51.249655] cfg80211: Disabling freq 5980 MHz
Jan  5 20:52:00 toporko kernel: [   51.249658] cfg80211: Disabling freq 6040 MHz
Jan  5 20:52:00 toporko kernel: [   51.249660] cfg80211: Disabling freq 6060 MHz
Jan  5 20:52:00 toporko kernel: [   51.249663] cfg80211: Disabling freq 6080 MHz

At this point, there was a short failure in connectivity between Linux
side and AP, however both sides recovered from it within seconds:

Jan  5 20:52:21 toporko kernel: [   71.316029] ieee80211 phy0: wlan0:
No probe response from AP 00:1e:52:79:e9:ff after 500ms,
disconnecting.
Jan  5 20:52:22 toporko kernel: [   72.946413] cfg80211: All devices
are disconnected, going to restore regulatory settings
Jan  5 20:52:22 toporko kernel: [   72.946423] cfg80211: Restoring
regulatory settings while preserving user preference for: US
Jan  5 20:52:22 toporko kernel: [   72.956465] cfg80211: Updating
information on frequency 2412 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:22 toporko kernel: [   72.956474] cfg80211: 2402000 KHz -
2472000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 20:52:22 toporko kernel: [   72.956478] cfg80211: Updating
information on frequency 2417 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:22 toporko kernel: [   72.956483] cfg80211: 2402000 KHz -
2472000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 20:52:22 toporko kernel: [   72.956486] cfg80211: Updating
information on frequency 2422 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:22 toporko kernel: [   72.956491] cfg80211: 2402000 KHz -
2472000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 20:52:22 toporko kernel: [   72.956494] cfg80211: Updating
information on frequency 2427 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:22 toporko kernel: [   72.956499] cfg80211: 2402000 KHz -
2472000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 20:52:22 toporko kernel: [   72.956503] cfg80211: Updating
information on frequency 2432 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:22 toporko kernel: [   72.956507] cfg80211: 2402000 KHz -
2472000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 20:52:22 toporko kernel: [   72.956511] cfg80211: Updating
information on frequency 2437 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:22 toporko kernel: [   72.956515] cfg80211: 2402000 KHz -
2472000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 20:52:22 toporko kernel: [   72.956519] cfg80211: Updating
information on frequency 2442 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:22 toporko kernel: [   72.956523] cfg80211: 2402000 KHz -
2472000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 20:52:22 toporko kernel: [   72.956527] cfg80211: Updating
information on frequency 2447 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:22 toporko kernel: [   72.956531] cfg80211: 2402000 KHz -
2472000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 20:52:22 toporko kernel: [   72.956535] cfg80211: Updating
information on frequency 2452 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:22 toporko kernel: [   72.956539] cfg80211: 2402000 KHz -
2472000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 20:52:22 toporko kernel: [   72.956543] cfg80211: Updating
information on frequency 2457 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:22 toporko kernel: [   72.956548] cfg80211: 2402000 KHz -
2472000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 20:52:22 toporko kernel: [   72.956551] cfg80211: Updating
information on frequency 2462 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:22 toporko kernel: [   72.956556] cfg80211: 2402000 KHz -
2472000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 20:52:22 toporko kernel: [   72.956559] cfg80211: Updating
information on frequency 2467 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:22 toporko kernel: [   72.956564] cfg80211: 2457000 KHz -
2482000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 20:52:22 toporko kernel: [   72.956568] cfg80211: Updating
information on frequency 2472 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:22 toporko kernel: [   72.956572] cfg80211: 2457000 KHz -
2482000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 20:52:22 toporko kernel: [   72.956576] cfg80211: Updating
information on frequency 2484 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:22 toporko kernel: [   72.956580] cfg80211: 2474000 KHz -
2494000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 20:52:22 toporko kernel: [   72.956584] cfg80211: Updating
information on frequency 5180 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:22 toporko kernel: [   72.956589] cfg80211: 5170000 KHz -
5250000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 20:52:22 toporko kernel: [   72.956592] cfg80211: Updating
information on frequency 5190 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:22 toporko kernel: [   72.956597] cfg80211: 5170000 KHz -
5250000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 20:52:22 toporko kernel: [   72.956601] cfg80211: Updating
information on frequency 5200 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:22 toporko kernel: [   72.956605] cfg80211: 5170000 KHz -
5250000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 20:52:22 toporko kernel: [   72.956609] cfg80211: Updating
information on frequency 5220 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:22 toporko kernel: [   72.956613] cfg80211: 5170000 KHz -
5250000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 20:52:22 toporko kernel: [   72.956617] cfg80211: Updating
information on frequency 5230 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:22 toporko kernel: [   72.956621] cfg80211: 5170000 KHz -
5250000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 20:52:22 toporko kernel: [   72.956625] cfg80211: Updating
information on frequency 5240 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:22 toporko kernel: [   72.956629] cfg80211: 5170000 KHz -
5250000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 20:52:22 toporko kernel: [   72.956633] cfg80211: Disabling freq 5260 MHz
Jan  5 20:52:22 toporko kernel: [   72.956636] cfg80211: Disabling freq 5270 MHz
Jan  5 20:52:22 toporko kernel: [   72.956638] cfg80211: Disabling freq 5280 MHz
Jan  5 20:52:22 toporko kernel: [   72.956641] cfg80211: Disabling freq 5300 MHz
Jan  5 20:52:22 toporko kernel: [   72.956643] cfg80211: Disabling freq 5310 MHz
Jan  5 20:52:22 toporko kernel: [   72.956646] cfg80211: Disabling freq 5320 MHz
Jan  5 20:52:22 toporko kernel: [   72.956649] cfg80211: Disabling freq 5500 MHz
Jan  5 20:52:22 toporko kernel: [   72.956651] cfg80211: Disabling freq 5510 MHz
Jan  5 20:52:22 toporko kernel: [   72.956654] cfg80211: Disabling freq 5520 MHz
Jan  5 20:52:22 toporko kernel: [   72.956656] cfg80211: Disabling freq 5540 MHz
Jan  5 20:52:22 toporko kernel: [   72.956659] cfg80211: Disabling freq 5550 MHz
Jan  5 20:52:22 toporko kernel: [   72.956662] cfg80211: Disabling freq 5560 MHz
Jan  5 20:52:22 toporko kernel: [   72.956664] cfg80211: Disabling freq 5580 MHz
Jan  5 20:52:22 toporko kernel: [   72.956667] cfg80211: Disabling freq 5590 MHz
Jan  5 20:52:22 toporko kernel: [   72.956669] cfg80211: Disabling freq 5600 MHz
Jan  5 20:52:22 toporko kernel: [   72.956672] cfg80211: Disabling freq 5620 MHz
Jan  5 20:52:22 toporko kernel: [   72.956674] cfg80211: Disabling freq 5630 MHz
Jan  5 20:52:22 toporko kernel: [   72.956677] cfg80211: Disabling freq 5640 MHz
Jan  5 20:52:22 toporko kernel: [   72.956680] cfg80211: Disabling freq 5660 MHz
Jan  5 20:52:22 toporko kernel: [   72.956682] cfg80211: Disabling freq 5670 MHz
Jan  5 20:52:22 toporko kernel: [   72.956685] cfg80211: Disabling freq 5680 MHz
Jan  5 20:52:22 toporko kernel: [   72.956687] cfg80211: Disabling freq 5700 MHz
Jan  5 20:52:22 toporko kernel: [   72.956691] cfg80211: Updating
information on frequency 5745 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:22 toporko kernel: [   72.956695] cfg80211: 5735000 KHz -
5835000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 20:52:22 toporko kernel: [   72.956699] cfg80211: Updating
information on frequency 5755 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:22 toporko kernel: [   72.956703] cfg80211: 5735000 KHz -
5835000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 20:52:22 toporko kernel: [   72.956707] cfg80211: Updating
information on frequency 5765 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:22 toporko kernel: [   72.956711] cfg80211: 5735000 KHz -
5835000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 20:52:22 toporko kernel: [   72.956715] cfg80211: Updating
information on frequency 5785 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:22 toporko kernel: [   72.956719] cfg80211: 5735000 KHz -
5835000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 20:52:22 toporko kernel: [   72.956723] cfg80211: Updating
information on frequency 5795 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:22 toporko kernel: [   72.956728] cfg80211: 5735000 KHz -
5835000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 20:52:22 toporko kernel: [   72.956731] cfg80211: Updating
information on frequency 5805 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:22 toporko kernel: [   72.956736] cfg80211: 5735000 KHz -
5835000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 20:52:22 toporko kernel: [   72.956740] cfg80211: Updating
information on frequency 5825 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:22 toporko kernel: [   72.956744] cfg80211: 5735000 KHz -
5835000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 20:52:22 toporko kernel: [   72.956747] cfg80211: Disabling freq 5835 MHz
Jan  5 20:52:22 toporko kernel: [   72.956750] cfg80211: Disabling freq 5845 MHz
Jan  5 20:52:22 toporko kernel: [   72.956752] cfg80211: Disabling freq 5855 MHz
Jan  5 20:52:22 toporko kernel: [   72.956755] cfg80211: Disabling freq 5865 MHz
Jan  5 20:52:22 toporko kernel: [   72.956757] cfg80211: Disabling freq 5920 MHz
Jan  5 20:52:22 toporko kernel: [   72.956760] cfg80211: Disabling freq 5940 MHz
Jan  5 20:52:22 toporko kernel: [   72.956763] cfg80211: Disabling freq 5960 MHz
Jan  5 20:52:22 toporko kernel: [   72.956765] cfg80211: Disabling freq 5980 MHz
Jan  5 20:52:22 toporko kernel: [   72.956768] cfg80211: Disabling freq 6040 MHz
Jan  5 20:52:22 toporko kernel: [   72.956770] cfg80211: Disabling freq 6060 MHz
Jan  5 20:52:22 toporko kernel: [   72.956773] cfg80211: Disabling freq 6080 MHz
Jan  5 20:52:22 toporko kernel: [   72.976646] cfg80211: Updating
information on frequency 2412 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:22 toporko kernel: [   72.976654] cfg80211: 2402000 KHz -
2472000 KHz @  KHz), (300 mBi, 2700 mBm)
Jan  5 20:52:22 toporko kernel: [   72.976659] cfg80211: Updating
information on frequency 2417 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:22 toporko kernel: [   72.976663] cfg80211: 2402000 KHz -
2472000 KHz @  KHz), (300 mBi, 2700 mBm)
Jan  5 20:52:22 toporko kernel: [   72.976667] cfg80211: Updating
information on frequency 2422 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:22 toporko kernel: [   72.976671] cfg80211: 2402000 KHz -
2472000 KHz @  KHz), (300 mBi, 2700 mBm)
Jan  5 20:52:22 toporko kernel: [   72.976675] cfg80211: Updating
information on frequency 2427 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:22 toporko kernel: [   72.976694] cfg80211: 2402000 KHz -
2472000 KHz @  KHz), (300 mBi, 2700 mBm)
Jan  5 20:52:22 toporko kernel: [   72.976698] cfg80211: Updating
information on frequency 2432 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:22 toporko kernel: [   72.976702] cfg80211: 2402000 KHz -
2472000 KHz @  KHz), (300 mBi, 2700 mBm)
Jan  5 20:52:22 toporko kernel: [   72.976706] cfg80211: Updating
information on frequency 2437 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:22 toporko kernel: [   72.976710] cfg80211: 2402000 KHz -
2472000 KHz @  KHz), (300 mBi, 2700 mBm)
Jan  5 20:52:22 toporko kernel: [   72.976714] cfg80211: Updating
information on frequency 2442 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:22 toporko kernel: [   72.976718] cfg80211: 2402000 KHz -
2472000 KHz @  KHz), (300 mBi, 2700 mBm)
Jan  5 20:52:22 toporko kernel: [   72.976722] cfg80211: Updating
information on frequency 2447 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:22 toporko kernel: [   72.976726] cfg80211: 2402000 KHz -
2472000 KHz @  KHz), (300 mBi, 2700 mBm)
Jan  5 20:52:22 toporko kernel: [   72.976730] cfg80211: Updating
information on frequency 2452 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:22 toporko kernel: [   72.976734] cfg80211: 2402000 KHz -
2472000 KHz @  KHz), (300 mBi, 2700 mBm)
Jan  5 20:52:22 toporko kernel: [   72.976738] cfg80211: Updating
information on frequency 2457 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:22 toporko kernel: [   72.976743] cfg80211: 2402000 KHz -
2472000 KHz @  KHz), (300 mBi, 2700 mBm)
Jan  5 20:52:22 toporko kernel: [   72.976746] cfg80211: Updating
information on frequency 2462 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:22 toporko kernel: [   72.976751] cfg80211: 2402000 KHz -
2472000 KHz @  KHz), (300 mBi, 2700 mBm)
Jan  5 20:52:22 toporko kernel: [   72.976754] cfg80211: Disabling freq 2467 MHz
Jan  5 20:52:22 toporko kernel: [   72.976757] cfg80211: Disabling freq 2472 MHz
Jan  5 20:52:22 toporko kernel: [   72.976760] cfg80211: Disabling freq 2484 MHz
Jan  5 20:52:22 toporko kernel: [   72.976763] cfg80211: Updating
information on frequency 5180 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:22 toporko kernel: [   72.976768] cfg80211: 5170000 KHz -
5250000 KHz @  KHz), (300 mBi, 1700 mBm)
Jan  5 20:52:22 toporko kernel: [   72.976771] cfg80211: Updating
information on frequency 5190 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:22 toporko kernel: [   72.976776] cfg80211: 5170000 KHz -
5250000 KHz @  KHz), (300 mBi, 1700 mBm)
Jan  5 20:52:22 toporko kernel: [   72.976779] cfg80211: Updating
information on frequency 5200 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:22 toporko kernel: [   72.976784] cfg80211: 5170000 KHz -
5250000 KHz @  KHz), (300 mBi, 1700 mBm)
Jan  5 20:52:22 toporko kernel: [   72.976788] cfg80211: Updating
information on frequency 5220 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:22 toporko kernel: [   72.976792] cfg80211: 5170000 KHz -
5250000 KHz @  KHz), (300 mBi, 1700 mBm)
Jan  5 20:52:22 toporko kernel: [   72.976796] cfg80211: Updating
information on frequency 5230 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:22 toporko kernel: [   72.976800] cfg80211: 5170000 KHz -
5250000 KHz @  KHz), (300 mBi, 1700 mBm)
Jan  5 20:52:22 toporko kernel: [   72.976804] cfg80211: Updating
information on frequency 5240 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:22 toporko kernel: [   72.976808] cfg80211: 5170000 KHz -
5250000 KHz @  KHz), (300 mBi, 1700 mBm)
Jan  5 20:52:22 toporko kernel: [   72.976812] cfg80211: Updating
information on frequency 5260 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:22 toporko kernel: [   72.976816] cfg80211: 5250000 KHz -
5330000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 20:52:22 toporko kernel: [   72.976820] cfg80211: Updating
information on frequency 5270 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:22 toporko kernel: [   72.976824] cfg80211: 5250000 KHz -
5330000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 20:52:22 toporko kernel: [   72.976828] cfg80211: Updating
information on frequency 5280 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:22 toporko kernel: [   72.976833] cfg80211: 5250000 KHz -
5330000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 20:52:22 toporko kernel: [   72.976836] cfg80211: Updating
information on frequency 5300 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:22 toporko kernel: [   72.976841] cfg80211: 5250000 KHz -
5330000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 20:52:22 toporko kernel: [   72.976844] cfg80211: Updating
information on frequency 5310 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:22 toporko kernel: [   72.976849] cfg80211: 5250000 KHz -
5330000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 20:52:22 toporko kernel: [   72.976852] cfg80211: Updating
information on frequency 5320 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:22 toporko kernel: [   72.976857] cfg80211: 5250000 KHz -
5330000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 20:52:22 toporko kernel: [   72.976860] cfg80211: Updating
information on frequency 5500 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:22 toporko kernel: [   72.976865] cfg80211: 5490000 KHz -
5600000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 20:52:22 toporko kernel: [   72.976869] cfg80211: Updating
information on frequency 5510 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:22 toporko kernel: [   72.976873] cfg80211: 5490000 KHz -
5600000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 20:52:22 toporko kernel: [   72.976877] cfg80211: Updating
information on frequency 5520 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:22 toporko kernel: [   72.976881] cfg80211: 5490000 KHz -
5600000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 20:52:22 toporko kernel: [   72.976885] cfg80211: Updating
information on frequency 5540 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:22 toporko kernel: [   72.976889] cfg80211: 5490000 KHz -
5600000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 20:52:22 toporko kernel: [   72.976893] cfg80211: Updating
information on frequency 5550 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:22 toporko kernel: [   72.976897] cfg80211: 5490000 KHz -
5600000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 20:52:22 toporko kernel: [   72.976901] cfg80211: Updating
information on frequency 5560 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:22 toporko kernel: [   72.976905] cfg80211: 5490000 KHz -
5600000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 20:52:22 toporko kernel: [   72.976909] cfg80211: Updating
information on frequency 5580 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:22 toporko kernel: [   72.976914] cfg80211: 5490000 KHz -
5600000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 20:52:22 toporko kernel: [   72.976917] cfg80211: Updating
information on frequency 5590 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:22 toporko kernel: [   72.976922] cfg80211: 5490000 KHz -
5600000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 20:52:22 toporko kernel: [   72.976925] cfg80211: Disabling freq 5600 MHz
Jan  5 20:52:22 toporko kernel: [   72.976928] cfg80211: Disabling freq 5620 MHz
Jan  5 20:52:22 toporko kernel: [   72.976930] cfg80211: Disabling freq 5630 MHz
Jan  5 20:52:22 toporko kernel: [   72.976933] cfg80211: Disabling freq 5640 MHz
Jan  5 20:52:22 toporko kernel: [   72.976936] cfg80211: Updating
information on frequency 5660 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:22 toporko kernel: [   72.976940] cfg80211: 5650000 KHz -
5710000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 20:52:22 toporko kernel: [   72.976944] cfg80211: Updating
information on frequency 5670 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:22 toporko kernel: [   72.976948] cfg80211: 5650000 KHz -
5710000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 20:52:22 toporko kernel: [   72.976952] cfg80211: Updating
information on frequency 5680 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:22 toporko kernel: [   72.976957] cfg80211: 5650000 KHz -
5710000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 20:52:22 toporko kernel: [   72.976960] cfg80211: Updating
information on frequency 5700 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:22 toporko kernel: [   72.976965] cfg80211: 5650000 KHz -
5710000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 20:52:22 toporko kernel: [   72.976968] cfg80211: Updating
information on frequency 5745 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:22 toporko kernel: [   72.976973] cfg80211: 5735000 KHz -
5835000 KHz @  KHz), (300 mBi, 3000 mBm)
Jan  5 20:52:22 toporko kernel: [   72.976977] cfg80211: Updating
information on frequency 5755 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:22 toporko kernel: [   72.976981] cfg80211: 5735000 KHz -
5835000 KHz @  KHz), (300 mBi, 3000 mBm)
Jan  5 20:52:22 toporko kernel: [   72.976985] cfg80211: Updating
information on frequency 5765 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:22 toporko kernel: [   72.976989] cfg80211: 5735000 KHz -
5835000 KHz @  KHz), (300 mBi, 3000 mBm)
Jan  5 20:52:22 toporko kernel: [   72.976993] cfg80211: Updating
information on frequency 5785 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:22 toporko kernel: [   72.976997] cfg80211: 5735000 KHz -
5835000 KHz @  KHz), (300 mBi, 3000 mBm)
Jan  5 20:52:22 toporko kernel: [   72.977001] cfg80211: Updating
information on frequency 5795 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:22 toporko kernel: [   72.977005] cfg80211: 5735000 KHz -
5835000 KHz @  KHz), (300 mBi, 3000 mBm)
Jan  5 20:52:22 toporko kernel: [   72.977009] cfg80211: Updating
information on frequency 5805 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:22 toporko kernel: [   72.977013] cfg80211: 5735000 KHz -
5835000 KHz @  KHz), (300 mBi, 3000 mBm)
Jan  5 20:52:22 toporko kernel: [   72.977017] cfg80211: Updating
information on frequency 5825 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:22 toporko kernel: [   72.977021] cfg80211: 5735000 KHz -
5835000 KHz @  KHz), (300 mBi, 3000 mBm)
Jan  5 20:52:22 toporko kernel: [   72.977025] cfg80211: Disabling freq 5835 MHz
Jan  5 20:52:22 toporko kernel: [   72.977027] cfg80211: Disabling freq 5845 MHz
Jan  5 20:52:22 toporko kernel: [   72.977030] cfg80211: Disabling freq 5855 MHz
Jan  5 20:52:22 toporko kernel: [   72.977032] cfg80211: Disabling freq 5865 MHz
Jan  5 20:52:22 toporko kernel: [   72.977035] cfg80211: Disabling freq 5920 MHz
Jan  5 20:52:22 toporko kernel: [   72.977037] cfg80211: Disabling freq 5940 MHz
Jan  5 20:52:22 toporko kernel: [   72.977040] cfg80211: Disabling freq 5960 MHz
Jan  5 20:52:22 toporko kernel: [   72.977043] cfg80211: Disabling freq 5980 MHz
Jan  5 20:52:22 toporko kernel: [   72.977045] cfg80211: Disabling freq 6040 MHz
Jan  5 20:52:22 toporko kernel: [   72.977048] cfg80211: Disabling freq 6060 MHz
Jan  5 20:52:22 toporko kernel: [   72.977050] cfg80211: Disabling freq 6080 MHz
Jan  5 20:52:25 toporko kernel: [   75.891565] wlan0: authenticate
with 00:1e:52:79:e9:ff (try 1)
Jan  5 20:52:25 toporko kernel: [   75.892454] wlan0: authenticated
Jan  5 20:52:25 toporko kernel: [   75.897183] wlan0: associate with
00:1e:52:79:e9:ff (try 1)
Jan  5 20:52:25 toporko kernel: [   75.897948] wlan0: RX AssocResp
from 00:1e:52:79:e9:ff (capab=0x511 status=0 aid=2)
Jan  5 20:52:25 toporko kernel: [   75.897955] wlan0: associated
Jan  5 20:52:25 toporko kernel: [   75.954104] cfg80211: Updating
information on frequency 2412 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:25 toporko kernel: [   75.954113] cfg80211: 2402000 KHz -
2472000 KHz @  KHz), (300 mBi, 2700 mBm)
Jan  5 20:52:25 toporko kernel: [   75.954118] cfg80211: Updating
information on frequency 2417 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:25 toporko kernel: [   75.954122] cfg80211: 2402000 KHz -
2472000 KHz @  KHz), (300 mBi, 2700 mBm)
Jan  5 20:52:25 toporko kernel: [   75.954126] cfg80211: Updating
information on frequency 2422 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:25 toporko kernel: [   75.954131] cfg80211: 2402000 KHz -
2472000 KHz @  KHz), (300 mBi, 2700 mBm)
Jan  5 20:52:25 toporko kernel: [   75.954135] cfg80211: Updating
information on frequency 2427 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:25 toporko kernel: [   75.954139] cfg80211: 2402000 KHz -
2472000 KHz @  KHz), (300 mBi, 2700 mBm)
Jan  5 20:52:25 toporko kernel: [   75.954143] cfg80211: Updating
information on frequency 2432 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:25 toporko kernel: [   75.954148] cfg80211: 2402000 KHz -
2472000 KHz @  KHz), (300 mBi, 2700 mBm)
Jan  5 20:52:25 toporko kernel: [   75.954151] cfg80211: Updating
information on frequency 2437 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:25 toporko kernel: [   75.954156] cfg80211: 2402000 KHz -
2472000 KHz @  KHz), (300 mBi, 2700 mBm)
Jan  5 20:52:25 toporko kernel: [   75.954160] cfg80211: Updating
information on frequency 2442 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:25 toporko kernel: [   75.954164] cfg80211: 2402000 KHz -
2472000 KHz @  KHz), (300 mBi, 2700 mBm)
Jan  5 20:52:25 toporko kernel: [   75.954168] cfg80211: Updating
information on frequency 2447 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:25 toporko kernel: [   75.954173] cfg80211: 2402000 KHz -
2472000 KHz @  KHz), (300 mBi, 2700 mBm)
Jan  5 20:52:25 toporko kernel: [   75.954176] cfg80211: Updating
information on frequency 2452 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:25 toporko kernel: [   75.954181] cfg80211: 2402000 KHz -
2472000 KHz @  KHz), (300 mBi, 2700 mBm)
Jan  5 20:52:25 toporko kernel: [   75.954185] cfg80211: Updating
information on frequency 2457 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:25 toporko kernel: [   75.954189] cfg80211: 2402000 KHz -
2472000 KHz @  KHz), (300 mBi, 2700 mBm)
Jan  5 20:52:25 toporko kernel: [   75.954193] cfg80211: Updating
information on frequency 2462 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:25 toporko kernel: [   75.954198] cfg80211: 2402000 KHz -
2472000 KHz @  KHz), (300 mBi, 2700 mBm)
Jan  5 20:52:25 toporko kernel: [   75.954202] cfg80211: Disabling freq 2467 MHz
Jan  5 20:52:25 toporko kernel: [   75.954204] cfg80211: Disabling freq 2472 MHz
Jan  5 20:52:25 toporko kernel: [   75.954207] cfg80211: Disabling freq 2484 MHz
Jan  5 20:52:25 toporko kernel: [   75.954211] cfg80211: Updating
information on frequency 5180 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:25 toporko kernel: [   75.954215] cfg80211: 5170000 KHz -
5250000 KHz @  KHz), (300 mBi, 1700 mBm)
Jan  5 20:52:25 toporko kernel: [   75.954219] cfg80211: Updating
information on frequency 5190 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:25 toporko kernel: [   75.954224] cfg80211: 5170000 KHz -
5250000 KHz @  KHz), (300 mBi, 1700 mBm)
Jan  5 20:52:25 toporko kernel: [   75.954228] cfg80211: Updating
information on frequency 5200 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:25 toporko kernel: [   75.954232] cfg80211: 5170000 KHz -
5250000 KHz @  KHz), (300 mBi, 1700 mBm)
Jan  5 20:52:25 toporko kernel: [   75.954236] cfg80211: Updating
information on frequency 5220 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:25 toporko kernel: [   75.954240] cfg80211: 5170000 KHz -
5250000 KHz @  KHz), (300 mBi, 1700 mBm)
Jan  5 20:52:25 toporko kernel: [   75.954244] cfg80211: Updating
information on frequency 5230 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:25 toporko kernel: [   75.954249] cfg80211: 5170000 KHz -
5250000 KHz @  KHz), (300 mBi, 1700 mBm)
Jan  5 20:52:25 toporko kernel: [   75.954253] cfg80211: Updating
information on frequency 5240 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:25 toporko kernel: [   75.954257] cfg80211: 5170000 KHz -
5250000 KHz @  KHz), (300 mBi, 1700 mBm)
Jan  5 20:52:25 toporko kernel: [   75.954261] cfg80211: Updating
information on frequency 5260 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:25 toporko kernel: [   75.954266] cfg80211: 5250000 KHz -
5330000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 20:52:25 toporko kernel: [   75.954269] cfg80211: Updating
information on frequency 5270 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:25 toporko kernel: [   75.954274] cfg80211: 5250000 KHz -
5330000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 20:52:25 toporko kernel: [   75.954278] cfg80211: Updating
information on frequency 5280 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:25 toporko kernel: [   75.954282] cfg80211: 5250000 KHz -
5330000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 20:52:25 toporko kernel: [   75.954286] cfg80211: Updating
information on frequency 5300 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:25 toporko kernel: [   75.954291] cfg80211: 5250000 KHz -
5330000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 20:52:25 toporko kernel: [   75.954295] cfg80211: Updating
information on frequency 5310 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:25 toporko kernel: [   75.954299] cfg80211: 5250000 KHz -
5330000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 20:52:25 toporko kernel: [   75.954303] cfg80211: Updating
information on frequency 5320 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:25 toporko kernel: [   75.954307] cfg80211: 5250000 KHz -
5330000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 20:52:25 toporko kernel: [   75.954311] cfg80211: Updating
information on frequency 5500 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:25 toporko kernel: [   75.954316] cfg80211: 5490000 KHz -
5600000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 20:52:25 toporko kernel: [   75.954320] cfg80211: Updating
information on frequency 5510 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:25 toporko kernel: [   75.954324] cfg80211: 5490000 KHz -
5600000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 20:52:25 toporko kernel: [   75.954328] cfg80211: Updating
information on frequency 5520 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:25 toporko kernel: [   75.954333] cfg80211: 5490000 KHz -
5600000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 20:52:25 toporko kernel: [   75.954337] cfg80211: Updating
information on frequency 5540 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:25 toporko kernel: [   75.954341] cfg80211: 5490000 KHz -
5600000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 20:52:25 toporko kernel: [   75.954345] cfg80211: Updating
information on frequency 5550 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:25 toporko kernel: [   75.954349] cfg80211: 5490000 KHz -
5600000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 20:52:25 toporko kernel: [   75.954353] cfg80211: Updating
information on frequency 5560 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:25 toporko kernel: [   75.954358] cfg80211: 5490000 KHz -
5600000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 20:52:25 toporko kernel: [   75.954362] cfg80211: Updating
information on frequency 5580 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:25 toporko kernel: [   75.954366] cfg80211: 5490000 KHz -
5600000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 20:52:25 toporko kernel: [   75.954370] cfg80211: Updating
information on frequency 5590 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:25 toporko kernel: [   75.954375] cfg80211: 5490000 KHz -
5600000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 20:52:25 toporko kernel: [   75.954378] cfg80211: Disabling freq 5600 MHz
Jan  5 20:52:25 toporko kernel: [   75.954381] cfg80211: Disabling freq 5620 MHz
Jan  5 20:52:25 toporko kernel: [   75.954383] cfg80211: Disabling freq 5630 MHz
Jan  5 20:52:25 toporko kernel: [   75.954386] cfg80211: Disabling freq 5640 MHz
Jan  5 20:52:25 toporko kernel: [   75.954389] cfg80211: Updating
information on frequency 5660 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:25 toporko kernel: [   75.954394] cfg80211: 5650000 KHz -
5710000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 20:52:25 toporko kernel: [   75.954398] cfg80211: Updating
information on frequency 5670 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:25 toporko kernel: [   75.954402] cfg80211: 5650000 KHz -
5710000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 20:52:25 toporko kernel: [   75.954406] cfg80211: Updating
information on frequency 5680 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:25 toporko kernel: [   75.954411] cfg80211: 5650000 KHz -
5710000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 20:52:25 toporko kernel: [   75.954414] cfg80211: Updating
information on frequency 5700 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:25 toporko kernel: [   75.954419] cfg80211: 5650000 KHz -
5710000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 20:52:25 toporko kernel: [   75.954423] cfg80211: Updating
information on frequency 5745 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:25 toporko kernel: [   75.954427] cfg80211: 5735000 KHz -
5835000 KHz @  KHz), (300 mBi, 3000 mBm)
Jan  5 20:52:25 toporko kernel: [   75.954431] cfg80211: Updating
information on frequency 5755 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:25 toporko kernel: [   75.954436] cfg80211: 5735000 KHz -
5835000 KHz @  KHz), (300 mBi, 3000 mBm)
Jan  5 20:52:25 toporko kernel: [   75.954440] cfg80211: Updating
information on frequency 5765 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:25 toporko kernel: [   75.954444] cfg80211: 5735000 KHz -
5835000 KHz @  KHz), (300 mBi, 3000 mBm)
Jan  5 20:52:25 toporko kernel: [   75.954448] cfg80211: Updating
information on frequency 5785 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:25 toporko kernel: [   75.954453] cfg80211: 5735000 KHz -
5835000 KHz @  KHz), (300 mBi, 3000 mBm)
Jan  5 20:52:25 toporko kernel: [   75.954456] cfg80211: Updating
information on frequency 5795 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:25 toporko kernel: [   75.954461] cfg80211: 5735000 KHz -
5835000 KHz @  KHz), (300 mBi, 3000 mBm)
Jan  5 20:52:25 toporko kernel: [   75.954465] cfg80211: Updating
information on frequency 5805 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:25 toporko kernel: [   75.954469] cfg80211: 5735000 KHz -
5835000 KHz @  KHz), (300 mBi, 3000 mBm)
Jan  5 20:52:25 toporko kernel: [   75.954473] cfg80211: Updating
information on frequency 5825 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 20:52:25 toporko kernel: [   75.954478] cfg80211: 5735000 KHz -
5835000 KHz @  KHz), (300 mBi, 3000 mBm)
Jan  5 20:52:25 toporko kernel: [   75.954481] cfg80211: Disabling freq 5835 MHz
Jan  5 20:52:25 toporko kernel: [   75.954484] cfg80211: Disabling freq 5845 MHz
Jan  5 20:52:25 toporko kernel: [   75.954486] cfg80211: Disabling freq 5855 MHz
Jan  5 20:52:25 toporko kernel: [   75.954489] cfg80211: Disabling freq 5865 MHz
Jan  5 20:52:25 toporko kernel: [   75.954492] cfg80211: Disabling freq 5920 MHz
Jan  5 20:52:25 toporko kernel: [   75.954494] cfg80211: Disabling freq 5940 MHz
Jan  5 20:52:25 toporko kernel: [   75.954497] cfg80211: Disabling freq 5960 MHz
Jan  5 20:52:25 toporko kernel: [   75.954500] cfg80211: Disabling freq 5980 MHz
Jan  5 20:52:25 toporko kernel: [   75.954502] cfg80211: Disabling freq 6040 MHz
Jan  5 20:52:25 toporko kernel: [   75.954505] cfg80211: Disabling freq 6060 MHz
Jan  5 20:52:25 toporko kernel: [   75.954508] cfg80211: Disabling freq 6080 MHz

Then things go quiet in the debug file until 21:00, at which point
everything goes downhill:

Jan  5 21:00:13 toporko kernel: [  543.500035] ieee80211 phy0: wlan0:
No probe response from AP 00:1e:52:79:e9:ff after 500ms,
disconnecting.
Jan  5 21:00:15 toporko kernel: [  545.128547] cfg80211: All devices
are disconnected, going to restore regulatory settings
Jan  5 21:00:15 toporko kernel: [  545.128560] cfg80211: Restoring
regulatory settings while preserving user preference for: US
Jan  5 21:00:15 toporko kernel: [  545.139620] cfg80211: Updating
information on frequency 2412 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 21:00:15 toporko kernel: [  545.139629] cfg80211: 2402000 KHz -
2472000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 21:00:15 toporko kernel: [  545.139633] cfg80211: Updating
information on frequency 2417 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 21:00:15 toporko kernel: [  545.139638] cfg80211: 2402000 KHz -
2472000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 21:00:15 toporko kernel: [  545.139642] cfg80211: Updating
information on frequency 2422 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 21:00:15 toporko kernel: [  545.139646] cfg80211: 2402000 KHz -
2472000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 21:00:15 toporko kernel: [  545.139650] cfg80211: Updating
information on frequency 2427 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 21:00:15 toporko kernel: [  545.139655] cfg80211: 2402000 KHz -
2472000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 21:00:15 toporko kernel: [  545.139658] cfg80211: Updating
information on frequency 2432 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 21:00:15 toporko kernel: [  545.139663] cfg80211: 2402000 KHz -
2472000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 21:00:15 toporko kernel: [  545.139666] cfg80211: Updating
information on frequency 2437 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 21:00:15 toporko kernel: [  545.139671] cfg80211: 2402000 KHz -
2472000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 21:00:15 toporko kernel: [  545.139675] cfg80211: Updating
information on frequency 2442 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 21:00:15 toporko kernel: [  545.139679] cfg80211: 2402000 KHz -
2472000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 21:00:15 toporko kernel: [  545.139683] cfg80211: Updating
information on frequency 2447 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 21:00:15 toporko kernel: [  545.139687] cfg80211: 2402000 KHz -
2472000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 21:00:15 toporko kernel: [  545.139691] cfg80211: Updating
information on frequency 2452 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 21:00:15 toporko kernel: [  545.139695] cfg80211: 2402000 KHz -
2472000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 21:00:15 toporko kernel: [  545.139699] cfg80211: Updating
information on frequency 2457 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 21:00:15 toporko kernel: [  545.139704] cfg80211: 2402000 KHz -
2472000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 21:00:15 toporko kernel: [  545.139707] cfg80211: Updating
information on frequency 2462 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 21:00:15 toporko kernel: [  545.139712] cfg80211: 2402000 KHz -
2472000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 21:00:15 toporko kernel: [  545.139715] cfg80211: Updating
information on frequency 2467 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 21:00:15 toporko kernel: [  545.139720] cfg80211: 2457000 KHz -
2482000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 21:00:15 toporko kernel: [  545.139724] cfg80211: Updating
information on frequency 2472 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 21:00:15 toporko kernel: [  545.139728] cfg80211: 2457000 KHz -
2482000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 21:00:15 toporko kernel: [  545.139732] cfg80211: Updating
information on frequency 2484 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 21:00:15 toporko kernel: [  545.139736] cfg80211: 2474000 KHz -
2494000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 21:00:15 toporko kernel: [  545.139740] cfg80211: Updating
information on frequency 5180 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 21:00:15 toporko kernel: [  545.139745] cfg80211: 5170000 KHz -
5250000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 21:00:15 toporko kernel: [  545.139749] cfg80211: Updating
information on frequency 5190 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 21:00:15 toporko kernel: [  545.139753] cfg80211: 5170000 KHz -
5250000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 21:00:15 toporko kernel: [  545.139757] cfg80211: Updating
information on frequency 5200 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 21:00:15 toporko kernel: [  545.139761] cfg80211: 5170000 KHz -
5250000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 21:00:15 toporko kernel: [  545.139765] cfg80211: Updating
information on frequency 5220 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 21:00:15 toporko kernel: [  545.139770] cfg80211: 5170000 KHz -
5250000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 21:00:15 toporko kernel: [  545.139773] cfg80211: Updating
information on frequency 5230 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 21:00:15 toporko kernel: [  545.139778] cfg80211: 5170000 KHz -
5250000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 21:00:15 toporko kernel: [  545.139781] cfg80211: Updating
information on frequency 5240 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 21:00:15 toporko kernel: [  545.139786] cfg80211: 5170000 KHz -
5250000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 21:00:15 toporko kernel: [  545.139790] cfg80211: Disabling freq 5260 MHz
Jan  5 21:00:15 toporko kernel: [  545.139792] cfg80211: Disabling freq 5270 MHz
Jan  5 21:00:15 toporko kernel: [  545.139795] cfg80211: Disabling freq 5280 MHz
Jan  5 21:00:15 toporko kernel: [  545.139798] cfg80211: Disabling freq 5300 MHz
Jan  5 21:00:15 toporko kernel: [  545.139800] cfg80211: Disabling freq 5310 MHz
Jan  5 21:00:15 toporko kernel: [  545.139803] cfg80211: Disabling freq 5320 MHz
Jan  5 21:00:15 toporko kernel: [  545.139806] cfg80211: Disabling freq 5500 MHz
Jan  5 21:00:15 toporko kernel: [  545.139808] cfg80211: Disabling freq 5510 MHz
Jan  5 21:00:15 toporko kernel: [  545.139811] cfg80211: Disabling freq 5520 MHz
Jan  5 21:00:15 toporko kernel: [  545.139813] cfg80211: Disabling freq 5540 MHz
Jan  5 21:00:15 toporko kernel: [  545.139816] cfg80211: Disabling freq 5550 MHz
Jan  5 21:00:15 toporko kernel: [  545.139819] cfg80211: Disabling freq 5560 MHz
Jan  5 21:00:15 toporko kernel: [  545.139821] cfg80211: Disabling freq 5580 MHz
Jan  5 21:00:15 toporko kernel: [  545.139824] cfg80211: Disabling freq 5590 MHz
Jan  5 21:00:15 toporko kernel: [  545.139827] cfg80211: Disabling freq 5600 MHz
Jan  5 21:00:15 toporko kernel: [  545.139829] cfg80211: Disabling freq 5620 MHz
Jan  5 21:00:15 toporko kernel: [  545.139832] cfg80211: Disabling freq 5630 MHz
Jan  5 21:00:15 toporko kernel: [  545.139834] cfg80211: Disabling freq 5640 MHz
Jan  5 21:00:15 toporko kernel: [  545.139837] cfg80211: Disabling freq 5660 MHz
Jan  5 21:00:15 toporko kernel: [  545.139840] cfg80211: Disabling freq 5670 MHz
Jan  5 21:00:15 toporko kernel: [  545.139842] cfg80211: Disabling freq 5680 MHz
Jan  5 21:00:15 toporko kernel: [  545.139845] cfg80211: Disabling freq 5700 MHz
Jan  5 21:00:15 toporko kernel: [  545.139848] cfg80211: Updating
information on frequency 5745 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 21:00:15 toporko kernel: [  545.139853] cfg80211: 5735000 KHz -
5835000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 21:00:15 toporko kernel: [  545.139856] cfg80211: Updating
information on frequency 5755 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 21:00:15 toporko kernel: [  545.139861] cfg80211: 5735000 KHz -
5835000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 21:00:15 toporko kernel: [  545.139865] cfg80211: Updating
information on frequency 5765 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 21:00:15 toporko kernel: [  545.139869] cfg80211: 5735000 KHz -
5835000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 21:00:15 toporko kernel: [  545.139873] cfg80211: Updating
information on frequency 5785 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 21:00:15 toporko kernel: [  545.139877] cfg80211: 5735000 KHz -
5835000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 21:00:15 toporko kernel: [  545.139881] cfg80211: Updating
information on frequency 5795 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 21:00:15 toporko kernel: [  545.139885] cfg80211: 5735000 KHz -
5835000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 21:00:15 toporko kernel: [  545.139889] cfg80211: Updating
information on frequency 5805 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 21:00:15 toporko kernel: [  545.139893] cfg80211: 5735000 KHz -
5835000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 21:00:15 toporko kernel: [  545.139897] cfg80211: Updating
information on frequency 5825 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 21:00:15 toporko kernel: [  545.139926] cfg80211: 5735000 KHz -
5835000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 21:00:15 toporko kernel: [  545.139930] cfg80211: Disabling freq 5835 MHz
Jan  5 21:00:15 toporko kernel: [  545.139933] cfg80211: Disabling freq 5845 MHz
Jan  5 21:00:15 toporko kernel: [  545.139936] cfg80211: Disabling freq 5855 MHz
Jan  5 21:00:15 toporko kernel: [  545.139938] cfg80211: Disabling freq 5865 MHz
Jan  5 21:00:15 toporko kernel: [  545.139941] cfg80211: Disabling freq 5920 MHz
Jan  5 21:00:15 toporko kernel: [  545.139943] cfg80211: Disabling freq 5940 MHz
Jan  5 21:00:15 toporko kernel: [  545.139945] cfg80211: Disabling freq 5960 MHz
Jan  5 21:00:15 toporko kernel: [  545.139948] cfg80211: Disabling freq 5980 MHz
Jan  5 21:00:15 toporko kernel: [  545.139950] cfg80211: Disabling freq 6040 MHz
Jan  5 21:00:15 toporko kernel: [  545.139953] cfg80211: Disabling freq 6060 MHz
Jan  5 21:00:15 toporko kernel: [  545.139955] cfg80211: Disabling freq 6080 MHz
Jan  5 21:00:15 toporko kernel: [  545.161716] cfg80211: Updating
information on frequency 2412 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 21:00:15 toporko kernel: [  545.161726] cfg80211: 2402000 KHz -
2472000 KHz @  KHz), (300 mBi, 2700 mBm)
Jan  5 21:00:15 toporko kernel: [  545.161730] cfg80211: Updating
information on frequency 2417 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 21:00:15 toporko kernel: [  545.161735] cfg80211: 2402000 KHz -
2472000 KHz @  KHz), (300 mBi, 2700 mBm)
Jan  5 21:00:15 toporko kernel: [  545.161739] cfg80211: Updating
information on frequency 2422 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 21:00:15 toporko kernel: [  545.161744] cfg80211: 2402000 KHz -
2472000 KHz @  KHz), (300 mBi, 2700 mBm)
Jan  5 21:00:15 toporko kernel: [  545.161748] cfg80211: Updating
information on frequency 2427 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 21:00:15 toporko kernel: [  545.161752] cfg80211: 2402000 KHz -
2472000 KHz @  KHz), (300 mBi, 2700 mBm)
Jan  5 21:00:15 toporko kernel: [  545.161756] cfg80211: Updating
information on frequency 2432 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 21:00:15 toporko kernel: [  545.161761] cfg80211: 2402000 KHz -
2472000 KHz @  KHz), (300 mBi, 2700 mBm)
Jan  5 21:00:15 toporko kernel: [  545.161765] cfg80211: Updating
information on frequency 2437 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 21:00:15 toporko kernel: [  545.161769] cfg80211: 2402000 KHz -
2472000 KHz @  KHz), (300 mBi, 2700 mBm)
Jan  5 21:00:15 toporko kernel: [  545.161773] cfg80211: Updating
information on frequency 2442 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 21:00:15 toporko kernel: [  545.161778] cfg80211: 2402000 KHz -
2472000 KHz @  KHz), (300 mBi, 2700 mBm)
Jan  5 21:00:15 toporko kernel: [  545.161782] cfg80211: Updating
information on frequency 2447 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 21:00:15 toporko kernel: [  545.161787] cfg80211: 2402000 KHz -
2472000 KHz @  KHz), (300 mBi, 2700 mBm)
Jan  5 21:00:15 toporko kernel: [  545.161791] cfg80211: Updating
information on frequency 2452 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 21:00:15 toporko kernel: [  545.161795] cfg80211: 2402000 KHz -
2472000 KHz @  KHz), (300 mBi, 2700 mBm)
Jan  5 21:00:15 toporko kernel: [  545.161799] cfg80211: Updating
information on frequency 2457 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 21:00:15 toporko kernel: [  545.161804] cfg80211: 2402000 KHz -
2472000 KHz @  KHz), (300 mBi, 2700 mBm)
Jan  5 21:00:15 toporko kernel: [  545.161808] cfg80211: Updating
information on frequency 2462 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 21:00:15 toporko kernel: [  545.161812] cfg80211: 2402000 KHz -
2472000 KHz @  KHz), (300 mBi, 2700 mBm)
Jan  5 21:00:15 toporko kernel: [  545.161816] cfg80211: Disabling freq 2467 MHz
Jan  5 21:00:15 toporko kernel: [  545.161819] cfg80211: Disabling freq 2472 MHz
Jan  5 21:00:15 toporko kernel: [  545.161822] cfg80211: Disabling freq 2484 MHz
Jan  5 21:00:15 toporko kernel: [  545.161825] cfg80211: Updating
information on frequency 5180 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 21:00:15 toporko kernel: [  545.161830] cfg80211: 5170000 KHz -
5250000 KHz @  KHz), (300 mBi, 1700 mBm)
Jan  5 21:00:15 toporko kernel: [  545.161834] cfg80211: Updating
information on frequency 5190 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 21:00:15 toporko kernel: [  545.161839] cfg80211: 5170000 KHz -
5250000 KHz @  KHz), (300 mBi, 1700 mBm)
Jan  5 21:00:15 toporko kernel: [  545.161843] cfg80211: Updating
information on frequency 5200 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 21:00:15 toporko kernel: [  545.161847] cfg80211: 5170000 KHz -
5250000 KHz @  KHz), (300 mBi, 1700 mBm)
Jan  5 21:00:15 toporko kernel: [  545.161851] cfg80211: Updating
information on frequency 5220 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 21:00:15 toporko kernel: [  545.161856] cfg80211: 5170000 KHz -
5250000 KHz @  KHz), (300 mBi, 1700 mBm)
Jan  5 21:00:15 toporko kernel: [  545.161860] cfg80211: Updating
information on frequency 5230 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 21:00:15 toporko kernel: [  545.161865] cfg80211: 5170000 KHz -
5250000 KHz @  KHz), (300 mBi, 1700 mBm)
Jan  5 21:00:15 toporko kernel: [  545.161868] cfg80211: Updating
information on frequency 5240 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 21:00:15 toporko kernel: [  545.161873] cfg80211: 5170000 KHz -
5250000 KHz @  KHz), (300 mBi, 1700 mBm)
Jan  5 21:00:15 toporko kernel: [  545.161877] cfg80211: Updating
information on frequency 5260 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 21:00:15 toporko kernel: [  545.161882] cfg80211: 5250000 KHz -
5330000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 21:00:15 toporko kernel: [  545.161886] cfg80211: Updating
information on frequency 5270 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 21:00:15 toporko kernel: [  545.161890] cfg80211: 5250000 KHz -
5330000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 21:00:15 toporko kernel: [  545.161894] cfg80211: Updating
information on frequency 5280 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 21:00:15 toporko kernel: [  545.161899] cfg80211: 5250000 KHz -
5330000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 21:00:15 toporko kernel: [  545.161903] cfg80211: Updating
information on frequency 5300 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 21:00:15 toporko kernel: [  545.161908] cfg80211: 5250000 KHz -
5330000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 21:00:15 toporko kernel: [  545.161912] cfg80211: Updating
information on frequency 5310 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 21:00:15 toporko kernel: [  545.161916] cfg80211: 5250000 KHz -
5330000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 21:00:15 toporko kernel: [  545.161920] cfg80211: Updating
information on frequency 5320 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 21:00:15 toporko kernel: [  545.161925] cfg80211: 5250000 KHz -
5330000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 21:00:15 toporko kernel: [  545.161929] cfg80211: Updating
information on frequency 5500 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 21:00:15 toporko kernel: [  545.161933] cfg80211: 5490000 KHz -
5600000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 21:00:15 toporko kernel: [  545.161937] cfg80211: Updating
information on frequency 5510 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 21:00:15 toporko kernel: [  545.161942] cfg80211: 5490000 KHz -
5600000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 21:00:15 toporko kernel: [  545.161946] cfg80211: Updating
information on frequency 5520 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 21:00:15 toporko kernel: [  545.161951] cfg80211: 5490000 KHz -
5600000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 21:00:15 toporko kernel: [  545.161955] cfg80211: Updating
information on frequency 5540 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 21:00:15 toporko kernel: [  545.161959] cfg80211: 5490000 KHz -
5600000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 21:00:15 toporko kernel: [  545.161963] cfg80211: Updating
information on frequency 5550 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 21:00:15 toporko kernel: [  545.161968] cfg80211: 5490000 KHz -
5600000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 21:00:15 toporko kernel: [  545.161972] cfg80211: Updating
information on frequency 5560 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 21:00:15 toporko kernel: [  545.161977] cfg80211: 5490000 KHz -
5600000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 21:00:15 toporko kernel: [  545.161980] cfg80211: Updating
information on frequency 5580 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 21:00:15 toporko kernel: [  545.161985] cfg80211: 5490000 KHz -
5600000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 21:00:15 toporko kernel: [  545.161989] cfg80211: Updating
information on frequency 5590 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 21:00:15 toporko kernel: [  545.161994] cfg80211: 5490000 KHz -
5600000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 21:00:15 toporko kernel: [  545.161997] cfg80211: Disabling freq 5600 MHz
Jan  5 21:00:15 toporko kernel: [  545.162000] cfg80211: Disabling freq 5620 MHz
Jan  5 21:00:15 toporko kernel: [  545.162003] cfg80211: Disabling freq 5630 MHz
Jan  5 21:00:15 toporko kernel: [  545.162005] cfg80211: Disabling freq 5640 MHz
Jan  5 21:00:15 toporko kernel: [  545.162009] cfg80211: Updating
information on frequency 5660 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 21:00:15 toporko kernel: [  545.162013] cfg80211: 5650000 KHz -
5710000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 21:00:15 toporko kernel: [  545.162017] cfg80211: Updating
information on frequency 5670 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 21:00:15 toporko kernel: [  545.162022] cfg80211: 5650000 KHz -
5710000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 21:00:15 toporko kernel: [  545.162026] cfg80211: Updating
information on frequency 5680 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 21:00:15 toporko kernel: [  545.162031] cfg80211: 5650000 KHz -
5710000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 21:00:15 toporko kernel: [  545.162035] cfg80211: Updating
information on frequency 5700 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 21:00:15 toporko kernel: [  545.162039] cfg80211: 5650000 KHz -
5710000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 21:00:15 toporko kernel: [  545.162043] cfg80211: Updating
information on frequency 5745 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 21:00:15 toporko kernel: [  545.162048] cfg80211: 5735000 KHz -
5835000 KHz @  KHz), (300 mBi, 3000 mBm)
Jan  5 21:00:15 toporko kernel: [  545.162052] cfg80211: Updating
information on frequency 5755 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 21:00:15 toporko kernel: [  545.162057] cfg80211: 5735000 KHz -
5835000 KHz @  KHz), (300 mBi, 3000 mBm)
Jan  5 21:00:15 toporko kernel: [  545.162061] cfg80211: Updating
information on frequency 5765 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 21:00:15 toporko kernel: [  545.162065] cfg80211: 5735000 KHz -
5835000 KHz @  KHz), (300 mBi, 3000 mBm)
Jan  5 21:00:15 toporko kernel: [  545.162069] cfg80211: Updating
information on frequency 5785 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 21:00:15 toporko kernel: [  545.162074] cfg80211: 5735000 KHz -
5835000 KHz @  KHz), (300 mBi, 3000 mBm)
Jan  5 21:00:15 toporko kernel: [  545.162078] cfg80211: Updating
information on frequency 5795 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 21:00:15 toporko kernel: [  545.162082] cfg80211: 5735000 KHz -
5835000 KHz @  KHz), (300 mBi, 3000 mBm)
Jan  5 21:00:15 toporko kernel: [  545.162086] cfg80211: Updating
information on frequency 5805 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 21:00:15 toporko kernel: [  545.162091] cfg80211: 5735000 KHz -
5835000 KHz @  KHz), (300 mBi, 3000 mBm)
Jan  5 21:00:15 toporko kernel: [  545.162095] cfg80211: Updating
information on frequency 5825 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 21:00:15 toporko kernel: [  545.162100] cfg80211: 5735000 KHz -
5835000 KHz @  KHz), (300 mBi, 3000 mBm)
Jan  5 21:00:15 toporko kernel: [  545.162103] cfg80211: Disabling freq 5835 MHz
Jan  5 21:00:15 toporko kernel: [  545.162106] cfg80211: Disabling freq 5845 MHz
Jan  5 21:00:15 toporko kernel: [  545.162109] cfg80211: Disabling freq 5855 MHz
Jan  5 21:00:15 toporko kernel: [  545.162111] cfg80211: Disabling freq 5865 MHz
Jan  5 21:00:15 toporko kernel: [  545.162114] cfg80211: Disabling freq 5920 MHz
Jan  5 21:00:15 toporko kernel: [  545.162117] cfg80211: Disabling freq 5940 MHz
Jan  5 21:00:15 toporko kernel: [  545.162119] cfg80211: Disabling freq 5960 MHz
Jan  5 21:00:15 toporko kernel: [  545.162122] cfg80211: Disabling freq 5980 MHz
Jan  5 21:00:15 toporko kernel: [  545.162125] cfg80211: Disabling freq 6040 MHz
Jan  5 21:00:15 toporko kernel: [  545.162128] cfg80211: Disabling freq 6060 MHz
Jan  5 21:00:15 toporko kernel: [  545.162130] cfg80211: Disabling freq 6080 MHz
Jan  5 21:00:19 toporko kernel: [  549.851375] wlan0: authenticate
with 00:1e:52:79:e9:ff (try 1)
Jan  5 21:00:19 toporko kernel: [  549.852340] wlan0: authenticated
Jan  5 21:00:19 toporko kernel: [  549.857876] wlan0: associate with
00:1e:52:79:e9:ff (try 1)
Jan  5 21:00:19 toporko kernel: [  549.858652] wlan0: RX AssocResp
from 00:1e:52:79:e9:ff (capab=0x511 status=0 aid=2)
Jan  5 21:00:19 toporko kernel: [  549.858659] wlan0: associated
Jan  5 21:00:19 toporko kernel: [  549.899302] cfg80211: Updating
information on frequency 2412 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 21:00:19 toporko kernel: [  549.899311] cfg80211: 2402000 KHz -
2472000 KHz @  KHz), (300 mBi, 2700 mBm)
Jan  5 21:00:19 toporko kernel: [  549.899315] cfg80211: Updating
information on frequency 2417 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 21:00:19 toporko kernel: [  549.899320] cfg80211: 2402000 KHz -
2472000 KHz @  KHz), (300 mBi, 2700 mBm)
Jan  5 21:00:19 toporko kernel: [  549.899324] cfg80211: Updating
information on frequency 2422 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 21:00:19 toporko kernel: [  549.899328] cfg80211: 2402000 KHz -
2472000 KHz @  KHz), (300 mBi, 2700 mBm)
Jan  5 21:00:19 toporko kernel: [  549.899332] cfg80211: Updating
information on frequency 2427 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 21:00:19 toporko kernel: [  549.899337] cfg80211: 2402000 KHz -
2472000 KHz @  KHz), (300 mBi, 2700 mBm)
Jan  5 21:00:19 toporko kernel: [  549.899340] cfg80211: Updating
information on frequency 2432 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 21:00:19 toporko kernel: [  549.899345] cfg80211: 2402000 KHz -
2472000 KHz @  KHz), (300 mBi, 2700 mBm)
Jan  5 21:00:19 toporko kernel: [  549.899349] cfg80211: Updating
information on frequency 2437 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 21:00:19 toporko kernel: [  549.899353] cfg80211: 2402000 KHz -
2472000 KHz @  KHz), (300 mBi, 2700 mBm)
Jan  5 21:00:19 toporko kernel: [  549.899357] cfg80211: Updating
information on frequency 2442 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 21:00:19 toporko kernel: [  549.899361] cfg80211: 2402000 KHz -
2472000 KHz @  KHz), (300 mBi, 2700 mBm)
Jan  5 21:00:19 toporko kernel: [  549.899365] cfg80211: Updating
information on frequency 2447 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 21:00:19 toporko kernel: [  549.899370] cfg80211: 2402000 KHz -
2472000 KHz @  KHz), (300 mBi, 2700 mBm)
Jan  5 21:00:19 toporko kernel: [  549.899373] cfg80211: Updating
information on frequency 2452 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 21:00:19 toporko kernel: [  549.899378] cfg80211: 2402000 KHz -
2472000 KHz @  KHz), (300 mBi, 2700 mBm)
Jan  5 21:00:19 toporko kernel: [  549.899382] cfg80211: Updating
information on frequency 2457 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 21:00:19 toporko kernel: [  549.899386] cfg80211: 2402000 KHz -
2472000 KHz @  KHz), (300 mBi, 2700 mBm)
Jan  5 21:00:19 toporko kernel: [  549.899390] cfg80211: Updating
information on frequency 2462 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 21:00:19 toporko kernel: [  549.899395] cfg80211: 2402000 KHz -
2472000 KHz @  KHz), (300 mBi, 2700 mBm)
Jan  5 21:00:19 toporko kernel: [  549.899398] cfg80211: Disabling freq 2467 MHz
Jan  5 21:00:19 toporko kernel: [  549.899401] cfg80211: Disabling freq 2472 MHz
Jan  5 21:00:19 toporko kernel: [  549.899404] cfg80211: Disabling freq 2484 MHz
Jan  5 21:00:19 toporko kernel: [  549.899408] cfg80211: Updating
information on frequency 5180 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 21:00:19 toporko kernel: [  549.899412] cfg80211: 5170000 KHz -
5250000 KHz @  KHz), (300 mBi, 1700 mBm)
Jan  5 21:00:19 toporko kernel: [  549.899416] cfg80211: Updating
information on frequency 5190 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 21:00:19 toporko kernel: [  549.899420] cfg80211: 5170000 KHz -
5250000 KHz @  KHz), (300 mBi, 1700 mBm)
Jan  5 21:00:19 toporko kernel: [  549.899424] cfg80211: Updating
information on frequency 5200 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 21:00:19 toporko kernel: [  549.899429] cfg80211: 5170000 KHz -
5250000 KHz @  KHz), (300 mBi, 1700 mBm)
Jan  5 21:00:19 toporko kernel: [  549.899432] cfg80211: Updating
information on frequency 5220 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 21:00:19 toporko kernel: [  549.899437] cfg80211: 5170000 KHz -
5250000 KHz @  KHz), (300 mBi, 1700 mBm)
Jan  5 21:00:19 toporko kernel: [  549.899441] cfg80211: Updating
information on frequency 5230 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 21:00:19 toporko kernel: [  549.899445] cfg80211: 5170000 KHz -
5250000 KHz @  KHz), (300 mBi, 1700 mBm)
Jan  5 21:00:19 toporko kernel: [  549.899449] cfg80211: Updating
information on frequency 5240 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 21:00:19 toporko kernel: [  549.899453] cfg80211: 5170000 KHz -
5250000 KHz @  KHz), (300 mBi, 1700 mBm)
Jan  5 21:00:19 toporko kernel: [  549.899457] cfg80211: Updating
information on frequency 5260 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 21:00:19 toporko kernel: [  549.899462] cfg80211: 5250000 KHz -
5330000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 21:00:19 toporko kernel: [  549.899466] cfg80211: Updating
information on frequency 5270 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 21:00:19 toporko kernel: [  549.899470] cfg80211: 5250000 KHz -
5330000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 21:00:19 toporko kernel: [  549.899474] cfg80211: Updating
information on frequency 5280 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 21:00:19 toporko kernel: [  549.899478] cfg80211: 5250000 KHz -
5330000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 21:00:19 toporko kernel: [  549.899482] cfg80211: Updating
information on frequency 5300 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 21:00:19 toporko kernel: [  549.899487] cfg80211: 5250000 KHz -
5330000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 21:00:19 toporko kernel: [  549.899491] cfg80211: Updating
information on frequency 5310 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 21:00:19 toporko kernel: [  549.899495] cfg80211: 5250000 KHz -
5330000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 21:00:19 toporko kernel: [  549.899499] cfg80211: Updating
information on frequency 5320 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 21:00:19 toporko kernel: [  549.899503] cfg80211: 5250000 KHz -
5330000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 21:00:19 toporko kernel: [  549.899507] cfg80211: Updating
information on frequency 5500 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 21:00:19 toporko kernel: [  549.899512] cfg80211: 5490000 KHz -
5600000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 21:00:19 toporko kernel: [  549.899515] cfg80211: Updating
information on frequency 5510 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 21:00:19 toporko kernel: [  549.899520] cfg80211: 5490000 KHz -
5600000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 21:00:19 toporko kernel: [  549.899524] cfg80211: Updating
information on frequency 5520 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 21:00:19 toporko kernel: [  549.899528] cfg80211: 5490000 KHz -
5600000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 21:00:19 toporko kernel: [  549.899532] cfg80211: Updating
information on frequency 5540 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 21:00:19 toporko kernel: [  549.899537] cfg80211: 5490000 KHz -
5600000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 21:00:19 toporko kernel: [  549.899540] cfg80211: Updating
information on frequency 5550 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 21:00:19 toporko kernel: [  549.899545] cfg80211: 5490000 KHz -
5600000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 21:00:19 toporko kernel: [  549.899549] cfg80211: Updating
information on frequency 5560 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 21:00:19 toporko kernel: [  549.899553] cfg80211: 5490000 KHz -
5600000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 21:00:19 toporko kernel: [  549.899557] cfg80211: Updating
information on frequency 5580 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 21:00:19 toporko kernel: [  549.899561] cfg80211: 5490000 KHz -
5600000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 21:00:19 toporko kernel: [  549.899565] cfg80211: Updating
information on frequency 5590 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 21:00:19 toporko kernel: [  549.899570] cfg80211: 5490000 KHz -
5600000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 21:00:19 toporko kernel: [  549.899573] cfg80211: Disabling freq 5600 MHz
Jan  5 21:00:19 toporko kernel: [  549.899576] cfg80211: Disabling freq 5620 MHz
Jan  5 21:00:19 toporko kernel: [  549.899579] cfg80211: Disabling freq 5630 MHz
Jan  5 21:00:19 toporko kernel: [  549.899581] cfg80211: Disabling freq 5640 MHz
Jan  5 21:00:19 toporko kernel: [  549.899584] cfg80211: Updating
information on frequency 5660 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 21:00:19 toporko kernel: [  549.899589] cfg80211: 5650000 KHz -
5710000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 21:00:19 toporko kernel: [  549.899593] cfg80211: Updating
information on frequency 5670 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 21:00:19 toporko kernel: [  549.899597] cfg80211: 5650000 KHz -
5710000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 21:00:19 toporko kernel: [  549.899601] cfg80211: Updating
information on frequency 5680 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 21:00:19 toporko kernel: [  549.899606] cfg80211: 5650000 KHz -
5710000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 21:00:19 toporko kernel: [  549.899609] cfg80211: Updating
information on frequency 5700 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 21:00:19 toporko kernel: [  549.899614] cfg80211: 5650000 KHz -
5710000 KHz @  KHz), (300 mBi, 2000 mBm)
Jan  5 21:00:19 toporko kernel: [  549.899618] cfg80211: Updating
information on frequency 5745 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 21:00:19 toporko kernel: [  549.899622] cfg80211: 5735000 KHz -
5835000 KHz @  KHz), (300 mBi, 3000 mBm)
Jan  5 21:00:19 toporko kernel: [  549.899626] cfg80211: Updating
information on frequency 5755 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 21:00:19 toporko kernel: [  549.899631] cfg80211: 5735000 KHz -
5835000 KHz @  KHz), (300 mBi, 3000 mBm)
Jan  5 21:00:19 toporko kernel: [  549.899634] cfg80211: Updating
information on frequency 5765 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 21:00:19 toporko kernel: [  549.899639] cfg80211: 5735000 KHz -
5835000 KHz @  KHz), (300 mBi, 3000 mBm)
Jan  5 21:00:19 toporko kernel: [  549.899643] cfg80211: Updating
information on frequency 5785 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 21:00:19 toporko kernel: [  549.899647] cfg80211: 5735000 KHz -
5835000 KHz @  KHz), (300 mBi, 3000 mBm)
Jan  5 21:00:19 toporko kernel: [  549.899651] cfg80211: Updating
information on frequency 5795 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 21:00:19 toporko kernel: [  549.899656] cfg80211: 5735000 KHz -
5835000 KHz @  KHz), (300 mBi, 3000 mBm)
Jan  5 21:00:19 toporko kernel: [  549.899659] cfg80211: Updating
information on frequency 5805 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 21:00:19 toporko kernel: [  549.899664] cfg80211: 5735000 KHz -
5835000 KHz @  KHz), (300 mBi, 3000 mBm)
Jan  5 21:00:19 toporko kernel: [  549.899668] cfg80211: Updating
information on frequency 5825 MHz for 20 a MHz width channel with
regulatory rule:
Jan  5 21:00:19 toporko kernel: [  549.899672] cfg80211: 5735000 KHz -
5835000 KHz @  KHz), (300 mBi, 3000 mBm)
Jan  5 21:00:19 toporko kernel: [  549.899675] cfg80211: Disabling freq 5835 MHz
Jan  5 21:00:19 toporko kernel: [  549.899678] cfg80211: Disabling freq 5845 MHz
Jan  5 21:00:19 toporko kernel: [  549.899681] cfg80211: Disabling freq 5855 MHz
Jan  5 21:00:19 toporko kernel: [  549.899684] cfg80211: Disabling freq 5865 MHz
Jan  5 21:00:19 toporko kernel: [  549.899686] cfg80211: Disabling freq 5920 MHz
Jan  5 21:00:19 toporko kernel: [  549.899689] cfg80211: Disabling freq 5940 MHz
Jan  5 21:00:19 toporko kernel: [  549.899692] cfg80211: Disabling freq 5960 MHz
Jan  5 21:00:19 toporko kernel: [  549.899694] cfg80211: Disabling freq 5980 MHz
Jan  5 21:00:19 toporko kernel: [  549.899697] cfg80211: Disabling freq 6040 MHz
Jan  5 21:00:19 toporko kernel: [  549.899700] cfg80211: Disabling freq 6060 MHz
Jan  5 21:00:19 toporko kernel: [  549.899703] cfg80211: Disabling freq 6080 MHz
Jan  5 21:03:36 toporko kernel: [  746.504034] ieee80211 phy0: wlan0:
No probe response from AP 00:1e:52:79:e9:ff after 500ms,
disconnecting.

And this stuff repeats over and over again in the debug log, until
finally these lines are logged:

Jan  5 21:12:33 toporko kernel: [ 1283.152098] wlan0: authenticate
with 00:1e:52:79:e9:ff (try 1)
Jan  5 21:12:33 toporko kernel: [ 1283.352027] wlan0: authenticate
with 00:1e:52:79:e9:ff (try 2)
Jan  5 21:12:33 toporko kernel: [ 1283.552026] wlan0: authenticate
with 00:1e:52:79:e9:ff (try 3)
Jan  5 21:12:33 toporko kernel: [ 1283.752028] wlan0: authentication
with 00:1e:52:79:e9:ff timed out
