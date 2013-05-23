Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pd0-f173.google.com ([209.85.192.173]:51325 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758967Ab3EWOkw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 May 2013 10:40:52 -0400
Received: by mail-pd0-f173.google.com with SMTP id v14so1744692pde.4
        for <linux-wireless@vger.kernel.org>; Thu, 23 May 2013 07:40:51 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1369302019.12002.0.camel@jlt4.sipsolutions.net>
References: <1367238384-26722-1-git-send-email-johannes@sipsolutions.net>
	<51823A0E.8020005@broadcom.com>
	<1367489163.8298.2.camel@jlt4.sipsolutions.net>
	<5182BBD4.9010701@broadcom.com>
	<1367922058.8328.2.camel@jlt4.sipsolutions.net>
	<CAFuUQkgTbf0959=xCUCA1AR-Vxv7Cj90GC4Ae7+BQUqme70ksQ@mail.gmail.com>
	<1369302019.12002.0.camel@jlt4.sipsolutions.net>
Date: Thu, 23 May 2013 22:40:51 +0800
Message-ID: <CAFuUQkiVHPNzRNdAnLnRkE0_w2ZERu_S4++3PcD504KCL8NBdA@mail.gmail.com> (sfid-20130523_164055_280697_8CA72F6D)
Subject: Re: [RFC v4] cfg80211: Android P2P-Device workaround
From: YanBo <dreamfly281@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Arend van Spriel <arend@broadcom.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

It do make crash in my test. and the crash point to this sentence,
after apply this patch, the crash gone.

Step in my test to reproduce this crash (on one android phone )

1: Create the p2p devices
2: Wake up both p2p0 and wlan0.
3: iw wlan0 scan to get the scan AP
4: iw wlan0 connect SSID freq macaddress to connect a open AP
normally the crash will happened after step 4

BR /Yanbo

On Thu, May 23, 2013 at 5:40 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2013-05-23 at 11:18 +0800, YanBo wrote:
>> After create the p2p0  wireless device. When call the
>> cfg80211_conn_work
>
> How is that getting called in the first place? I'm not saying there's no
> bug, but your suggested fix is completely pointless, we shouldn't get
> there.
>
> johannes
>
