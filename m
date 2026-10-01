Received: from mail-ed2-f32.google.com (mail-ed2-f32.google.com [74.125.228.96])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D91C938B7A5
	for <linux-wireless@vger.kernel.org>; Thu,  1 Oct 2026 08:31:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.96
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790843511; cv=none; b=K4bB76T7lvxHXgu3FEFPCKsqYTSQMbaqjozq5Q9Rl4UyM0BQR3khipIei47d3jjpympnZCTsBqUEUqBM0qyX6tfYibIr2Vc3ebxmdc9VPKexn9GR1JTn2BvijRZ3useDBv3nWR0iOUURJpyNFwlaF0uWmpC05pA4nVz8dOOiE94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790843511; c=relaxed/simple;
	bh=jsGYpGVtx/gu/fnnmYEgQ1aLJh8X3uwDWJU3+TGlBtw=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TVPYyGc2K/R+mxmIYCrsVUihDMBbHoSoXrJ+bHS1cKI7JACZgCBJjyqPGZ4bJ0ZScmJPNt8ySkWHu4ML5PqP24QZYf/CgkOOeSoLF5h19RFAr/mF5UG7jfslpGYMUgEoTnybCL1HO3UHz4icx57Ns7FjHkxtiENGjJpqb7xBvZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mYKiXMH+; arc=none smtp.client-ip=74.125.228.96
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mYKiXMH+"
Received: by mail-ed2-f32.google.com with SMTP id 4fb4d7f45d1cf-6ad186afdf4so3471900a12.0
        for <linux-wireless@vger.kernel.org>; Thu, 01 Oct 2026 01:31:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790843508; x=1791448308; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=WWTht7KveA1InBPtTg+d36mJ+CInYbIU01dv/GFiZKw=;
        b=mYKiXMH+GvpwKG4jL8zj3wDxQ5LUzzNSE9rXB1K6znusuBxSHRCkdLlVtMQ0/aM03n
         V6eKPNXBx/8KGpHCpQKDAeU2tcAIklSs25waH64VvijYZxW6HfQftcNXlrqr8RaSFvtU
         w1Ffzzu/WvY1Dt6tfl/2fpzFclQtDXKObht9ugTu6KQLmw+leyx/GC0C2FWV9IgdXAO+
         P1ji/UJt0eli254nqUJtOqooicJ1Uq2QhIT9JpHjNxNg1EaYsqmWdZa/2b/Vz0wHDtXg
         LtH+Uc6U9KhKh8iMYdJmJMwpcgFORhF0YTXh2BiUJaCpyOt6hEaFem7BaOUVcIB1fz36
         kL5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790843508; x=1791448308;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WWTht7KveA1InBPtTg+d36mJ+CInYbIU01dv/GFiZKw=;
        b=quRiaDVDLV+3EeiFNSn0JcL1UkBU+trScg5gAwzhJFJDvEzMF9mJL+0JjcEWue/fLR
         t3AprnHYEXcyxkCj2ppEUEdOKgmVvWNzouCMpiiN/oxyqIiNLt1kwM2yRgAS8MYroyJB
         HF4M6ZqiQtd8Cei9kYhr5yuBf+8YFbmR2/GpTIRu+HJP70YBZBW9A5sw4JoRCYJpS5np
         xnC4VVlNwYXzqMVxnoa54Bm7OykwBYLP8R3M06u12NH1DvM0KhhnXyf8OJigyi4NKDfH
         75NXqIO2Mbz9smkYe9sO33rzp/ZQ8kMYw9Myztf6qJPrb1GRxRiFMIFAA8njyFLhcEIr
         oSgw==
X-Gm-Message-State: AFq9FYKyQkq5fZcxi7fYoYyc+eAlvco7sEciLOW6xtfnnbfJmbbGzSx0
	3JtHkC7Rdq635kNBMN8LvidEi6rcq4BoEHpD5d1iLuItbYgWb3b95XFP0fgegS6mGCvozg==
X-Gm-Gg: AYBFou3U28gTsesq1xip1wxsx2/iGXSAq7R3FwW9jR+FRMe1osrLJ0fg+B0MQaCcQe5
	KZUpIfk2WS9i0ja3KxnIiDtSlXyJrMyobEuGbKLHIbSdXvtD6tHVLfcINfZ/Xp0DFqvVziJb4et
	8OHTK5Mvru2T3R6MA7Pd62KKy18L1inStbRU9g6y8MxDngQCjl7McdfLUknA9ARJQNVZ46JS5jt
	FF+IZnoSNgcGcDuBXbSGGk9buWmeUw+dSc2CD6A7xOKXGRUGbYtCy9x/RVWwNjSrDTd5LbgQamQ
	JmLeg0HO3B2BOttWWqXCfFn+7mT8+iabwK8zpmUCeu0cAihZX78jPn0H+os32mzqmRwqenuQLaQ
	ntsjSn+OU3Gi5ZbL6Gmac581T1PkjCzmJBo2oq9F4mjHCMqLIrYxCE6CbY87bQytLE5Gx9+ti6Z
	AUXD2xdavwGUcbYA8CWHc8/nZ2BKXljwbOm4gSH8aTK6gC1aslJin/3YvwkpEbqmKWso+q/AZtv
	yBeFm3C3bMxKTKL
X-Received: by 2002:a05:6402:2348:b0:6ac:813a:a1ef with SMTP id 4fb4d7f45d1cf-6ae1993bcd1mr3174195a12.26.1790843507748;
        Thu, 01 Oct 2026 01:31:47 -0700 (PDT)
Received: from localhost ([2c0f:3d00:6be:8900:ce5e:9212:ea4b:f30])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6ae5ca42180sm679570a12.10.2026.10.01.01.31.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Oct 2026 01:31:47 -0700 (PDT)
From: Miri Korenblit <error27@gmail.com>
X-Google-Original-From: Miri Korenblit <miriam.rachel.korenblit@intel.com>
Date: Thu, 1 Oct 2026 11:31:43 +0300
To: miriam.rachel.korenblit@intel.com
Cc: linux-wireless@vger.kernel.org,
	Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>
Subject: [PATCH v2 iwlwifi-next 06/15] wifi: iwlwifi: fw: harden UEFI
 reduced-power TLV parsing
Message-ID: <20260926201527.2552432e98e8.I570750f27d9530d4c76922d2699a272d9c60a0ab@changeid>
References: <20260926171734.2142723-1-miriam.rachel.korenblit@intel.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260926171734.2142723-1-miriam.rachel.korenblit@intel.com>
Message-ID: <20261001083143.u0d55kA-OsXdwq87OnVyOmElCt_Xbfd_WIF2HcIQ_7g@z>

Commit e68f74594fdb ("wifi: iwlwifi: fw: harden UEFI reduced-power
TLV parsing") from Sep 26, 2026 (linux-next), leads to the following
Smatch static checker warning:

	drivers/net/wireless/intel/iwlwifi/fw/uefi.c:354 iwl_uefi_reduce_power_parse()
	warn: duplicate check 'tlv_len < 12' (previous on line 344)

> From: Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>
> 
> UEFI reduced-power parsing advanced by ALIGN(tlv_len, 4) but
> validated only tlv_len. When remaining bytes were between these
> values, len could underflow and parsing could continue past the
> buffer boundary.
> 
> Validate remaining bytes against the aligned length before
> advancing in both TLV walkers. Also reject short PNVM_SKU TLVs
> before reading sku_id fields.
> 
> Signed-off-by: Pagadala Yesu Anjaneyulu <pagadala.yesu.anjaneyulu@intel.com>
> Assisted-by: GitHubCopilot:GPT-5.3-Codex
> Signed-off-by: Miri Korenblit <miriam.rachel.korenblit@intel.com>
> ---
> @@ -323,8 +341,15 @@ int iwl_uefi_reduce_power_parse(struct iwl_trans *trans,
>  			const struct iwl_sku_id *tlv_sku_id =
>  				(const void *)(data + sizeof(*tlv));
>  
> +			if (tlv_len < sizeof(*tlv_sku_id)) {
                            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
No need to add this, it's already checked below.

> +				IWL_ERR(trans,
> +					"Invalid IWL_UCODE_TLV_PNVM_SKU len %u\n",
> +					tlv_len);
> +				return -EINVAL;
> +			}
> +
>  			IWL_DEBUG_FW(trans,
> -				     "Got IWL_UCODE_TLV_PNVM_SKU len %d\n",
> +				     "Got IWL_UCODE_TLV_PNVM_SKU len %u\n",
>  				     tlv_len);
>  			if (tlv_len < sizeof(*tlv_sku_id)) {
                            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

regards,
dan carpenter

>  				IWL_ERR(trans, "invalid PNVM SKU TLV len: %u\n",

