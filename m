Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx51.mymxserver.com ([85.199.173.110]:1245 "EHLO
	mx51.mymxserver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932964AbZHZNWI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Aug 2009 09:22:08 -0400
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>
Subject: Re: [PATCH] rndis_wlan: set cipher suites for cfg80211
Date: Wed, 26 Aug 2009 15:21:29 +0200
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
References: <20090826125302.25900.98016.stgit@fate.lan>
In-Reply-To: <20090826125302.25900.98016.stgit@fate.lan>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200908261521.30050.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> +static const u32 rndis_cipher_suites[] = {
> +	WLAN_CIPHER_SUITE_WEP40,
> +	WLAN_CIPHER_SUITE_WEP104,
> +	WLAN_CIPHER_SUITE_TKIP,
> +	WLAN_CIPHER_SUITE_CCMP,
> +};
> +

Okay, this is static, a.k.a. set-in-stone. Then why ...

> +	memcpy(priv->cipher_suites, rndis_cipher_suites,
> +						sizeof(rndis_cipher_suites));

... copy this to priv?

> +	wiphy->cipher_suites = priv->cipher_suites;
> +	wiphy->n_cipher_suites = ARRAY_SIZE(rndis_cipher_suites);

Wouldn't

+   wiphy->cipher_suide = rndis_cipher_suites;
+   wiphy->n_cipher_suites = ARRAY_SIZE(rndis_cipher_suites);

do the job?  That way you can drop priv->cipher_suites.


-- 
http://www.holgerschurig.de
