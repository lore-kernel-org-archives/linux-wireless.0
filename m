Received: from smtp11.infineon.com (smtp11.infineon.com [217.10.52.105])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFD16366061;
	Mon, 24 Aug 2026 03:08:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.10.52.105
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787540904; cv=none; b=oZqPmwclccWWVNb6v4MfkdCPVO4PEa8Ltom0Sv1X3oKdGz1tARBlS7ksR6IMDTQE8cG1iowwd0Hww4kqg33XPdaUVF6QvVA7S8Ke+2EpnhxoLwc9ZjAGYPgnr4fmJdJB3p53ZYy0Pe5s3pf7M5pMI0V4CiS6++khmBGfnCiP7iw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787540904; c=relaxed/simple;
	bh=OU6ZgFXRcEUyBCv+EJJfs2AERU7/oxIMIkQvo+Coby4=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eHKAJOAve+dwNipjBRl3DcMv3vOtdLtZkrkhxSIP8YoMKK9kHfc7rFIhvqK+1zIOzfkjgY18HC7JOW8AwfwWv8JtEcKO9CQTzr+akhT6GC9tWlgFGOjd/IbMn+x0BAi7zwe/tZWBXgL2sliY4oNNNOmqBeDyUQuaMmLEkup/kuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=infineon.com; spf=pass smtp.mailfrom=infineon.com; dkim=pass (1024-bit key) header.d=infineon.com header.i=@infineon.com header.b=PdfFShm5; arc=none smtp.client-ip=217.10.52.105
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=infineon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infineon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=infineon.com header.i=@infineon.com header.b="PdfFShm5"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=infineon.com; i=@infineon.com; q=dns/txt; s=IFXMAIL;
  t=1787540903; x=1819076903;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=OU6ZgFXRcEUyBCv+EJJfs2AERU7/oxIMIkQvo+Coby4=;
  b=PdfFShm5I1hdhwk+WfI3jTeQkVkKM8og3AcWvnBBp2DcuecoXxmQzTax
   PMJBuwn2xrE4YGU4avcc8pADFsUj6Urv4Fa6r6qPapnXbGnP5AFLANDD3
   aGQeeNBoUuqJediPhMD+eH1mW3qbXWn4eSVi8fgJDgbOKUFLDafDAyBZt
   M=;
X-CSE-ConnectionGUID: BLTwLGeTTNyhunk0pD+3qg==
X-CSE-MsgGUID: AG/XS9MWTBS8PQmAcsFnkg==
X-IronPort-AV: E=McAfee;i="6800,10657,11884"; a="157231319"
X-IronPort-AV: E=Sophos;i="6.25,239,1779141600"; 
   d="scan'208";a="157231319"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO MUCSE819.infineon.com) ([172.23.29.45])
  by smtp11.infineon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2026 05:08:20 +0200
Received: from MUCSE809.infineon.com (172.23.29.35) by MUCSE819.infineon.com
 (172.23.29.45) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.46; Mon, 24 Aug
 2026 05:08:19 +0200
Received: from ISCN5CG5251XQT.infineon.com (10.161.6.196) by
 MUCSE809.infineon.com (172.23.29.35) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.46; Mon, 24 Aug 2026 05:08:15 +0200
Date: Mon, 24 Aug 2026 11:08:06 +0800
From: HungTsung Huang <Jason.Huang2@infineon.com>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
CC: <linux-wireless@vger.kernel.org>, <johannes.berg@intel.com>,
	<johannes@sipsolutions.net>, <hsin-hung.li@cypress.com>,
	<linux-kernel@vger.kernel.org>, <brcm80211@lists.linux.dev>,
	<brcm80211-dev-list.pdl@broadcom.com>, <wlan-kernel-dev-list@infineon.com>,
	<jeff.johnson@oss.qualcomm.com>, Carella Chen <carella.chen@infineon.com>
Subject: Re: [PATCH v5 0/5] brcmfmac: add FT/OKC roaming offload support
Message-ID: <20260824030806.GA468784@ISCN5CG5251XQT.infineon.com>
References: <20260821-upstream-wireless-next-main-jason-11r-support-v1-v5-0-eeab4fda0f31@infineon.com>
 <71261493-e974-4f5c-a453-b4c2e449baf5@broadcom.com>
 <cbb4b486-c7db-4687-a08c-1b1486583d32@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <cbb4b486-c7db-4687-a08c-1b1486583d32@broadcom.com>
X-ClientProxiedBy: MUCSE824.infineon.com (172.23.29.55) To
 MUCSE809.infineon.com (172.23.29.35)

Hi Arend,

On Sat, Aug 22, 2026 at 08:26:52PM +0200, Arend van Spriel wrote:
> > Thanks for the follow-up, but looks like it happened again. Missing
> > patch 5/5 as happened with v3 series.
> I do have other comment(s) for v5 series, but feel free to send the
> missing patch so I can review that in one go.

Thanks for pointing this out, and sorry for the noise.

This seems to be an issue with our SMTP / mail gateway. I will make sure
we verify that all patches are successfully received in Patchwork for
future submissions.

I have re-sent patch 5/5, threaded to the original v5 cover letter:
https://patchwork.kernel.org/project/linux-wireless/patch/20260824022735.468599-1-Jason.Huang2@infineon.com/

Thank you.
