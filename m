Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s72.web-hosting.com ([198.187.29.22]:57586 "EHLO
	s72.web-hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752758AbaJGEfl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 7 Oct 2014 00:35:41 -0400
From: Sujith Manoharan <sujith@msujith.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <21555.28109.720719.149443@gargle.gargle.HOWL> (sfid-20141007_063544_354104_C3DD6CB3)
Date: Tue, 7 Oct 2014 10:06:29 +0530
To: John Linville <linville@tuxdriver.com>
Cc: <linux-wireless@vger.kernel.org>, <ath9k-devel@qca.qualcomm.com>
Subject: Re: [PATCH 6/6] ath9k: Process beacons properly
In-Reply-To: <1412574579-22532-7-git-send-email-sujith@msujith.org>
References: <1412574579-22532-1-git-send-email-sujith@msujith.org>
	<1412574579-22532-7-git-send-email-sujith@msujith.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sujith Manoharan wrote:
> From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
> 
> When the current operating channel context has
> been marked as ATH_CHANCTX_STATE_FORCE_ACTIVE,
> do not process beacons that might be received,
> since we have to wait for the station to become
> authorized.
> 
> Signed-off-by: Sujith Manoharan <c_manoha@qca.qualcomm.com>
> ---
>  drivers/net/wireless/ath/ath9k/channel.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/net/wireless/ath/ath9k/channel.c b/drivers/net/wireless/ath/ath9k/channel.c
> index 16bed6a..55f2369 100644
> --- a/drivers/net/wireless/ath/ath9k/channel.c
> +++ b/drivers/net/wireless/ath/ath9k/channel.c
> @@ -492,7 +492,8 @@ void ath_chanctx_event(struct ath_softc *sc, struct ieee80211_vif *vif,
>  		break;
>  	case ATH_CHANCTX_EVENT_BEACON_RECEIVED:
>  		if (!test_bit(ATH_OP_MULTI_CHANNEL, &common->op_flags) ||
> -		    sc->cur_chan == &sc->offchannel.chan)
> +		    sc->cur_chan == &sc->offchannel.chan ||
> +		    sc->sched.state == ATH_CHANCTX_STATE_FORCE_ACTIVE)
>  			break;

The check for FORCE_ACTIVE needs to be done after we set
beacon_miss/beacon_pending to zero.

Also, since we now have a small window where we start receiving
beacons while waiting for the handshake to complete, we
end up rearming the timer based on the cached tsf_val of the current
channel. But, since it will be zero the first time the
context becomes active, the timeout value is assigned
spurious values.

I'll address both these issues and send a v2.

Sujith
