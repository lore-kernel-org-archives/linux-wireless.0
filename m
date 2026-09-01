Received: from smtp14.infineon.com (smtp14.infineon.com [217.10.52.160])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56AB44483B9;
	Tue,  1 Sep 2026 07:15:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.10.52.160
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788246953; cv=none; b=SoM+h8SoY3vQeovVoEohtpVf0xQWJnkZjGvDswExhTIZdL4tAYnI1gG8bPfLYhIyflZEHOLwlN6c1R9TFxb5CvwRd7yRxSwWjJgaiESzR6DAgS2+rOpPWwqh1hzkxwXaBmeoj30CdKVMGQsk4LjWTcut89NjktJXe4bOBGbUk+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788246953; c=relaxed/simple;
	bh=CQhdniJ6ytQBLPKBNUGYkZcuBEuTvR5bKJgrmTdSV60=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c2RIY+QwrXCScZp6LhDHO//WePisbTqohMxm31V1Nd+d79R1kcVSKy6gesSRyxgnmKMuxwaN2EBrsP6A6hDbF3oBETjVjiF8tmso4f3ndXPPFy2qSiw75mxLLC7sXAuKLt4qZqtv5uOD1jpveFl41GQLgO0Sn9NAu4KDs89hkT4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=infineon.com; spf=pass smtp.mailfrom=infineon.com; dkim=pass (1024-bit key) header.d=infineon.com header.i=@infineon.com header.b=VCkwem0V; arc=none smtp.client-ip=217.10.52.160
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=infineon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infineon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=infineon.com header.i=@infineon.com header.b="VCkwem0V"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=infineon.com; i=@infineon.com; q=dns/txt; s=IFXMAIL;
  t=1788246952; x=1819782952;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=CQhdniJ6ytQBLPKBNUGYkZcuBEuTvR5bKJgrmTdSV60=;
  b=VCkwem0VkMXYs8vqKjGtkTWLWGY75eOfoPNAzNn1GGP9lC/17/fo/C2E
   6v3GgdPtjVFGIgeYecYcTqNDClGwDZYRpxBnbY5ClUUQCTFjdDBAX6Gh+
   S77k9JZEUiuyrmIgM6SPA4Xa+vY4Qy8ar0L4lp/l+OCmCweYoT0rk6cCl
   Q=;
X-CSE-ConnectionGUID: zrK6w3BVRzyE9EkXFaGZsA==
X-CSE-MsgGUID: A/SxG0cERSOpeTJIqPm25w==
X-IronPort-AV: E=McAfee;i="6800,10657,11892"; a="144879284"
X-IronPort-AV: E=Sophos;i="6.25,255,1779141600"; 
   d="scan'208";a="144879284"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO MUCSE803.infineon.com) ([172.23.29.29])
  by smtp14.infineon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2026 09:14:36 +0200
Received: from MUCSE809.infineon.com (172.23.29.35) by MUCSE803.infineon.com
 (172.23.29.29) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Tue, 1 Sep
 2026 09:14:35 +0200
Received: from ISCN5CG5251XQT.infineon.com (10.161.6.196) by
 MUCSE809.infineon.com (172.23.29.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Tue, 1 Sep 2026 09:14:32 +0200
Date: Tue, 1 Sep 2026 15:14:24 +0800
From: HungTsung Huang <Jason.Huang2@infineon.com>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
CC: <linux-wireless@vger.kernel.org>, <johannes.berg@intel.com>,
	<johannes@sipsolutions.net>, <hsin-hung.li@cypress.com>,
	<linux-kernel@vger.kernel.org>, <brcm80211@lists.linux.dev>,
	<brcm80211-dev-list.pdl@broadcom.com>, <wlan-kernel-dev-list@infineon.com>,
	<jeff.johnson@oss.qualcomm.com>, Carella Chen <carella.chen@infineon.com>
Subject: Re: [PATCH v5 1/5] wifi: nl80211: add roam offload extended feature
Message-ID: <20260901071424.GA1876155@ISCN5CG5251XQT.infineon.com>
References: <20260821-upstream-wireless-next-main-jason-11r-support-v1-v5-0-eeab4fda0f31@infineon.com>
 <20260821-upstream-wireless-next-main-jason-11r-support-v1-v5-1-eeab4fda0f31@infineon.com>
 <382c3dbb-ff32-4e62-9b79-c6e4cc6273ef@broadcom.com>
 <8a866e2b-8802-4a8e-8421-2732da5f5c8f@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8a866e2b-8802-4a8e-8421-2732da5f5c8f@broadcom.com>
X-ClientProxiedBy: MUCSE823.infineon.com (172.23.29.54) To
 MUCSE809.infineon.com (172.23.29.35)

Hi Arend,

> Actually there is a checkpatch warning that line with the STA_1X check
> is 82 characters. So my suggestion please make it FAST_ROAMING instead
> of ROAM_OFFLOAD and swap the two checks to fix the checkpatch warning.
> 
Thank you for your suggestion. We will rename it to NL80211_EXT_FEATURE_FAST_ROAM_OFFLOAD.
The name reflects that userspace offloads fast-roaming handling to the driver/firmware,
and it covers both FT and OKC. We will also reorder the checks to avoid the line-length warning.

Thank you.
