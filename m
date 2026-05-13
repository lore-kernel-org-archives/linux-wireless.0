Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB2EB356769
	for <linux-wireless@vger.kernel.org>; Wed, 13 May 2026 03:53:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778644398; cv=none; b=TCm1y4WxkG35F3ICaFY5pP+Q8wQvIk8vvvmwfX4hZuHKtlHmYbZjA6etWgAFGY4S25RQASznmXza+KpcUYJ2+F6WpadKC8Y1yG+IixZP3QteN/9haW1JifAB39Zgfoa5ZocdPSiNW324gtxkh4uTBdKREdMbdJOkqXyzFV/263M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778644398; c=relaxed/simple;
	bh=Ab5nNAx8DBQSkiRo2hsYdWjmWD2vijAjwIIx1P7HlIc=;
	h=From:To:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type; b=MswTWR0cCwNKFBhKy1cboqQKSJoWhy8LJGVql0XhSkTXrCzqsLh2nmm/PBWg0XWiwh4OFN9Gbk4BkcyIVXStwQBclGXKSs1+aaKGC1gLlgb8BEtrsIR7p58p/JyCH/SqdvKuYlxvFlzZxvcyxqNlf4fA1kPro3ZyMQ2+RehpHFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=lfQaZv0G; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="lfQaZv0G"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 64D3rEohD487520, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1778644394; bh=ZTwaJ2t6m+38xY1apsMfhlBLf3kglfO74Ei2+E2JAxU=;
	h=From:To:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type;
	b=lfQaZv0GwPuYklKz6UoxulWz2Os/6/vLDGu+eVrXRcNBOim3zr95ijgkCM+rXK2BY
	 wZ7KTi4R2SRJh9kQOhDLVS0SgFA3gfeK8Srt0Oj9T9PGuuSVdau6DQ2X/aSzHeWg3m
	 ivCURUkbG3JqXp5RLTnQItL99gvOoTPXuP2JZBME74h459m9EE32QKoUpAcTQu/mtA
	 GBp6jkcH3GnWKowTsxlxUT/qLT/glf3ukuEjlbxtjyJgbc0/xzvY9yg47cHYkol88F
	 fZOMktg45xd1Ktfv2iytV+fSbwmW4+QeEMJlEo4pW6sGHMwaHgITXZJRR7oj0VMLdV
	 4jBblFkIzZNpA==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.27/5.94) with ESMTPS id 64D3rEohD487520
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-wireless@vger.kernel.org>; Wed, 13 May 2026 11:53:14 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 13 May 2026 11:53:15 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS05.realtek.com.tw (10.21.1.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 13 May 2026 11:53:14 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS05.realtek.com.tw
 (10.21.1.55) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17 via Frontend
 Transport; Wed, 13 May 2026 11:53:14 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Ping-Ke Shih <pkshih@realtek.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH rtw-next 01/14] wifi: rtw89: add AMPDU to radiotap
In-Reply-To: <20260506131000.1706298-2-pkshih@realtek.com>
References: <20260506131000.1706298-1-pkshih@realtek.com> <20260506131000.1706298-2-pkshih@realtek.com>
Message-ID: <86f5cdbb-ced9-4b14-839b-f95ac0b1ce53@RTKEXHMBS05.realtek.com.tw>
Date: Wed, 13 May 2026 11:53:14 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Ping-Ke Shih <pkshih@realtek.com> wrote:

> The RX desc can report current frame is in AMPDU, but no way point out
> if it is a last one in AMPDU. Update AMPDU reference only.
> 
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>

14 patch(es) applied to rtw-next branch of rtw.git, thanks.

756dc69e5639 wifi: rtw89: add AMPDU to radiotap
9535e2279ba9 wifi: rtw89: add VHT beamformed to radiotap
a371139d8be9 wifi: rtw89: SNIFFER_MODE bit along IEEE80211_CONF_MONITOR
c847d0c14c47 wifi: rtw89: phy: define PHY status IE length for generations
847758f15f46 wifi: rtw89: phy: enable IE-09/IE-10 PHY status report for monitor mode
bc1006b68b89 wifi: rtw89: move HE radiotap to an individual function
236b25d9308d wifi: rtw89: fill VHT radiotap
16a1becdd1fb wifi: rtw89: fill HE-SU/HE-TB/HE-MU/HE-EXT_SU radiotap
41d78f3f3596 wifi: rtw89: debug: make implementation of beacon_info entry in order
cd92d278c186 wifi: rtw89: add debugfs entry of monitor mode options to capture HE-MU packets
884495c39de1 wifi: rtw89: phy: check length before parsing PHY status IE
48402f736f93 wifi: rtw89: phy: skip trailing 8-byte zeros of PHY status IE for RTL8922D
0805ddc2fdb6 wifi: rtw89: phy: support PHY status IE-09 GEN2 for RTL8922D
f77199a0cf66 wifi: rtw89: check skb headroom before adding radiotap

---
https://github.com/pkshih/rtw.git

