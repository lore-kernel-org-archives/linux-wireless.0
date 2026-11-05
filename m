Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.17
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793900586;
	b=Qjr67KjArr3lHEo4Yr+Q95/fsxcAKOjVNiFbJOM7dYZrxzAFSGRzRRCGqtMd7SjyVNWC
	 Eruq8nxj9U+kUhn6a3o5WaovqGAKG2o9H0NQ/zBgMtvKH0nTroGBM+3MEluF32xyPNKp0
	 IrlRmHzNvreuDWJoMdHbayumSilF5zFspPiYBsitIAU0MmgKumhbppHNg2+semSvXWYVG
	 JVCDQGyumT/kha1MMFu93kfn28J59z5FPQwNWFegsqq6FeA48uliLrg69fs9cvt+SaXyx
	 4xCQSQ1i0vrSZ8lK6QomcLn8PRE/Pz5ZW/kNmqK18e+M6tgCmx95lw1ODmhHxUSEJAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793900586;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=hGWbG0OTBcEs6liKdfhDKG1wwMO0YofEMmfJg6VixdI=;
	b=EwQ4QD0cDIIkKH/Q5B5dtCIvAtix4x1zZU4r6EE/6fRrUB/n//aXx0puTe0EkrsvdGcT
	 8VmEVeujQJdygnmkRIxZDaP/ttn+CjOSv9TPJHMW2DRJNEhaYZZMy40WD62c4E8EPqVYH
	 G0P93s52R/BWWhbbex0DckX3E98nY+9LMZOl3UN92Hw80JYQm7gEkCUa97DiA4KBJ+cQn
	 SNtQkqWPACFaLSOKv7Is3taYTkQhLnLmDU9EFOfzhhJTu6T6c8XKdF6TF3ULsj2Jk9X7A
	 4UlmCqMC+ExmceusebvWPFy40TrfkV0o2I22eThYT4KrIIqxaY08zeTJlZ7qcHcP3ng==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=ICr4DiIM;
	arc=none smtp.remote-ip=198.175.65.17
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE5FB606D811
	for <linux-wireless@vger.kernel.org>; Thu,  5 Nov 2026 17:43:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org BE5FB606D811
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=ICr4DiIM
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793900584; x=1825436584;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=/Fq7xQ+uOoJ0rHoMWXQjK+Eer41rtwx1skg9KG67P7k=;
  b=ICr4DiIMr9PSzay3H4GAyECEDPukHDNg5lfKFtzoJ1RvYjvVB401M5Mm
   3b9GspURrH78Icj3PqZVP78A/DXIW4LHPTVJTsV/ePOOgDSlK/zUr3Wpd
   FQvBRZbJxqb7PknojcJFE6DksH6IrZC3f2hXMX0NPDg0NezbT2bdo94e7
   i+Ev4TVykF1cfj07SMeLot1cy3fnz2pAxXmuvSZbg2CIcVY+1nFF7HqNl
   kUvB2PZPntgKygdpIzUqLuGPOdEpuMbZZlH/pGX3RWh5g9x4P7Vr8JzQh
   wMT0J3SQEihdrkJliAn2JyIw8HJycjyCimKQ3k99VOqiMqmwPK9wxh1As
   g==;
X-CSE-ConnectionGUID: vtQuu+61QJmu0yySMm85Aw==
X-CSE-MsgGUID: lK4jUrh5SHuL2fOYu3qpDQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11957"; a="2726953"
X-IronPort-AV: E=Sophos;i="6.27,197,1787036400"; 
   d="scan'208";a="2726953"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2026 09:43:04 -0800
X-CSE-ConnectionGUID: SbhzMv1JT7m1sOAnjWU1gQ==
X-CSE-MsgGUID: UI2svXNbRs6G0RjgSq+GVA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,197,1787036400"; 
   d="scan'208";a="7489381"
Received: from iapp347.iil.intel.com (HELO 87c02287900a.iil.intel.com) ([10.167.28.6])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2026 09:43:03 -0800
From: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
To: Shivani Baranwal <shivani.baranwal@oss.qualcomm.com>,
	johannes@sipsolutions.net
Cc: Andrei Otcheretianski <andrei.otcheretianski@intel.com>,
	linux-wireless@vger.kernel.org,
	kavita.kavita@oss.qualcomm.com,
	vamsin@qti.qualcomm.com
Subject: Re: [PATCH wireless-next 11/15] wifi: nl80211/cfg80211: add support for NDP response in offload mode
Date: Thu,  5 Nov 2026 19:42:43 +0200
Message-ID: <20261105174250.37677-6-andrei.otcheretianski@intel.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261014103359.1508345-12-shivani.baranwal@oss.qualcomm.com>
References: <20261014103359.1508345-1-shivani.baranwal@oss.qualcomm.com> <20261014103359.1508345-12-shivani.baranwal@oss.qualcomm.com>
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

On Wed, Oct 14, 2026 at 04:03:55PM +0530, Shivani Baranwal wrote:
> diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
> @@ -18623,6 +18625,127 @@ static int nl80211_nan_ndp_initiate(struct sk_buff *skb,
> +	if (params.accept) {
> +		if (!tb[NL80211_NAN_NDP_ATTR_RESP_NDI]) {
> +			NL_SET_ERR_MSG(info->extack,
> +				       "NDP accept requires RESP_NDI");
> +			return -EINVAL;
> +		}
> +		params.resp_ndi = nla_data(tb[NL80211_NAN_NDP_ATTR_RESP_NDI]);

And here too, need to check that such NAN data interface exists

> +	params.ndpe = nla_get_flag(tb[NL80211_NAN_NDP_ATTR_NDPE]);
> +
> +	return rdev_nan_ndp_respond(rdev, wdev, &params);
> +}

Same here, pmk should be cleared from the stack

> diff --git a/net/wireless/trace.h b/net/wireless/trace.h
> @@ -2574,6 +2574,30 @@ TRACE_EVENT(rdev_nan_ndp_initiate,
> +	TP_printk(WIPHY_PR_FMT ", " WDEV_PR_FMT
> +		  ", peer: %pM, ndp_id: %u, accept: %d",
> +		  WIPHY_PR_ARG, WDEV_PR_ARG,
> +		  __entry->peer_nmi, __entry->ndp_id, __entry->accept)
> +);

Better print/record all the important parameters

Thanks,
Andrei
