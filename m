Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 765342AE78;
	Tue,  8 Sep 2026 02:48:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788835730; cv=none; b=q8Y9oW46aKxKPVVRaURGMUnxL4llyB20b869zDF8vbpDnK3B+1cGXo7tzN3+a+UydGDgN+AX2Mts0+zPb+7YTJYUjQPAFZrNpbSq0k9CRsGjABjY5bD6PTU5xCt/tt2mdPaK2J70v+ZQtRD+CI2ODkDuE3F+z5ZhifnB384v5Hg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788835730; c=relaxed/simple;
	bh=oae5Np6IlqLqtKUchCLD0jHIcWQyIrQodyFdMrO1kz4=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type; b=sdo0t0MhDP2bbPRc3digTtfB9/+wtPEgG3FPVgMdK/3reBdw6a2ja2qi5N6H2u0bMtqwsSWykeHa7FMxMnid64KyT1e3D8R4w09/31eCYrPo8tPz0Ac3y17fxPPKFEqJUqx/BJiNcUqmhDV1BwRajqzkPvvwJHfzz2hg+xID5XI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=IXMmJ5o6; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="IXMmJ5o6"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6882mUzbD3422949, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1788835711; bh=Z3hPpkgwRBgDjiPglEYVp9kdysiraAKidKCA/ZEd5JA=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type;
	b=IXMmJ5o66WXYJT8BMJ34nwkTXImcUcJ+8zj037RyO18wlq5MRCgWbaoc/SoAIbZuh
	 WztudlKmZVSjufQ6LLIy1/H65y9fFGBTmQPFGPcbCkpNA925XAQHhJFis+3UqsAe2b
	 rM/cvd8oq4Qy5WFQcJImAoZLsWpeQwn8qjJD3qMFHpzsM3e2OeHlkijT79vqy6qecc
	 ng6sBllmqqIRsD5TsZTteE+5ySTGuVGQP0LNgrP543xzIsM6YZK0eG4aRA5x8UtWrA
	 HDxmnxikTi6fNon/bysawNQYGv13y8H7KN1aJrPGTtVrNu2YepcqTFdtE2zb+zg/2s
	 +Rl4T+1O5uxvw==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6882mUzbD3422949
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 8 Sep 2026 10:48:31 +0800
Received: from RTKEXHMBS04.realtek.com.tw (10.21.1.54) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Tue, 8 Sep 2026 10:48:30 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS04.realtek.com.tw
 (10.21.1.54) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.43 via Frontend
 Transport; Tue, 8 Sep 2026 10:48:30 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Gongwei Li <13875017792@163.com>, Ping-Ke Shih <pkshih@realtek.com>
CC: Chin-Yen Lee <timlee@realtek.com>, Kalle Valo <kvalo@kernel.org>,
	<linux-wireless@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Gongwei Li
	<ligongwei@kylinos.cn>
Subject: Re: [PATCH] wifi: rtw89: fw: propagate real error code in rtw89_fw_h2c_add_general_pkt()
In-Reply-To: <20260901093331.3441469-1-13875017792@163.com>
References: <20260901093331.3441469-1-13875017792@163.com>
Message-ID: <186f8f00-dec5-4159-b7e3-e2c19c05bd21@RTKEXHMBS04.realtek.com.tw>
Date: Tue, 8 Sep 2026 10:48:30 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Gongwei Li <13875017792@163.com> wrote:

> From: Gongwei Li <ligongwei@kylinos.cn>
> 
> The error path of rtw89_fw_h2c_add_general_pkt() returns -ENOMEM
> unconditionally, which masks the real reason of a failure. In
> particular:
> 
> * rtw89_fw_h2c_add_pkt_offload() can fail with -ENOSPC when no more
>   packet offload slot is available, or with the error of H2C TX, but
>   the callers only see -ENOMEM and get misled when debugging.
> 
> * For an unsupported type, the switch default case returns -ENOMEM,
>   which is misleading and should be -EINVAL.
> 
> Return a real error code instead of -ENOMEM, and use -EINVAL for
> unsupported types.
> 
> Fixes: 5c12bb66b79d ("wifi: rtw89: refine packet offload flow")
> Signed-off-by: Gongwei Li <ligongwei@kylinos.cn>

1 patch(es) applied to rtw-next branch of rtw.git, thanks.

5469ea5a14aa wifi: rtw89: fw: propagate real error code in rtw89_fw_h2c_add_general_pkt()

---
https://github.com/pkshih/rtw.git

