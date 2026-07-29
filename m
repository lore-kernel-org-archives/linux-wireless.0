Received: from smtp11.infineon.com (smtp11.infineon.com [217.10.52.105])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17BD9481250;
	Wed, 29 Jul 2026 12:08:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.10.52.105
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785326927; cv=none; b=UDwT9bVkaIr3NTRPOLiThUFLFTG/N7mUQsoNclRrKl1WWCZJ9oFCLPlpaZ3ZQTIEgix7YJusnxjyQl2BosKsn9CgElJMiiNCRgEnQ9gbywYDfElyi4i7loRHWF0OndhEszNknyFaYCyWZn7ux/xGTMRtHSghNLwEPqCZ/BKi/5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785326927; c=relaxed/simple;
	bh=kh+7Z94S3OLyBoF/uGlwBQC0SNaC+dBanj5N8l7BpWQ=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AGspoGiKU7DfSm6V1GmemkeRqVutlaB/8e5ih6Yfm4FVHlHzA4My5652i2O0YK81Vm5/yqHX8hHerk5l10o1JWHqPPn3y7Pms6vTKzxHd1H+bdH3d3OT2ulMZ66TIFfVxPlOmC7WNsN7xs+Y9F8pFpW8SeQ1+6P/1DpXAI2Bw68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=infineon.com; spf=pass smtp.mailfrom=infineon.com; dkim=pass (1024-bit key) header.d=infineon.com header.i=@infineon.com header.b=lsuAAATl; arc=none smtp.client-ip=217.10.52.105
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=infineon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infineon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=infineon.com header.i=@infineon.com header.b="lsuAAATl"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=infineon.com; i=@infineon.com; q=dns/txt; s=IFXMAIL;
  t=1785326925; x=1816862925;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=kh+7Z94S3OLyBoF/uGlwBQC0SNaC+dBanj5N8l7BpWQ=;
  b=lsuAAATlI6bUsctpGU57bTNxdNwOPufebZ+A8rmq/GEZjixePC1+28Ov
   K9R75bdEpLZHbQ0ttgpVxFIfhBKsUB7C0DbC2jOQePa0Bo8kODqSe0ZkD
   o+BCUgKm1mz8VkIvlY8WyAMQp/YUht69RsxfwSqssILqxrNufcR24REXV
   4=;
X-CSE-ConnectionGUID: tGhkPrr8QiCKj29WQdpRYg==
X-CSE-MsgGUID: w0z0dvmETG+MDooFSQcNVg==
X-IronPort-AV: E=McAfee;i="6800,10657,11859"; a="153663146"
X-IronPort-AV: E=Sophos;i="6.25,192,1779141600"; 
   d="scan'208";a="153663146"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO MUCSE822.infineon.com) ([172.23.29.53])
  by smtp11.infineon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jul 2026 14:07:34 +0200
Received: from MUCSE827.infineon.com (172.23.29.20) by MUCSE822.infineon.com
 (172.23.29.53) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Wed, 29 Jul
 2026 14:07:34 +0200
Received: from ISCN5CG54722ST.infineon.com (10.161.6.196) by
 MUCSE827.infineon.com (172.23.29.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Wed, 29 Jul 2026 14:07:32 +0200
Date: Wed, 29 Jul 2026 12:07:09 +0000
From: Gokul Sivakumar <gokulkumar.sivakumar@infineon.com>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
CC: Bogdan Nicolae <bogdan.nicolae@gmail.com>,
	<linux-wireless@vger.kernel.org>, <brcm80211@lists.linux.dev>,
	<brcm80211-dev-list.pdl@broadcom.com>, <linux-kernel@vger.kernel.org>,
	<wlan-kernel-dev-list@infineon.com>
Subject: Re: [PATCH] wifi: brcmfmac: configure SAE PWE method for external
 SAE AP
Message-ID: <7jvxg3jlrsxs4sy2pysyrtwzvczxjczeaxa5xzdojk27vcmrc6@bvaar7uqofby>
References: <20260729053408.13715-1-bogdan.nicolae@gmail.com>
 <5cf57b2d-2bcc-481c-87bf-3a034d5f99be@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <5cf57b2d-2bcc-481c-87bf-3a034d5f99be@broadcom.com>
X-ClientProxiedBy: MUCSE817.infineon.com (172.23.29.43) To
 MUCSE827.infineon.com (172.23.29.20)

On 07/29, Arend van Spriel wrote:
> On 29/07/2026 07:34, Bogdan Nicolae wrote:
> > When bringing up a WPA3-SAE SoftAP with external (user space) SAE, the
> > driver never told the firmware which SAE Password Element (PWE) method to
> > accept. The firmware was observed to corrupt its heap over time due to
> > this omission, leading to firmware trap (data abort in heap allocator).
> > 
> > Parse the beacon IEs on start_ap() and set the extsae_pwe iovar
> > accordingly: 2 when the RSNX IE advertises H2E, 1 when an H2E-only
> > membership selector is present, 0 otherwise. This matches the behaviour
> > of the upstream/vendor driver and only applies to SAE-capable APs when
> > external SAE is supported.
> 
> This makes sense, but may I ask what device do you have? Suspect it is a
> Cypress/Infineon chip. I could not find the iovar in our (Broadcom bca)
> code base so I suspect it is vendor specific.

Arend, yes, this an Infineon vendor specific Firmware IOVAR. Seems like
he got the patch from Infineon's downstream brcmfmac github and applied
it on upstream brcmfmac driver as it is with minor changes.

Bogdan, from Infineon we are currently working on a patch to adopt our
"extsae_pwe" vendor changes for the upstream brcmfmac driver. Because it
can't be applied as it is on upstream brcmfmac without affecting other
firmware vendors.

We will submit our "extsae_pwe" patch for upstream review in a few days.
Kindly wait.

Regards,
Gokul
