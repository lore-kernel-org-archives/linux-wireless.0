Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.17
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793900583;
	b=2ELfm+5W2GAN8cdawx59Fjsr5JErfVQhxlvbbanlUgS0wWtrfXBpotQUy6fe3iwe3N0r
	 1K10c5t9NCrlRPs4gax6UfhzVgOBTKxblhoW1CBNU+4XDf5HZ0PvRaFDdBTxa7bE+s4v8
	 94SL0gaLwA3TGAr6IJH4oissyX7VbZ2LTazNoXjVEh2zpKyvMoGE2lZBkFuMEYDcASlKc
	 OHm0lX/qrktK2if46HlGKLkcGReZIjoq9KX6ROtwCmITCW8SlZA3DHqM7O2tEYXMHh8bn
	 CsvvhLGz3ifmoGHKS7eINqExK01Pmibm2W1rLUgowxNYvnkOPFL6q9Q0SlP30OKqDKQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793900583;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=6oYUFMYW01SWFJOtp813AcDx3VlXhqqyP7dRYtXXipE=;
	b=bh7qtGm3SwtMUz/wOCBOA4AMC6tSLV6HAynXXLSZoU1QUOY3jh71UCvztWGUip8GjaXv
	 MwCt5diB94Zy5X1t/Mhpa0s44MKUJYA1GeYlcMxgwG+IZzWToyEskfvIDiHy4bWTQZ0NB
	 jHX7k5KsNxlw3m+kbAr2mc39f5sIRultJNdLQYC9VZ/CD94b4hJVhssJTAAxOgV7kdRG2
	 UNhVaNIB5NzmhPmwkDrkwxAGO/FrtrJvtH2/rMOjod42c0egWxys1HOQeHc2esLc89xRM
	 6KcgBbmXGQCBULUYdxGtbXVrqGWoRnS3HdCNCC0IwHJF+kpRJ0s25nh5hoQfakLB08w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=P+zaQDmZ;
	arc=none smtp.remote-ip=198.175.65.17
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4390C606A33D
	for <linux-wireless@vger.kernel.org>; Thu,  5 Nov 2026 17:43:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4390C606A33D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=P+zaQDmZ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793900583; x=1825436583;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=tDDKY9JPRsGzPZfwXghkOI56+03crPjyEXPPhuOtupk=;
  b=P+zaQDmZUcHiSCsIt6uGs17wn+pdAuNrWHpNdDgkUSC2oZajyOnhWA86
   Ox7XedrX/3QMuWuYCG/HOxANnbX/AFZtTkgEJHcgRlPCwiR/vH2XdyUte
   /3/fJg+AJlVbrjJFscUE6EGO4VvV/holY4/OF1OGLC2ntNVC+foqeM3dR
   yhwqyTzFslmX7EYgT80Zw7IBWBsdSVvIcyOrDdsCjA/C7+WW2M1o+r+wR
   TpBEFopKxwPSyb9cZSrjyZUy1JqtNJRaN135wXcLySpqqWKR+CTbW065q
   WEWWq1TQm6OHj6iB0AumwOh0XBGRwdPRaraUIgsl2fqVb6lxr41di5rGG
   Q==;
X-CSE-ConnectionGUID: pa9O725jQmuSxzlrdzqN6Q==
X-CSE-MsgGUID: F8bWALmVQ7Ss0Vedi/ESXQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11957"; a="2726944"
X-IronPort-AV: E=Sophos;i="6.27,197,1787036400"; 
   d="scan'208";a="2726944"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2026 09:43:02 -0800
X-CSE-ConnectionGUID: CaLd+yqsTHCV5M0GbxVaxA==
X-CSE-MsgGUID: Gkl/6J3zTY68janIvnJmBA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,197,1787036400"; 
   d="scan'208";a="7489366"
Received: from iapp347.iil.intel.com (HELO 87c02287900a.iil.intel.com) ([10.167.28.6])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2026 09:43:01 -0800
From: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
To: Shivani Baranwal <shivani.baranwal@oss.qualcomm.com>,
	johannes@sipsolutions.net
Cc: Andrei Otcheretianski <andrei.otcheretianski@intel.com>,
	linux-wireless@vger.kernel.org,
	kavita.kavita@oss.qualcomm.com,
	vamsin@qti.qualcomm.com
Subject: Re: [PATCH wireless-next 10/15] wifi: nl80211/cfg80211: add support for NDP initiation in offload mode
Date: Thu,  5 Nov 2026 19:42:42 +0200
Message-ID: <20261105174250.37677-5-andrei.otcheretianski@intel.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261014103359.1508345-11-shivani.baranwal@oss.qualcomm.com>
References: <20261014103359.1508345-1-shivani.baranwal@oss.qualcomm.com> <20261014103359.1508345-11-shivani.baranwal@oss.qualcomm.com>
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

On Wed, Oct 14, 2026 at 04:03:54PM +0530, Shivani Baranwal wrote:
> diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
> @@ -8046,6 +8060,76 @@ enum nl80211_nan_conf_attributes {
> + * @NL80211_NAN_NDP_ATTR_ID: (u8) NDP ID (1-255). Allocated by the
> + *	initiator and echoed in all subsequent NDP messages.

This one is never parsed

> + * @NL80211_NAN_NDP_ATTR_GTK_REQUIRED: flag. GTK/IGTK/BIGTK protection
> + *	required for group-addressed NDP frames.

You mention GTK/IGTK/BIGTK, but the flag is only for GTK

> + * @NL80211_NAN_NDP_ATTR_NDPE: flag. Use NDPE attribute instead of NDP
> + *	attribute when peer supports NDPE.

Why would the user space care if NDPE is used instead?

> +	NL80211_NAN_NDP_ATTR_SSI,
> +	NL80211_NAN_NDP_ATTR_CIPHER_SUITE,
> +	NL80211_NAN_NDP_ATTR_PMK,

Same here as in the DE patches. You need to make sure now SKB is properly
cleared

> diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
> @@ -18473,6 +18498,131 @@ static int nl80211_nan_set_peer_sched(struct sk_buff *skb,
> +	params.peer_nmi = nla_data(info->attrs[NL80211_ATTR_MAC]);
> +	params.init_ndi = nla_data(tb[NL80211_NAN_NDP_ATTR_INIT_NDI]);

I would validate that such NAN_DATA interface exists

> +	params.ndpe = nla_get_flag(tb[NL80211_NAN_NDP_ATTR_NDPE]);
> +
> +	return rdev_nan_ndp_initiate(rdev, wdev, &params);
> +}

Need to clean the PMK from stack

> diff --git a/net/wireless/trace.h b/net/wireless/trace.h
> @@ -2552,6 +2552,28 @@ TRACE_EVENT(rdev_nan_set_non_evac_channels,
> +	TP_printk(WIPHY_PR_FMT ", " WDEV_PR_FMT
> +		  ", peer: %pM, publish_id: %u",
> +		  WIPHY_PR_ARG, WDEV_PR_ARG,
> +		  __entry->peer_nmi, __entry->publish_id)
> +);

Better record all the parameters

Thanks,
Andrei
