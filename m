Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B63E37A486
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 03:40:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784259640; cv=none; b=e/RdWJXFwWXvwcXKXFqbst9Jo5+hVxvEg+eqZqP1Ao3Vj2LwSThY0ExgRkzuyArlqymNMvxRDuLt7s1EYukTANdmmT3oFLANawnqR4cXC8kDRNn57qckdv7A5w8Bt3XmUCr+jdSmwuG5DHAc2ODdS56QX/Zs/EiuOcW7McU3pEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784259640; c=relaxed/simple;
	bh=qlvUPNeJnYXpKQ3UuCEg53S63rXyQt8dDWFBgFpHfJ8=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type; b=pCUj/LrlywEIyCLwZRSFGx1EJ+4BQEgqPXrjm1HoE3gKHdIumCO4vlvJuxQjb2XcLv99Aj6SDICjKK3KtT6JvulmaiswEtm+KpyRJqgvrABbBV/8bcaUzDyGIFeMTjMjeAYYi4D3jd2ySRXa/I3I71iEy92NPSzCGqgaliRG2lQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=tTf7nXOC; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="tTf7nXOC"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 66H3eWuJ54094249, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1784259632; bh=YFQAF3d9QLa1nZTObgH20ood83Rm878/8vHOFQ+y+B8=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type;
	b=tTf7nXOCqjJQqNWhR/8+eFzWj4/PQ4W540/i+kQ1Ru71sGtedP5y6ExucKdwO2TlR
	 U5DPG8z6I7LnKfqIuYXx/Cq7ql8zPvh91yuh14eS22FUlqA8jy/c/IY+09vL1qP8NA
	 UPzkp56Gi7x40OSwPAzmP2K21WHtlHiVYRR1idC/18Ae1vx+97yOIsQYMMnF1ZAYtW
	 mM1EuIftSP3T7aTvT7t3r1TyS7BeGmAPRB5e+YxRcemAMgw1uEUvqfuL1IgJR5dJ3h
	 JRbNso1hD6xMwN90HMuzwOtrOc+jZzsOaiDROBkeUh+VafBLUgnrR5TkG/XsHev9MS
	 QCv9Qjult/tkw==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 66H3eWuJ54094249
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 11:40:32 +0800
Received: from RTKEXHMBS01.realtek.com.tw (172.21.6.40) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 17 Jul 2026 11:40:33 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS01.realtek.com.tw (172.21.6.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 17 Jul 2026 11:40:32 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS06.realtek.com.tw
 (10.21.1.56) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17 via Frontend
 Transport; Fri, 17 Jul 2026 11:40:32 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Ping-Ke Shih <pkshih@realtek.com>, <linux-wireless@vger.kernel.org>
CC: <echuang@realtek.com>, <kevin_yang@realtek.com>
Subject: Re: [PATCH rtw-next 1/8] wifi: rtw89: pack I/O during bb_sethw to reduce API execution time
In-Reply-To: <20260712034506.53209-2-pkshih@realtek.com>
References: <20260712034506.53209-1-pkshih@realtek.com> <20260712034506.53209-2-pkshih@realtek.com>
Message-ID: <6590bc6f-7a46-402b-a304-eacf6d2b99de@RTKEXHMBS06.realtek.com.tw>
Date: Fri, 17 Jul 2026 11:40:32 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Ping-Ke Shih <pkshih@realtek.com> wrote:

> From: Eric Huang <echuang@realtek.com>
> 
> Wrap rtw89_chip_bb_sethw() with rtw89_io_pack/unpack so all register
> writes during baseband hardware initialization are batched into a single
> bus transaction. This reduces API execution time from ~11000 us to
> ~4000 us on affected platforms.
> 
> Signed-off-by: Eric Huang <echuang@realtek.com>
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>

8 patch(es) applied to rtw-next branch of rtw.git, thanks.

b45b22bbe9d5 wifi: rtw89: pack I/O during bb_sethw to reduce API execution time
07c26ead36e7 wifi: rtw89: mac: abstract register definition of firmware boot debug
b9f582e939f6 wifi: rtw89: 8922d: add TX time limit for 2GHz band
ed74acea8320 wifi: rtw89: introduce helper to get tx shape index
7054b03136e4 wifi: rtw89: add tx shape v0 to keep built-in arrays compatible during transitions
b4eaac15cbb4 wifi: rtw89: extend tx shape format for regulatory 6 GHz power type
b5bf2dc96f95 wifi: rtw89: fw: do bb_preinit before downloading firmware
3c15399ef64e wifi: rtw89: debug: add diagnosis for RF

---
https://github.com/pkshih/rtw.git

