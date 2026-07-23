Received: from smtp14.infineon.com (smtp14.infineon.com [217.10.52.160])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E5A337DEAD;
	Thu, 23 Jul 2026 05:22:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.10.52.160
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784784149; cv=none; b=vD0z+OJ4rLIx96ZwfYuzo3nYeRrs8QfYSnQtYU+rJtWWav0k5yhOGUBJqrRDOCOdLL0H1LhJKeTm4LodoqVQ8LBvtWSYoezUdsb9dVkH/iNn8Y+1ljt+d5bjlZZ/wOZAgHXdh9kjgMZ3ka7+RxnnouB++ou0QhUacFgjE3mUQIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784784149; c=relaxed/simple;
	bh=j5pzo7e1FDluujUuUBNuOKF3mreTTHNBppu+y3L261I=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=NtJeLoquyPmzVYvzvNC8hbYbeAmbIIdUvci6G6YvkoA4zHkLMEBT5K/kVhFpNYRWr/9/t5Z+FjFUGobn5VMYNK8WGBv8J8FpxxA1Y1AYB1vNcl0fqrf6EIIaRvRCItY/JCu7KeZSvKcmQnhQyvKniP+rUN/AoWi0DgaL/YzF1BY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=infineon.com; spf=pass smtp.mailfrom=infineon.com; dkim=pass (1024-bit key) header.d=infineon.com header.i=@infineon.com header.b=nCIk4usX; arc=none smtp.client-ip=217.10.52.160
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=infineon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infineon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=infineon.com header.i=@infineon.com header.b="nCIk4usX"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=infineon.com; i=@infineon.com; q=dns/txt; s=IFXMAIL;
  t=1784784148; x=1816320148;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=j5pzo7e1FDluujUuUBNuOKF3mreTTHNBppu+y3L261I=;
  b=nCIk4usXRQQOoLWjhMoUCFfEEWRFBkMrpZ0pq3gq0vUxMXW0ewbr1tju
   Qc5UDKOEWjEq9lqyUCLwTPcUBlCEN963QO/8xkY/t2nurvxCI9F9ETq6V
   S0HTRcy6Zwxw3KdDENhXxDTe5lso9JNX23wx9i64Z11T4h+I5t80Ro/Za
   g=;
X-CSE-ConnectionGUID: uDIU35IcSemwqhpoC3kisQ==
X-CSE-MsgGUID: 4ImyKAbtTga9VI3B66P+Sw==
X-IronPort-AV: E=McAfee;i="6800,10657,11854"; a="139078717"
X-IronPort-AV: E=Sophos;i="6.25,179,1779141600"; 
   d="scan'208";a="139078717"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO MUCSE814.infineon.com) ([172.23.29.40])
  by smtp14.infineon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Jul 2026 07:22:25 +0200
Received: from MUCSE809.infineon.com (172.23.29.35) by MUCSE814.infineon.com
 (172.23.29.40) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.43; Thu, 23 Jul
 2026 07:22:24 +0200
Received: from ISCN5CG5251XQT.infineon.com (10.161.6.196) by
 MUCSE809.infineon.com (172.23.29.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Thu, 23 Jul 2026 07:22:22 +0200
Date: Thu, 23 Jul 2026 13:22:14 +0800
From: HungTsung Huang <Jason.Huang2@infineon.com>
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
	<y@ISCN5CG5251XQT.infineon.com>
CC: <linux-wireless@vger.kernel.org>, <brcm80211@lists.linux.dev>,
	<brcm80211-dev-list.pdl@broadcom.com>, <linux-kernel@vger.kernel.org>, "Kurt
 Lee" <kurt.lee@cypress.com>
Subject: Re: [PATCH v5] wifi: brcmfmac: add DPP support
Message-ID: <20260723052214.GA178538@ISCN5CG5251XQT.infineon.com>
References: <20260715084718.667522-1-Jason.Huang2@infineon.com>
 <20260720194900.2356442-1-arend.vanspriel@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260720194900.2356442-1-arend.vanspriel@broadcom.com>
X-ClientProxiedBy: MUCSE823.infineon.com (172.23.29.54) To
 MUCSE809.infineon.com (172.23.29.35)

Hi Arend,

Thank you for the Acked-by.
As requested, the standalone P2P device vif guard patch has been
submitted. Here is the official Linux mailing list link so you can
track it.

https://patchwork.kernel.org/project/linux-wireless/patch/20260722082608.412472-1-Jason.Huang2@infineon.com/

Best regards,
Jason

On Mon, Jul 20, 2026 at 09:48:56PM +0200, Arend van Spriel wrote:
> Caution: This e-mail originated outside Infineon Technologies. Please be cautious when sharing information or opening attachments especially from unknown senders. Refer to our intranet guide<https://intranet-content.infineon.com/explore/aboutinfineon/rules/informationsecurity/ug/SocialEngineering/Pages/SocialEngineeringElements_en.aspx> to help you identify Phishing email.
> 
> 
> 
> On Wed, 15 Jul 2026, Jason Huang wrote:
> 
> > [PATCH v5] wifi: brcmfmac: add DPP support
> >
> > Add DPP AKM handling and RSN parsing support ...
> >
> > Changes since v4:
> > - Drop the pre-existing P2P device vif fixes; they are now a standalone
> >   wireless patch.
> 
> The DPP code looks good. The P2P fixes have been removed as requested and
> the changelog is present.
> 
> Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
> 
> This ack is conditional on the standalone P2P device vif guard patch being
> submitted. When you post it, please reply here with the lore.kernel.org
> link so I can track it.
> 
> Regards,
> Arend
