Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AAB1339844;
	Mon, 16 Mar 2026 06:05:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773641160; cv=none; b=L2N1zuTZ5rf+ippdoI81tOqHj6vZ85KzQmq6hkzL94EwPuBP1j48cK6ZF+iKgWUAD3pm+vvK1aC+LnhCLxTxaWC3QW7PFPqBSctftnfspGywM9d11gryGiSSkUl1rXtDqrHRhprJKF55u6wbiBvyu04xcAP+hPTH7D6IkkR+ihg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773641160; c=relaxed/simple;
	bh=bQXHKihHzH6ePfgjMWNAAdaBuLP7sAD/XeakmjFozSk=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type; b=qrTO+UB3E3D/CacWwggiM22QZ4R+fegFhFwXRN5ZLqqM9tP350JTaZNkE6q+zGUCnP1TE5/7pfN9K8bqxsCz65DIboc2yB77UBLJhBGUcaFy21mkXsCo+KX1WHsevzicHXfI7Hs2vumJkMjGF8trgDuVVEifdmpE/2ouqVQYV3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=fXo0kAeu; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="fXo0kAeu"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 62G62LlO41337098, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1773640941; bh=ymFdtUJ4E76eVIMgzZS40vN1ilZMhP44XPXQ7l5aQ0k=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type;
	b=fXo0kAeu4gtb0Nh+lJCitMaNV1Y8awFBOKZoVDgH3/Pq/Mnvx12I8qYfLzhLzQIQU
	 7zF6m+3Yb/0CV5vQ6o9Us8sUd92bp9KFOFJmD0fBudN+kXCEXg8ew70CB9e08joQna
	 l8sxaH1Pap+RxnlwwR6ytv4lNZI04R/xrUKDDeu/F4F65E4L22iqKF8P2Nj4d6bArD
	 dLuJYb63sFIvEl/s5EcorzkVFJg3trnqJbbQbHXYdSbafunoe0xd155HQ7KNHDI2wQ
	 Ls4Yd0Voa0ENNnBBRHxIChWra67hlxWNpEAflK4T8VvTMaBmRPqKieCn1T+qWzykpW
	 idvZo4l48L9WA==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.21/5.94) with ESMTPS id 62G62LlO41337098
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 16 Mar 2026 14:02:21 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.10; Mon, 16 Mar 2026 14:02:22 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS06.realtek.com.tw (10.21.1.56) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.10; Mon, 16 Mar 2026 14:02:21 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS06.realtek.com.tw
 (10.21.1.56) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1748.10 via Frontend
 Transport; Mon, 16 Mar 2026 14:02:16 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Johan Hovold <johan@kernel.org>, <linux-wireless@vger.kernel.org>
CC: Jeff Johnson <jjohnson@kernel.org>,
        =?utf-8?q?Toke_H=C3=B8iland-J=C3=B8r?=
 =?utf-8?q?gensen?= <toke@toke.dk>,
        Brian Norris <briannorris@chromium.org>,
        Francesco Dolcini <francesco@dolcini.it>, Felix Fietkau <nbd@nbd.name>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Ryder Lee <ryder.lee@mediatek.com>,
        Shayne Chen <shayne.chen@mediatek.com>,
        Sean Wang <sean.wang@mediatek.com>, Jakub Kicinski <kuba@kernel.org>,
        Stanislaw Gruszka <stf_xl@wp.pl>,
        "Hin-Tak
 Leung" <hintak.leung@gmail.com>,
        Jes Sorensen <Jes.Sorensen@gmail.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Nicolas Ferre
	<nicolas.ferre@microchip.com>,
        Alexandre Belloni
	<alexandre.belloni@bootlin.com>,
        Claudiu Beznea <claudiu.beznea@tuxon.dev>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno
	<angelogioacchino.delregno@collabora.com>,
        Greg Kroah-Hartman
	<gregkh@linuxfoundation.org>,
        <libertas-dev@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        Johan Hovold <johan@kernel.org>
Subject: Re: [PATCH v2 16/18] wifi: rtl818x: drop redundant device reference
In-Reply-To: <20260306085144.12064-17-johan@kernel.org>
References: <20260306085144.12064-1-johan@kernel.org> <20260306085144.12064-17-johan@kernel.org>
Message-ID: <94394d24-1938-4cd5-b8b7-ffcb6022c837@RTKEXHMBS06.realtek.com.tw>
Date: Mon, 16 Mar 2026 14:02:16 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Johan Hovold <johan@kernel.org> wrote:

> Driver core holds a reference to the USB interface and its parent USB
> device while the interface is bound to a driver and there is no need to
> take additional references unless the structures are needed after
> disconnect.
> 
> Drop the redundant device reference to reduce cargo culting, make it
> easier to spot drivers where an extra reference is needed, and reduce
> the risk of memory leaks when drivers fail to release it.
> 
> Signed-off-by: Johan Hovold <johan@kernel.org>

3 patch(es) applied to rtw-next branch of rtw.git, thanks.

68e7d359a5ee wifi: rtl818x: drop redundant device reference
711b8add3929 wifi: rtl8xxxu: drop redundant device reference
bbb15e71156c wifi: rtw88: fix device leak on probe failure

---
https://github.com/pkshih/rtw.git

