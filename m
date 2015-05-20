Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:37268 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751818AbbETNMJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 20 May 2015 09:12:09 -0400
Message-ID: <1432127524.19214.11.camel@sipsolutions.net> (sfid-20150520_151214_191216_2A957C95)
Subject: Re: [PATCH v2 1/2] mac80211: fix AP_VLAN crypto tailroom calculation
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 20 May 2015 15:12:04 +0200
In-Reply-To: <1431508609-9841-1-git-send-email-michal.kazior@tieto.com> (sfid-20150513_111659_239981_BA392FBA)
References: <1431349503-5461-1-git-send-email-michal.kazior@tieto.com>
	 <1431508609-9841-1-git-send-email-michal.kazior@tieto.com>
	 (sfid-20150513_111659_239981_BA392FBA)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2015-05-13 at 09:16 +0000, Michal Kazior wrote:
> Some splats I was seeing:
> 
>  (a) WARNING: CPU: 1 PID: 0 at /devel/src/linux/net/mac80211/wep.c:102 ieee80211_wep_add_iv
>  (b) WARNING: CPU: 1 PID: 0 at /devel/src/linux/net/mac80211/wpa.c:73 ieee80211_tx_h_michael_mic_add
>  (c) WARNING: CPU: 3 PID: 0 at /devel/src/linux/net/mac80211/wpa.c:433 ieee80211_crypto_ccmp_encrypt
> 
> I've seen (a) and (b) with ath9k hw crypto and (c)
> with ath9k sw crypto. All of them were related to
> insufficient skb tailroom and I was able to
> trigger these with ping6 program.
> 
> AP_VLANs may inherit crypto keys from parent AP.
> This wasn't considered and yielded problems in
> some setups resulting in inability to transmit
> data because mac80211 wouldn't resize skbs when
> necessary and subsequently drop some packets due
> to insufficient tailroom.
> 
> For efficiency purposes don't inspect both AP_VLAN
> and AP sdata looking for tailroom counter. Instead
> update AP_VLAN tailroom counters whenever their
> master AP tailroom counter changes.

Applied.

johannes

