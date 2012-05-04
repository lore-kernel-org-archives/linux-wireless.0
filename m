Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:52407 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752129Ab2EDVk5 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 May 2012 17:40:57 -0400
Received: by vcqp1 with SMTP id p1so2359374vcq.19
        for <linux-wireless@vger.kernel.org>; Fri, 04 May 2012 14:40:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CABF+-6WvgwjkrD6WG8GxcXQ+JM7szugFWZbLN6ssJ8589Q7-BA@mail.gmail.com>
References: <CABF+-6XxBKMx2wKuJr+idc9igeB-NHRCh0rL7eCyWifgH1YoKg@mail.gmail.com>
	<4FA15A70.2020108@stericsson.com>
	<CABF+-6XbdG_QMa0iQJMpbOsr4bXCq4mDEB6unkM8jxNGWYwFyQ@mail.gmail.com>
	<4FA23DA0.3030207@stericsson.com>
	<CABF+-6WjnVxC55iGHwoaL2zJ+_6oLbkVjaqwwLLrQzZxKwwWxw@mail.gmail.com>
	<4FA2BF0A.4040307@stericsson.com>
	<CABF+-6UgQek50abaLnUsBh3LEccG2Pd1vFQDiLyxgcky-JN4Ag@mail.gmail.com>
	<CAFED-jkzELRHGy7pwqDznLqPzhandwZLQEoCEFvw5F6ogMxiYA@mail.gmail.com>
	<CABF+-6WvgwjkrD6WG8GxcXQ+JM7szugFWZbLN6ssJ8589Q7-BA@mail.gmail.com>
Date: Fri, 4 May 2012 17:40:56 -0400
Message-ID: <CABF+-6U8100oTnpaU=anEYtzkktPLvNqp_bm5M+7Yp_Hajv3+w@mail.gmail.com> (sfid-20120504_234100_843395_EE7C9084)
Subject: Re: [PATCHv2 00/21] cw1200: ST-Ericsson cw1200 wlan device driver
From: Kevin Groeneveld <kgroeneveld@gmail.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc: Dmitry Tarnyagin <dmitry.tarnyagin@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>> So, you should configure this in cw1200_add_interface() for new
>> compat-wireless:
>>
>>        vif->driver_flags |= IEEE80211_VIF_BEACON_FILTER |
>>                             IEEE80211_VIF_SUPPORTS_CQM_RSSI;

I tried adding the above code today and I can now connect in station mode.

While connected in station mode I get a lot of the following warnings
in the log:

ieee80211 phy1: Slowpath: tailroom is not big enough. Req: 8, got: 0.

Is that anything to worry about?

The driver did seem to crash on me once today spewing out a lot of
WARNINGs and trace info to the log.  Unfortunately I didn't save the
log.  I will try to pay more attention to it if it happens again.

I also did a bit more testing in AP mode.  After changing hostapd to
802.11g mode I got much better throughput.  However, I did see quite a
few warnings in the log such as the following:

[  296.854219] ieee80211 phy2: Missed interrupt?
[  297.104219] ieee80211 phy2: Multicast delivery timeout.
[  254.194450] ieee80211 phy2: Requeue for link_id 0 (try 1). STAs
asleep: 0x00000002
[   34.731942] ieee80211 phy2: Requeue for link_id 1 (try 1). STAs
asleep: 0x00000002
[  462.159614] ieee80211 phy2: Requeue for link_id 0 (try 1). STAs
asleep: 0x00000002
[  482.560642] ieee80211 phy2: Requeue for link_id 0 (try 1). STAs
asleep: 0x00000002
[  482.568372] ieee80211 phy2: Requeue for link_id 1 (try 1). STAs
asleep: 0x00000002
[  482.601447] ieee80211 phy2: Multicast delivery timeout.
[  482.736948] ieee80211 phy2: Requeue for link_id 0 (try 1). STAs
asleep: 0x00000006
[  482.879955] ieee80211 phy2: Requeue for link_id 1 (try 1). STAs
asleep: 0x00000006
[  483.052676] ieee80211 phy2: Requeue for link_id 0 (try 1). STAs
asleep: 0x00000006
[  483.570836] ieee80211 phy2: Requeue for link_id 1 (try 1). STAs
asleep: 0x00000006
[  483.578685] ieee80211 phy2: Requeue for link_id 1 (try 1). STAs
asleep: 0x00000006
[  483.765740] ieee80211 phy2: Requeue for link_id 1 (try 2). STAs
asleep: 0x00000006
[  483.773462] ieee80211 phy2: Requeue for link_id 1 (try 2). STAs
asleep: 0x00000006
[  484.340904] ieee80211 phy2: Requeue for link_id 0 (try 1). STAs
asleep: 0x00000006
[  484.348626] ieee80211 phy2: Requeue for link_id 1 (try 1). STAs
asleep: 0x00000006
[  484.356344] ieee80211 phy2: Requeue for link_id 1 (try 1). STAs
asleep: 0x00000006
[  484.670846] ieee80211 phy2: Requeue for link_id 1 (try 1). STAs
asleep: 0x00000006
[  484.903498] ieee80211 phy2: Requeue for link_id 0 (try 1). STAs
asleep: 0x00000006
[    2.101774] ieee80211 phy2: Requeue for link_id 0 (try 1). STAs
asleep: 0x00000000
[    2.109569] ieee80211 phy2: Requeue for link_id 0 (try 1). STAs
asleep: 0x00000000
[    2.119271] ieee80211 phy2: Requeue for link_id 0 (try 2). STAs
asleep: 0x00000000
[    2.128483] ieee80211 phy2: Requeue for link_id 0 (try 2). STAs
asleep: 0x00000004
[    2.137894] ieee80211 phy2: Requeue for link_id 0 (try 3). STAs
asleep: 0x00000004
[    5.629055] ieee80211 phy2: Requeue for link_id 0 (try 1). STAs
asleep: 0x00000004
[   81.020541] ieee80211 phy2: Missed interrupt?
[   85.050556] ieee80211 phy2: Missed interrupt?
[   96.410571] ieee80211 phy2: Missed interrupt?
[  100.410560] ieee80211 phy2: Missed interrupt?
[  105.700565] ieee80211 phy2: Missed interrupt?
[  119.410573] ieee80211 phy2: Missed interrupt?
[  140.050548] ieee80211 phy2: Missed interrupt?
[  156.993680] ieee80211 phy2: Requeue for link_id 0 (try 1). STAs
asleep: 0x00000004
[  157.001679] ieee80211 phy2: Requeue for link_id 0 (try 1). STAs
asleep: 0x00000004
[  157.240546] ieee80211 phy2: Multicast delivery timeout.
[  167.400528] ieee80211 phy2: Missed interrupt?

Should I be worried about these?


Thanks,

Kevin
