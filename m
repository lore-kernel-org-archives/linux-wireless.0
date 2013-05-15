Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp27.msg.oleane.net ([62.161.4.27]:53186 "EHLO
	smtp27.msg.oleane.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757321Ab3EON6E (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 May 2013 09:58:04 -0400
Received: from RD9 ([195.6.104.67])
	by smtp27.msg.oleane.net (MTA) with ESMTP id r4FDw0dh002242
	for <linux-wireless@vger.kernel.org>; Wed, 15 May 2013 15:58:00 +0200
From: "Jean-Pierre Tosoni" <jp.tosoni@acksys.fr>
To: <linux-wireless@vger.kernel.org>
Subject: [RFC] 802.11s needs to send about 900 frames to detect a lost peer on ath9k (AR9160 chip)
Date: Wed, 15 May 2013 15:58:00 +0200
Message-ID: <005601ce5174$3634a8c0$a29dfa40$@acksys.fr> (sfid-20130515_155809_046365_AB892EF6)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

I am testing what happens when a mesh peer suddenly disappears while I am
sending data to it.

I am using compat-wireless 2013-04-16 plus openwrt patches, and I operate on
a clean 5GHz channel at HT40.
I am sending a low throughput UDP stream, then I suddenly poweroff the
receiver MP.
On Wireshark I can see that the sending MP continues sending approx. 900
frames for about one second before giving up, which seems a very large
number of frames (and a large detection delay).

I investigated for the reason of so many frames, I found the following
reasons, each of them bring questions.


1) ath9k does not give up before ATH_MAX_SW_RETRIES(=30)  retries, some of
them done by hardware and some by software in ath9k/xmit.c.
Q: I saw that the number of retries is configurable in ath5k and nl80211
(NL80211_ATTR_WIPHY_RETRY_LONG). Should we use this instead of the constant,
or is this obsolete/unsupported/inappropriate/whatever?

2) ath9k retries are computed from ts_longretry. But when the peer
disappears, the last retries are subject to RTS, hence the retry count is in
ts_shortretry instead.
Q: shouldn't we add ts_shortretry and ts_longretry in
ath9k/xmit.c/ath_tx_complete_aggr() and ath_tx_rc_status() ?

3) In the rate control table, rates 1,2,3 are subject to RTS. When RTS fails
the shortretry count seems to be always 10, whatever is the retry count set
by the rate control. From Wireshark I see that indeed there are 10 RTS
retries per rate control slot. (I googled for this one, the point is rised
in madwifi-devel but not answered)
Q: is this a "feature" of the AR9160 ? or in the standard ? or a hidden
constant ?

4) The mac80211 mesh_hwmp code computes an error rate with a decaying
algorithm. Each time a TX frame fails it updates the error rate and gives up
when the error is >95%. But when the ath9k driver retries 26x4 = 104 times,
this accounts only for one failure.
Q1: shouldn't we take into account the number of retries done by the
underlying driver ?
Q2: Isn't a 95% error rate damn high for a useable link ??? (just kidding -
or not?)

>From (4), 17 frames are required for the mesh to detect failure. From (3) 26
frames are sent by the hardware for each try. From (2) the ath9k resends 4
times each failed frame. Total 17*4*26 = 1768 frames before detecting peer
failure. The observed count is lesser because at some point the driver
starts aggregating.

I plan to work on these issues - Any advice about the best ways to improve
this? 

Cheers

