Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 063AE367F31;
	Thu, 10 Sep 2026 01:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789004000; cv=none; b=F7FwFPDyyH79ad1CD6n7k73lcJNqMSJdmbuLK3QtIz1ArFBVo71wY1v9G/vjRSNtuBgUG+aTe49GehUbarBa9m4JliuAIIpMRu79Hw6hb1R88HvF5m0JUCgoPQNnczX/UZfRpJE6lufBsMFs/1rygmSe6bUji6wZrnI1KbFyhRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789004000; c=relaxed/simple;
	bh=0u27hcVBehnWVlDS9NgaCGKKw+1TsWcLcm88dqOZX20=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=evPVp4IxSUlEq3idhFp6KjUOUDl25NdLmEs6j+9poyWQRKSQ7jBhO1lqrgB64wfgRqr3z1wjSBdS9lL6mgV90L6I5/Uq4afxP1MovARkTR2fkbTPzmZUcHUxOxsIpLu4VMPRoV3OBzAwBW/Cr4xPE+yI3/xQFvZct8DmU0A6kJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=XF72x5Ro; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="XF72x5Ro"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68A1X8gyC1088587, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1789003988; bh=0u27hcVBehnWVlDS9NgaCGKKw+1TsWcLcm88dqOZX20=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=XF72x5RoqpQuqZKy6Nss+T7eEBnJRRRz/OK5I5si45lynRbSjPGKYOjbA5GET2GXb
	 75w5CCAFQvjnr/VtVqU3VmJ0CastNlNzSzu/1/8nXiFFHIyCSr538EExKMXWmZ8+zd
	 E5dobuo9nW9yHEtgIVFMBDFM6bowoTW1axti9kyaCnzEo+l+NT6f1+cJMu6CZDjldD
	 xtH2QCOSqqTxceY1yBYFY+ti5dddNTVsX/tXA/5IquhGrIPbxHyLmExsl9BilR5I/v
	 l1t9miECSqJ7wnaUO5Ua8VFNVoWDwNPfKLmsap5UHfoZVSLLK6CjGGnSKvb1Jb+8Es
	 DPChN6FgYCLXg==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68A1X8gyC1088587
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 10 Sep 2026 09:33:08 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Thu, 10 Sep 2026 09:33:06 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::126f:59ad:658:674d%10]) with mapi id
 15.02.2562.043; Thu, 10 Sep 2026 09:33:06 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Mehmet Fide <mehmet.fide@gmail.com>
CC: Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"mehmet.fide@screeningeagle.com" <mehmet.fide@screeningeagle.com>
Subject: RE: [PATCH rtw-next v2 3/3] wifi: rtw88: widen the ATIM window while
 an AP interface is up
Thread-Topic: [PATCH rtw-next v2 3/3] wifi: rtw88: widen the ATIM window while
 an AP interface is up
Thread-Index: AQHdPvxdShv1XG2yn0K/8lIzEPYqN7bHCoag
Date: Thu, 10 Sep 2026 01:33:06 +0000
Message-ID: <7c5bbf0771544b24855103349cfbd343@realtek.com>
References: <20260907190901.1056945-1-mehmet.fide@gmail.com>
 <20260907190901.1056945-4-mehmet.fide@gmail.com>
In-Reply-To: <20260907190901.1056945-4-mehmet.fide@gmail.com>
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
> From: Mehmet Fide <mehmet.fide@screeningeagle.com>
>=20
> The frames held for dozing stations go out right after the DTIM beacon
> and only for the duration of the ATIM window. The chips come up with a
> 2 TU window (the two that program it set 0x2 at init), which drains
> about three frames per DTIM; the vendor driver sets 0xa or 0xc in AP
> mode instead. With the 2 TU window the measured page pool exhaustion
> takes ~100 s of ordinary multicast chatter; at 0x4 the same storm
> already drains, so 0xa leaves comfortable headroom.
>=20
> Program 0xa when an AP interface starts and put the default back when
> it stops, since most chips never initialize the register themselves.
> The bound and the filter of the previous patches still apply: the
> window adds drain capacity, the budget protects the pool when that is
> not enough, the filter keeps chatter off the beacon-paced path.
>=20
> Suggested-by: Ping-Ke Shih <pkshih@realtek.com>
> Signed-off-by: Mehmet Fide <mehmet.fide@screeningeagle.com>

Acked-by: Ping-Ke Shih <pkshih@realtek.com>


