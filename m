Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06FD225B09E
	for <linux-wireless@vger.kernel.org>; Mon, 17 Aug 2026 03:07:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786936072; cv=none; b=f93GYPNLlo09DRaBMQFuVUMSXfmHKQAZHn+jqKvBqVnEvqo4LWxUuiMYuKyvxfB6I4mtNgfUeTxtH8beWeeZgbM6Ya4VneMzQ+30tkfzmj19fNcmd2sFApajxCGKpdvNqfMmQt+OKMiPAkvxy5dZ63gvIHIfy6EB2bJ64BtkCRU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786936072; c=relaxed/simple;
	bh=7Vq5JVoBxXF6HcaiuOPYOq1i1/cBRHuS2+HWZAxDakg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=i9tttnDHbyZQKnvbV9CzrMxPeEPYOQgTf+AZnjFrthH0GivdRjK9sKuPAwlFnR865VYNDqokWbLMur6ZJT5RSckqe//XqyAlHDRgDK8vc50P44TE7nvo24tVEkoQ8N9ormdXY8Z5dXNG2M2sc8u7afkUChL7Fkm0/ssYLxzFR+8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=bIzpCI4R; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="bIzpCI4R"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 67H37kzR63472936, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1786936066; bh=7Vq5JVoBxXF6HcaiuOPYOq1i1/cBRHuS2+HWZAxDakg=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=bIzpCI4RAdo4NKlnK6n3qJX7muQGcqVRavk9lOTYX79hxqpkQOFOcQ1RX1Z6yC1MP
	 6Up7LX2QBy/JVad753YfPaTLUbDpt6XPLH3EZKy434kmGtvvG+Wj4bbmlMh63lpgjM
	 EC5D06CIIg/5PZ/wO3Iuv2SlJNIj4poOURc5UGxce4wMuMSZtGmO0yof5fLaA4bnV6
	 ibzseQ8FVUfoTKmTBFg2E9ooytUb/Y/yKtIs6fGEi5vXV8RFOSKphA+s0s2pkrlq+d
	 qB/bHNdWy7oj6tGa7k8ssb2qvE3VfmbjMzCSGJWzV4b0h6XSaGOWImA0N4gvoO7WZi
	 Ftw9PyhE+lt1A==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 67H37kzR63472936
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 17 Aug 2026 11:07:46 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Mon, 17 Aug 2026 11:07:46 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS05.realtek.com.tw (10.21.1.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Mon, 17 Aug 2026 11:07:45 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::126f:59ad:658:674d%10]) with mapi id
 15.02.2562.043; Mon, 17 Aug 2026 11:07:44 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Chelsy Ratnawat <chelsyratnawat2001@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH] wifi: rtlwifi: remove dead mimo_ps handling from rate
 update code
Thread-Topic: [PATCH] wifi: rtlwifi: remove dead mimo_ps handling from rate
 update code
Thread-Index: AQHdLA3N+FjDpuX+WkWojRg1qq8syLahkpBw
Date: Mon, 17 Aug 2026 03:07:44 +0000
Message-ID: <66136fec9d9044e2945dd8877ad3bfe9@realtek.com>
References: <20260814165556.1102547-1-chelsy.ratnawat1@ibm.com>
In-Reply-To: <20260814165556.1102547-1-chelsy.ratnawat1@ibm.com>
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

Chelsy Ratnawat <chelsyratnawat2001@gmail.com> wrote:
> From: Chelsy Ratnawat <chelsyratnawat2001@gmail.com>
>=20
> Several rtlwifi drivers declare mimo_ps as IEEE80211_SMPS_OFF
> and never modify it. As a result, conditionals checking for
> IEEE80211_SMPS_STATIC or IEEE80211_SMPS_DYNAMIC are false,
> making those branches unreachable.
>=20
> Remove the unused mimo_ps variables, drop the dead SMPS
> branches, and simplify the remaining rate mask selection logic
> without changing runtime behavior. Also move ratr_mask
> declarations out of the removed conditional blocks where
> appropriate.
>=20
> Signed-off-by: Chelsy Ratnawat <chelsyratnawat2001@gmail.com>

Acked-by: Ping-Ke Shih <pkshih@realtek.com>

By the way, I think this is v2, right? You should mention this in subject
and add change log here with '---' delimiter.=20

But no need resend because of this.=20

