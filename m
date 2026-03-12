Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 174611F7575
	for <linux-wireless@vger.kernel.org>; Thu, 12 Mar 2026 03:01:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773284462; cv=none; b=PNLDEmzNqxzhUJ8ILcuAcX6s1Ec9+t3t+jS/2R6dsZ5xHKk0H4By4zgsCf/IbL3EQlA3CYitrBJWa5pkt7fmIz01IDC+CsKyarf1jnW8mcfPTlccTnPCMqeE2M67rK+VkawDzoiGxOI9C0dxTYgotkgn9SxDHJm7BiXw7m1VpWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773284462; c=relaxed/simple;
	bh=6+sPtIulJbJpKhzrNO90hYwsK4WsUq3sGROgzh24epc=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type; b=MvgCUsWqvWqty/BK3RrOPnZKPOzHneRr3qL2qNFufxzgegSaI4j3A4Z0wJd+xfRhDfZ8RQuSmJWz0YYgJkgDkM1LcQXWUj0SZqKwWYADNebs/Tn9ObooJSLRUMbaQHTvYj6zRrIC2IaeskWrQOXsmrr3QRdVy1GqmUtjwPoC2Yw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=VDLoswVB; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="VDLoswVB"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 62C30weF61719630, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1773284458; bh=PlLszDo29GnBDPrOtN4N6qbbe5lt9V6uB7H214e7DlY=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type;
	b=VDLoswVBOZkGOJNVnwnKzkEGHkHRSWG4BHeWCPv7ZOzKt+XyjcgCstSnvQahoYjkD
	 8a6EtJ09lMTsV5KcDJsXq8PvPDSjzntZgigis+syPlWl8KnC8LKWFWqpci1A/S2lvI
	 e6wzLcqLuo+wnVFE+xO6acKVEs5kKIb3gli1hHavMlrMjmVtTVP3IZKSqADZBU4sqe
	 Or0ttwWPLv2yW7Z1G1RpCrVggSPPJZQK1cCLPB76/JeUUun1ZebquqotwhobWBf3R4
	 3UtlT9djOsfgTQK/2td7CciKWDHbERCKU8FH2kXJyI/Q+UPio8BsyJvv3ZqSWHXFG3
	 QlOpBx4IPZqMQ==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.21/5.94) with ESMTPS id 62C30weF61719630
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK)
	for <linux-wireless@vger.kernel.org>; Thu, 12 Mar 2026 11:00:58 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.10; Thu, 12 Mar 2026 11:00:58 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS06.realtek.com.tw (10.21.1.56) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.10; Thu, 12 Mar 2026 11:00:58 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS06.realtek.com.tw
 (10.21.1.56) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1748.10 via Frontend
 Transport; Thu, 12 Mar 2026 11:00:58 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Ping-Ke Shih <pkshih@realtek.com>, <linux-wireless@vger.kernel.org>
CC: <timlee@realtek.com>, <phhuang@realtek.com>, <kevin_yang@realtek.com>
Subject: Re: [PATCH rtw-next 01/13] wifi: rtw89: mac: finish active TX immediately without waiting for DMAC
In-Reply-To: <20260310080146.31113-2-pkshih@realtek.com>
References: <20260310080146.31113-1-pkshih@realtek.com> <20260310080146.31113-2-pkshih@realtek.com>
Message-ID: <b93104ce-2145-4faf-a128-fb94edd5fd58@RTKEXHMBS06.realtek.com.tw>
Date: Thu, 12 Mar 2026 11:00:58 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Ping-Ke Shih <pkshih@realtek.com> wrote:

> Currently active TX only finishes after ensuring PCIE and DMAC become idle.
> However, the waiting time might be long. Since the packet is already
> transmitted over the air, update the registers to finish active TX
> immediately, regardless of the PCIE/DMAC status.
> 
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>

As internal test, this will affect performance, so drop this. Still keep
remaining patches.

Set patchset state to Not Applicable

[rtw-next,01/13] wifi: rtw89: mac: finish active TX immediately without waiting for DMAC

---
https://github.com/pkshih/rtw.git

