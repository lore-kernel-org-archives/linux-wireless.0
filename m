Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=198.175.65.17
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793900586;
	b=HLrKG5/OW9yZn1E408EOOBc+pXR1Ty7oXxOV6KwuDiY5VAWpGIY/OV2/4l6t9CaftF2Y
	 EvDH4MGxnbf7/qV49Oe8cI0vx6yForYLEVaqLFHnw3Y6W8bc/jx0JlMKngwXwh3ATxnUX
	 +452PlOdN9Y+8uNW5dEMuHycwwTNA6Wrx5szAw9Zc5APXrroXWvqVcW/F7Ddu6N0Q4HC1
	 SHSnBIc8wyvitUmVrC1W+e9z8x5Gi/HRt8yWUr2cZ2B0V3lwOw5GoD2DJNH4gbGBpcsWm
	 GdxwqZzNZqqau2nCUjTmT4q5BpJGEzeapVQBcBiTdcGm4O2ybAU6hbokff7Hbb3yByA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793900586;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=XZ8CzPYlUCcUM2Qv0/g9dzAky/5DorybMBDmBYJTuns=;
	b=XkF944UhMgkG15ya/dgp/DVPOr523tttDKBQZNgJMyAtfknpBPyXSs+9FcQ9F+8JTsBm
	 XNtufqp08C9OZPzcnuQfMw3zbrYSvPEgWUpgUmTcXy1xAG0z4o5d9YFWz6kJKMBvoUCLS
	 R5UjVDxUi1Y0jqWPPiYWQwEA+F2vEVUBvgW38W35CW3pPUJIHmV9+RpmBxuBbd8TQnC0K
	 t7AWU+sj2vMWYbYExkBGiSyE66U9VisU8mYyhW42PgP9BAilqpa0D/aQ3Mo06lHMse1AZ
	 pRaANRui+Q6cNq3S01eQkstTLdY83QGkBPyoS6Icamvs+6jVm6dyA9ANwZgcDGzg7VQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=HRRAInZH;
	arc=none smtp.remote-ip=198.175.65.17
Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.17])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45898606A337
	for <linux-wireless@vger.kernel.org>; Thu,  5 Nov 2026 17:43:06 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 45898606A337
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=HRRAInZH
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793900586; x=1825436586;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=TGIXY6CrFrLkmj2bn8+6j47wYa7wpUED7ZKhxOofNHo=;
  b=HRRAInZH06exxF9T1ag5mmZoaDHCA6e0wHcmwK8/txCeOn0LS3RCEXml
   rFFwqGX9gPzs+VLlaWDgSV6nUbII6dA6q6x1aoOwZdiWbRb/0enDCgoqP
   VIJMaqUMARtkD2lMCnprm9A71wJ6DhJKK5FiId331dpkOU+1hQpWKQc/k
   xetHJrJwQuY4O/LnlaWz57Q38KcUXQt4zyazBVQIzBI1tc8NAMMnm9pxT
   WV2uv5PN6N6pJVyTaZ228y4/9ORCzl9t/+oikYBxEN2fKJQiwn7NSQQlj
   1pRA/NyxrfHpln5NSlj4oZ4CwQwdB4lSjkwl7my6YM8jPpaV6rN/xdFWC
   A==;
X-CSE-ConnectionGUID: vejV82g5RBKQwhxuZlc6XA==
X-CSE-MsgGUID: 4DDDZcVkTOattSAQxacMfA==
X-IronPort-AV: E=McAfee;i="6800,10657,11957"; a="2726963"
X-IronPort-AV: E=Sophos;i="6.27,197,1787036400"; 
   d="scan'208";a="2726963"
Received: from fmviesa007.fm.intel.com ([10.60.135.147])
  by orvoesa109.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2026 09:43:06 -0800
X-CSE-ConnectionGUID: Yk5WiL4QRsqRK2fdfsD+/Q==
X-CSE-MsgGUID: W69WWCbZSQ6ZteXo1IxYtg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,197,1787036400"; 
   d="scan'208";a="7489403"
Received: from iapp347.iil.intel.com (HELO 87c02287900a.iil.intel.com) ([10.167.28.6])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2026 09:43:05 -0800
From: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
To: Shivani Baranwal <shivani.baranwal@oss.qualcomm.com>,
	johannes@sipsolutions.net
Cc: Andrei Otcheretianski <andrei.otcheretianski@intel.com>,
	linux-wireless@vger.kernel.org,
	kavita.kavita@oss.qualcomm.com,
	vamsin@qti.qualcomm.com
Subject: Re: [PATCH wireless-next 13/15] wifi: nl80211/cfg80211: add support for NDP request indication
Date: Thu,  5 Nov 2026 19:42:44 +0200
Message-ID: <20261105174250.37677-7-andrei.otcheretianski@intel.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261014103359.1508345-14-shivani.baranwal@oss.qualcomm.com>
References: <20261014103359.1508345-1-shivani.baranwal@oss.qualcomm.com> <20261014103359.1508345-14-shivani.baranwal@oss.qualcomm.com>
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

On Wed, Oct 14, 2026 at 04:03:57PM +0530, Shivani Baranwal wrote:
> diff --git a/include/uapi/linux/nl80211.h b/include/uapi/linux/nl80211.h
> @@ -1483,6 +1483,11 @@
> + * @NL80211_CMD_NAN_NDP_REQUEST: Notification sent to userspace when
> + *	the driver receives a NDP Request frame from a peer. Carries
> + *	%NL80211_ATTR_MAC (peer NMI) and %NL80211_ATTR_NAN_NDP nested with
> + *	all parsed NDP request parameters. Userspace must ensure the NDI
> + *	interface is ready before calling %NL80211_CMD_NAN_NDP_RESPOND.

You can reuse the same NL80211_CMD_NAN_NDP_INITIATE for notification as well

> diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
> @@ -18798,6 +18798,85 @@ static int nl80211_nan_ndp_terminate(struct sk_buff *skb,
> +	nla_nest_end(msg, ndp_attr);
> +	genlmsg_end(msg, hdr);
> +	genlmsg_unicast(wiphy_net(wiphy), msg, wdev->owner_nlportid);
> +	return;

Trace the notification events

Thanks,
Andrei
