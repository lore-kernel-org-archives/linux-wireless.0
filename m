Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8404B3033CB
	for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 05:20:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789536004; cv=none; b=go4tiJ7bPcOnNQrBVTKOqnUyQhK39dae+h3rH8TNo1dlmCWWEwjHORj80t3U0twVxxPr1np9f/Tuen32z16OD+80/IkbdXe7oFeHUR64dc5zaitoWr/TYAQ1UbdWX5npn2qjmFLhvvY6+A/7xqtYIveka5vsYMsmQr478wxofpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789536004; c=relaxed/simple;
	bh=Hq2abUenvKFmZhGuEmM86zvEpzh2OXOO2TKie5rbBJo=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type; b=ptKDFgusGzjdY7QeTvCHx5zdSyDuB7SdyuZ9dB1l12CWCDEzdDeN9LS9jMUDL7jSuWqzbiJzRtTcx/zSMoeNtmmcERv8/dcWV9ksCDxuEP0VhHJi7DgYWftBcC+SB5tP28EDp6VhITGNXgf6KwXpd6Z629Brf/1FPQcknjbtFe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=Zye0Pyt3; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="Zye0Pyt3"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68G5K0vxC2122154, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1789536000; bh=n7zANNXz3Lt6jm1VBdskbUHhE/dr3dcAJGupVFwK61E=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type;
	b=Zye0Pyt35o6c/jx4MY0NKhEfqd85L9khaDjMxM4HaLbUmTv8zQ3VsaDUd3aNvYMIZ
	 uPALNPNziwj8i8eb6APvckXWhW6JAixhMVq0o53JEvwTUshx+URvp9VQJSASUWz1Qs
	 n7+9inNfZKDdhU4FWmuc4NlARguElSoazeqWKMBshSHUBX1Qt/SG/oaWrMrE3Yhu05
	 tvlU3wsJJX4o4bCBPzpE/IAkyav1MDGeS59rVK4CgeaBDbq3FOppA6eSp6QYpEK7cc
	 loqkYd6s6yx9mYLwA4cyZNIuQALWfAFnOigvxmNtMMcFmzBucAHUnt0Afgimu4zgJD
	 /mGKycn3I3jNw==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68G5K0vxC2122154
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Wed, 16 Sep 2026 13:20:00 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 16 Sep 2026 13:20:00 +0800
Received: from RTKEXHMBS04.realtek.com.tw (10.21.1.54) by
 RTKEXHMBS06.realtek.com.tw (10.21.1.56) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 16 Sep 2026 13:19:59 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS04.realtek.com.tw
 (10.21.1.54) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49 via Frontend
 Transport; Wed, 16 Sep 2026 13:19:59 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Ping-Ke Shih <pkshih@realtek.com>, <linux-wireless@vger.kernel.org>
CC: <timlee@realtek.com>
Subject: Re: [PATCH rtw-next] wifi: rtw89: pci: disable D3cold on ASUS ExpertBook B3/P3 series
In-Reply-To: <20260911065358.34375-1-pkshih@realtek.com>
References: <20260911065358.34375-1-pkshih@realtek.com>
Message-ID: <c0ba5e61-8909-4d3e-9bbc-29931a2ade9f@RTKEXHMBS04.realtek.com.tw>
Date: Wed, 16 Sep 2026 13:19:59 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Ping-Ke Shih <pkshih@realtek.com> wrote:

> From: Chin-Yen Lee <timlee@realtek.com>
> 
> ASUS ExpertBook models (B3406CMA, B3606CMA, P3406CMA, and P3606CMA) may
> encounter PCIe link loss or recovery issues after entering the L2 low-power
> state associated with D3cold.
> 
> Prevent these affected platforms from entering D3cold to avoid the
> problematic PCIe L2 state transition.
> 
> Add a DMI quirk match table so that other non-affected platforms can
> continue utilizing D3cold power saving.
> 
> Signed-off-by: Chin-Yen Lee <timlee@realtek.com>
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>

1 patch(es) applied to rtw-next branch of rtw.git, thanks.

8cf894e2c693 wifi: rtw89: pci: disable D3cold on ASUS ExpertBook B3/P3 series

---
https://github.com/pkshih/rtw.git

