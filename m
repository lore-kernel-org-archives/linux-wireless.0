Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:35126 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758788Ab3EWQIM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 May 2013 12:08:12 -0400
Message-ID: <1369325287.12002.32.camel@jlt4.sipsolutions.net> (sfid-20130523_180815_791873_7D477806)
Subject: Re: [RFC v4] cfg80211: Android P2P-Device workaround
From: Johannes Berg <johannes@sipsolutions.net>
To: YanBo <dreamfly281@gmail.com>
Cc: Arend van Spriel <arend@broadcom.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Thu, 23 May 2013 18:08:07 +0200
In-Reply-To: <CAFuUQkiVHPNzRNdAnLnRkE0_w2ZERu_S4++3PcD504KCL8NBdA@mail.gmail.com> (sfid-20130523_164054_044965_7DFBA23C)
References: <1367238384-26722-1-git-send-email-johannes@sipsolutions.net>
	 <51823A0E.8020005@broadcom.com>
	 <1367489163.8298.2.camel@jlt4.sipsolutions.net>
	 <5182BBD4.9010701@broadcom.com>
	 <1367922058.8328.2.camel@jlt4.sipsolutions.net>
	 <CAFuUQkgTbf0959=xCUCA1AR-Vxv7Cj90GC4Ae7+BQUqme70ksQ@mail.gmail.com>
	 <1369302019.12002.0.camel@jlt4.sipsolutions.net>
	 <CAFuUQkiVHPNzRNdAnLnRkE0_w2ZERu_S4++3PcD504KCL8NBdA@mail.gmail.com>
	 (sfid-20130523_164054_044965_7DFBA23C)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-05-23 at 22:40 +0800, YanBo wrote:
> It do make crash in my test. and the crash point to this sentence,
> after apply this patch, the crash gone.
> 
> Step in my test to reproduce this crash (on one android phone )
> 
> 1: Create the p2p devices
> 2: Wake up both p2p0 and wlan0.
> 3: iw wlan0 scan to get the scan AP
> 4: iw wlan0 connect SSID freq macaddress to connect a open AP
> normally the crash will happened after step 4

Ok yeah I can reproduce this, it's entirely unrelated to this particular
patch but even upstream -- the function is missing a check
"wdev->netdev". I'll send a patch.

johannes

