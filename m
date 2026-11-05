Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.17
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793900583;
	b=1CrfYnIGZ6z9L0q8P+DXsocoG5CcalhUI3cP6PvtS5aOVn82hn/00hqPMMHmH+JExAXo
	 d1jjRUg/dQb1t6DWDxvSjzy60YB/EF58+O1Jnwax4BvMVHPRaPkB423s4T/sIo8b/0pOY
	 9tgg2pw172CVFm/eYMSDpH4E1SBTMhlaRki21xs5Hm77vj7Qk8yYeiWpzkl+mYVOPEiAK
	 +HqG04okfn0JxPZUhTq6OcPpNio0zdqQImWgFlmGAv27Nuxxkh6uD/2tPvTY9gFr9uPmw
	 cGQ/32a5VtAD6SyIm8iKxvBWNueRgqfuiNalM+9f0jxWVc1gIusw1qdNQ6kieH3l3LA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793900583;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=DoygwZAo2QRBNeVN/hmCt0pFGnxbbSGCY+BLYmGnZl4=;
	b=X9laoaASy77hIrhmxgjL6vfhS/WBiuygN+qKnOQm7UWY469yj/zhH+u0BSW2xIvSu0gJ
	 9rQWjrIfrs01NRILYSdWS+T5EGop6nxq1t3I0w3yiBCFlxrx8f/0YVtlITDC+/yLrvGC0
	 j3ESSV3L5VX6C0y7oZBXw4+wrvRCgA7KSZyp6XGz6HEA6bH3J5UPokodPoBEbK7boqL+A
	 JSH7OJk9/Vl7xIk5TW/qJOvOuav3F7JxxNc3ib1OPoGq52aCQkpPm/FPEcGAvpgr1p+4/
	 vW2TvslazROwt3vOO/LS2PR1C3NBy8C+ECa4iewsRs9cRIU2VbWl9NsFLiUtYlJAv/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=ANit+sXu;
	arc=none smtp.remote-ip=198.175.65.17
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1066B606A332
	for <linux-wireless@vger.kernel.org>; Thu,  5 Nov 2026 17:43:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1066B606A332
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=ANit+sXu
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793900582; x=1825436582;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=UZqza5uAkPTVSL4ss3OVw++Pn7GxKTqW/KFpHzgGetU=;
  b=ANit+sXuoQvKb4WD3vJYKuuwtsk5q51j+cTAL13EUseU3loSbezzQl28
   gz7e0i2FKfa0vBn4YGJHqoPxHJTvy1q9U9VfYpoBRvUW+U1cUkm0Gv3Jd
   hpw17Ay9en9wvurHOoqi0fvl5R/PHM+Ri/X4SaFrAMbH4JiCmvc6Mt2GI
   dmyDaM4S8HX0PAjztFPV4WIVQoAsMAr9yTpYZLdZrvnV4bGxYwGURLzo2
   qLjGwb99y0ojBfp8peb2Ij9ezcZal5Kf/VDU0L513kM+JHjmffwBiazJd
   DGa7zRk/y7RuXujFkJb+Q2fxkh/AMrJ3/YiSY+sFs8D/SeOhNpTJzHnfC
   Q==;
X-CSE-ConnectionGUID: soNaAQA6SRqBR+HErn+BeA==
X-CSE-MsgGUID: 76fAsC9KSc6DjyARG0AkHw==
X-IronPort-AV: E=McAfee;i="6800,10657,11957"; a="2726913"
X-IronPort-AV: E=Sophos;i="6.27,197,1787036400"; 
   d="scan'208";a="2726913"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2026 09:42:56 -0800
X-CSE-ConnectionGUID: hYww1w6sRLG4pQDsGwTY0w==
X-CSE-MsgGUID: 0WpQvzWQS7iOnd6Xvkq6fw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,197,1787036400"; 
   d="scan'208";a="7489301"
Received: from iapp347.iil.intel.com (HELO 87c02287900a.iil.intel.com) ([10.167.28.6])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2026 09:42:55 -0800
From: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
To: Shivani Baranwal <shivani.baranwal@oss.qualcomm.com>,
	johannes@sipsolutions.net
Cc: Andrei Otcheretianski <andrei.otcheretianski@intel.com>,
	linux-wireless@vger.kernel.org,
	kavita.kavita@oss.qualcomm.com,
	vamsin@qti.qualcomm.com
Subject: Re: [PATCH wireless-next 03/15] wifi: nl80211/cfg80211: extend NAN match indication for discovery offload
Date: Thu,  5 Nov 2026 19:42:39 +0200
Message-ID: <20261105174250.37677-2-andrei.otcheretianski@intel.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261014103359.1508345-4-shivani.baranwal@oss.qualcomm.com>
References: <20261014103359.1508345-1-shivani.baranwal@oss.qualcomm.com> <20261014103359.1508345-4-shivani.baranwal@oss.qualcomm.com>
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

On Wed, Oct 14, 2026 at 04:03:47PM +0530, Shivani Baranwal wrote:
> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
> @@ -10581,6 +10581,23 @@ void cfg80211_free_nan_func(struct cfg80211_nan_func *f);
>   * @addr: the MAC address of the peer
>   * @info_len: the length of the &info
>   * @info: the Service Specific Info from the peer (if any)
> + * @extra_info_len: the length of @extra_info (Extended SSI)
> + * @extra_info: Extended Service Specific Info from the peer (if any)

I think according to the spec either SSI or extended SSI is used so info field
may be reused.

> + * @ies_len: the length of @ies
> + * @ies: additional elements from the peer's Service Descriptor frame (if any)

What do you mean elements - this is an action frame? Or maybe the intention
was "additional NAN attributes". But still not clear "additional to what". I
would simplify by including here the entire action frame contents so user
space can parse whatever it needs without being limited by nl80211 API. In
such case you don't need all the fields below, besides RSSI maybe.

Thanks,
Andrei
