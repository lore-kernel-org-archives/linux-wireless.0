Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE3DA3C07A
	for <linux-wireless@vger.kernel.org>; Sun,  2 Aug 2026 01:49:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785635389; cv=none; b=kXOC8dPgnDqSlrQZW09hQKyamXlILALYY5GxGQaBrzqhOOGHAyG70Lv+vevvWv8bJyAnDxC1OhG/E8dtIxjjba0MfRkEnO7XS0G+gVuB/2/DiVsqnqDMg+J7XNa5/bT8uTBmMQgZ9Yk/Tzywd9LGOuRZlXFpR5Gi/4K7pEvmEwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785635389; c=relaxed/simple;
	bh=mFblfulr7/qnqagG8sOVsGYydo+7yTZIMt/02oDH3yo=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type; b=KVlXZUD6Ia6mgzMpceizoQEnWVSKQ0pWs6IomZ/5c8i8C/EoWyf2HIS7mOi7gJaylKk9j4V8pLeR5I8wUnrnjhfGgU90gP39quWuUqddndfx9YsyFaYD2qhjnO2KUuol86B30KwtIXnioW+BuW7v8ro0am+31UjNBd8u9LzVQ5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=MsMoKhRv; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="MsMoKhRv"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6721njqjF3077204, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1785635385; bh=b3DMCa0eyLaNDzqH1+gFKvXIG+e+aFCH/535Dh1pBvM=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type;
	b=MsMoKhRv5FF5Zo+00y2qsRP52RcdVhPHGbzkseVUWq7lEFqlCbNvoIq3kflR8i5Dv
	 Ta6+DYKHVFAJ8KvSPbEK00iFibzEFDTVKla4gwgcue/fCzCSSDb/00Oh5zE7iIyxAx
	 hOJsFtXbwabPHyBkCjVCZ/CSeoVqHxUufxkXpHRilOi6pXFOsBMc24ZFmHlSb6ihGo
	 n4YuTYy7VDdd0t5R+/S29NSBOQ+fWQBjpc1K2kRP4Kd2EbNALhDLR9Yq6NiBn6Uv1Q
	 nSCEkSSV0iV0XxQ9P8WC4xPY5/1FtXlvmS6UgZrhN6vNRoOYTL+Zl7onJGD+zpgiVv
	 HecSkQHR+XedA==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6721njqjF3077204
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Sun, 2 Aug 2026 09:49:45 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Sun, 2 Aug 2026 09:49:45 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS05.realtek.com.tw (10.21.1.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Sun, 2 Aug 2026 09:49:45 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS05.realtek.com.tw
 (10.21.1.55) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17 via Frontend
 Transport; Sun, 2 Aug 2026 09:49:45 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Ping-Ke Shih <pkshih@realtek.com>, <linux-wireless@vger.kernel.org>
CC: <dian_syuan0116@realtek.com>, <phhuang@realtek.com>
Subject: Re: [PATCH rtw-next v2 1/3] wifi: rtw89: refine RX filter configuration for WiFi 7 generation
In-Reply-To: <20260729124354.3231368-2-pkshih@realtek.com>
References: <20260729124354.3231368-1-pkshih@realtek.com> <20260729124354.3231368-2-pkshih@realtek.com>
Message-ID: <bd02e4bf-662b-4055-b3d9-18ec5d3e0020@RTKEXHMBS05.realtek.com.tw>
Date: Sun, 2 Aug 2026 09:49:45 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Ping-Ke Shih <pkshih@realtek.com> wrote:

> From: Dian-Syuan Yang <dian_syuan0116@realtek.com>
> 
> When an AP interface is registered and starts AP, mac80211 calls the
> configure_filter() to clear B_AX_A_UC_CAM_MATCH and B_AX_A_BC_CAM_MATCH
> so that frames from un-associated stations can be received. However, for
> a dedicated AP interface created via iw command, configure_filter() is
> only triggered on the initial AP startup. Since the interface remains up
> even after hostapd stops, and it isn't triggered again on later restarts.
> Additionally, each AP start causes IPS leave, reverting the RX filter to
> its default value.
> 
> For WiFi 7 chips, the default value is hardcoded in rx_fltr_init_be(),
> so the reverted value does not match hal.rx_fltr. Therefore, refine
> the behavior of WiFi 7 chips to align with the WiFi 6 implementation.
> 
> Signed-off-by: Dian-Syuan Yang <dian_syuan0116@realtek.com>
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>

3 patch(es) applied to rtw-next branch of rtw.git, thanks.

304720870f4c wifi: rtw89: refine RX filter configuration for WiFi 7 generation
58c0d447c53b wifi: rtw89: fix scan offload version check logic
d946a4e03116 wifi: rtw89: change scan offload format to V3 for WiFi 7 IC

---
https://github.com/pkshih/rtw.git

