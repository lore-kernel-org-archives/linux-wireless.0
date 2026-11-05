Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.17
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793900589;
	b=Ld3bDA1Y+5ZsukIK/61VpYsSb8+VxQtwUfNk9+t2naWz8wooRPXX3NVp1LPaKUdTkE6d
	 vZJkH/+S6dFZuj/aHyes+DTlSconmxjJ07MI0h4UZ702wLXZ7HQeCjsaSaZMEWQyrWIko
	 t5CHE+pdSXwhiZJX0gIoJlw0/Is/KYF3so11WlHvakkg2mKODtndvFZITVbX4oAMyp1z6
	 xy6iX7kJQjPD+0xKYgDZ80w+TAXVVdzb9Ju+lw+e1mLdXOm2eVExIevHGFRbfd4fRHQHa
	 cIUsJtSYrwhZzk5tx49KoL8K0zLg/QQ26boyt6VZyfK+94DhIC5xeYeN2V+WdeZh75w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793900589;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=mAbdJhg7KQQLMPqnM2x2qGh2TczYxJtrbnDI9lw6h+Q=;
	b=GxbIdoqT9Wy9y285huWFPN4mLcyfnCpKBN1OBFW5bnZiAKAJuCCqMLZJ+cpJcYIb7tNR
	 dYsvcF63oNjM6QVhI3ocyP+wX9Zjc0eFjDqgZkuB0v2SvHpS4vl+r8i5pNqagVdc0vWvA
	 TIrLfEWTHqJD4841Ca7Yz3Q1M2yipz0Ilo2T7iIiPlZ+9bqIWk38GP0MCRLFgm4t9g83P
	 7JNx2f9WdK0dbwkkL+deZF1ifsyzg4ed2GJ+bIsyWW7Clci+zTpiuwnzhNTXkRiaCiFja
	 dIV14Dq86ood54cWZ9YWTXaBVjxRwOk0JUnAHBZhyO8Pn6JUPcZznLUF9i/cOS0q/rQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=QMgHXcUM;
	arc=none smtp.remote-ip=198.175.65.17
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32DFF606A337
	for <linux-wireless@vger.kernel.org>; Thu,  5 Nov 2026 17:43:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 32DFF606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=QMgHXcUM
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793900588; x=1825436588;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=lPtjP3yQPx4ZRRZvZjROkLRXCbnu/qXUGHAsaz8Mt6Y=;
  b=QMgHXcUMEnNNjVKiZcrIynIdv5OjnNYxd4W2HxH0osqspCCdSdwpNPQH
   g5uP/PeJ5mJ7aZEONf3bfiR+d33KFtdZxb5T6w/CkAFs/p1UB7eBoXmCu
   laEQWhtWLXy1RWEuOAK0EgQDEV/iXLzatVGzZ44jH6PJ7NpttcaMFhJBG
   6WqlfZIH01rbNYJJzosHoctcpp3y6su23Zf8mdE6ZQ9TY6n/FbUt46zEU
   nF7wiWZ4OczFK5962JB8xsTSbvLj1zDWRUDOpfAbq+2or5DhIfmPsqL0D
   3lMDa+E568+C/Wo9TFKt+TYnEc/bpO0laFeHRoqfXaWwUSd3D/oJYr/K7
   A==;
X-CSE-ConnectionGUID: d/Ay79maS0ObmdL2xLuCIw==
X-CSE-MsgGUID: alUxBruDRvG1vG6muAsCog==
X-IronPort-AV: E=McAfee;i="6800,10657,11957"; a="2726969"
X-IronPort-AV: E=Sophos;i="6.27,197,1787036400"; 
   d="scan'208";a="2726969"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2026 09:43:08 -0800
X-CSE-ConnectionGUID: pTt+09rbRgqVe0ccWLQxzA==
X-CSE-MsgGUID: UlW4nkCxQKu0mcbm28HrKw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,197,1787036400"; 
   d="scan'208";a="7489424"
Received: from iapp347.iil.intel.com (HELO 87c02287900a.iil.intel.com) ([10.167.28.6])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2026 09:43:07 -0800
From: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
To: Shivani Baranwal <shivani.baranwal@oss.qualcomm.com>,
	johannes@sipsolutions.net
Cc: Andrei Otcheretianski <andrei.otcheretianski@intel.com>,
	linux-wireless@vger.kernel.org,
	kavita.kavita@oss.qualcomm.com,
	vamsin@qti.qualcomm.com
Subject: Re: [PATCH wireless-next 14/15] wifi: nl80211/cfg80211: add support for NDP confirm indication
Date: Thu,  5 Nov 2026 19:42:45 +0200
Message-ID: <20261105174250.37677-8-andrei.otcheretianski@intel.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261014103359.1508345-15-shivani.baranwal@oss.qualcomm.com>
References: <20261014103359.1508345-1-shivani.baranwal@oss.qualcomm.com> <20261014103359.1508345-15-shivani.baranwal@oss.qualcomm.com>
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

On Wed, Oct 14, 2026 at 04:03:58PM +0530, Shivani Baranwal wrote:
> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
> +void cfg80211_nan_ndp_confirm(struct wireless_dev *wdev,
> +			      struct cfg80211_nan_ndp_confirm_params *params,
> +			      gfp_t gfp);

I think a better name would be cfg80211_nan_ndp_status(), but it's a matter of
taste I guess

> diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
> +enum nl80211_nan_ndp_status {
> +	NL80211_NAN_NDP_STATUS_ACCEPTED,
> +	NL80211_NAN_NDP_STATUS_REJECTED,
> +};

A boolean flag is simpler instead of an enum with these two options only

> diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
> @@ -796,6 +796,7 @@ nl80211_nan_ndp_policy[NL80211_NAN_NDP_ATTR_MAX + 1] = {
> +	[NL80211_NAN_NDP_ATTR_STATUS] = { .type = NLA_U8 },

That's an out attribute, no policy is required for that.

> +	nla_nest_end(msg, ndp_attr);
> +	genlmsg_end(msg, hdr);
> +	genlmsg_unicast(wiphy_net(wiphy), msg, wdev->owner_nlportid);
> +	return;

Also here, the trace event should be recorded here

Thanks,
Andrei
