Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.17
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793900582;
	b=Rk/cNtj9MLo/frSZOmvqidRSnrGyMIi1xDVItORE1UPA7k3GRWjrFYs9d+gy9kMzkEwW
	 aC/OadmpJLPKEqaZ7Xv9lMS+c7SRE+aIP0VTrCkc12HajQAI858lk9sbbB6GN6LpVduAA
	 PlddxChMWzI/+noBAzl9dlnqjgQgiqj+RBx/hzaCKKMXL53Et8IUQ3K++netls5OXZaua
	 lhW78uaxnoSLCjMnCa0AtMlUldILXWxHZNOmlrLn393eTUZfYr01+VsopPq/FwXZMvLhH
	 /7kNMoR8KSgwXYImv2rJ4G5LWs2x1WxaTPUO87MxypJnyb9I/wzfZQjjt8qKPz8mQDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793900582;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=89YkL96dzgwoZXHkVJTPn2clnu+l8ZStOzk4YYt0biE=;
	b=EQtyAQOftWRHT8er5m2S200mJtbOrd8+4r7rnvXFdr2TaeAEFXbCN58ozDplPd2WzZST
	 7HEfNC0PqScZvYnmwRzj6lWJ//8qOpHVDfZMh7TKJ/QA/mzcT5VoxUmer2co6ysr/tT4M
	 Q6O1xtjbX6ADsSSa/qkPzq+3ERyKpvBmQiMCqXpspWD18O76+6IT7MxWi7oKk1y2CsfsK
	 SgZCU10eV2t78bqW8vvFeDcXLmvYgEjQ2ZwB/jICZVHaq7czOyCKa33bS8J8JDhiPjQJX
	 JjZ4A1cEe0LF59PIpC9udY8sy3k8EnsDueYUn8odMrmzw5D9fqyHDI/Bdo6mGNKZv5A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b="fH/mXthu";
	arc=none smtp.remote-ip=198.175.65.17
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4565D606A336
	for <linux-wireless@vger.kernel.org>; Thu,  5 Nov 2026 17:43:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4565D606A336
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=fH/mXthu
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793900582; x=1825436582;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=DBL5p8pqrBItEOLz4MmfK73c73O10VOjNCVCgjWtb/w=;
  b=fH/mXthu3dpnZZ/J4EGI7bg1fdTOwqK0WqsgBlizoBAt764Y2OQZQIn8
   dgEkuUsJt7WBKtzNb6x/WMyaG6hpgxdAuiWzarBKCTMzPYg8pEV7OWwIM
   tcvw8Vj/k3eCtYE4M1yFkPYq6nsVQRvxTXIowofTWOuQ9jrCCQaq9I8Gd
   p8jF+nu7emBHmiHDW0xSzjPeMY4AY28ObodSrA/bBRZyDBhuUMxax3gXv
   7Ewm6fAd8QTpy3iwoBjiSPOxcXbc+ELH8xh6h2//ubdRkjiVXcUTASXi1
   vo06qkR5zmDhx/OvdSxfMoNDKXaOd/w/0yyu3EDcCVejZoM6S4SzA11nD
   w==;
X-CSE-ConnectionGUID: OVSvq3TqTUCAA6hN6HPfEw==
X-CSE-MsgGUID: ZS+C8lqITWqv3ObNhSGN5w==
X-IronPort-AV: E=McAfee;i="6800,10657,11957"; a="2726925"
X-IronPort-AV: E=Sophos;i="6.27,197,1787036400"; 
   d="scan'208";a="2726925"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2026 09:42:58 -0800
X-CSE-ConnectionGUID: jxbLQcMcQe2pC78XtIDCmw==
X-CSE-MsgGUID: LRHaKoCsRHe1nOaZRR307Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,197,1787036400"; 
   d="scan'208";a="7489319"
Received: from iapp347.iil.intel.com (HELO 87c02287900a.iil.intel.com) ([10.167.28.6])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2026 09:42:57 -0800
From: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
To: Shivani Baranwal <shivani.baranwal@oss.qualcomm.com>,
	johannes@sipsolutions.net
Cc: Andrei Otcheretianski <andrei.otcheretianski@intel.com>,
	linux-wireless@vger.kernel.org,
	kavita.kavita@oss.qualcomm.com,
	vamsin@qti.qualcomm.com
Subject: Re: [PATCH wireless-next 06/15] wifi: nl80211/cfg80211: add support for request-based NAN ranging
Date: Thu,  5 Nov 2026 19:42:40 +0200
Message-ID: <20261105174250.37677-3-andrei.otcheretianski@intel.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261014103359.1508345-7-shivani.baranwal@oss.qualcomm.com>
References: <20261014103359.1508345-1-shivani.baranwal@oss.qualcomm.com> <20261014103359.1508345-7-shivani.baranwal@oss.qualcomm.com>
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

On Wed, Oct 14, 2026 at 04:03:50PM +0530, Shivani Baranwal wrote:
> diff --git a/net/wireless/pmsr.c b/net/wireless/pmsr.c
> @@ -306,11 +306,108 @@ static int pmsr_parse_ftm(struct cfg80211_registered_device *rdev,
> +	/* NAN ranging requires ASAP; reject if not set by userspace */
> +	out->ftm.asap = nla_get_flag(tb[NL80211_PMSR_FTM_REQ_ATTR_ASAP]);
> +	if (!out->ftm.asap) {
> +		NL_SET_ERR_MSG(info->extack,
> +			       "FTM: NAN ranging requires ASAP mode");
> +		return -EINVAL;
> +	}
> +	if (!capa->ftm.asap) {
> +		NL_SET_ERR_MSG(info->extack,
> +			       "FTM: NAN ASAP mode is not supported by device");
> +		return -EOPNOTSUPP;
> +	}

If ASAP is mandatory for NAN, how the device that advertises NAN ranging
support can advertise no support for ASAP?

Thanks,
Andrei
