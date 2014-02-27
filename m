Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:35662 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752589AbaB0Sbi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 27 Feb 2014 13:31:38 -0500
Message-ID: <1393525892.4648.14.camel@jlt4.sipsolutions.net> (sfid-20140227_193142_231063_0212C8C7)
Subject: Re: pci-half-mini 7260 Wireless AC support 3.13
From: Johannes Berg <johannes@sipsolutions.net>
To: Tim Nelson <tim.l.nelson@gmail.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 27 Feb 2014 19:31:32 +0100
In-Reply-To: <1393523885.4648.12.camel@jlt4.sipsolutions.net> (sfid-20140227_185813_646736_1C81C834)
References: <CAOAOC6a96e5MrEOVY=KXirhUU-rJRv2hgz5B0so9SkWYMpoDfw@mail.gmail.com>
	 <1393517094.4648.3.camel@jlt4.sipsolutions.net>
	 <CAOAOC6agHr6mVB2jcUx1qHWnBJZyOw0=KP0Wp5BVhrvJgRhmQg@mail.gmail.com>
	 <1393517627.4648.4.camel@jlt4.sipsolutions.net>
	 <CAOAOC6ZhnB=LrJWvG07tOK=b_wWAFO74YdhXWZPxrVCk8=425A@mail.gmail.com>
	 <CAOAOC6aoz43LdXBTcRHWqPMvQAVKsH6z4yNqe_hEpT7zouo+Ew@mail.gmail.com>
	 <1393519119.4648.7.camel@jlt4.sipsolutions.net>
	 <CAOAOC6Z5J8_-ZKVukxfz+_K402E5sjhTdBvf3TzsWUDgwqw0Zw@mail.gmail.com>
	 <1393519539.4648.10.camel@jlt4.sipsolutions.net>
	 <CAOAOC6aWWh3y8b-iRsouxFV+d9oKSpL4hkeVyJ6sarGEVzyOdg@mail.gmail.com>
	 <CAOAOC6bzV8yZfOPRj1zCa0ONQ8VQ=vwBug6jga6LgzEADdk=Ww@mail.gmail.com>
	 (sfid-20140227_184955_785023_7183652A) <1393523695.4648.11.camel@jlt4.sipsolutions.net>
	 (sfid-20140227_185501_959792_F40EE445) <1393523885.4648.12.camel@jlt4.sipsolutions.net>
	 (sfid-20140227_185813_646736_1C81C834)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

(replying to myself, Tim responded off-list)

On Thu, 2014-02-27 at 18:58 +0100, Johannes Berg wrote:

> iw wlan0 interface add moni0 type monitor flags none
> ip link set moni0 up
> tcpdump -i moni0 -s 0 -w /tmp/assoc.pcap

Turns out I missed a quirk in the 11ac spec when implementing this - the
channel center frequency segment 0 is reserved when the channel width is
0 (use HT).

Try this change maybe:

diff --git a/net/mac80211/mlme.c b/net/mac80211/mlme.c
index 46b62bb3677c..ca1f74bb5d50 100644
--- a/net/mac80211/mlme.c
+++ b/net/mac80211/mlme.c
@@ -222,6 +222,7 @@ ieee80211_determine_chantype(struct ieee80211_sub_if_data *sdata,
 	switch (vht_oper->chan_width) {
 	case IEEE80211_VHT_CHANWIDTH_USE_HT:
 		vht_chandef.width = chandef->width;
+		vht_chandef.center_freq1 = chandef->center_freq1;
 		break;
 	case IEEE80211_VHT_CHANWIDTH_80MHZ:
 		vht_chandef.width = NL80211_CHAN_WIDTH_80;


johannes

