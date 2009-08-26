Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sypressi.dnainternet.net ([83.102.40.135]:59154 "EHLO
	sypressi.dnainternet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752539AbZHZSPv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Aug 2009 14:15:51 -0400
Message-ID: <20090826211551.14002pzogxthwfk0@hayate.sektori.org>
Date: Wed, 26 Aug 2009 21:15:51 +0300
From: "Jussi Kivilinna" <jussi.kivilinna@mbnet.fi>
To: "Holger Schurig" <hs4233@mail.mn-solutions.de>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH] rndis_wlan: set cipher suites for cfg80211
References: <20090826125302.25900.98016.stgit@fate.lan>
	<200908261521.30050.hs4233@mail.mn-solutions.de>
In-Reply-To: <200908261521.30050.hs4233@mail.mn-solutions.de>
MIME-Version: 1.0
Content-Type: text/plain;
	charset=UTF-8;
	DelSp="Yes";
	format="flowed"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quoting "Holger Schurig" <hs4233@mail.mn-solutions.de>:

>> +static const u32 rndis_cipher_suites[] = {
>> +	WLAN_CIPHER_SUITE_WEP40,
>> +	WLAN_CIPHER_SUITE_WEP104,
>> +	WLAN_CIPHER_SUITE_TKIP,
>> +	WLAN_CIPHER_SUITE_CCMP,
>> +};
>> +
>
> Okay, this is static, a.k.a. set-in-stone. Then why ...
>
>> +	memcpy(priv->cipher_suites, rndis_cipher_suites,
>> +						sizeof(rndis_cipher_suites));
>
> ... copy this to priv?
>
>> +	wiphy->cipher_suites = priv->cipher_suites;
>> +	wiphy->n_cipher_suites = ARRAY_SIZE(rndis_cipher_suites);
>
> Wouldn't
>
> +   wiphy->cipher_suide = rndis_cipher_suites;
> +   wiphy->n_cipher_suites = ARRAY_SIZE(rndis_cipher_suites);
>
> do the job?  That way you can drop priv->cipher_suites.
>

Yes, that works just fine, and first version was that way. Reason is  
that rndis_wlan should really check device capabilities and set cipher  
suites
depending by theim (so then per device priv->cipher_suite is needed).  
Current static array is not problem as currently there is only one  
chip that uses rndis_wlan and array matches its capabilities.  
priv->channel/rndis_channels and priv->rate/rndis_rates are the same  
and I plan to add caps checking code later.

-Jussi

