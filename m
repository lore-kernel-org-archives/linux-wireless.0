Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wf-out-1314.google.com ([209.85.200.175]:44526 "EHLO
	wf-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756742AbYLKWIV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Dec 2008 17:08:21 -0500
Received: by wf-out-1314.google.com with SMTP id 27so957038wfd.4
        for <linux-wireless@vger.kernel.org>; Thu, 11 Dec 2008 14:08:20 -0800 (PST)
Subject: Re: [PATCH] ath5k : Fix correct padding
From: Harvey Harrison <harvey.harrison@gmail.com>
To: Benoit PAPILLAULT <benoit.papillault@free.fr>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ath5k-devel@lists.ath5k.org
In-Reply-To: <49418D23.8060905@free.fr>
References: <49418D23.8060905@free.fr>
Content-Type: text/plain
Date: Thu, 11 Dec 2008 14:08:18 -0800
Message-Id: <1229033298.15776.18.camel@brick> (sfid-20081211_230823_881207_DB5831F0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2008-12-11 at 22:58 +0100, Benoit PAPILLAULT wrote:
> Padding the 802.11 header to a multiple of 4 bytes needs to be done only
> for DATA frames. This fixes a bug where 2 bytes were missing in monitor
> mode for ACK frames.

Without commenting on whether or not this is needed

>   		/*
> @@ -2623,6 +2629,7 @@ ath5k_tx(struct ieee80211_hw *hw, struct sk_buff *skb)
>   	unsigned long flags;
>   	int hdrlen;
>   	int pad;
> +	const struct ieee80211_hdr * hdr = (const struct ieee80211_hdr *)skb;

skb->data perhaps.

Harvey

