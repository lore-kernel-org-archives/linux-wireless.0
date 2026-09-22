Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B1B232B126;
	Tue, 22 Sep 2026 06:48:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790059707; cv=none; b=BtPRPMd0vTOnqiuYPkqtP0jPVv4XxjIsLeTtctuSxE5GP4WY2jQ0SnkJne1NAhPOysRmEzQ0Ghw11HyVxKyoifi6sTn+Bh3o6n17FDlmkZn7zG3mOUxQt76t5Ov2mi0qF53ofPY/7wQn17GoL2phFkHdbNhHaB03x8ygnwX9oS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790059707; c=relaxed/simple;
	bh=C7UHXn4J4JzSgwKRvwcMv3dBxQQAlWl/bGjFsmutJ+I=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=q+zm/Z8RqVFJkhQHl0SxyCMVarn7piIjl1PbZetyojwZJfMbB0Gy7ya31fuNIxBoW3v+1s4ByVsRjZ4kvrdf1FYH4pjHjkCUTJH3guHIGRIATqHYmGCb2/NVFOoeH+0UfluQ0gNuRg7XI+0EcIlvWNI2go5hPYKjc02xFU02yNw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=tUCgBVP6; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="tUCgBVP6"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68M6mEZA13396137, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1790059695; bh=dniwKo3j0ZUOeXJUEJD/7teguGjZ2TTLJ7n3urEckG4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=tUCgBVP6fcnz2pQh8JB1S6rpgFkeoc5a9jtdI5TB1z+7jPhBU3zFAbWVtwyjGlo87
	 OAWzKjf0gP8NhkiItkwQfHYaBpMunSRbfkVzE2EOX5KLQ4fnUnlYaj+JbJVkMdfnsP
	 TjlUpWRDzTpPxlrQ/pvqLeQMhUU93aWRxGqDAEiqgeMf8cTOwADKPMRSvUsmOCsrjz
	 zJt8Y4HQ2nPjgMD+5GoY9SIaqsCewfeiHPbCUbsz2d8RyLyhTlgFZhrVCCEHmNmPfa
	 nX90Ba5h6qICH0hFA8xSPgwz4m3f9APcGpglNWAf1eTuG3FziSU8kRmsClUniKQymA
	 0cDUN7tk1iTrA==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68M6mEZA13396137
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 22 Sep 2026 14:48:15 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Tue, 22 Sep 2026 14:48:15 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::b3cc:c263:b82d:e87c%10]) with mapi id
 15.02.2562.049; Tue, 22 Sep 2026 14:48:15 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Mehmet Fide <mehmet.fide@gmail.com>
CC: Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"mehmet.fide@screeningeagle.com" <mehmet.fide@screeningeagle.com>
Subject: RE: [PATCH rtw-next] wifi: rtw88: honour the transmit power mac80211
 asks for
Thread-Topic: [PATCH rtw-next] wifi: rtw88: honour the transmit power mac80211
 asks for
Thread-Index: AQHdRq+EwW8OYhDOM0qePD8BQryiXrbZ2EHw///K7ICAAIkZwA==
Date: Tue, 22 Sep 2026 06:48:14 +0000
Message-ID: <c164023223334f7095ef2a28f6bada33@realtek.com>
References: <dc09d252a96c4992ad18e2ba70cfad31@realtek.com>
 <20260922062641.1313856-1-mehmet.fide@gmail.com>
In-Reply-To: <20260922062641.1313856-1-mehmet.fide@gmail.com>
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
> When I wrote v1 I did not know that rtw88 already exposes
> set_sar_specs. I have since verified it on the RTL8822BU: it caps the
> per-path index from the given dBm and covers our exposure case, so we
> will use it. That leaves the patch as a consistency question rather
> than a need of ours: should rtw88 honour the level mac80211 hands over,
> as ath9k and most other drivers do, instead of accepting it and letting
> mac80211 report it as applied? If you want that, a v2 with your review
> points addressed is ready and I will send it. If you prefer SAR to be
> the only way to lower the power on these chips, I will drop it.

I don't lean to either, but ...

> > > +   if (changed & IEEE80211_CONF_CHANGE_CHANNEL)
> > > +           rtw_set_channel(rtwdev);
> > > +   else if (changed & IEEE80211_CONF_CHANGE_POWER)
> >
> > Should it be 'if' instead of 'else if'?
>=20
> rtw_set_channel() ends with rtw_phy_set_tx_power_level(), so when the
> channel changed the tables are already programmed with the level kept
> in rtw_hal, and a second pass would program the same values again. The
> explicit call is only needed when the level changed on its own, so I
> kept the else. If you prefer the plain if for readability I will change
> it.

Here should add a comment to be clear. It might become not clean...
Then I'd prefer SAR.=20

Ping-Ke

