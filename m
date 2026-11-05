Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=192.198.163.9
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793900462;
	b=WDA/mQiKlxnBhdmsAkw1ZRP9AOJ2dwgUpZocbzl7WCBSSnsyAyKQWKIYKQAYTiG56Gbn
	 Zm9Gb48JPANkX+4pjdUZqUhMMg1pmMKRPbv0dB/FSqz6rYs9cWUWeUj5LAo4UBfJKXWBg
	 gxNnXy8dr+qmi4AyU12ET0eDwgwTh5Y/dhkeJWg69IvmFrRiGC+ZV+pDq8GZn+zjCyUCr
	 i0nf4AQ2P7SiWp2kM2J4rv+W5PcPn5001gYJMQhoB3KkHqQAp2ClpIHVNQD9gQd21ptNR
	 mVp+4BwwsIEwR8+4GPgSQ90bsqAHlgXoR8aXuLsOIu11TtNj7hvi7PO1wJjpcSPjz4g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793900462;
	h=DMARC-Filter:DKIM-Signature:X-CSE-ConnectionGUID:X-CSE-MsgGUID:
	 X-IronPort-AV:X-IronPort-AV:Received:X-CSE-ConnectionGUID:
	 X-CSE-MsgGUID:X-ExtLoop1:X-IronPort-AV:Received:From:To:Cc:Subject:
	 Date:Message-ID:X-Mailer:In-Reply-To:References:MIME-Version:
	 Content-Type:Content-Transfer-Encoding;
	bh=kMMWACtyE8QzOyFRA22GbKgzTKizllqK1sqig7b1Jqg=;
	b=WH9qD3qGFc1bCRJIutaoibgq8mE/3GVC1leNbUEjHA2SKPBk8wOA5Zvje+DJS58ygmHe
	 MwK9MzsSNS4VZs9iS2kHndwWErvQxuQssWIyx7TaWDaA6bZxtC8y79jzJEmiKfyQuQRiN
	 UcN67+78dNdVit6YTD1vhuaLLCjGy22mYiKGqOPwuA1xEBxeTGk/cbxZTm5hplhvR/Yxw
	 u+jWplnvZpuG+7Wd3ejo65SY4i/d1+Li/hlpotrFXOROfyXBIDOjc0Bd0IVmY/OOsEGhd
	 mO69ELYMH0OBvAK759Pb5TqHZB7YSYR7+XWhKmU4zeWzLwMfbfGqf7XiyfwRbRH6HDA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=intel.com;
	spf=pass smtp.mailfrom=intel.com;
	dkim=pass header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b="L/xRgWhu";
	arc=none smtp.remote-ip=192.198.163.9
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15AFD606A329
	for <linux-wireless@vger.kernel.org>; Thu,  5 Nov 2026 17:41:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 15AFD606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=intel.com header.i=@intel.com header.a=rsa-sha256 header.s=Intel header.b=L/xRgWhu
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1793900461; x=1825436461;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=GRj+b3N+NwRPd+V+Kr8hbkpvnBi/ER8/3uUxlHD6E9c=;
  b=L/xRgWhuGEI7FBFJUcT0/Ri+5EXjxmYvAH/ZNKSERDbqz8hvo0ABq+2A
   fzNszs7qlCnT04Sp44Iu73BiH6rhWBsP0uhQKCLC6CMim62Ee8fL4X3+H
   zDIciKmd7wwB8wQJPMmPODOd2zvJhYuiSzhIepbYWcaKlr9y4QlK+X8GP
   u/1PGL3wru0BtFFFXemvw5eARyLpJv3wtk8rS97gVVtqwumOkCcVQlcXz
   LlTLPKFguWQ7lP6pbLjxgLnMAwen1gxfjQjCtyP5xrnmkpoizHPmnz2UF
   5T1+cSJ5ZbtXlekRk5YJHKxznTnyb26mvOnQw6ot3Lcv8zDbG0+VWnQ/k
   g==;
X-CSE-ConnectionGUID: CJjKb0+uRaKzBAZD/O7/5Q==
X-CSE-MsgGUID: W4rpVXBfSJ2nR0swDzsNAQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11957"; a="2579620"
X-IronPort-AV: E=Sophos;i="6.27,197,1787036400"; 
   d="scan'208";a="2579620"
Received: from fmviesa005.fm.intel.com ([10.60.135.145])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2026 09:40:46 -0800
X-CSE-ConnectionGUID: 8hYp8SLxQpOaHRgXqVaZgA==
X-CSE-MsgGUID: SaFrF0WQQjSC4SG05PTnyA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.27,197,1787036400"; 
   d="scan'208";a="7193294"
Received: from iapp347.iil.intel.com (HELO 87c02287900a.iil.intel.com) ([10.167.28.6])
  by smtpauth.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Nov 2026 09:40:45 -0800
From: Andrei Otcheretianski <andrei.otcheretianski@intel.com>
To: Shivani Baranwal <shivani.baranwal@oss.qualcomm.com>,
	johannes@sipsolutions.net
Cc: Andrei Otcheretianski <andrei.otcheretianski@intel.com>,
	linux-wireless@vger.kernel.org,
	kavita.kavita@oss.qualcomm.com,
	vamsin@qti.qualcomm.com
Subject: Re: [PATCH wireless-next 01/15] wifi: nl80211: reject NAN add-function when Discovery Engine is in userspace
Date: Thu,  5 Nov 2026 19:40:39 +0200
Message-ID: <20261105174041.37504-1-andrei.otcheretianski@intel.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261014103359.1508345-2-shivani.baranwal@oss.qualcomm.com>
References: <20261014103359.1508345-1-shivani.baranwal@oss.qualcomm.com> <20261014103359.1508345-2-shivani.baranwal@oss.qualcomm.com>
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

On Wed, Oct 14, 2026 at 04:03:45PM +0530, Shivani Baranwal wrote:
> diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
> @@ -17383,6 +17383,12 @@ static int nl80211_nan_add_func(struct sk_buff *skb,
>  	if (!wdev_running(wdev))
>  		return -ENOTCONN;
>  
> +	if (wdev->wiphy->nan_capa.flags & WIPHY_NAN_FLAGS_USERSPACE_DE) {
> +		NL_SET_ERR_MSG(info->extack,
> +			       "NAN Discovery Engine is in userspace");
> +		return -EOPNOTSUPP;
> +	}
> +

Similar if should be also added in del_func

Thanks,
Andrei
