Received: from mail1.manjaro.org (mail1.manjaro.org [142.132.176.110])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DC33226D18
	for <linux-wireless@vger.kernel.org>; Sun, 22 Mar 2026 08:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=142.132.176.110
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774167306; cv=none; b=FlvRm72bN5cLRk50eO/hSBGITHKToBcNyx2NRX9muUL3eNeze5dXCF4fO+4x9N60sahHDpPi8Uh8hb3MY2ZLlhRatSRDVl7f9vOUQRSWS05W8ozxDz5DgLZU4FEZnUo3Qgub3f/DVxMCFw0tO7EdyXotn//0ho0SeFBTqlI6Tug=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774167306; c=relaxed/simple;
	bh=1OWRApit93tDm/8Q0QbeYs24eCd9hjS1a55cen2hKHE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=H7ZKb/PA+8oL34qKOYxt0rMS2gauYNqGf3bEM3FHb/HgrkCJ+lB6DEp7EMDiC43mUCjtha5Usxby30O9jhm924uAYHyVLwaDws+d62kjPL2NLnVBn36nEdYvaNRB9A8jTOJzcg/F6D6yyBtLl8qB+5IZirJGW7ul2/OeWuPkess=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manjaro.org; spf=pass smtp.mailfrom=manjaro.org; dkim=pass (2048-bit key) header.d=manjaro.org header.i=@manjaro.org header.b=aIffeeDz; arc=none smtp.client-ip=142.132.176.110
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=manjaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=manjaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=manjaro.org header.i=@manjaro.org header.b="aIffeeDz"
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 92697422AA;
	Sun, 22 Mar 2026 09:04:57 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=manjaro.org; s=dkim;
	t=1774166701; h=from:subject:date:message-id:to:cc:mime-version:content-type:
	 content-transfer-encoding:content-language:in-reply-to:references:
	 disposition-notification-to; bh=XHCc8YdbXAd4tT2+dhaomC2NfJx3IFIemBPUrXZaJMc=;
	b=aIffeeDz8Z7ukSglxBiFW2JVW4etELCMzU6hX2Sv0BB7pT7eFSrFJPOKs6l146Olefvzjn
	ZMf1a5NtvFT0aLsexQpORxaFdoJ78qMgvF8qEbyiP4tvc790P6nZV8TguiB1S0Imx/skpR
	m/3dezGwUvg28ajXknhRwLAF3nGVqopU8aoCHNve/CzXF7XKRseenlwCMYVsv733w8M43V
	YZ2UUDEggx80VeqDrcOYrhYnULQuxu7MtfnFbo4p6uzfMndJVcOnkpzbUX1BOjvb4QVFx7
	EFPvVaAvVNmJLRoRiZGO04wa0BCR8CGic3Tp7TH/ZgR/8UTFnUSofhnzBKdmGA==
Message-ID: <4041383f-5ce3-4904-b03f-1084c72c7c8d@manjaro.org>
Date: Sun, 22 Mar 2026 09:04:56 +0100
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 01/11] wifi: mt76: connac: use is_connac2() to replace
 is_mt7921() checks
To: Sean Wang <sean.wang@kernel.org>
Cc: nbd@nbd.name, lorenzo.bianconi@redhat.com,
 linux-wireless@vger.kernel.org, linux-mediatek@lists.infradead.org,
 Sean Wang <sean.wang@mediatek.com>
References: <20260219004007.19733-1-sean.wang@kernel.org>
 <cab3c9a6-5563-40f5-9389-42ae3ac877ac@manjaro.org>
 <CAGp9Lzr85cNvveAzpb6SaB2TofY06SGcVRuUq_xTWpURuc1AxA@mail.gmail.com>
Content-Language: en-US
From: =?UTF-8?Q?Philip_M=C3=BCller?= <philm@manjaro.org>
Organization: Manjaro Community
In-Reply-To: <CAGp9Lzr85cNvveAzpb6SaB2TofY06SGcVRuUq_xTWpURuc1AxA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Last-TLS-Session-Version: TLSv1.3

On 2/21/26 21:19, Sean Wang wrote:
> Thanks for the catch I’ll update this in the next version.

Hi Sean, thx. Do you have already an updated version of this driver and 
a rough idea when all of this might reach wireless-next branch?

-- 
Best, Philip

