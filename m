Received: from smtp11.infineon.com (smtp11.infineon.com [217.10.52.105])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D06E13F788F;
	Wed, 15 Jul 2026 09:22:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.10.52.105
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784107373; cv=none; b=PRtAV5kO8zWNs0FYShh6f08PmYBHwLdUeG+43Sj2W9uUrSoNDOS1dEh8pdw9zu7NqVT9to1YRV56//J2iVVMRGERF92SEcqnhd/+r3uyhB95zMBF7CkJmQPdhUvPx25APZt1I6rx/sQlcJdVWCaM6X1ENyBgdPVTI8Gb8SKkA9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784107373; c=relaxed/simple;
	bh=CVcZzAXEg5AQNn1Q2SUlbxYxKW4xgc0u+95fNoEXqwE=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=FbiInSoXt5ItMjK8epUGMaZiyCp3MV9MvLEOSH9p3eiv12y+wrFpn4YewKInkkah4zXynCw0wgCBgZO6n7gdt6pVgr+EIMlmZvteY9Oz4Y3Qi0vGqJod8QV3hm2A5gvF4AA/FJPqD5mmSc9X7If7DffkkF9eIywJBkFAJiBtAIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=infineon.com; spf=pass smtp.mailfrom=infineon.com; dkim=pass (1024-bit key) header.d=infineon.com header.i=@infineon.com header.b=dqMG1d4g; arc=none smtp.client-ip=217.10.52.105
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=infineon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infineon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=infineon.com header.i=@infineon.com header.b="dqMG1d4g"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=infineon.com; i=@infineon.com; q=dns/txt; s=IFXMAIL;
  t=1784107368; x=1815643368;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=CVcZzAXEg5AQNn1Q2SUlbxYxKW4xgc0u+95fNoEXqwE=;
  b=dqMG1d4gJKa+LDtE6tbqKfbq3kBFhoWjmAGR+RryQWCteLlFLBWIpGQW
   TYSdAMQ8LfdELNqhDok1grnB4+dld+GokVBWvHBiWDWNo3GsxtwUcJuKi
   6r5sZIDhFzQ/bAwGz8zQF7VZHhbtWv4Rg//yyQQJdYFA6ZPn2a6E8bLOl
   8=;
X-CSE-ConnectionGUID: iGc+MqDoTRmZj1ywcobxwg==
X-CSE-MsgGUID: NQFGeLNFQ/6P7imSqHQ86A==
X-IronPort-AV: E=McAfee;i="6800,10657,11847"; a="151709897"
X-IronPort-AV: E=Sophos;i="6.25,165,1779141600"; 
   d="scan'208";a="151709897"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO MUCSE819.infineon.com) ([172.23.29.45])
  by smtp11.infineon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Jul 2026 11:22:40 +0200
Received: from MUCSE809.infineon.com (172.23.29.35) by MUCSE819.infineon.com
 (172.23.29.45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.43; Wed, 15 Jul
 2026 11:22:40 +0200
Received: from ISCN5CG5251XQT.infineon.com (10.161.6.196) by
 MUCSE809.infineon.com (172.23.29.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 15 Jul 2026 11:22:37 +0200
Date: Wed, 15 Jul 2026 17:22:29 +0800
From: HungTsung Huang <Jason.Huang2@infineon.com>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
CC: <linux-wireless@vger.kernel.org>, <brcm80211@lists.linux.dev>,
	<brcm80211-dev-list.pdl@broadcom.com>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v4] wifi: brcmfmac: add DPP support
Message-ID: <20260715092229.GA667683@ISCN5CG5251XQT.infineon.com>
References: <20260708071230.312836-1-Jason.Huang2@infineon.com>
 <20260712223314.2182929-1-arend.vanspriel@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20260712223314.2182929-1-arend.vanspriel@broadcom.com>
X-ClientProxiedBy: MUCSE808.infineon.com (172.23.29.34) To
 MUCSE809.infineon.com (172.23.29.35)

Hi Arend,

Thanks for the clarification.

Could you please confirm whether it is OK to submit the standalone P2P fix
to wireless in parallel to wireless-next origin/main? My understanding is
that the P2P fix does not need to wait for the DPP support patch to be
accepted, since it fixes pre-existing bugs and the DPP patch no longer
depends on it.

The reason I added:
> > +         p2p->bss_idx[P2PAPI_BSSCFG_DEVICE].vif &&
> >           p2p->bss_idx[P2PAPI_BSSCFG_DEVICE].vif->saved_ie.probe_req_ie_len) {

was that DPP public action frames can be sent through the primary interface
without a P2P device vif being created. The existing peer channel search path
assumed the P2P device vif was always available before accessing saved
Probe Request IEs, which could dereference a NULL vif in that case. However,
I agree this is a pre-existing P2P bug rather than part of DPP support, so I
moved it into the standalone P2P fix patch.

Regards,
Jason
