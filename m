Received: from smtp14.infineon.com (smtp14.infineon.com [217.10.52.160])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6AF036B912;
	Tue,  8 Sep 2026 05:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.10.52.160
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788847188; cv=none; b=YVzEId3JFsj+rZ6G2LUQp5qP5zZ8yeyWJuylPJO6iemc87Bbr6M6FKXct08ZzbHMR76biDSXMMVo1NXh1wSZJyocG8ILbhAZV9wV/UdcMbqX2naTAJjS6HszxQgNnfH84jsXiS4qCrJHbHg7ELHbCFucmDjBaTp9RdPNlkR3PpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788847188; c=relaxed/simple;
	bh=4qe5IV54jyWdaYQxFgoOUHeEcAJEkAxi8lDtTCC33nU=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q3lzChB5Sbod+gVemXf8/c33uqJFLagerG1A7ij9YGmXbM6j7jvFdEQTp1mDDwllz4g4z8+MvTgWm05+4y/QX5g53oLpife66ym6C/c5bLsHRrOooXqoOUs6NnOXYt62cXxMF1+1CbiClT3chCwwVwy4N12ZnZQZKzHKZ2Oy+4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=infineon.com; spf=pass smtp.mailfrom=infineon.com; dkim=pass (1024-bit key) header.d=infineon.com header.i=@infineon.com header.b=JB61B+sg; arc=none smtp.client-ip=217.10.52.160
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=infineon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infineon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=infineon.com header.i=@infineon.com header.b="JB61B+sg"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=infineon.com; i=@infineon.com; q=dns/txt; s=IFXMAIL;
  t=1788847187; x=1820383187;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=4qe5IV54jyWdaYQxFgoOUHeEcAJEkAxi8lDtTCC33nU=;
  b=JB61B+sgHrHtPR+3tuxPFmVFM9Bq2kSSPmuIc0Uw5MtJJr/p7snY6AV1
   gGg27uJWmYwzVG1/VXy9+snBnd3eTAwocxyYh6tOEEYSCS3v2VPC2DwIN
   EKNBWcrAbLD/kS9UHX8K02zUFZNEAhnYJw7G6i8aph00H7Twywd9FuANO
   0=;
X-CSE-ConnectionGUID: xsjTBOtuTzuy/oiTMVyACQ==
X-CSE-MsgGUID: 1Zj5dLtqR0i4PXTpa/X/IA==
X-IronPort-AV: E=McAfee;i="6800,10657,11899"; a="146028908"
X-IronPort-AV: E=Sophos;i="6.25,268,1779141600"; 
   d="scan'208";a="146028908"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO MUCSE822.infineon.com) ([172.23.29.53])
  by smtp14.infineon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Sep 2026 07:59:39 +0200
Received: from MUCSE809.infineon.com (172.23.29.35) by MUCSE822.infineon.com
 (172.23.29.53) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Tue, 8 Sep
 2026 07:59:39 +0200
Received: from ISCN5CG5251XQT.infineon.com (10.161.6.196) by
 MUCSE809.infineon.com (172.23.29.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Tue, 8 Sep 2026 07:59:36 +0200
Date: Tue, 8 Sep 2026 13:59:28 +0800
From: HungTsung Huang <Jason.Huang2@infineon.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>, <arend.vanspriel@broadcom.com>,
	<hsin-hung.li@cypress.com>, <linux-kernel@vger.kernel.org>,
	<brcm80211@lists.linux.dev>, <brcm80211-dev-list.pdl@broadcom.com>,
	<wlan-kernel-dev-list@infineon.com>, <jeff.johnson@oss.qualcomm.com>,
	"Carella Chen" <carella.chen@infineon.com>
Subject: Re: [PATCH v5 1/5] wifi: nl80211: add roam offload extended feature
Message-ID: <20260908055928.GA196825@ISCN5CG5251XQT.infineon.com>
References: <20260821-upstream-wireless-next-main-jason-11r-support-v1-v5-0-eeab4fda0f31@infineon.com>
 <20260821-upstream-wireless-next-main-jason-11r-support-v1-v5-1-eeab4fda0f31@infineon.com>
 <94f92252ee873146420ed2a53ac1b86dead1345b.camel@sipsolutions.net>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <94f92252ee873146420ed2a53ac1b86dead1345b.camel@sipsolutions.net>
X-ClientProxiedBy: MUCSE804.infineon.com (172.23.29.30) To
 MUCSE809.infineon.com (172.23.29.35)

Hi Johannes,

Yes, you're right. nl80211_del_pmk() should allow the same
ROAM_OFFLOAD-only case as nl80211_set_pmk(); otherwise userspace can
install PMK material for roaming offload but cannot delete it again.

I'll fix this in next version by applying the same feature check to del_pmk().
Thanks for catching this.
