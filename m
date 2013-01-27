Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:46368 "EHLO purkki.adurom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755727Ab3A0GHE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Jan 2013 01:07:04 -0500
From: Kalle Valo <kvalo@adurom.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: WARNING: at net/mac80211/agg-tx.c:685 ieee80211_start_tx_ba_cb
References: <87vcakxzin.fsf@purkki.adurom.net>
	<1359233629.8699.4.camel@jlt4.sipsolutions.net>
Date: Sun, 27 Jan 2013 08:07:02 +0200
In-Reply-To: <1359233629.8699.4.camel@jlt4.sipsolutions.net> (Johannes Berg's
	message of "Sat, 26 Jan 2013 21:53:49 +0100")
Message-ID: <87r4l7xipl.fsf@purkki.adurom.net> (sfid-20130127_070709_015773_7B92171B)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg <johannes@sipsolutions.net> writes:

> On Sat, 2013-01-26 at 07:51 +0200, Kalle Valo wrote:
>> Hi,
>> 
>> I noticed this warning in the log just by accident, I haven't had any
>> problems. I'm running latest wireless-testing (commit 9d9540984a) on
>> thinkpad x230 with Intel 6205.
>> 
>> [   10.262245] wlan0: authenticate with 00:26:f2:f7:cf:b2
>> [   10.272891] wlan0: send auth to 00:26:f2:f7:cf:b2 (try 1/3)
>> [   10.275093] wlan0: authenticated
>> [   10.278751] wlan0: associate with 00:26:f2:f7:cf:b2 (try 1/3)
>> [   10.282307] wlan0: RX AssocResp from 00:26:f2:f7:cf:b2 (capab=0x411 status=0 aid=3)
>> [   10.303014] wlan0: associated
>> [   10.303062] IPv6: ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
>> [  836.534120] wlan0: deauthenticating from 00:26:f2:f7:cf:b2 by local choice (reason=3)
>> [  836.570864] ------------[ cut here ]------------
>> [  836.570894] WARNING: at net/mac80211/agg-tx.c:685 ieee80211_start_tx_ba_cb+0x1b5/0x240 [mac80211]()
>
> Smells like a race to me. We probably requested aggregation and then
> deauthenticated, thus killing the session data. Then the driver probably
> had a bug and said it started the session or something ...

Just did a grep and noticed even more warnings:

x230:~$ zgrep --no-filename WARNING /var/log/syslog*
Jan 26 19:54:36 x230 kernel: [18654.186629] WARNING: at
net/mac80211/util.c:599 ieee80211_can_queue_work.isra.10+0x32/0x40
[mac80211]()
Jan 26 20:59:57 x230 kernel: [20275.013461] WARNING: at
net/mac80211/util.c:599 ieee80211_can_queue_work.isra.10+0x32/0x40
[mac80211]()
Jan 25 20:22:01 x230 kernel: [  836.570894] WARNING: at
net/mac80211/agg-tx.c:685 ieee80211_start_tx_ba_cb+0x1b5/0x240
[mac80211]()
Jan 22 21:39:44 x230 kernel: [29075.830248] WARNING: at
net/mac80211/util.c:599 ieee80211_can_queue_work.isra.10+0x32/0x40
[mac80211]()
Jan 22 22:05:49 x230 kernel: [29135.651334] WARNING: at
net/mac80211/util.c:599 ieee80211_can_queue_work.isra.10+0x32/0x40
[mac80211]()
Jan 22 23:01:11 x230 kernel: [31878.606310] WARNING: at
net/mac80211/util.c:599 ieee80211_can_queue_work.isra.10+0x32/0x40
[mac80211]()
Jan 23 18:36:33 x230 kernel: [ 9113.473283] WARNING: at
net/mac80211/util.c:599 ieee80211_can_queue_work.isra.10+0x32/0x40
[mac80211]()
Jan 18 09:11:18 x230 kernel: [65051.228555] WARNING: at
net/mac80211/util.c:599 ieee80211_can_queue_work.isra.10+0x32/0x40
[mac80211]()
Jan 18 21:43:10 x230 kernel: [81530.791082] WARNING: at
net/mac80211/util.c:599 ieee80211_can_queue_work.isra.10+0x32/0x40
[mac80211]()
Jan 18 22:15:40 x230 kernel: [82837.817517] WARNING: at
net/mac80211/util.c:599 ieee80211_can_queue_work.isra.10+0x32/0x40
[mac80211]()
Jan 20 10:31:23 x230 kernel: [88609.307199] WARNING: at
net/mac80211/util.c:599 ieee80211_can_queue_work.isra.10+0x32/0x40
[mac80211]()
Jan 20 22:51:56 x230 kernel: [98535.334962] WARNING: at
drivers/net/wireless/iwlwifi/dvm/tx.c:434 iwlagn_tx_skb+0x7c1/0x840
[iwldvm]()
Jan 21 07:18:08 x230 kernel: [99957.410266] WARNING: at
net/mac80211/util.c:599 ieee80211_can_queue_work.isra.10+0x32/0x40
[mac80211]()
Jan 22 09:17:12 x230 kernel: [120963.155777] WARNING: at
net/mac80211/util.c:599 ieee80211_can_queue_work.isra.10+0x32/0x40
[mac80211]()
Jan 15 08:04:25 x230 kernel: [40630.492569] WARNING: at
net/mac80211/util.c:599 ieee80211_can_queue_work.isra.10+0x32/0x40
[mac80211]()
Jan 15 16:24:50 x230 kernel: [56111.825186] WARNING: at
drivers/net/wireless/iwlwifi/dvm/tx.c:434 iwlagn_tx_skb+0x7c1/0x840
[iwldvm]()
Jan 16 07:20:36 x230 kernel: [13251.280305] WARNING: at
net/mac80211/util.c:599 ieee80211_can_queue_work.isra.10+0x32/0x40
[mac80211]()

These are with various versions of wireless-testing, I update pretty
frequently.

-- 
Kalle Valo
