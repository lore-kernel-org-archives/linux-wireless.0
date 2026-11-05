Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.17
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793900591;
	b=27A6dSXdkKN7Tyt6DYBLP/ALtv5Z4Cxvx4HOwD987ScmH0/b/pjJio5eQmsXSKzym7eX
	 lpylInGecxY8+wzqZGsHcYv68eBpkqVV2Mo7er2aaAnp6k4VeePI8TvgeMYIXQ23vjwtk
	 mnEJXlrxtDOnrmiTD3dMyILIBhINOCtiXF3jKuuVCz5MbByj9LuMqgZmN4RMU7I0hhu/r
	 Q/4Vc4pXmaZgsgN/pNJr6HBU7KSftCyVw/szahGoyAObyj2JHgwxDpt3k2GpS798vg5RX
	 qtCHx7I5BLKt32Jz0G39QDl32hU9OSh/hBP2ToMHQaqisSLDacX2z8npVQBmBx41ZmA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793900591;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=xOi3yJP3SKjaauhb5caL6ztSlYUGPVkKrLEJmtcXmy0=;
	b=vHNCsJGIDZhw0IC+vTfbgZl8UwCPfXIahAJYmsF/QY9IGhRA8xJ8bDOl3VMUCDLkgIrn
	 zp8/qIaJ3GB4gp6RRr4hXNfRnYmtsFy2XBsViZBFosFu5slKfv0q+PQjxeb669NiQJr4s
	 qPKHXGHYHuwGYs2yzEMwIAZfAnzxBT4NqHm9dx/Y9DSlcNuyxQi9rKfLc0qzy5TfwPQln
	 auyvqpVpHGeg8HXl9kgIkMlco3Iqz5YL1EEY3su3fMrhyjhIJKqSOiCeldJ5Z6t+OAkFl
	 asafMoeNtNElBLgwOkGd+mFKq6qinm8r/M2l4c141OJ1j9AoH2TyANv5afmJUo6BJ/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=OUWRLQgN;
	arc=none smtp.remote-ip=198.175.65.17
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BEB9606D819
	for <linux-wireless@vger.kernel.org>; Thu,  5 Nov 2026 17:43:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2BEB9606D819
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=OUWRLQgN
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793900590; x=1825436590;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=rd0qsQvGbp5JSYFUgL2v6fql5wJ9I25DmgKnT6tTr6k=;
  b=OUWRLQgNYuuFVT/cWUKEyNUqJSGT2B4XEzsFpicrZF075YxVyXuuK74k
   1ypgrseWBNq6LH/mi3ptQRPIc8skwdZgYmj0/iVGVsNbrhukXa9WvGqwP
   hoBY7a4f6szA46A+wVKpLQqpHBchKpCA+aJK8n0JXwaCzs3CW3ZYXMUd5
   +MGwid5j6z+IsIdPCkR6U8opxAnT0JZJ/RzUHSpF2iXjRfMqt0FrO7Og2
   5ldRom7iz9YhGCfWgPOLoJukV6AcYYUtx5rVuoaewmNzF8s2rDYw2SXdg
   co1/rzeYHE/7bru7JMHxzRrj5DvBsmsVRNy8GL21/Wz1X/pJ6MKaYM2mP
   A==;
X-CSE-ConnectionGUID: T7V7JKvyTDmJ8rhVz9dzJA==
X-CSE-MsgGUID: 5kxiAceeSK6wljJztBJt3g==
X-IronPort-AV: E=McAfee;i="6800,10657,11957"; a="2726975"
X-IronPort-AV: E=Sophos;i="6.27,197,1787036400"; 
   d="scan'208";a="2726975"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2026 09:43:10 -0800
X-CSE-ConnectionGUID: czeI/KKYSnigReJ2nVUBeg==
X-CSE-MsgGUID: v1DRyBGARSCWCE3cY0deoQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,197,1787036400"; 
   d="scan'208";a="7489451"
Received: from iapp347.iil.intel.com (HELO 87c02287900a.iil.intel.com) ([10.167.28.6])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2026 09:43:09 -0800
From: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
To: Shivani Baranwal <shivani.baranwal@oss.qualcomm.com>,
	johannes@sipsolutions.net
Cc: Andrei Otcheretianski <andrei.otcheretianski@intel.com>,
	linux-wireless@vger.kernel.org,
	kavita.kavita@oss.qualcomm.com,
	vamsin@qti.qualcomm.com
Subject: Re: [PATCH wireless-next 15/15] wifi: nl80211/cfg80211: add support for NDP terminated indication
Date: Thu,  5 Nov 2026 19:42:46 +0200
Message-ID: <20261105174250.37677-9-andrei.otcheretianski@intel.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261014103359.1508345-16-shivani.baranwal@oss.qualcomm.com>
References: <20261014103359.1508345-1-shivani.baranwal@oss.qualcomm.com> <20261014103359.1508345-16-shivani.baranwal@oss.qualcomm.com>
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

On Wed, Oct 14, 2026 at 04:03:59PM +0530, Shivani Baranwal wrote:
> diff --git a/include/net/cfg80211.h b/include/net/cfg80211.h
> +struct cfg80211_nan_ndp_terminated_params {
> +	const u8 *peer_nmi;
> +	u8 ndp_id;
> +	const u8 *init_ndi;
> +	u8 reason;
> +};

Consider adding locally_generated flag.

> diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
> @@ -18952,6 +18952,56 @@ void cfg80211_nan_ndp_confirm(struct wireless_dev *wdev,
> +	nla_nest_end(msg, ndp_attr);
> +	genlmsg_end(msg, hdr);
> +	genlmsg_unicast(wiphy_net(wiphy), msg, wdev->owner_nlportid);
> +	return;

Same, record the trace event here

Thanks,
Andrei
