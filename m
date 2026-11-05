Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.17
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793900583;
	b=QLtRC/qb0AH4cjE1Jn3mIGh3KiDqIXGRKYwv9+slLcFCqlnEeRE86wuRKHW2ulMvau1V
	 RYR1MgDFBq9vhj8SS5ENojqA4DP6y3YcHZDbqHCyHNEoc96TkhYE5fGiHeoNwMBe8vK2c
	 BPKwD4i4i6A/0KCgQij55yFuQPpm9D1VONhWB6p/toJUYx3d83zy2W6Ty8czXD5LufIME
	 FmXzB99FmAWEuRXadJfKfLX6YWh+2axBKT9gvcBN7nA0rUAPlawa21zXWc/42+RuOKdS3
	 OTmyKcxM+XF9chpM7iN9EaL06Jr8l1Ab/Tq6OK3Ry8bQMqjXJzVF15GXINUZk89paCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793900583;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=4Y7n1gCOXSepeYB/H7IrNT35hf8Xt0cIaLmGUmtGuys=;
	b=GhcG5Bg8Uz6/H55ax8Kv8T9P1+qS6zy+0AHhUon1hMHD+QYW2V3CK/OtfDYyNx/aKUfl
	 kfwEvozQvh8xdvaJrJCkxaqSg13DUg8hy+enXxSi1HWD2MQSXS9Q58+4WuLIWb8YFySMV
	 99cBc01dd133YLYtCGRadwonkVvloMTmOn/XLyOdsPn74bekskjVQ7Xxuv3H0S7iX/5lU
	 HKobnvccdPLQU1ajyEUwEAeIGQdYUnd3UUukkyU2bKjz5vEG/sBMdfITqTg1J/FNiPKH/
	 E7in/v5d9i35Nkcp/ppWLGtgIRA8BvzmuR7XO2kh0m7QLUD7Dnj2Z9ubi2wsfPpgTFg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=B119ptQT;
	arc=none smtp.remote-ip=198.175.65.17
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05537606A339
	for <linux-wireless@vger.kernel.org>; Thu,  5 Nov 2026 17:43:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 05537606A339
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=B119ptQT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793900583; x=1825436583;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=6uWrcRL8rfLMBvNJAd0SLpcQW9sjKr1L2vg9W6oStAk=;
  b=B119ptQTu4+t+vj1+KSC6tsyiqPC1DCthWegD1UTzYXaT486XAvoXVRV
   7y+/El3T8BZQqYkn6GtIR5GAFIkDaJEH3Dw6Uyfa0CfR8RiTmprjAe3Gv
   P637MTnBqJbgY+GSpVdE/Gt/biS9jAL9nVnfjMR3mkFEQ03IDL9FD56sJ
   2KR3BPhcVOV7GCznv6mJVPqekbgod2xper0/+PcpXX+g3gtbGKYo396p4
   /0Ke3OFV77sEcn3uKf6RoIjMrQKFuEe93wHg47WZqsJCcVDCzDK5EWVcD
   NnQFWVtLzXyziyrN+On1g7M8wMdpVmas+ko7nWSqdxOGwgjtMd5uxdzzP
   g==;
X-CSE-ConnectionGUID: N6u0SIt3QVyoCg/NeSy0HA==
X-CSE-MsgGUID: rYjsai1xSPKHfMuGh7m8Jg==
X-IronPort-AV: E=McAfee;i="6800,10657,11957"; a="2726934"
X-IronPort-AV: E=Sophos;i="6.27,197,1787036400"; 
   d="scan'208";a="2726934"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2026 09:43:00 -0800
X-CSE-ConnectionGUID: W1XSAt3cTc+M2FPL1ogz/w==
X-CSE-MsgGUID: INvyLzMzQp2np34bgC+F8Q==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,197,1787036400"; 
   d="scan'208";a="7489340"
Received: from iapp347.iil.intel.com (HELO 87c02287900a.iil.intel.com) ([10.167.28.6])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2026 09:42:59 -0800
From: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
To: Shivani Baranwal <shivani.baranwal@oss.qualcomm.com>,
	johannes@sipsolutions.net
Cc: Andrei Otcheretianski <andrei.otcheretianski@intel.com>,
	linux-wireless@vger.kernel.org,
	kavita.kavita@oss.qualcomm.com,
	vamsin@qti.qualcomm.com
Subject: Re: [PATCH wireless-next 09/15] wifi: nl80211: add NDP offload capability advertisement
Date: Thu,  5 Nov 2026 19:42:41 +0200
Message-ID: <20261105174250.37677-4-andrei.otcheretianski@intel.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261014103359.1508345-10-shivani.baranwal@oss.qualcomm.com>
References: <20261014103359.1508345-1-shivani.baranwal@oss.qualcomm.com> <20261014103359.1508345-10-shivani.baranwal@oss.qualcomm.com>
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

On Wed, Oct 14, 2026 at 04:03:53PM +0530, Shivani Baranwal wrote:
> diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
> @@ -9279,6 +9279,9 @@ enum nl80211_s1g_short_beacon_attrs {
> + * @NL80211_NAN_CAPA_OFFLOAD_NDP: flag attribute. Driver handles NAN Data
> + *	Path (NDP) handshake frames and data path key installation.

Please elaborate a bit more, what exactly the driver should support (the
commands in your next patches etc)

Thanks,
Andrei
