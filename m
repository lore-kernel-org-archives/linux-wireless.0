Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 454BF379C42;
	Fri, 17 Jul 2026 03:44:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784259883; cv=none; b=H6nkRULpd52qzKKOJMldJhDXh7mJZf30he4NqWtWchK8lP071s5IcjbZYStQ/rFLPAJ2a811nIn5pnqRHleDgCTLWRi8fXbmBskTb/Y/PE0yLtVQLcMwfaZZlUc+Lt2GegyfQ6coWkvS31anwwL6KPH3rxd6IpPiK2EZecHpo1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784259883; c=relaxed/simple;
	bh=yLqhk80SiqLC/+rFg78Q9VDwlc2DoWvB0XGPNLypAuI=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type; b=OXUjs193szbk1QuXXQu1vWj90BctgKq2bga+rQiep5bNlWf2QoGRAXYBk3p+NDvbzHAHbwXihaoyQNTsd04Gs7+BxxZ2fgrwFzTl5GmWkiiojbdcYwMzFBa3qVCUpWU1E7VUabGvhmNNfhnQNTcwpCt39yfTAtsrouJ3AfMMbww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=r+6NCjg7; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="r+6NCjg7"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 66H3iVuJ54096292, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1784259872; bh=uP/i9uGfcKTR6JL1xVj14JNe2zMFQW0xTfbOthU/8N4=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type;
	b=r+6NCjg77IbqFjlI6fREXJnfr14QPCVTPF4i7k+dzBzuyAcyslQ+HPGsPf777sA3t
	 MJGonjPUfiII4NU9LjLtU9JPrbtcuixC8hsyaE9w0rdO5xvxQKo4tLFMvcOz12FZ9J
	 pBVfPRNU8mZGzi/+H8tFzSPUDE6LiWqaoZ8nbDDzqaTSTFzLvhZnkdvY1IOdsC2+57
	 R7x1IL+CsKsquYKM0BYZfyU0Aq4ga9TGyxctke7kEa8wl9ouBsWv1oKjH5M5isUIvW
	 GYtrW8g+Qbs7JvQBOA5gkKpi2SFpkU2WAfWvrpD9dKUSTQpZV9ZMDgauPZ43A/jUoV
	 ga1OHNv2rezRg==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 66H3iVuJ54096292
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Fri, 17 Jul 2026 11:44:32 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 17 Jul 2026 11:44:32 +0800
Received: from RTKEXHMBS03.realtek.com.tw (10.21.1.53) by
 RTKEXHMBS05.realtek.com.tw (10.21.1.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 17 Jul 2026 11:44:32 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS03.realtek.com.tw
 (10.21.1.53) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17 via Frontend
 Transport; Fri, 17 Jul 2026 11:44:31 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <zhaoguohan@kylinos.cn>, Ping-Ke Shih <pkshih@realtek.com>,
	<linux-wireless@vger.kernel.org>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] wifi: rtw89: wow: fix unsupported cipher debug messages
In-Reply-To: <20260715060813.476245-1-zhaoguohan@kylinos.cn>
References: <20260715060813.476245-1-zhaoguohan@kylinos.cn>
Message-ID: <6a555206-dd8e-42f6-a717-ca3d7ce44a5c@RTKEXHMBS03.realtek.com.tw>
Date: Fri, 17 Jul 2026 11:44:31 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

zhaoguohan@kylinos.cn wrote:

> From: GuoHan Zhao <zhaoguohan@kylinos.cn>
> 
> Correct two WoWLAN debug messages to say "unsupported cipher".
> 
> Signed-off-by: GuoHan Zhao <zhaoguohan@kylinos.cn>
> Acked-by: Ping-Ke Shih <pkshih@realtek.com>

1 patch(es) applied to rtw-next branch of rtw.git, thanks.

73aecc221e7d wifi: rtw89: wow: fix unsupported cipher debug messages

---
https://github.com/pkshih/rtw.git

