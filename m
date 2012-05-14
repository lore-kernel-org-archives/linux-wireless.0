Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:41138 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755466Ab2ENOAs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 May 2012 10:00:48 -0400
Received: by dady13 with SMTP id y13so5951776dad.19
        for <linux-wireless@vger.kernel.org>; Mon, 14 May 2012 07:00:48 -0700 (PDT)
MIME-Version: 1.0
Date: Mon, 14 May 2012 10:00:48 -0400
Message-ID: <CALGY4fvUmHmFbYAH2044qCBOozOqmOCBcmB8acV-Qivd3PpFgQ@mail.gmail.com> (sfid-20120514_160052_465054_559DF6AB)
Subject: iwlwifi regression: disconnections
From: Nikolay Martynov <mar.kolya@gmail.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi.

  I have Intel 5300 card. It works fine with 3.2.16. When I try 3.3.6
or 3.4.0rc6 I get connection drops often - once 5-10 mins. With 3.2.16
such disconnects happen once-twice a day. AP - ath9k based router and
it doesn't change. I'm using kernels from ubuntu kernel ppa.

  Here is what I see in logs during disconnect:

[ 1024.296004] ICMPv6 RA: ndisc_router_discovery() failed to add default route.
[ 1259.209166] wlan1: deauthenticating from XX:XX:XX:XX:XX:XX by local
choice (reason=3)
[ 1259.277831] cfg80211: All devices are disconnected, going to
restore regulatory settings
[ 1259.277842] cfg80211: Restoring regulatory settings
[ 1259.277851] cfg80211: Calling CRDA to update world regulatory domain
[ 1259.293624] cfg80211: Ignoring regulatory request Set by core since
the driver uses its own custom regulatory domain
[ 1259.293629] cfg80211: World regulatory domain updated:
[ 1259.293632] cfg80211:   (start_freq - end_freq @ bandwidth),
(max_antenna_gain, max_eirp)
[ 1259.293636] cfg80211:   (2402000 KHz - 2472000 KHz @ 40000 KHz),
(300 mBi, 2000 mBm)
[ 1259.293640] cfg80211:   (2457000 KHz - 2482000 KHz @ 20000 KHz),
(300 mBi, 2000 mBm)
[ 1259.293644] cfg80211:   (2474000 KHz - 2494000 KHz @ 20000 KHz),
(300 mBi, 2000 mBm)
[ 1259.293647] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz),
(300 mBi, 2000 mBm)
[ 1259.293651] cfg80211:   (5735000 KHz - 5835000 KHz @ 40000 KHz),
(300 mBi, 2000 mBm)
[ 1265.296158] wlan1: authenticate with XX:XX:XX:XX:XX:XX
[ 1265.297450] wlan1: send auth to XX:XX:XX:XX:XX:XX (try 1/3)
[ 1265.500053] wlan1: send auth to XX:XX:XX:XX:XX:XX (try 2/3)
[ 1265.502380] wlan1: authenticated
[ 1265.504080] wlan1: associate with XX:XX:XX:XX:XX:XX (try 1/3)
[ 1265.507624] wlan1: RX AssocResp from XX:XX:XX:XX:XX:XX (capab=0x411
status=0 aid=1)
[ 1265.507632] wlan1: associated


I'll be happy to help with any additional information of debugging.
Thanks!

-- 
Truthfully yours,
Martynov Nikolay.
Email: mar.kolya@gmail.com
