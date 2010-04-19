Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from purkki.adurom.net ([80.68.90.206]:35692 "EHLO purkki.valot.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751214Ab0DSGaE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Apr 2010 02:30:04 -0400
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Subject: Re: regression: soft lockup with ath9k on master-2010-04-14
References: <87pr20mrez.fsf@purkki.valot.fi>
	<20100415195812.GC3020@tuxdriver.com>
From: Kalle Valo <kvalo@adurom.com>
Date: Mon, 19 Apr 2010 09:29:59 +0300
In-Reply-To: <20100415195812.GC3020@tuxdriver.com> (John W. Linville's message of "Thu\, 15 Apr 2010 15\:58\:12 -0400")
Message-ID: <871veclztk.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"John W. Linville" <linville@tuxdriver.com> writes:

> On Thu, Apr 15, 2010 at 10:44:52PM +0300, Kalle Valo wrote:
>> Hello,
>> 
>> I just updated my laptop to latest wireless-testing and it everytime
>> soft lockups few seconds after association.
>> 
>> I haven't updated wireless-testing for few days, so I can't say when
>> this bug was introduced.
>
> It might be useful to do a bisect.  If you choose to do that, you
> might want to use wireless-next-2.6 instead, since that doesn't have
> the occasional pulls from Linus that make bisecting wireless-testing
> more painful.

Thanks for the tip, it helped a lot. My new laptop is really slow to
compile kernels :/

I bisected it finally and found the culprit:

66b0470aeef10a3b0f9a6a1c60d908b5a06c62ae is the first bad commit
commit 66b0470aeef10a3b0f9a6a1c60d908b5a06c62ae
Author: Johannes Berg <johannes@sipsolutions.net>
Date:   Tue Apr 6 11:18:45 2010 +0200

    mac80211: remove ieee80211_sta_stop_rx_ba_session
    
    All callers of ieee80211_sta_stop_rx_ba_session can
    just call __ieee80211_stop_rx_ba_session instead
    because they already have the station struct, so do
    that and remove ieee80211_sta_stop_rx_ba_session.
    
    Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
    Signed-off-by: John W. Linville <linville@tuxdriver.com>

I verified that reverting these three patches make my laptop stable
again:

54297e4d60b74e602138594c131097347d128b5a mac80211: fix some RX aggregation...
098a607091426e79178b9a6c318d993fea131791 mac80211: clean up/fix aggregation..
66b0470aeef10a3b0f9a6a1c60d908b5a06c62ae mac80211: remove ieee80211_sta_...

(I had to revert all three because of conflicts.)

I took a quick peek of the patches but I wasn't able to immediately
say what was wrong. This just made me suspicious:

-       ieee80211_sta_stop_rx_ba_session(sta->sdata, sta->sta.addr,
-                                        (u16)*ptid, WLAN_BACK_TIMER,
-                                        WLAN_REASON_QSTA_TIMEOUT);
+       __ieee80211_stop_rx_ba_session(sta, *ptid,
-                                        WLAN_BACK_RECIPIENT,
+                                      WLAN_REASON_QSTA_TIMEOUT);

WLAN_BACK_TIMER was changed to WLAN_BACK_RECIPIENT, but I don't know
if it was in purpose or not. Johannes, any ideas?

-- 
Kalle Valo
