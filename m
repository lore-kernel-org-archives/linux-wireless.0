Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.17
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793900581;
	b=Z83KRcDYpA3nDnKJF708dOF70lkNFfukAqvXqASOUBgoPpYtfiXpqFicjDCZzyknGkpN
	 ZlThRfGzP86fCTPhgtGBVqpX3wtcjddvwj715JtS2mzrpq82vL367dTzQDyBQ8HXObwFY
	 WYFceXc2locSzb+G31dklSIylN4OHOwpyWLf8AjlwQluy2mJsHFoWBe69V15u7y+SQDkw
	 TjfsXSXE6RkUYF1+0oCGMtwbQD5h6QFj1utwbbnLF53wXQliGs95zmXFa0/DSFmFXnx0e
	 M218/F438OMSWvi3Wy72T2/UamM9+8w4vVH+XUYTpqYG0VQGVsmMta3H/rnMelcjEyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793900581;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=ix7Tzzs/rSzLiSnNWgmD70OhrIRB2PH8StMQye/I8Kc=;
	b=MMxQK3pdZEHF60LTECVa9PEWbveSS2xNeO3AXjohJ1ViSfNae0drMasZGGpYwmDatd41
	 7JDgjX/2UZBn3orTEtb5wTd/jWA0uCaiYCIV13YJvqRz0zYGSm04CV7VwemMQOKxTL4SD
	 yR7C5k8TbSeGvnbe6JFxh057jUvNV0ymDpbc8AGfq+g8fVrdxDEpm9EKjnMyg49Tu/MHu
	 jfA5QHBesU8NiNOreMBW64sHDH1kTfZ1IXMtwCdICV7WhutQsjcr7MFFE4I0qMDW3XL9L
	 WSG6XC06+SpjMp7NDMX+mDVu8i8fJnmsNuOzk8KuTT9VzpK1yZ6G6hZ/h8uRdTZ6O8g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=Soh5rPtN;
	arc=none smtp.remote-ip=198.175.65.17
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCF0E606A328
	for <linux-wireless@vger.kernel.org>; Thu,  5 Nov 2026 17:42:59 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DCF0E606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=Soh5rPtN
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793900580; x=1825436580;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6FzvMHZgZjWgzpBZ+GONBvVhhn+TMe9OnoBwS41xKPk=;
  b=Soh5rPtNNnFGPs4G1J9o6oXEV6zJ124IJY594MycskjJStf8dZtqJbWe
   T1toV4eZRzQkNaVA2mMyz6UWIv1+PMX33TFEmOA9ns99uQrIEADwRGKgb
   U6tHWwmh+lKFDxso+0nQOuO85QCx+BWnZkA1jvbUoNkYtILZvfdPclNzB
   TlcmmCbLRkJitepjOORlWaopV7qMRh47a6iJY6Nl02qrOj5dDafF7ulE5
   XcTTyCNQoqzn2e2C3q/vC4E6eogMh1B/vzzhAM+rztDI4syWrkniFxtIN
   /AG7Xre8ylElVm5XB7VuYYeDa9ikbwqjjQZNFPfrBYasoab3gznt0xr5F
   w==;
X-CSE-ConnectionGUID: u0HvNCvRQsOauPIdqoDRjQ==
X-CSE-MsgGUID: AyP8QlBJTXGpcIx84PVf1Q==
X-IronPort-AV: E=McAfee;i="6800,10657,11957"; a="2726908"
X-IronPort-AV: E=Sophos;i="6.27,197,1787036400"; 
   d="scan'208";a="2726908"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2026 09:42:55 -0800
X-CSE-ConnectionGUID: 3H7gkQJWSgayl+W7TjHxbA==
X-CSE-MsgGUID: hRemUlzDT3m9DXgNJouWrA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,197,1787036400"; 
   d="scan'208";a="7489287"
Received: from iapp347.iil.intel.com (HELO 87c02287900a.iil.intel.com) ([10.167.28.6])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2026 09:42:53 -0800
From: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
To: Shivani Baranwal <shivani.baranwal@oss.qualcomm.com>,
	johannes@sipsolutions.net
Cc: Andrei Otcheretianski <andrei.otcheretianski@intel.com>,
	linux-wireless@vger.kernel.org,
	kavita.kavita@oss.qualcomm.com,
	vamsin@qti.qualcomm.com
Subject: Re: [PATCH wireless-next 02/15] wifi: nl80211/cfg80211: extend NAN function for discovery offload
Date: Thu,  5 Nov 2026 19:42:38 +0200
Message-ID: <20261105174250.37677-1-andrei.otcheretianski@intel.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261014103359.1508345-3-shivani.baranwal@oss.qualcomm.com>
References: <20261014103359.1508345-1-shivani.baranwal@oss.qualcomm.com> <20261014103359.1508345-3-shivani.baranwal@oss.qualcomm.com>
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Wed, Oct 14, 2026 at 04:03:46PM +0530, Shivani Baranwal wrote:
> diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
> @@ -7715,6 +7715,8 @@ enum nl80211_nan_func_term_reason {
>  #define NL80211_NAN_FUNC_SERVICE_SPEC_INFO_MAX_LEN 0xff
>  #define NL80211_NAN_FUNC_SRF_MAX_LEN 0xff
>  
> +#define NL80211_NAN_NDP_PMK_LEN 32
> +

I wouldn't explicitly limit length on the nl80211.h level.

> + * @NL80211_NAN_FUNC_PAIRING_SETUP: flag attribute. This service supports
> + *	NAN pairing setup (new pairing).
> + * @NL80211_NAN_FUNC_PAIRING_CACHE: flag attribute. This service supports
> + *	NAN pairing caching (NPK caching).
> + * @NL80211_NAN_FUNC_PAIRING_VERIFY: flag attribute. This service supports
> + *	NAN pairing verification using a cached NPK.

Those pairing flags are advertised in DCEA (Device Capability Extension
attribute) which is per device and not tied to any service. So I think it
shouldn't be configured per function.

> + * @NL80211_NAN_FUNC_ND_PMK: %NL80211_NAN_NDP_PMK_LEN-byte pre-shared NAN
> + *	Data Path PMK (ND-PMK).
> + *	Requires %NL80211_EXT_FEATURE_SECURE_NAN.
>   *

I think some things may be missing here. It would be good to compare it with
wpa_supplicant's nan_publish/subscribe_params

> @@ -7775,12 +7797,36 @@ enum nl80211_nan_func_attributes {
>  	NL80211_NAN_FUNC_TERM_REASON,
> +	NL80211_NAN_FUNC_SDEA_CTRL,
> +	NL80211_NAN_FUNC_PAIRING_BOOTSTRAP_METHODS,
> +	NL80211_NAN_FUNC_CSIDS,
> +	NL80211_NAN_FUNC_PAIRING_SETUP,
> +	NL80211_NAN_FUNC_PAIRING_CACHE,
> +	NL80211_NAN_FUNC_PAIRING_VERIFY,
> +	NL80211_NAN_FUNC_ND_PMK,

Another thought here, for devices that might want to have DE offloaded, but
keep NDP/NDL establishment and schedule management in user space it would be
useful to add additional NAN attributes. I'm thinking about availability
attribute here, but maybe better to have something generic: extra NAN
attributes or some similar concept.

> +enum nl80211_nan_func_sdea_ctrl_flags {
> +	NL80211_NAN_FUNC_SDEA_CTRL_DATAPATH_REQUIRED	= 1 << 2,
> +	NL80211_NAN_FUNC_SDEA_CTRL_SECURITY_REQUIRED	= 1 << 6,
> +	NL80211_NAN_FUNC_SDEA_CTRL_GTK_REQUIRED		= 1 << 10,
> +};

If only those bits are supposed to be configured I wouldn't allow the entire
sdea control option and rather have those as flag attributes.

> diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
> @@ -17564,6 +17573,95 @@ static int nl80211_nan_add_func(struct sk_buff *skb,
> +		if (tb[NL80211_NAN_FUNC_ND_PMK]) {
> +			memcpy(func->nd_pmk,
> +			       nla_data(tb[NL80211_NAN_FUNC_ND_PMK]),
> +			       sizeof(func->nd_pmk));
> +			func->nd_pmk_set = true;
> +		}

As ND_PMK is carried here, NL80211_FLAG_CLEAR_SKB should be set now

> +		if (tb[NL80211_NAN_FUNC_CSIDS]) {
> +			int len = nla_len(tb[NL80211_NAN_FUNC_CSIDS]);
> +			int n = len / sizeof(u32);
> +
> +			if (len % sizeof(u32)) {
> +				NL_SET_ERR_MSG_ATTR(info->extack,
> +						    tb[NL80211_NAN_FUNC_CSIDS],
> +						    "CSIDs must be an array of u32 values");
> +				err = -EINVAL;
> +				goto out;
> +			}

Various input validations here can be done on policy level

> diff --git a/net/wireless/util.c b/net/wireless/util.c
> @@ -2820,6 +2820,7 @@ void cfg80211_free_nan_func(struct cfg80211_nan_func *f)
>  	kfree(f->serv_spec_info);
>  	kfree(f->srf_bf);
>  	kfree(f->srf_macs);
> +	kfree(f->csids);

You have pmk inside now.. memzero it here or use kfree_sensitive()

Thanks,
Andrei
