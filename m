Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A007377558;
	Mon, 20 Apr 2026 08:33:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776674000; cv=none; b=h32q3USA/BvaHDnKRmvDVgdBQNwSYo7voSDBtRlfVkUWSTZdhugJCP4Yv5UanQGuGzpwyHaeDvpeQFLpS04sryKkO+WuWRvbBMIWe134QLKKG+CdOuW7HkrqcjHyhc0UMmUdw3IUmuaILuAUKuVxlhu1/VLxdUhmrUJ73ldQTmA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776674000; c=relaxed/simple;
	bh=HP6S+1dljtb8+dXgfDRPL2al/KQXrJe8qRU9T2s5mY0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=alE5a4LfojIYSpxSbfdjhxmVA2I9ssVv4/7Xiys5Cp5hB4+12EZ9bbe5IziiW5SpbhI7b6IBqKuurNPr115+PIMjgo7p1KotFe5iMtLZ13qJsZGK1J1ul8P9en+NPetqaUNdF2TVQp+oeHbEcJB+lRARpffnpGoNHaRo7CLXBzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=OUJpOx5L; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="OUJpOx5L"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 63K8X5QC0828816, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1776673985; bh=HP6S+1dljtb8+dXgfDRPL2al/KQXrJe8qRU9T2s5mY0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=OUJpOx5Lt+MZQimDcbB1/H5vjFeqS5MvhhU/VO7TqtDiPO/6vFlH9qENAw5mIStjQ
	 3dYQyEjtJxqwbZaHKBSXRMgoFJvFvxAokxhbUzuQK86WDUMKOgEFEY1XuycnaFHmFG
	 k0+Z1JiQRaDJ4LPxeLT7NIqQ60xELELRdq6JfCyUJUPY1Rrd4xV+CYQn8QyJjJjz1l
	 6s27NONnHj3UCF8tgzGqCX3LF3NZm2tTX6VHaO8eCnf0kH6iagbB61OSMHSlVlEjyS
	 tTozy2FHFhKIyznPcdujInPPGAVCzH/EgTZY3bGz4bjY71gdgtVwIT+DzHQbHKAYbh
	 vy6lhx4NCWefw==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.26/5.94) with ESMTPS id 63K8X5QC0828816
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 20 Apr 2026 16:33:05 +0800
Received: from RTKEXHMBS01.realtek.com.tw (172.21.6.40) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.10; Mon, 20 Apr 2026 16:33:05 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS01.realtek.com.tw (172.21.6.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 20 Apr 2026 16:33:05 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([fe80::ed72:3015:2840:4458]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::ed72:3015:2840:4458%10]) with mapi id
 15.02.1748.010; Mon, 20 Apr 2026 16:33:05 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Hugo Villeneuve <hugo@hugovil.com>
CC: Hugo Villeneuve <hvilleneuve@dimonoff.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] wifi: rtlwifi: fix typos in comments
Thread-Topic: [PATCH] wifi: rtlwifi: fix typos in comments
Thread-Index: AQHczqWQyp8zhc/RLkiGIWuxJU1UtLXnotIQ
Date: Mon, 20 Apr 2026 08:33:05 +0000
Message-ID: <1a4b61233ed242c2bd7e5300860f8ea1@realtek.com>
References: <20260417200520.3919437-1-hugo@hugovil.com>
In-Reply-To: <20260417200520.3919437-1-hugo@hugovil.com>
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

Hugo Villeneuve <hugo@hugovil.com> wrote:
> From: Hugo Villeneuve <hvilleneuve@dimonoff.com>
>=20
> Fix typos in rtl8821ae_card_disable() comments.

Will mention rtl8821ae_card_disable() in subject during getting merged.
Like " wifi: rtlwifi: fix typos of comments in rtl8821ae_card_disable()"

>=20
> Signed-off-by: Hugo Villeneuve <hvilleneuve@dimonoff.com>

Acked-by: Ping-Ke Shih <pkshih@realtek.com>


