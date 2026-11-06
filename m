Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=178.21.23.139
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793926743;
	b=oIxFo0petJSJEfBhMvA5b0PcRyzCVJ3zIl3R891CSte+7pr+XD9yLVUdMyzLL3kYvipi
	 g+yvsdTcSRdC1d8NqN9H6Ur9FL4TjLzu/74ivtfI75w+U3LBCHjnL2UMuWOp7FalHgvGf
	 CCpqNBB4M7mgmQKcFGoRfxYM8RXImExsZeZrOG+azrl6aN22nLbz80qinI01m8t6Q7P6w
	 KVEDeczsTadnZcJq9K8qiQyuOEwx3M9hlByrcrcBHgXbdLXBU5bADxx2YCX1ED2CGkxNO
	 0uNJUOZEK9VRFsEAlvT+2J+75WftJRDGbSx9GF/kWlzpYnGCa/vXOufIIPe9nQCJppw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793926743;
	h=DMARC-Filter:Received:X-Virus-Scanned:Received:DKIM-Signature:
	 Message-ID:Subject:From:To:Cc:In-Reply-To:References:Content-Type:
	 Content-Transfer-Encoding:Date:MIME-Version:User-Agent;
	bh=goHBFdJc1I9ikTvKKpUhfylXuKu9IMDZPMyzXqJcLXE=;
	b=2hRHndfFEHWsIKkqrFwVhOgwHILKgIQbe8QtHCiEc6BiaRNYFpwmKoglTLqdgPBk8EB5
	 xW6JJ7qU/KmRe5Q1ZLsRVZPIx2KZUOGeEhQxAfOEeaGYq7gbxzEWz2s+o4ksuSmm8liqw
	 eYHkYhXQeWkSYluKga+iPSrTOdb4VKDNEjPGhrTyk905/eoUNybKPxHsA+95i7naV0StK
	 XF3NMTf4eQF15shg0+1VFX2AWutlrXguJVDOBCnX2t220XtJk0U74gyzFUKUZiA73fLeX
	 22ItEw26uV2vpG/5fkbjWxnTMdmCPGlxVfrvgYaqPa5wAHxVxF7TaLwP+xZ1C8uPgWQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=disroot.org;
	spf=pass smtp.mailfrom=disroot.org;
	dkim=pass header.d=disroot.org header.i=@disroot.org header.a=rsa-sha256 header.s=mail header.b="hLcm/KUT";
	arc=none smtp.remote-ip=178.21.23.139
Received: from layka.disroot.org (layka.disroot.org [178.21.23.139])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85A52606A31B;
	Fri,  6 Nov 2026 00:59:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 85A52606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=disroot.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=disroot.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=disroot.org header.i=@disroot.org header.a=rsa-sha256 header.s=mail header.b=hLcm/KUT
Received: from mail01.layka.lan (localhost [127.0.0.1])
	by disroot.org (Postfix) with ESMTP id 588C680A47;
	Fri, 06 Nov 2026 01:59:00 +0100 (CET)
X-Virus-Scanned: SPAM Filter at disroot.org
Received: from layka.disroot.org ([127.0.0.1])
 by localhost (disroot.org [127.0.0.1]) (amavis, port 10024) with ESMTP
 id XY4Jum9Sge5i; Fri,  6 Nov 2026 01:58:59 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=disroot.org; s=mail;
	t=1793926739; bh=goHBFdJc1I9ikTvKKpUhfylXuKu9IMDZPMyzXqJcLXE=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=hLcm/KUTmXhQ2QVfnCgFQYStkpwmmGPaQz6OruRIJIoAv189GbkQsXh/jQrER1eTB
	 KRwSuBXoQws5gVBiJ7zuFhXqdk6pkVa4XHHQdco7gqKCs8uo7IOAKIzv5fpuaogYuH
	 m/AtA+bA9OtE49IOQaokNqSlBQoGxp741Seo16Ws/BM2pfHfNOF4ie6PO76q89RLyH
	 GYGF6GNMgwNmvajnUtRE+3I1VU/AsPJENCcW0pKHhfJugWXE6odL6DmGp6uPlKr1w2
	 AxDGPr2TSSf6YkSxRwbinvdI7DYzQwKW0CHvSIdvN5YK4YkbpZ2KjqkQs6+5c1Os1b
	 aH8KxuuUwAqeQ==
Message-ID: <2ed89d0f0114df0dc798dcc7dd1a6a4bd2d1fb7e.camel@disroot.org>
Subject: Re: [PATCH ath-next v2 0/5] wifi: ath11k: firmware crash recovery
 fixes
From: Florian Maurer <fmaurer@disroot.org>
To: Julius Bairaktaris <julius@bairaktaris.de>
Cc: Jeff Johnson <jjohnson@kernel.org>, ath11k@lists.infradead.org, 
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, Baochen Qiang
	 <baochen.qiang@oss.qualcomm.com>, Vasanthakumar Thiagarajan	
 <vasanthakumar.thiagarajan@oss.qualcomm.com>, Rameshkumar Sundaram	
 <rameshkumar.sundaram@oss.qualcomm.com>, P Praneesh	
 <praneesh.p@oss.qualcomm.com>, Kalle Valo <kvalo@kernel.org>, Muhammad
 Usama Anjum <usama.anjum@arm.com>, John Crispin <john@phrozen.org>, Sriram
 R	 <sriram.ramachandran@oss.qualcomm.com>
In-Reply-To: <20261101164716.302826-1-julius@bairaktaris.de>
References: <20261018210153.1925962-1-julius@bairaktaris.de>
	 <20261101131550.1890062-1-fmaurer@disroot.org>
	 <20261101164716.302826-1-julius@bairaktaris.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Date: Fri, 06 Nov 2026 01:58:58 +0100
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Evolution 3.56.2-0+deb13u1 

Hi Julius,

On Sun, 2026-11-01 at 17:47 +0100, Julius Bairaktaris wrote:
> I will run your crash 10-20 ms after "is now up" against v3 on my
> AX3600 and post it with your three patches on top as one series, with
> your From: and Signed-off-by kept and your Tested-by on my five. Is
> that fine with you?
>=20

Yes, sure - thanks! I'll also test this again as needed.

Thanks,
Florian
