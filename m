Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1F0E20E030
	for <linux-wireless@vger.kernel.org>; Mon, 30 Mar 2026 01:46:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774835171; cv=none; b=qW0Ea3B0hfmWbcuGtTSTGqoifTiHdQvilLULZNqNpv0kovqzoUJOtLUCwsXbL7KV85O6jIjAXaqlpkqUzSwagrN6INqMQGK6mN6dJ6DBzw4rk8I04dd7B3sdD2+g1K22aWosny6633DiAiQtI7GGLOfGlKdANxwGxUROklgCQck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774835171; c=relaxed/simple;
	bh=PAtJCrXGHzPVnSLZRHYLEUR4PfFZK6kb8HH5mT73NMM=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type; b=qSRfcwBp4yFHmlMiT64f3EN4HlXufpNpmCzMIULXS7MJ36Mh0CrP6znn8cQU2dUc7226LRFqA0C+tYg3V8eHl33/4MQno4PudL6T2wap+CBYsGrI86hWaQrwuB17MGNbht9hsySo0k2mguXSOAwYHnTHJ7JzOmrSk90p7j6Pk5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=AjKwt/zB; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="AjKwt/zB"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 62U1k31P1069246, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1774835163; bh=O5Xz8Nq61AvQvJEgC/FB0UA5m248syibAOkuTtWUS/g=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type;
	b=AjKwt/zBnPO8PK9ndpy57TpJcj22WxMxp6egY4migm+ofQ0GrUnV8JwQvhV1I7/gH
	 hJVPbRJY5ADg6w4N00JVFB7dVXEQXoRxT3SuomVuhCXp5XnU2zcxlB6tWo3t48EfoS
	 UkxlMRw+9/wz5ByPtvUkMbEMvnYkQKSCAsJTx5nlORh0W+VHTOShBRZ46BrL3mmZtl
	 43LWC22a7h3jK4P/+9C1fWj9YHccaoS4pwtqIY6i3gfJLIW6/yx3eH01OZ2BGsGhXr
	 Az6aqWjA9joIFK1qioyI+xxDoZJKIPaBBWPm/00mDyj9+FvdqNMpSu9Ey/D6F5mpPS
	 t8qSw4IbIoe2w==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.26/5.94) with ESMTPS id 62U1k31P1069246
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 30 Mar 2026 09:46:03 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.10; Mon, 30 Mar 2026 09:46:04 +0800
Received: from RTKEXHMBS04.realtek.com.tw (10.21.1.54) by
 RTKEXHMBS06.realtek.com.tw (10.21.1.56) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.10; Mon, 30 Mar 2026 09:46:01 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS04.realtek.com.tw
 (10.21.1.54) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1748.10 via Frontend
 Transport; Mon, 30 Mar 2026 09:45:56 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Zenm Chen <zenmchen@gmail.com>, <linux-wireless@vger.kernel.org>,
        <pkshih@realtek.com>, <rtl8821cerfe2@gmail.com>
CC: <al.williams@awce.com>, <usbwifi2024@gmail.com>, <zenmchen@gmail.com>
Subject: Re: [PATCH rtw-next] wifi: rtw89: Add support for TP-Link Archer TX50U
In-Reply-To: <20260320093122.6754-1-zenmchen@gmail.com>
References: <20260320093122.6754-1-zenmchen@gmail.com>
Message-ID: <af7e6c57-1702-4c74-8bd8-addc877b73c0@RTKEXHMBS04.realtek.com.tw>
Date: Mon, 30 Mar 2026 09:45:56 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Zenm Chen <zenmchen@gmail.com> wrote:

> Add the ID 37ad:0103 to the table to support an additional RTL8832CU
> adapter: TP-Link Archer TX50U.
> 
> Link: https://github.com/morrownr/rtl8852cu-20251113/issues/2
> Signed-off-by: Zenm Chen <zenmchen@gmail.com>

1 patch(es) applied to rtw-next branch of rtw.git, thanks.

6678828eb78f wifi: rtw89: Add support for TP-Link Archer TX50U

---
https://github.com/pkshih/rtw.git

