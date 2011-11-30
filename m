Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:60739 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752807Ab1K3MQU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Nov 2011 07:16:20 -0500
Subject: Re: [PATCH 4/4] mac80211: handle protection mode, RIFS and ADDBA
 for HT IBSS
From: Johannes Berg <johannes@sipsolutions.net>
To: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Alexander Simon <an.alexsimon@googlemail.com>,
	Marek Lindner <lindner_marek@yahoo.de>,
	Felix Fietkau <nbd@openwrt.org>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
In-Reply-To: <1322502917-28205-5-git-send-email-siwu@hrz.tu-chemnitz.de>
References: <1322502917-28205-1-git-send-email-siwu@hrz.tu-chemnitz.de>
	 <1322502917-28205-5-git-send-email-siwu@hrz.tu-chemnitz.de>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 30 Nov 2011 13:16:15 +0100
Message-ID: <1322655375.3982.11.camel@jlt3.sipsolutions.net> (sfid-20111130_131623_679357_57CD5A9E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2011-11-28 at 18:55 +0100, Simon Wunderlich wrote:

> +	/*
> +	 * 11.5.1.1: If the initiating STA is an HT STA, is a member of an

802.11-2012 will renumber clauses, please add new references as
"802.11-2007 11.5.1.1"

Other than that I have a feeling this patch should come before patch 3?

> +++ b/net/mac80211/ibss.c
> @@ -954,6 +954,7 @@ int ieee80211_ibss_join(struct ieee80211_sub_if_data *sdata,
>  			struct cfg80211_ibss_params *params)
>  {
>  	struct sk_buff *skb;
> +	u32 changed = 0;
>  
>  	skb = dev_alloc_skb(sdata->local->hw.extra_tx_headroom +
>  			    sizeof(struct ieee80211_hdr_3addr) +
> @@ -1016,6 +1017,23 @@ int ieee80211_ibss_join(struct ieee80211_sub_if_data *sdata,
>  	ieee80211_recalc_idle(sdata->local);
>  	mutex_unlock(&sdata->local->mtx);
>  
> +	/*
> +	 * 9.13.3.1: In an IBSS, the HT Protection field is reserved, but

Same reference thing here.

johannes

