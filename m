Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D97C3F4DD2
	for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 07:28:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790148500; cv=none; b=Nm8rJ9XV6wp7W0s1whYCWLgQjApjlaEwGAN0FhTF61MJgQ0Ra4jrd9T05Pp6vE28nHHH7JRyNMjZrqbNzY/fqB0XYimA03FYaQdRqGS/bjCf594KokeS69tQQLHWNyXJIL1Q9S8/7438Gvj5Fw+Iw2/8PmgOrnrez7k/G3gjkkU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790148500; c=relaxed/simple;
	bh=ngF86Gi/bK0AYeADRzZQfeow3dm1WBqjpBV8ybShGqI=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:Content-Type; b=rykvrrFB8zZ7PYqCKL90LrvoiyxdSLm7UIzRnc0fgkdo8TiTYcqVe1PjOMkPiiZe0p9Htgau7JcqDgj3DYzsYKHRji/Qsg65TQamn0GvUQy3o0FEDMLDCtxNXJN430ryDOJSp+QXO9YOsnMhzTLvnM5h86cLiG6/UycPKadl1WU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=Hoigch58; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="Hoigch58"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68N7SG9Q0136828, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1790148496; bh=4e/1+HrqdsLPanz9P/v6ecqGD9gBXZZb+Y2CAI1xU2s=;
	h=From:To:CC:Subject:Date:Message-ID:MIME-Version:
	 Content-Transfer-Encoding:Content-Type;
	b=Hoigch58kX2l0smLjqCkfp0qRZXEXpPYXNZe9cGpEe05OIuuvBa4blg1L7SvLpAop
	 Eh6LPoAjwekgFT9AkRDUmORHttXmc44xDjNx5UPuK3/IXqa6ktIwD3x9pWxxu08gHa
	 i3Uh0CcJ1/EFCE1bSgbsPE5dCE6nNtgMWx0obYFE5y4ht2lngi0nsXhhObOzMVNxaj
	 zVOzZIb4hgZkqRMiMkug5Z1uNtKU6Jj5xqK87YOJHRGshN3wJb80fjOIx8NwZ1Jplb
	 VwmKWSj86lqTb6K8rTcUgnjUAmU6aYVN8ztWhAe52A+aGS+YohpJqVILQdTp3Rwf5i
	 Aw/+Xsr7Kcjtg==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68N7SG9Q0136828
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Wed, 23 Sep 2026 15:28:16 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 23 Sep 2026 15:28:16 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS06.realtek.com.tw
 (10.21.1.56) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49 via Frontend
 Transport; Wed, 23 Sep 2026 15:28:16 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
CC: <gary.chang@realtek.com>, <kevin_yang@realtek.com>
Subject: [PATCH rtw-next 0/3] wifi: rtw89: add out-of-bound checking and reset map for hw_reconfig flow
Date: Wed, 23 Sep 2026 15:27:38 +0800
Message-ID: <20260923072741.54118-1-pkshih@realtek.com>
X-Mailer: git-send-email 2.25.1
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain

Reset associated links for hw_reconfig, and add out-of-bound checking
reported by LLM tool.

Chih-Kang Chang (2):
  wifi: rtw89: wow: check AOAC report C2H event length
  wifi: rtw89: wow: check AOAC report key index

Zong-Zhe Yang (1):
  wifi: rtw89: ser: reset map of associated links when L2 SER

 drivers/net/wireless/realtek/rtw89/mac.c | 8 ++++++++
 drivers/net/wireless/realtek/rtw89/ser.c | 9 +++++++++
 drivers/net/wireless/realtek/rtw89/wow.c | 3 +++
 3 files changed, 20 insertions(+)


base-commit: 2f77c66694108785a1f6ae6c5de06453e7f7a91f
-- 
2.25.1

