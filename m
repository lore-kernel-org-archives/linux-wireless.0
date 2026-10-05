Received: from mail-139-mta249.mxyeet.net (mail-139-mta249.mxyeet.net [23.172.139.249])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0197049C4D8
	for <linux-wireless@vger.kernel.org>; Mon,  5 Oct 2026 14:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=23.172.139.249
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791209613; cv=none; b=ndu4gHAyshViPn2hRDsE2eQX85O5n2kxMBaSRPCVIRRQuowUYrm34e4NXGsHuZM1ogeY6F0nyIzI9DsdsiJXxkFQLuqSdX1z2neNsy5MKMbkunJmVXnaYEx7jxTop2ZMgqyCg6CVbuKhKyOfvj1jzNbD6VvV9SVbbtoAj6G+AmM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791209613; c=relaxed/simple;
	bh=bXP2gsPKInS3wxEiRyHL64d/IyuhIOqfNGcm9LumHTk=;
	h=MIME-Version:Date:From:To:Cc:Subject:In-Reply-To:References:
	 Message-ID:Content-Type; b=FM42nyUWXqPR6CrA4hzv5RWOIawFxQcLVCZMysrzerQaq4m8uaELLm5UFSFmoEgBcV5ZxxCtG/8Er1j1HPQz/MOK/JgmCFImZfU+okavUryrpLvnS+O4+86Iq2q78HWcomWp6Sf7Rt8We7+IGKENj+tYsSl7D6GOvRvvfGMY3VE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=endrik.dev; spf=pass smtp.mailfrom=endrik.dev; dkim=pass (2048-bit key) header.d=endrik.dev header.i=@endrik.dev header.b=ps608y4H; arc=none smtp.client-ip=23.172.139.249
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=endrik.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=endrik.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=endrik.dev header.i=@endrik.dev header.b="ps608y4H"
Received: from lu-shared04.cpanelplatform.com [2602:faa9:3000::1006] (Authenticated sender: relay@mxyeet.net)
 by mail-139-mta249.mxyeet.net (MailFilter Outbound) with ESMTPSA id 1a10c64c76900089d7.002
 for <linux-wireless@vger.kernel.org>
 (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384);
 Mon, 05 Oct 2026 14:08:13 +0000
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=endrik.dev;
	s=default; h=Content-Transfer-Encoding:Content-Type:Message-ID:References:
	In-Reply-To:Subject:Cc:To:From:Date:MIME-Version:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Unsubscribe-Post:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=tx3Yyu7EF76UxqlyUCyryECBr1KTcBsd0J+ccOAf8Yk=; b=ps608y4HhMrmhuFVL3TB8eycQF
	Ed40sDquQKudRnUFH/vYsFROYzGzQUgyCnfZkU5AZDbp5Hlf7Lo1O76Y5VNbd9GNCtkPMtMiTxGY1
	zxMfggJXFju/HAdmNidqkC3COC/sm844mNr9ZHRRo+dObGNWOgybc+w8siVM+suBWZnIa4dM5Im0Y
	SiMA6RCP+szT06qwvG8Oleqj6PnVRkQAK4iilaCzeAlPX3gXWLYUB7t/HD1cbkgjNiy0toVatiDRl
	7ZzqO49Vl2276zXm4qzY+bZDQ/V3T64KZ2XlOyTGBR9ULfrxelGLyf3Ji8Yv0iaVZ5ux2Ko14yaVz
	6istlqIw==;
Received: from [::1] (port=41434 helo=lu-shared04.cpanelplatform.com)
	by lu-shared04.cpanelplatform.com with esmtpa (Exim 4.100.1)
	(envelope-from <git@endrik.dev>)
	id 1xDjMR-00000002mNC-3l8V;
	Mon, 05 Oct 2026 16:08:11 +0200
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Mon, 05 Oct 2026 16:08:11 +0200
From: git@endrik.dev
To: "Korenblit, Miriam Rachel" <miriam.rachel.korenblit@intel.com>
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, git@endrik.dev
Subject: Re: [PATCH] wifi: iwlwifi: mld: include VI packets in low latency
 detection
In-Reply-To: <IA3PR11MB7213134F2D0E081A853C7A06A6A3962@IA3PR11MB721313.namprd11.prod.outlook.com>
References: <20261004214438.128694-1-git@endrik.dev>
 <IA3PR11MB7213134F2D0E081A853C7A06A6A3962@IA3PR11MB721313.namprd11.prod.outlook.com>
User-Agent: Roundcube Webmail/1.6.19
Message-ID: <173121002b0895ac0b12bd3cbae3b78b@endrik.dev>
X-Sender: git@endrik.dev
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-From-Rewrite: unmodified, there is a forwarder that points to the actual sender.
X-AuthUser: endrik@endrik.dev
X-NCN-Id: qrBpiUCfTMOkjygEbw==

> I don't want to rely on the value of the different enums too much.
> Let's be explicit:
> return tid_to_mac80211_ac[tid]  == IEEE80211_AC_VI ||
>             tid_to_mac80211_ac[tid]  == IEEE80211_AC_VO

Hey,

I actually considered that initially, but as a kernel newbie,
I thought a minimal patch would result in less hassle for reviewers.

A v2 with the explicit comparison is coming shortly.

Thanks,
Endrik
