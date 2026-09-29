Received: from smtpcmd03117.aruba.it (smtpcmd03117.aruba.it [62.149.158.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0439392828
	for <linux-wireless@vger.kernel.org>; Tue, 29 Sep 2026 08:08:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=62.149.158.117
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790669340; cv=none; b=MiDXG57eB+Yhjoaf0vQbu0vnNzwV5YNpAW2XeD8qBuEOIgsQ/v1RNh7J2wBtY1CZldWcya/NCVpENiZNbxJM1m7dBkQjNoAMMz2jzk606ZDd1WxWj5fmLQf/KdtBWjLDXxcyQZYF2402yGI3S3Y1aPiRhE9kr/YId2gIG+nzMoE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790669340; c=relaxed/simple;
	bh=WBwLXXMWAqto5FiNVxRkG8uGQgX93DlHOiZDhOkJpX4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nm1ddBQm6LUd+CNdWaaXLVy7IMfJxc2u4ZyShK8druFSvl4Z0g0GrnF/O4E7YtLabOJCaAbbKnuZbrVSa3HpYP+u4lJSRZwaY3gtQwjGtB3EfX3oE64hbw83Sw6O8LbRGDXbZSBBE3E+bpRKTzA5vQZrozbmLObOljFErxOedoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mythread.it; spf=pass smtp.mailfrom=mythread.it; dkim=pass (2048-bit key) header.d=mythread.it header.i=@mythread.it header.b=PoDrs8I+; arc=none smtp.client-ip=62.149.158.117
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mythread.it
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=mythread.it
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=mythread.it header.i=@mythread.it header.b="PoDrs8I+"
Received: from DELL-MOBILE03.ad.smart.it ([77.89.54.34])
	by Aruba SMTP with ESMTPSA
	id BSqPxUZ0gdVTCBSqPxzae1; Tue, 29 Sep 2026 10:05:46 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mythread.it; s=a1;
	t=1790669146; bh=WBwLXXMWAqto5FiNVxRkG8uGQgX93DlHOiZDhOkJpX4=;
	h=Date:From:To:Subject:MIME-Version:Content-Type;
	b=PoDrs8I+PjWveRXWS63dmFrP7kxo2UzcmCxf/R2Udj/I9CzWnTu9DcdLTBi33ln0e
	 XH2x/YsvShgnHoxncpB9AkXoSV4cLkFiy5oGDha/ekZR98qFas6jXov+N9EkxApSGS
	 iLN+IGBE0NNNRqMwTscTeVJWNsKjmJ+J7JnPnoJKIYpboK2QdUd+2IUpSzvj+w48gL
	 DuSBKNEDgf3mpY7hDW5CW43UqUarzJVr8s255VnF957UkJkd7uPhg3jpFSKpjRxVLr
	 geaI8ZiQqDE0RlITW2HkDmi8ZVywS0IeLU5NyBuQmnEPzkFO/Vc3Ol/lRYNNRgcbCM
	 OOEi+zG01+Zpg==
Date: Tue, 29 Sep 2026 10:05:44 +0200
From: Alessio Ferri <alessio.ferri@mythread.it>
To: "andreas.wendleder" <andreas.wendleder@proton.me>
Cc: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>, "b43-dev@lists.infradead.org"
 <b43-dev@lists.infradead.org>, "linux-wireless@vger.kernel.org"
 <linux-wireless@vger.kernel.org>
Subject: Re: BCM4360 AC-PHY support for b43 =?UTF-8?B?4oCU?=
 reverse-engineered, seeking guidance on a clean path upstream
Message-ID: <20260929100544.343ce6d2@DELL-MOBILE03.ad.smart.it>
In-Reply-To: <hCBGuqVmDlV3Y7f2t6L8DtnoyBNbC8KghHXm0fZCHLDLrtfaoYw9e0UcCCsQHHK1X4TBz0DuvSL4zmAx_dVS3q54BZ0JZXtjXXNnuSAFtyo=@proton.me>
References: <rOzY3WnW4q5L1osv7iagU81dLGldzZEsu3EqHxmH4d7Z4vxubBYvRNT0vsrbr8n-CUSEYyXxGFE3h9PHLHgePjm3_rMK_B_0m5loTpyxX-M=@proton.me>
	<ih-lXs5OlHxMhydtcZFtKNhGg3cGlR137CEMZ07_zFQcfCYAImW6MRWPDjkdwy-xK9bIwpDK9ImgerqHmQMsAxX3ckEjsiN8QoCSlpvIsSM=@proton.me>
	<20260928200309.01a36f5e@barney>
	<DL5AS1oidqGRAmMHt0Jcp3X4T3ob_Fa-lfhTmMMak3ATUnfcyETDn65CQf3iLvVeg4ExYoc_0GW7QMoaB1jEW4nzKAKFDv8bD0hqBEtkUKg=@proton.me>
	<20260929081403.6076a6da@barney>
	<20260929093405.79d9f4ec@DELL-MOBILE03.ad.smart.it>
	<hCBGuqVmDlV3Y7f2t6L8DtnoyBNbC8KghHXm0fZCHLDLrtfaoYw9e0UcCCsQHHK1X4TBz0DuvSL4zmAx_dVS3q54BZ0JZXtjXXNnuSAFtyo=@proton.me>
X-Mailer: Claws Mail 4.2.0 (GTK 3.24.41; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-CMAE-Envelope: MS4xfOiC0NiK3rNAf/cRxmU9pacGEzOtuHhVmgKEtaCvet96LBC7MOf14DhSlqDB6mwZh9LYJ11pELuIARQYYPzSHOu34Kbh4mV3Dh5HILViTD88yIvWTlDX
 Lu+lEbNoC79BCMnXQfdcYH7QhZLT0IVeTCWE7vrNRUhhMnRkW9fFTGvnPz9ZJColWohKMTyvp8zM3VZJpSTKCxITXJ64UVNVr5pOI698Q267J0knn2voZT6J
 IOFsSzIoreTreqFVvE+Ot1U3kyQ7GF/VG0CRpMDq858HTyarCIczgTn3/P7f/vJ9n9IharROmj3wly0x+CVLLQ==

On Tue, 29 Sep 2026 07:49:35 +0000
"andreas.wendleder" <andreas.wendleder@proton.me> wrote:

> > > Maybe we can find somebody doing an AI implementation from specs.
> > > But then, why not publish yours instead?
> > >  
> > 
> > I'm still working on my driver for 4352/4360, so two of us
> > actually.  
> 
> Cool. Does it work? What does work?
> 
> So how do we proceed from here? I'm in the dirty room. :)
>  

At the moment i have to retry it on hardware, last time it crashed
because mac writes were incomplete, it is 5Ghz only because i have only
routers with no 2.4GHz antennas for the 4352/4360. It is based on the
7.14.89 broadcom driver and ucode rev42 ver 928. Also, all my routers
have femctrl = 6 from the srom, so i don't know what to do when the
value is different. Least, but not last, the wl order of macro operation
and b43 order are different in multiple places, how did you reconcile
the two?
