Received: from mail.w1.fi (mail.w1.fi [212.71.239.96])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A8CF344022
	for <linux-wireless@vger.kernel.org>; Mon, 23 Feb 2026 09:26:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.71.239.96
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771838801; cv=none; b=PLPJoNikP3rgukmtuAJhwK71nKngm4kRaW2S8HAhDtG7DnIJAKHv16oMvY5xv76UM+5T6uDqqnA3kJZ0pbCt2cZynB9fxzUEWiVlqei4WETDnFOlcxgp9XkthMh8FBH6mUyjZhDzGWMrL6TaHypGHqw+AzfGKzmI8jHiltQYxqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771838801; c=relaxed/simple;
	bh=vLvO+KWMgQQk6suQgw576gM4uDiLAdmJauWsv3hY56k=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=GHd5OrL5K+qESWwS59Y6rHwWlcUMeX1jNgbc5f3XP4ITPeB8jw7HDhOvMn374CxUNkkRuxLH7l8i1XiiVaSlyoUTqBo6N3EBGOGLtJq/NTgd1Zu1Jo7nMJUSBKPUHFGveCpbXFihn1xaPp6LsNd2QOsAd3a8iNhSkR/fxP76a/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=w1.fi; spf=pass smtp.mailfrom=w1.fi; dkim=pass (2048-bit key) header.d=w1.fi header.i=@w1.fi header.b=CxtiYLqX; arc=none smtp.client-ip=212.71.239.96
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=w1.fi
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=w1.fi
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=w1.fi header.i=@w1.fi header.b="CxtiYLqX"
Received: from localhost (localhost [127.0.0.1])
	by mail.w1.fi (Postfix) with ESMTP id 642BC11E0F;
	Mon, 23 Feb 2026 09:17:17 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at w1.fi
Received: from mail.w1.fi ([127.0.0.1])
	by localhost (mail.w1.fi [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id rXiDvWL71nQq; Mon, 23 Feb 2026 09:17:15 +0000 (UTC)
Received: by jm (sSMTP sendmail emulation); Mon, 23 Feb 2026 11:17:13 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=w1.fi; s=default;
	t=1771838235; bh=vLvO+KWMgQQk6suQgw576gM4uDiLAdmJauWsv3hY56k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CxtiYLqXK4aZVoDgmIO5iwMt91FfjRD6QbV9ryXGmbhLl68VL2KLsnd1KR2h8kYJ7
	 9A9KcTGdQletpj2Q5IoMfAPUt+oQUhHZotFcDyDF1MMwfONI5cZRyXoSd/NmdJu+Db
	 iPldKWrOphEHU1fWcyIDf37Iu/C2CsySNsBOTal3Jr3QzXpJ8wuVvifkNbsspaXQBp
	 YQf1+I4WbfvYWU5BaRYSDPTk14Pp/Gaf8LYIor7a1dkQKNCuBAoq3xcTbZlaf7Kh99
	 vd3CrPo5l/XMCAE6UTmNg1Zk3Wq3EyVrOfI+8dBMz52HlY3Cr++wnQFP7v0RapQ866
	 IROhMPjmYon1g==
Date: Mon, 23 Feb 2026 11:17:13 +0200
From: Jouni Malinen <j@w1.fi>
To: Sai Pratyusha Magam <sai.magam@oss.qualcomm.com>
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	quic_drohan@quicinc.com
Subject: Re: [PATCH wireless-next v3] wifi: mac80211: Fix AAD/Nonce
 computation for management frames with MLO
Message-ID: <aZwbGXdE8Fgn7f0w@w1.fi>
References: <20260212042601.2250514-1-sai.magam@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260212042601.2250514-1-sai.magam@oss.qualcomm.com>

On Thu, Feb 12, 2026 at 09:56:01AM +0530, Sai Pratyusha Magam wrote:
> diff --git a/drivers/net/wireless/virtual/mac80211_hwsim.c b/drivers/net/wireless/virtual/mac80211_hwsim.c
> @@ -4189,6 +4225,7 @@ static int mac80211_hwsim_change_nan_config(struct ieee80211_hw *hw,
>  	.start_nan = mac80211_hwsim_start_nan,                  \
>  	.stop_nan = mac80211_hwsim_stop_nan,                    \
>  	.nan_change_conf = mac80211_hwsim_change_nan_config,    \
> +	.set_key = mac80211_hwsim_set_key,                     \
>  	HWSIM_DEBUGFS_OPS

Defining the set_key callback makes mac80211 disable various features
and not all of them were covered below:

> @@ -5621,6 +5658,7 @@ static int mac80211_hwsim_new_radio(struct genl_info *info,
> +	hw->wiphy->flags |= WIPHY_FLAG_IBSS_RSN;

That's one of features that get disabled by default in mac80211 if a
driver defines ops->set_key. In addition to that, these ext_features
need to be enabled in mac80211_hwsim:

wiphy_ext_feature_set(wiphy,
		      NL80211_EXT_FEATURE_SPP_AMSDU_SUPPORT);
wiphy_ext_feature_set(local->hw.wiphy,
		      NL80211_EXT_FEATURE_CAN_REPLACE_PTK0);
wiphy_ext_feature_set(local->hw.wiphy,
		      NL80211_EXT_FEATURE_EXT_KEY_ID);
 
-- 
Jouni Malinen                                            PGP id EFC895FA
