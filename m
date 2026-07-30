Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8171F364940
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 02:25:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785378309; cv=none; b=iI0y3JRVybcf6rGLmvvgbccEbkiNaxH5wGVaZ6nc3wHEA4lj++3aojdQ2YWGVYN/4whqs19G8ALwHQDqEtou1Gu8N39C3UaWqkaRtLNBpQA0gMG0aXXrzBRLR9fMIsVs1yGvECF6NdzbVTLcU6pSIxaMgo2FeHmhD6+Hm2RF1ps=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785378309; c=relaxed/simple;
	bh=YMpNfxcX4TBAB3lTjz/j22W6cQfeuUefLKdOCZOvllw=;
	h=From:To:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type; b=ktcDWXdLY6seNIWiFGAEO3a6aZ9bUixqRMQBLSxY+7Q2st4EYVXwRXScqssM0BFnNHbzB8wiPG4oAl2CKZq7JHCDIGiyhg5W4DWznYsCmzNj5bejoUUgQintcyOhyGVmgVQoiw3exeq/2TM4K1DEyporccydsLoJS/rkGUCncgE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=qm7/EFpu; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="qm7/EFpu"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 66U2P4VX0900305, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1785378305; bh=ItmjYT2Jo6NSf29YnJuGqE+kKKUPw8c7C9YCWG37fY4=;
	h=From:To:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type;
	b=qm7/EFpu4wIQ8wsWXqwGUyf3gfabGlSmySncu7K6QxRZqPkRnAaEIu4v1VpXPBpDF
	 FjgH17b8mBcF6o1WtnzZQvTt32VNWubaWvkpAaW1k8bphfgASfDoRUFVOIZt16OD6u
	 Olj1Y4ljY/gY33sifWjm+5x2A9TmLk7rqzWpSep5EPTKMxJzWviccx3XXDlJaQq480
	 w2cOqD8LI2SxggkdudlKkHrLWyHrucddhCxYrN7hmnnjZG7y/CpgA82aCqS4qQEzmJ
	 F8gAFkBYkIV0/AmrImGlJYQVPArj3/E+GCiH7I/Pwqc4RUQvWAZh+UAS4z9RupVHkZ
	 +FVJfWpKMCg3Q==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 66U2P4VX0900305
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 30 Jul 2026 10:25:04 +0800
Received: from RTKEXHMBS01.realtek.com.tw (172.21.6.40) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 30 Jul 2026 10:25:04 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS01.realtek.com.tw (172.21.6.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 30 Jul 2026 10:25:04 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS05.realtek.com.tw
 (10.21.1.55) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17 via Frontend
 Transport; Thu, 30 Jul 2026 10:25:04 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <stf_xl@wp.pl>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] wifi: rtl818x: initialize eeprom_93cx6 struct to zero
In-Reply-To: <20260723110640.8588-1-stf_xl@wp.pl>
References: <20260723110640.8588-1-stf_xl@wp.pl>
Message-ID: <7948816e-cab0-4582-a99d-6f25d45ca70a@RTKEXHMBS05.realtek.com.tw>
Date: Thu, 30 Jul 2026 10:25:04 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

stf_xl@wp.pl wrote:

> From: Stanislaw Gruszka <stf_xl@wp.pl>
> 
> Commit 7738a7ab9d12 ("misc: eeprom: eeprom_93cx6: Add quirk for extra
> read clock cycle") added extra 'quirk' field to struct eeprom_93cx6.
> 
> Many existing users of eeprom_93cx6, including rtl818x drivers, allocate
> the structure on the stack without initializing all fields. As a result,
> the added quirk field has an undefined value and can randomly cause
> reading wrong data from the EEPROM.
> 
> Fix by initializing the structures with {}.
> 
> Fixes: 7738a7ab9d12 ("misc: eeprom: eeprom_93cx6: Add quirk for extra read clock cycle")
> Cc: stable@kernel.org # v6.13+
> Signed-off-by: Stanislaw Gruszka <stf_xl@wp.pl>
> Reviewed-by: Ping-Ke Shih <pkshih@realtek.com>

1 patch(es) applied to rtw-next branch of rtw.git, thanks.

799b5f45cb81 wifi: rtl818x: initialize eeprom_93cx6 struct to zero

---
https://github.com/pkshih/rtw.git

