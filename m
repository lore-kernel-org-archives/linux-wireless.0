Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qa0-f49.google.com ([209.85.216.49]:45809 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752473Ab3EHDwb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 May 2013 23:52:31 -0400
Received: by mail-qa0-f49.google.com with SMTP id bs12so826953qab.1
        for <linux-wireless@vger.kernel.org>; Tue, 07 May 2013 20:52:30 -0700 (PDT)
MIME-Version: 1.0
Date: Tue, 7 May 2013 23:52:30 -0400
Message-ID: <CA++BO6SfpV_7pimE=-TUcbXRX9Xgd8v69B5AQzPQ2g1b82e0FA@mail.gmail.com> (sfid-20130508_055234_675978_74AB68CD)
Subject: ath9k_htc works poorly in 3.9
From: Corey Richardson <corey@octayn.net>
To: linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Initially, I can associate and everything works fine, but after an
hour or maybe a few, I get deauthenticated, with:

[ 3115.047842] cfg80211: Calling CRDA for country: US
[ 3116.383330] wlan0: authenticate with 00:14:c2:ae:e1:c0
[ 3116.480597] wlan0: send auth to 00:14:c2:ae:e1:c0 (try 1/3)
[ 3119.526272] wlan0: send auth to 00:14:c2:ae:e1:c0 (try 2/3)
[ 3121.485530] wlan0: deauthenticating from 00:14:c2:ae:e1:c0 by local
choice (reason=3)
[ 3123.386841] wlan0: authenticate with 00:14:c2:ae:e1:c0
[ 3123.483019] wlan0: send auth to 00:14:c2:ae:e1:c0 (try 1/3)
[ 3126.528663] wlan0: send auth to 00:14:c2:ae:e1:c0 (try 2/3)
[ 3128.486335] wlan0: deauthenticating from 00:14:c2:ae:e1:c0 by local
choice (reason=3)
[ 3130.879429] wlan0: authenticate with 00:14:c2:ae:e1:c0
[ 3130.976309] wlan0: send auth to 00:14:c2:ae:e1:c0 (try 1/3)
[ 3130.976512] wlan0: deauthenticating from 00:14:c2:ae:e1:c0 by local
choice (reason=3)

in dmesg and

May 07 23:32:57 roger NetworkManager[317]: <warn> Connection
disconnected (reason -4)
May 07 23:32:57 roger NetworkManager[317]: <info> (wlan0): supplicant
interface state: completed -> disconnected
May 07 23:32:58 roger NetworkManager[317]: <info> (wlan0): supplicant
interface state: disconnected -> scanning
May 07 23:32:59 roger NetworkManager[317]: <info> (wlan0): supplicant
interface state: scanning -> authenticating
May 07 23:32:59 roger NetworkManager[317]: <info> (wlan0): roamed from
BSSID 00:14:C2:AE:E1:C0 (home1) to (none) ((none))
May 07 23:33:04 roger NetworkManager[317]: <info> (wlan0): supplicant
interface state: authenticating -> disconnected
May 07 23:33:04 roger NetworkManager[317]: <warn> Connection
disconnected (reason -3)
May 07 23:33:05 roger NetworkManager[317]: <info> (wlan0): supplicant
interface state: disconnected -> scanning
May 07 23:33:06 roger NetworkManager[317]: <info> (wlan0): supplicant
interface state: scanning -> authenticating
May 07 23:33:11 roger NetworkManager[317]: <info> (wlan0): supplicant
interface state: authenticating -> disconnected
May 07 23:33:11 roger NetworkManager[317]: <warn> Connection
disconnected (reason -3)
May 07 23:33:12 roger NetworkManager[317]: <info> (wlan0): supplicant
interface state: disconnected -> scanning
May 07 23:33:13 roger NetworkManager[317]: <warn> (wlan0): link timed out.
May 07 23:33:13 roger NetworkManager[317]: <info> (wlan0): device
state change: activated -> failed (reason 'SSID not found') [100 120
53]
May 07 23:33:13 roger NetworkManager[317]: <warn> Activation (wlan0)
failed for connection 'home1'
May 07 23:33:13 roger NetworkManager[317]: <info> (wlan0): device
state change: failed -> disconnected (reason 'none') [120 30 0]
May 07 23:33:13 roger NetworkManager[317]: <info> (wlan0):
deactivating device (reason 'none') [0]
May 07 23:33:13 roger NetworkManager[317]: <info> (wlan0): canceled
DHCP transaction, DHCP client pid 527
May 07 23:33:14 roger NetworkManager[317]: <info> (wlan0): supplicant
interface state: scanning -> authenticating
May 07 23:33:14 roger NetworkManager[317]: <warn> Connection
disconnected (reason -3)
May 07 23:33:14 roger NetworkManager[317]: <info> (wlan0): supplicant
interface state: authenticating -> disconnected
May 07 23:33:14 roger NetworkManager[317]: <warn> Connection
disconnected (reason -3)


in the journal.

Removing and reinserting the USB stick allows me to reassociate about
50% of the time; others need a reboot.

This is a regression from 3.8. It was present in the earlier 3.9 RC's
after Johannes' fix for idle sequence handling, but not before the
changes that broke ath9k_htc, so I think something between the patch
that broke the driver and the patch that fixed it is to blame.
