Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f193.google.com ([209.85.192.193]:32863 "EHLO
	mail-pf0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757357AbcHCCH2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Aug 2016 22:07:28 -0400
Received: by mail-pf0-f193.google.com with SMTP id i6so13607695pfe.0
        for <linux-wireless@vger.kernel.org>; Tue, 02 Aug 2016 19:07:23 -0700 (PDT)
Subject: Re: [PATCH v2] nl80211: Receive correct value for
 NL80211_MESHCONF_HT_OPMODE command
References: <1468927556-4703-1-git-send-email-masashi.honma@gmail.com>
 <1470138089-6864-1-git-send-email-masashi.honma@gmail.com>
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org, j@w1.fi,
	me@bobcopeland.com
To: masashi.honma@gmail.com
From: Masashi Honma <masashi.honma@gmail.com>
Message-ID: <9967cc0f-777e-31f6-0c4a-a788e92b9049@gmail.com> (sfid-20160803_040736_815133_FD62F2ED)
Date: Wed, 3 Aug 2016 10:07:35 +0900
MIME-Version: 1.0
In-Reply-To: <1470138089-6864-1-git-send-email-masashi.honma@gmail.com>
Content-Type: text/plain; charset=iso-2022-jp; format=flowed; delsp=yes
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2016年08月02日 20:41, Masashi Honma wrote:
> -	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, ht_opmode, 0, 16,
> +	FILL_IN_MESH_PARAM_IF_SET(tb, cfg, ht_opmode, 0,
> +				  IEEE80211_HT_OP_MODE_PROTECTION |
> +				  IEEE80211_HT_OP_MODE_NON_GF_STA_PRSNT |
> +				  IEEE80211_HT_OP_MODE_NON_HT_STA_PRSNT,
>  				  mask, NL80211_MESHCONF_HT_OPMODE,
>  				  nl80211_check_u16);

This patch could over write cfg->ht_opmode even though EINVAL.
I will modify this.

Masashi Honma.
