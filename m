Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED0F734678E
	for <linux-wireless@vger.kernel.org>; Wed,  7 Oct 2026 03:47:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791344869; cv=none; b=BZcmhG1G4bg18/wn/zSIjYnE9Rd8NPiemBBbntXDGAfy0mu22deOjoe+1FvBy96y+Y/NJOm+iL/lfn1BFpkTQl+4uEQEEe9DzF4RzBYYYiuOE4dgB8tA27iyiRDHfFrcbkYGyL+MphU+2xR/0cDjPisQNVqxU592md0Et0urN2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791344869; c=relaxed/simple;
	bh=navUJDERsLgTRsCDpaOQDuMXNGzeVCVWibkZg5rt8bs=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type; b=C0VEx/CoIdHyZNBj+sj62LbQAY1B/PA18TaHDC9Qexsw0TDs00KboL69JV5dzzNHUBzHc0piraoZ07f551x90d74HbD+CW4d1y8cMuIjv+pjcHmvYWULxgVyomdiL5ikIg/PGnDQXUI476imye1cp5lIIuAcTS7aBdwGmU9lqu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=imWGREFT; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="imWGREFT"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6973ljPS33498423, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1791344865; bh=ZFmmxXgCuB5xtxw0OHA6KCTQEp5yfvZw76Q+XK79rSA=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type;
	b=imWGREFTz8zx5wg+Jfu1k/97HiE2y2BD18bAcraXHgvhsHZCq370Z5mEAQc8JqIEG
	 BopsQ7JaoPV+wEJ9U21+KkxPX+S+Tv/vq26Ggksqu/KmTrv26hWaKwGProco82Om0i
	 B39ercsdn+gFrkJqs9DflFHHj0hmaTecAGL9BuzZeXWOvAqpI1GLDSmkNqd7AmJT/3
	 3sUr5AemsG003vYANovcoZ7uqkqLFKxEf28xFFBT49K0nzMBPFP83HR+xThLqO5qyK
	 oeteXfpkNMfbDoiLnRzVbdFoMDONlc2c9sVCiYk5AqxKgcRUpXdyKK1/TMTnGzHJe4
	 45lzxrjXQ5NXg==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6973ljPS33498423
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Wed, 7 Oct 2026 11:47:45 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 7 Oct 2026 11:47:44 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS05.realtek.com.tw (10.21.1.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 7 Oct 2026 11:47:43 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS05.realtek.com.tw
 (10.21.1.55) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49 via Frontend
 Transport; Wed, 7 Oct 2026 11:47:43 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Ping-Ke Shih <pkshih@realtek.com>, <linux-wireless@vger.kernel.org>
CC: <gary.chang@realtek.com>, <echuang@realtek.com>,
	<wenjie.tsai@realtek.com>, <kevin_yang@realtek.com>
Subject: Re: [PATCH rtw-next 1/6] wifi: rtw89: ps: send H2C command related to MLO info when FWIPS
In-Reply-To: <20260930064524.39403-2-pkshih@realtek.com>
References: <20260930064524.39403-1-pkshih@realtek.com> <20260930064524.39403-2-pkshih@realtek.com>
Message-ID: <21b8d023-7139-460d-966c-7641381c2c6a@RTKEXHMBS05.realtek.com.tw>
Date: Wed, 7 Oct 2026 11:47:43 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Ping-Ke Shih <pkshih@realtek.com> wrote:

> From: Chih-Kang Chang <gary.chang@realtek.com>
> 
> When entering FWIPS, also send the H2C command related to MLO info, the
> same as in LPS. Otherwise, the firmware cannot get enough information.
> 
> Signed-off-by: Chih-Kang Chang <gary.chang@realtek.com>
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>

6 patch(es) applied to rtw-next branch of rtw.git, thanks.

64331a0ce58e wifi: rtw89: ps: send H2C command related to MLO info when FWIPS
0fd2ed6a5074 wifi: rtw89: pci: fix typo of "deliver"
7a3638503335 wifi: rtw89: rx: refine skb/desc naming to improve readability
2995f5234ab2 wifi: rtw89: rx: no need to cancel 6 GHz probe per vif
a4d288b5200a wifi: rtw89: phy: write full data for BB gain table type 15
11a7351f30b9 wifi: rtw89: pack I/O during RF nctl init to reduce execution time

---
https://github.com/pkshih/rtw.git

