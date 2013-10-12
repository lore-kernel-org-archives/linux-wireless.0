Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from phoenix3.szarvasnet.hu ([87.101.127.16]:42680 "EHLO
	mail.szarvasnet.hu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752558Ab3JLQTy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Oct 2013 12:19:54 -0400
Message-ID: <525976CD.5040004@openwrt.org> (sfid-20131012_181957_468179_433F1F98)
Date: Sat, 12 Oct 2013 18:20:29 +0200
From: Gabor Juhos <juhosg@openwrt.org>
MIME-Version: 1.0
To: Kevin Lo <kevlo@kevlo.org>
CC: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, users@rt2x00.serialmonkey.com
Subject: Re: [PATCH v3] rt2x00: rt2800lib: remove duplicate rf_vals for RF3053
References: <20131012152735.GB4156@ns.kevlo.org>
In-Reply-To: <20131012152735.GB4156@ns.kevlo.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2013.10.12. 17:27 keltezéssel, Kevin Lo írta:
> We already have rf_vals_3x with same values.  Hence rf_vals_3053 is removed
> in this patch.
> 
> Signed-off-by: Kevin Lo <kevlo@kevlo.org>
> Acked-by: Paul Menzel <paulepanter@users.sourceforge.net>
> Acked-by: Stanislaw Gruszka <stf_xl@wp.pl>
> ---
> Changes since v1:
>   - update comment of rf_vals_3x to indicate that it also supports RF3053
>   - add Paul's Acked-by tag
> ---
> Changes since v2:
>  - the previous patch was malformed
>  - add Stanislaw's Acked-by tag
> ---
> 
> diff --git a/drivers/net/wireless/rt2x00/rt2800lib.c b/drivers/net/wireless/rt2x00/rt2800lib.c

<...>

>  	struct hw_mode_spec *spec = &rt2x00dev->spec;
> @@ -7599,14 +7533,11 @@ static int rt2800_probe_hw_mode(struct rt2x00_dev *rt2x00dev)
>  		   rt2x00_rf(rt2x00dev, RF5392)) {
>  		spec->num_channels = 14;
>  		spec->channels = rf_vals_3x;
> -	} else if (rt2x00_rf(rt2x00dev, RF3052)) {
> +	} else if (rt2x00_rf(rt2x00dev, RF3052) ||
> +		   rt2x00_rf(rt2x00dev, RF3053)) { 

checpatch.pl says this:

ERROR: trailing whitespace
#127: FILE: drivers/net/wireless/rt2x00/rt2800lib.c:7537:
+^I^I   rt2x00_rf(rt2x00dev, RF3053)) { $

total: 1 errors, 0 warnings, 96 lines checked

Otherwise the patch is ok.

-Gabor
