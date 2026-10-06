Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5E401A3172;
	Tue,  6 Oct 2026 00:47:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791247651; cv=none; b=bE3R7KY/VzpcUadoat17q11EVAmSV5fEvr5wWBF6/AtHTLfBsI7QC4RWEVMCju6R3NjDqi5kdI+tin2Pt0G38+nHlUUXQyTttyE3cFt37ZAisgipSaDCmL1kKA0Gu76LU0jO0s8MImYM/MIfPnRevwVXsmNfNxN84PBDM94fpiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791247651; c=relaxed/simple;
	bh=dixaRa9R2qQYCzjdHfCFPOmvH2DhXbAl10qtxCLIwQc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=cpSOeegRUsrfxYy06tl9mbttLcf89E+HvYFXDMyhrVbDs/knh8OmGsaKAQgjwqndrav4mtSDJkAkadV3a415wt7fpUDgUlikIgYU/lLHc4Ovcbl7Dr0KHxTUNJJNntuK5qGl28EEBYw7iSeKX53F5y3BaiPskzgd6Jq46u0XBI0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=BO4OMFuy; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="BO4OMFuy"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6960lEQI12408484, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1791247634; bh=dixaRa9R2qQYCzjdHfCFPOmvH2DhXbAl10qtxCLIwQc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=BO4OMFuydIBw18L33KLjd1IcobEr+T2jYHEzwLjOdQlvIt/zoJoYBj/6g+zWhH8eO
	 tt/yX7d7TR01ZEHr6+Lb5Vut4sKwuxvoWtZX/mwL7Mc6vMNwtfeu+gJG8cley37Nc4
	 xw71yXXLGtTSgOCK1WF6/EyaU7tmM40+k4WSu0H/DDUj0bqjcTtwcNjYKx7ccy4QX5
	 T6XKWr3FMVNkyRR982aNP+fGVYOjMCGEqQMFx1mgUTKH0VfHpPHr+GB54V+Tp8WKDK
	 N97SPBW9+Q0YLQ3UEtbZimQJlIHzWiYEYB/+AaI9aJbzVLbtXmawJknJ58e0vn/bxR
	 FA1DFLVMhTgAg==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6960lEQI12408484
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 6 Oct 2026 08:47:14 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Tue, 6 Oct 2026 08:47:14 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::b3cc:c263:b82d:e87c%10]) with mapi id
 15.02.2562.049; Tue, 6 Oct 2026 08:47:14 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Mehmet Fide <mehmet.fide@gmail.com>
CC: Luka Gejak <luka.gejak@linux.dev>, Bitterblue Smith
	<rtl8821cerfe2@gmail.com>, "linux-wireless@vger.kernel.org"
	<linux-wireless@vger.kernel.org>, "linux-kernel@vger.kernel.org"
	<linux-kernel@vger.kernel.org>, "mehmet.fide@screeningeagle.com"
	<mehmet.fide@screeningeagle.com>
Subject: RE: [PATCH rtw-next v3 0/2] wifi: rtw88: channel switch in AP mode
Thread-Topic: [PATCH rtw-next v3 0/2] wifi: rtw88: channel switch in AP mode
Thread-Index: AQHdVNZ4ts6N6Jh3bEeUdjVzehzxzLbvrnEA
Date: Tue, 6 Oct 2026 00:47:14 +0000
Message-ID: <b6c8d3f63f7e40fa8b515352cba19541@realtek.com>
References: <20261005143313.129670-1-mehmet.fide@gmail.com>
In-Reply-To: <20261005143313.129670-1-mehmet.fide@gmail.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Mehmet Fide <mehmet.fide@gmail.com> wrote:
> v3:
> - 1/2: the beacon out-pointer is initialised in the caller (Luka)

If you have something changed, you should not carry my acked-by.
Or, point out the reason you can.=20

Ping-Ke

