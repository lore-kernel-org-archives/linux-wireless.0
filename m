Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:43798 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755585Ab0KSBVZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Nov 2010 20:21:25 -0500
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Subject: Re: [RFC] mac80211: disable aggregatin for voice traffic
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Date: Fri, 19 Nov 2010 02:21:24 +0100
From: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>,
	Matt Smith <matt.smith@atheros.com>,
	Senthil Balasubramanian <senthilkumar@atheros.com>
In-Reply-To: <1290129534-21785-1-git-send-email-lrodriguez@atheros.com>
References: <1290129534-21785-1-git-send-email-lrodriguez@atheros.com>
Message-ID: <8e66f390eb4591841e22b8f5f2188e5d@localhost>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 18 Nov 2010 17:18:54 -0800, "Luis R. Rodriguez"
<lrodriguez@atheros.com> wrote:
> This should help with latency issues which can happen when
> using aggregation.
> 
> Cc: Matt Smith <matt.smith@atheros.com>
> Cc: Senthil Balasubramanian <senthilkumar@atheros.com>
> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
> ---
> 
> We discussed this a while ago but never to around to it.
> 
>  net/mac80211/tx.c |    3 ++-
>  1 files changed, 2 insertions(+), 1 deletions(-)
> 
> diff --git a/net/mac80211/tx.c b/net/mac80211/tx.c
> index e694836..405ddc9 100644
> --- a/net/mac80211/tx.c
> +++ b/net/mac80211/tx.c
> @@ -1225,7 +1225,8 @@ ieee80211_tx_prepare(struct ieee80211_sub_if_data
> *sdata,
>  		tx->sta = sta_info_get(sdata, hdr->addr1);
>  
>  	if (tx->sta && ieee80211_is_data_qos(hdr->frame_control) &&
> -	    (local->hw.flags & IEEE80211_HW_AMPDU_AGGREGATION)) {
> +	    (local->hw.flags & IEEE80211_HW_AMPDU_AGGREGATION) &&
> +	    (ieee802_1d_to_ac[skb->priority] != IEEE80211_AC_VO)) {

wtf? total NACK. You're setting up an aggregation session and then not
using it? That's totally deluded ... just don't set up the session!!

johannes
