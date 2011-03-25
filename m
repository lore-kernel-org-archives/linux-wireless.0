Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43924 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752680Ab1CYLV4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Mar 2011 07:21:56 -0400
Subject: Re: Aggregation problem with rt2800 AP and Intel 5100 STA
From: Johannes Berg <johannes@sipsolutions.net>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: Emmanuel Grumbach <egrumbach@gmail.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <201103251208.22473.helmut.schaa@googlemail.com>
References: <201103232358.29966.helmut.schaa@googlemail.com>
	 <1300987930.26265.6.camel@jlt3.sipsolutions.net>
	 <AANLkTi=mFbtLbQwNX6ZnzW9_xn_CYUBvv98z3-ZT9uf0@mail.gmail.com>
	 <201103251208.22473.helmut.schaa@googlemail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 25 Mar 2011 12:23:44 +0100
Message-ID: <1301052224.3827.2.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-03-25 at 12:08 +0100, Helmut Schaa wrote:

> mac80211 isn't sending a BAR in the case above because of this code
> in ieee80211_tx_status (status.c):
> 
> 218                 acked = !!(info->flags & IEEE80211_TX_STAT_ACK);
> 219                 if (!acked && test_sta_flags(sta, WLAN_STA_PS_STA)) {
> 220                         /*
> 221                          * The STA is in power save mode, so assume
> 222                          * that this TX packet failed because of that.
> 223                          */
> 224                         ieee80211_handle_filtered_frame(local, sta, skb);
> 225                         rcu_read_unlock();
> 226                         return;
> 227                 }
> ...
> 233                 if ((info->flags & IEEE80211_TX_STAT_AMPDU_NO_BACK) &&
> 234                     (ieee80211_is_data_qos(fc))) {
> 235                         u16 tid, ssn;
> 236                         u8 *qc;
> 237 
> 238                         qc = ieee80211_get_qos_ctl(hdr);
> 239                         tid = qc[0] & 0xf;
> 240                         ssn = ((le16_to_cpu(hdr->seq_ctrl) + 0x10)
> 241                                                 & IEEE80211_SCTL_SEQ);
> 242                         ieee80211_send_bar(sta->sdata, hdr->addr1,
> 243                                            tid, ssn);
> 244                 }
> 
> So, if a frame failed because the STA entered PS state it will be added
> to the filtered frames queue and no BAR will get generated.

Right. Of course, if the device could help and the driver would set
IEEE80211_TX_STAT_TX_FILTERED this would be better since then the frames
wouldn't even be on the air...

FWIW, since Intel hw uses special queues for aggregation the ucode just
stops those queues when the station goes to sleep. Caused me some grey
hair in fact since I had naively expected it to reject those frames too.

> However, if this was the case mac80211 should send out all filtered frames
> after the STA wakes up again, which does not happen in the situation
> above (3106 and 3107 got lost) :(

Yeah, that's in fact strange. Unless they timed out?

> Generating the BAR also for filtered frames might improve the situation but
> looks more like a workaround to me.

Agree.

> Still debugging the rt2800 tx status reporting.

Maybe it's not reporting the right status for all frames?

johannes

