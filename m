Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E768E1A6822
	for <linux-wireless@vger.kernel.org>; Tue,  8 Sep 2026 02:45:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788835555; cv=none; b=WwvvRXGxt/42kE4ZzQasF7LPq/Xi6NAZMB3NVWVMuB0a4Zs4jHagKNRYh5b9Vr7WIM5RzkYO2uuIRv79Yb//RXo6mv+aNTbx9j21xCae758KUYsISnov/j4l47hkKIUDGzXJeXItW2iSThIWArEA/wX2S2XEpLj+7YypwXqyMIE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788835555; c=relaxed/simple;
	bh=XYMLMgQDcVqwLIP6y3MqVWyM1a2ivmm/2euh5bM8wgY=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type; b=ckMJ8SoUFTiGqk36j12yvV599S33AcCBCoFOX0y8ONWP0U4xeo9pX9hvAGlftTONKhLK2moqXbkbbXDRffeiYe9h9KPIK/bC9Y2N/VLA44HTOMYBwH8JkChTPU6x+ll0hMVxw3xXwEuMjsmGWGSLkTq9GPY50a+ibWVcr3J1hMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=QbSh7ymY; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="QbSh7ymY"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6882jm2W33421834, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1788835548; bh=FbTHJez8S0bh4PDeSStaz9u/retY10q7oYKEUG+U220=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type;
	b=QbSh7ymYKD938/ceci3x9HLurSW5B70oGuNlvaGidfImIDbP4b7MSkItGImIVjgmi
	 nPBvo5JmJsnCnMsFa/egbVRTGJZMNm2BxUJpFvO9f+syqGM6wcv1KgOaCDW37YM+Ts
	 JSa20wbaxoBsvzzW5ohQ5zBmUOvWCGwmeEcWFfIo+6LuohOcsPnOURIJ4wWbFHdCya
	 W8Fs4MF5cjPrMWp+Bh99bU0ZmJKa8PkebDlb5LDSvasHtNd8p6EMEJhv386MsBSeEb
	 QRg0envMRK/PSp/FfaViDUMShrRjJbhDKrjxLC7BwD+Bo73AquejAiivZtyQsuAtDM
	 kAB0LnlAj/z7g==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6882jm2W33421834
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 8 Sep 2026 10:45:48 +0800
Received: from RTKEXHMBS04.realtek.com.tw (10.21.1.54) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Tue, 8 Sep 2026 10:45:48 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS04.realtek.com.tw
 (10.21.1.54) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.43 via Frontend
 Transport; Tue, 8 Sep 2026 10:45:42 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <nick@venenga.com>, <linux-wireless@vger.kernel.org>
CC: <pkshih@realtek.com>, Nick Venenga <nick@venenga.com>
Subject: Re: [PATCH v2 rtw-next] wifi: rtw89: 8922au: add ASUS BE93
In-Reply-To: <010f01a05fa084ba-80349068-cd1f-4e4e-99f5-8cf6f4c03216-000000@us-east-2.amazonses.com>
References: <20260829140823.2213829-1-nick@venenga.com> <010f01a05fa084ba-80349068-cd1f-4e4e-99f5-8cf6f4c03216-000000@us-east-2.amazonses.com>
Message-ID: <42ce56d4-4603-4b7c-b76f-82fdcbd1b059@RTKEXHMBS04.realtek.com.tw>
Date: Tue, 8 Sep 2026 10:45:42 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

nick@venenga.com wrote:

> From: Nick Venenga <nick@venenga.com>
> 
> ASUS USB-BE93 Mini USB-C adapter
> Originally added and tested here https://github.com/morrownr/rtw89/pull/121
> 
> Acked-by: Ping-Ke Shih <pkshih@realtek.com>
> Signed-off-by: Nick Venenga <nick@venenga.com>

1 patch(es) applied to rtw-next branch of rtw.git, thanks.

54631010cb20 wifi: rtw89: 8922au: add ASUS BE93

---
https://github.com/pkshih/rtw.git

