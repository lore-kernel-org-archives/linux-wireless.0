Received: from smtp11.infineon.com (smtp11.infineon.com [217.10.52.105])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 361053242BC;
	Mon, 10 Aug 2026 05:26:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.10.52.105
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786339585; cv=none; b=PNcNpiy4eMyL/yvLYTHUlP7e7fGtfnMjCmm6vPAYvE6P+firGxQJNLEpoDY1iHxZ0GUywl0miIrcvGKZPs9czcDxbu7HYj+e/IvGwP2D6343FGjYE/hGV7U23qjJDA1YYiwykeaENe/7b8t1Q3MsRkLUc1exaYznv08TTA+e3gM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786339585; c=relaxed/simple;
	bh=WIWq/QsyZwrnIkfQnJiztVNlAjrze/SlDchywtFuGyY=;
	h=Date:From:To:CC:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tLyywi0bS1bQRsytLQgW0kHDMpcQoCNZ2kR8IFpn8L9qaFww2Noah8Seg7kyPOb6Sh6inAAbWUlwFrZJS1BWJbrhtHG3Lmekl81oWtJL0P66nw1ds3KHNvlTNYyYgzr/lqSAQN7miG6Qdpbq2yzQ5uUgUuF+U7v0EKjKtu3w0vo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=infineon.com; spf=pass smtp.mailfrom=infineon.com; dkim=pass (1024-bit key) header.d=infineon.com header.i=@infineon.com header.b=bMxFLszs; arc=none smtp.client-ip=217.10.52.105
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=infineon.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=infineon.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=infineon.com header.i=@infineon.com header.b="bMxFLszs"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=infineon.com; i=@infineon.com; q=dns/txt; s=IFXMAIL;
  t=1786339584; x=1817875584;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=WIWq/QsyZwrnIkfQnJiztVNlAjrze/SlDchywtFuGyY=;
  b=bMxFLszsS4OXorAv8W4UF1qq8Zk2U1IkyWAu+X06KTCG89/LO1Zh42/e
   uZgtgq4ICp7HTEsxMCDY3FijuHcxR9+HyhlM7m8dWv2GUJc8fREQYRyGl
   RbBUYduOrpiwCvoEjrYOgPIhGKi2zXA+pxcCidoE6Q9Co4gqgwcAUWuym
   o=;
X-CSE-ConnectionGUID: ArB9bjEqST22m+2rgXT3VQ==
X-CSE-MsgGUID: c/5th761RDuLkOi/abQMWg==
X-IronPort-AV: E=McAfee;i="6800,10657,11870"; a="155213232"
X-IronPort-AV: E=Sophos;i="6.25,215,1779141600"; 
   d="scan'208";a="155213232"
X-Amp-Result: SKIPPED(no attachment in message)
Received: from unknown (HELO MUCSE814.infineon.com) ([172.23.29.40])
  by smtp11.infineon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2026 07:26:16 +0200
Received: from MUCSE827.infineon.com (172.23.29.20) by MUCSE814.infineon.com
 (172.23.29.40) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.45; Mon, 10 Aug
 2026 07:26:15 +0200
Received: from ISCN5CG54722ST.infineon.com (10.161.6.196) by
 MUCSE827.infineon.com (172.23.29.20) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.45; Mon, 10 Aug 2026 07:26:13 +0200
Date: Mon, 10 Aug 2026 05:26:06 +0000
From: Gokul Sivakumar <gokulkumar.sivakumar@infineon.com>
To: Bogdan Nicolae <bogdan.nicolae@gmail.com>
CC: Arend van Spriel <arend.vanspriel@broadcom.com>,
	<linux-wireless@vger.kernel.org>, <brcm80211@lists.linux.dev>,
	<brcm80211-dev-list.pdl@broadcom.com>, <linux-kernel@vger.kernel.org>,
	<wlan-kernel-dev-list@infineon.com>
Subject: Re: [PATCH] wifi: brcmfmac: configure SAE PWE method for external
 SAE AP
Message-ID: <anlg7rijoaF4fCfr@ISCN5CG54722ST.infineon.com>
References: <20260729053408.13715-1-bogdan.nicolae@gmail.com>
 <20260802083905.3819981-8-arend.vanspriel@broadcom.com>
 <CA+ORkNSS1dOdUK51B0Q1r2Htc5NpP-=EmE4FO6=4rX5CUU_FpA@mail.gmail.com>
 <19fdfd09e38.2873.9b12b7fc0a3841636cfb5e919b41b954@broadcom.com>
 <CA+ORkNQXRKVzi1NN9+YmsQ26dQNNMMu=uBZQ7msQTDG_CtUP3w@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CA+ORkNQXRKVzi1NN9+YmsQ26dQNNMMu=uBZQ7msQTDG_CtUP3w@mail.gmail.com>
X-ClientProxiedBy: MUCSE819.infineon.com (172.23.29.45) To
 MUCSE827.infineon.com (172.23.29.20)

On 08/08, Bogdan Nicolae wrote:
> On Sat, Aug 8, 2026 at 12:20 AM Arend van Spriel
> <arend.vanspriel@broadcom.com> wrote:
> >
> > Op 8 augustus 2026 02:00:22 schreef Bogdan Nicolae <bogdan.nicolae@gmail.com>:
> >
> > > Gokul (representing Infineon) promised he would send a patch a while back.
> > > This would be a preferred solution as it comes directly from the vendor.
> > > But it also takes time. I can send a revised patch next week.
> >
> > Yeah. With Johannes being on vacation I say we can give Infineon bit more
> > time to provide their patch.
> 
> Sounds good, Arend. Gokul, I'm available to test/collaborate, just let me know.

Sure, we will send the Infineon patchset for review within few days.

Regards,
Gokul
