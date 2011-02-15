Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f174.google.com ([209.85.214.174]:51826 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751501Ab1BOHQu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Feb 2011 02:16:50 -0500
Received: by iwn9 with SMTP id 9so5636129iwn.19
        for <linux-wireless@vger.kernel.org>; Mon, 14 Feb 2011 23:16:49 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19802.10321.400306.871734@gargle.gargle.HOWL>
Date: Tue, 15 Feb 2011 12:46:33 +0530
To: Vivek Natarajan <vnatarajan@atheros.com>
Cc: <linville@tuxdriver.net>, <linux-wireless@vger.kernel.org>,
	<johannes@sipsolutions.net>
Subject: [RFC v2 1/2] mac80211: Fix a race on enabling power save.
In-Reply-To: <1297750589-15465-1-git-send-email-vnatarajan@atheros.com>
References: <1297750589-15465-1-git-send-email-vnatarajan@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Vivek Natarajan wrote:
>  	if ((local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK) &&
> -	    (!(ifmgd->flags & IEEE80211_STA_NULLFUNC_ACKED)))
> +	    (!(ifmgd->flags & IEEE80211_STA_NULLFUNC_ACKED) ||
> +	     !(ifmgd->flags & IEEE80211_STA_PS_PENDING))) {
> +		ifmgd->flags |= IEEE80211_STA_PS_PENDING;
>  		ieee80211_send_nullfunc(local, sdata, 1);
> +	}
>  
>  	if (!((local->hw.flags & IEEE80211_HW_REPORTS_TX_ACK_STATUS) &&
>  	      (local->hw.flags & IEEE80211_HW_PS_NULLFUNC_STACK)) ||
> -	    (ifmgd->flags & IEEE80211_STA_NULLFUNC_ACKED)) {
> +	    ((ifmgd->flags & IEEE80211_STA_NULLFUNC_ACKED) &&
> +	      ifmgd->flags & IEEE80211_STA_PS_PENDING))  {
>  		ifmgd->flags &= ~IEEE80211_STA_NULLFUNC_ACKED;
> +		ifmgd->flags &= ~IEEE80211_STA_PS_PENDING;
>  		local->hw.conf.flags |= IEEE80211_CONF_PS;
>  		ieee80211_hw_config(local, IEEE80211_CONF_CHANGE_PS);
>  	}
> +	ieee80211_wake_queues_by_reason(&local->hw,
> +					IEEE80211_QUEUE_STOP_REASON_PS);
>  }

The queues are activated when enabling powersave ?

>  void ieee80211_dynamic_ps_timer(unsigned long data)
> diff --git a/net/mac80211/status.c b/net/mac80211/status.c
> index 010a559..51caa0d 100644
> --- a/net/mac80211/status.c
> +++ b/net/mac80211/status.c
> @@ -315,7 +315,10 @@ void ieee80211_tx_status(struct ieee80211_hw *hw, struct sk_buff *skb)
>  	    (local->hw.flags & IEEE80211_HW_REPORTS_TX_ACK_STATUS) &&
>  	    !(info->flags & IEEE80211_TX_CTL_INJECTED) &&
>  	    local->ps_sdata && !(local->scanning)) {
> -		if (info->flags & IEEE80211_TX_STAT_ACK) {
> +		if ((info->flags & IEEE80211_TX_STAT_ACK) &&
> +		   (local->ps_sdata->u.mgd.flags & IEEE80211_STA_PS_PENDING)) {
> +			ieee80211_stop_queues_by_reason(&local->hw,
> +							IEEE80211_QUEUE_STOP_REASON_PS);

I am not too familiar with the PS code, but why are the queues being stopped
after the nullfunc frame has been sent out and acked ? And it is a bit unclear why
the new flag IEEE80211_STA_PS_PENDING is required at all... Can't IEEE80211_STA_NULLFUNC_ACKED
be used to fix this race ?

Sujith
