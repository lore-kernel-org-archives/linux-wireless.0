Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B4E641F7EA
	for <linux-wireless@vger.kernel.org>; Tue, 11 Aug 2026 23:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786489675; cv=none; b=hqFvmO6c4fhtPu0KX6ZNeeNsLlWKzD91L6nrMnu7xx5kU1kwyHyLucTyRVwxL3UJ9q6kC1c8L6QnV/XzePfIt+MIQdvbttpf3T059mb4EWeolkjE9GWQPXRU25BdwB4TnTrpfV7SwXPKqTLRmqX0rJqllCvABDP5iq7nbjxdsWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786489675; c=relaxed/simple;
	bh=hZ2+doldLFi5Or3oJGS1Q6/v0N2AdkGLlj5306iVrjg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZHuros9U0RQeTeLn2uWdFuIpQLmfkrQws2YhuLNjkSwxlLZsLHUbaA4xRGBkoKpZ0P3NR++wqkjObVLfI+t50gIgTSOcuI+3ZIswyGg+qrQ4dxMr7ALPntmishy+eir0WKMGTY4dAvaPc229t59XkD8YRHEzqlnr9M/OxsDWdWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=MYBMZwAp; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="MYBMZwAp"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-38ea87caafeso324952a91.3
        for <linux-wireless@vger.kernel.org>; Tue, 11 Aug 2026 16:07:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1786489673; x=1787094473; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=MxdgMqtF68s+a8E8Ijlw0yd5ACEIUeoM0nOyAFFalno=;
        b=MYBMZwApurV4XG5Ul0gir32r3Dx/WyXhWSDX4oznjbHqAWu1KzuD2wheJtxHR44hB2
         NDMkpbs0nahalEFPMC7ZGsTJfKNWNx+mopugFiGJvPFR1Hiyntrwvj5PeOLdJzIYdPid
         QBHajW8lvzt7VbpuYbXfbDXWWuhaW5JedwqE0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786489673; x=1787094473;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=MxdgMqtF68s+a8E8Ijlw0yd5ACEIUeoM0nOyAFFalno=;
        b=Vtafq9NyRPpy1TiVpogFw10W4eUQcwr400ljQhu4sdwGOCse6pBeFx6w5nZm7Y6sXZ
         JC1wE51okPrYRAk0We4YE+FmmHblLa0vP4Qgr/FQX1ny/aAFXl68p/9derAlvjmzlKXd
         2dCmoz7H5ANkQQHR1qzzSsH8CkXYlDL0kmIOz2BlnhE5Ij7uiXNGP21LB/x0cHohYt5W
         cRz/jkcgDOhDCjmRLKl81yaqsPvc0yAUmhrOA/HNozExFld/NzqtoUZ5m85xsDe1PAPk
         oJfzWWJ46LcjKfNZTKP6cRdonYJJPKVNUbE0Q0lyzxKMOR8t30l0iNEAlbipUmMiRvK/
         LdMA==
X-Forwarded-Encrypted: i=1; AHgh+Rqvnee/5eO73VgW47OYMOC2PkK4TIMdGMV21/5ixbYn861RSdm7CdZSYklIZKmz/6hW8W6BY1GyMICGMbfcuw==@vger.kernel.org
X-Gm-Message-State: AOJu0YyKNL486tsZDfOXQ8xjKgScjDZyeACSfOgGSmvWW1vUbJT0kU04
	cN+bSRRLB7bUmg2MMZF5UAB8enc0WHcFOZtqiLzfcCioIEqGh6flPRbJXEFagqGWUg==
X-Gm-Gg: AR+sD11i2N9L34g+vHqZlQc5tymnGDBpUGH805DBK8UqwqbIX5cprYcOen6qPhN7qOa
	MollkMAI83CqWu3npY43ca6Pylj5othpicJIqf5M0UQThtEJjCOENAppBknS91FVKKFvCGpM0pc
	1pj7UDHeSyWavZeNggfWRD7jhWgpVFzIoewyW2l7Zf5ZKC/6QHZM/AbxcSWLkza3ORJ8kSxF/Qg
	FwJ5JrKkMJKamp7mAPWXtKXzdL/PYCDUkmiKO6Q3sW/fNuc4cEsk8b8rybozOgTX4aukkP01442
	fFKnXY2Kms5s9SIufdwJfI3M92ImCsht8IRSUn8uhUbIHt9QO2hQbtSEGpSgKwnJgVF87aZvJw/
	mEL1T6EbeZRobRXntoObgGH4ohgREdvs96AjQDSJyK7XNymnk0uoplQ1KdfCE7LDegd2INQFbd8
	LN4gTbvT9FWuNitub7DxbsO/Fw6ILUxFTMLTgFaNIcLl9F4HfqSAbPf1xadDJ6reuVVAZq0jJdJ
	UMOfJhlVwOzAqYmRS2QlmScB+M=
X-Received: by 2002:a17:90a:ec8e:b0:38e:250b:122f with SMTP id 98e67ed59e1d1-3930162a6cemr543682a91.16.1786489673385;
        Tue, 11 Aug 2026 16:07:53 -0700 (PDT)
Received: from localhost ([2a00:79e0:2e7c:8:79fa:d268:80cb:4947])
        by smtp.gmail.com with UTF8SMTPSA id a92af1059eb24-141245540fesm5012264c88.9.2026.08.11.16.07.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Aug 2026 16:07:52 -0700 (PDT)
Date: Tue, 11 Aug 2026 16:07:50 -0700
From: Brian Norris <briannorris@chromium.org>
To: Doruk Tan Ozturk <doruk@0sec.ai>
Cc: francesco@dolcini.it, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] wifi: mwifiex: bound the pairwise-cipher OUI walk to
 the IE length
Message-ID: <anurRohJ_lLHkfvC@google.com>
References: <20260711071334.58307-1-doruk@0sec.ai>
 <20260715185541.14350-1-doruk@0sec.ai>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260715185541.14350-1-doruk@0sec.ai>

Hi,

On Wed, Jul 15, 2026 at 08:55:41PM +0200, Doruk Tan Ozturk wrote:
> mwifiex_search_oui_in_ie() reads the pairwise-cipher (PTK) count from a
> beacon/probe-response RSN or WPA information element:
> 
> 	count = iebody->ptk_cnt[0];
> 
> and then walks "count" 4-byte OUIs from the element, comparing each with
> memcmp(). The count byte comes straight from the (attacker-supplied) IE
> and is never checked against the element's own length. The callers admit
> the element on element_id alone (has_ieee_hdr() / has_vendor_hdr(), no
> length check), so a crafted RSN/WPA IE with a large pairwise count makes
> the walk read up to 255 * 4 bytes past the element -- an out-of-bounds
> read of the kmemdup()'d beacon buffer, reachable from any AP whose
> beacon/probe response is processed during scan result parsing.
> 
> Pass the number of available IE bytes to the walk and reject a count
> whose OUI list would not fit, keeping the loop within the element.
> 
> Found by 0sec automated security-research tooling (https://0sec.ai).
> 
> Fixes: 5e6e3a92b9a4 ("wireless: mwifiex: initial commit for Marvell mwifiex driver")
> Cc: stable@vger.kernel.org
> Assisted-by: 0sec:multi-model
> Signed-off-by: Doruk Tan Ozturk <doruk@0sec.ai>
> ---
> 
> Changes in v2 (per Francesco Dolcini's review):
>  - store offsetof(struct ie_body, ptk_body) in a named variable
>    (ptk_body_offset) and reuse it in both bounds checks; no
>    functional change.
>  - switch the Assisted-by trailer to 0sec:multi-model.
>  drivers/net/wireless/marvell/mwifiex/scan.c | 22 ++++++++++++++++++---
>  1 file changed, 19 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/net/wireless/marvell/mwifiex/scan.c b/drivers/net/wireless/marvell/mwifiex/scan.c
> index 97c0ec3b822e..33ef8af0a5e1 100644
> --- a/drivers/net/wireless/marvell/mwifiex/scan.c
> +++ b/drivers/net/wireless/marvell/mwifiex/scan.c
> @@ -104,12 +104,21 @@ has_vendor_hdr(struct ieee_types_vendor_specific *ie, u8 key)
>   * a given oui in PTK.
>   */
>  static u8
> -mwifiex_search_oui_in_ie(struct ie_body *iebody, u8 *oui)
> +mwifiex_search_oui_in_ie(struct ie_body *iebody, u8 *oui, int ie_len)
>  {
> +	const size_t ptk_body_offset = offsetof(struct ie_body, ptk_body);
>  	u8 count;
>  
> +	/* Need grp_key_oui[4] + ptk_cnt[2] before reading the OUI count. */
> +	if (ie_len < (int)ptk_body_offset)
> +		return MWIFIEX_OUI_NOT_PRESENT;
> +
>  	count = iebody->ptk_cnt[0];
>  
> +	/* Reject an OUI count whose list would run past the element. */
> +	if (ptk_body_offset + count * sizeof(iebody->ptk_body) > (size_t)ie_len)
> +		return MWIFIEX_OUI_NOT_PRESENT;
> +
>  	/* There could be multiple OUIs for PTK hence
>  	   1) Take the length.
>  	   2) Check all the OUIs for AES.
> @@ -143,11 +152,14 @@ mwifiex_is_rsn_oui_present(struct mwifiex_bssdescriptor *bss_desc, u32 cipher)
>  	u8 ret = MWIFIEX_OUI_NOT_PRESENT;
>  
>  	if (has_ieee_hdr(bss_desc->bcn_rsn_ie, WLAN_EID_RSN)) {
> +		int ie_len = (int)bss_desc->bcn_rsn_ie->ieee_hdr.len -
> +			     RSN_GTK_OUI_OFFSET;

Are you ensuring you don't underflow when computing ie_len here? What if
bss_desc->bcn_rsn_ie->ieee_hdr.len is small / zero?

> +
>  		iebody = (struct ie_body *)
>  			 (((u8 *) bss_desc->bcn_rsn_ie->data) +
>  			  RSN_GTK_OUI_OFFSET);
>  		oui = &mwifiex_rsn_oui[cipher][0];
> -		ret = mwifiex_search_oui_in_ie(iebody, oui);
> +		ret = mwifiex_search_oui_in_ie(iebody, oui, ie_len);
>  		if (ret)
>  			return ret;
>  	}
> @@ -169,10 +181,14 @@ mwifiex_is_wpa_oui_present(struct mwifiex_bssdescriptor *bss_desc, u32 cipher)
>  	u8 ret = MWIFIEX_OUI_NOT_PRESENT;
>  
>  	if (has_vendor_hdr(bss_desc->bcn_wpa_ie, WLAN_EID_VENDOR_SPECIFIC)) {
> +		int ie_len = (int)bss_desc->bcn_wpa_ie->vend_hdr.len -
> +			     (int)sizeof(bss_desc->bcn_wpa_ie->vend_hdr.oui) -
> +			     WPA_GTK_OUI_OFFSET;

Same question.

Brian

> +
>  		iebody = (struct ie_body *)((u8 *)bss_desc->bcn_wpa_ie->data +
>  					    WPA_GTK_OUI_OFFSET);
>  		oui = &mwifiex_wpa_oui[cipher][0];
> -		ret = mwifiex_search_oui_in_ie(iebody, oui);
> +		ret = mwifiex_search_oui_in_ie(iebody, oui, ie_len);
>  		if (ret)
>  			return ret;
>  	}
> -- 
> 2.43.0
> 
