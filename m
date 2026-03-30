Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCD6E175A81;
	Mon, 30 Mar 2026 01:50:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774835404; cv=none; b=ncpdjLOcHaODIuuv3HRWqc9EMPpFVcOkytHKCv4zk/5LXtoAM6ZEiM8a3Plk32qpyhf3318/NS/d2RDaCkVzuSzh+p11t9v12LTKrtb7fB67kQwfjjtr6R/ussQ8zH78DydbL4ixzDd+3MVBHXrq0DzZGhUZrkT11o8k4vOcVzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774835404; c=relaxed/simple;
	bh=1QIsGMrx1bhOXLEeJ726K5mGCREoBKWGy/hDUgPo8uE=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type; b=oTnY9JND6agqDVvIRXYQ2nCrLVSQ0CwUQrZSmGPCJb4u8Z8ZKxem1gpQG5bAgeGjebQhqG5ni8UyO0bECtZnVZbYITmSe8GA+2fe94bk3X4WS/sC8t6oI8aJCG3c5rcWDghlPcbB6W5F6LJgq3SwkCMugNHVd88nTIxa9f4CBWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=DELecomo; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="DELecomo"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 62U1nVaO5073478, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1774835371; bh=geXm3FemlH8eRdmyDg97vzDqCwXLuW58EwxVJhu71Lg=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type;
	b=DELecomoOGjR+hRCBSeWGeBX8QZ16SoR23DTVlTkKrbZAg8IzZur3srvG5rqhedXt
	 ZwpNSk++itVSoR1aRr/cWrGZy9JnhB1Ba67Fv9qsf2KhD31fJnEVqaBLXmV9WEqGjL
	 ElibVl0GGToLck1wmkQIkh7hVBG5EUAErg+3Wt6u5jpKPpjbfnqukbWwYxCa+4nB47
	 ienAeD1QNdfEw5QLr9y8xV7GQwJZ+G4/3N9M14jcTyvwD7/aLDeA+HDSbNt0WkBaqO
	 YMsBWF6gtNbp8wOkaKvvoQsM740dbn0s/sLCRIazu0K6yTk2jMjWTjnm7UKXCBD1yA
	 v2PZPrhYfaySg==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.26/5.94) with ESMTPS id 62U1nVaO5073478
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 30 Mar 2026 09:49:31 +0800
Received: from RTKEXHMBS04.realtek.com.tw (10.21.1.54) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.10; Mon, 30 Mar 2026 09:49:30 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS04.realtek.com.tw
 (10.21.1.54) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1748.10 via Frontend
 Transport; Mon, 30 Mar 2026 09:49:25 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Alexey Velichayshiy <a.velichayshiy@ispras.ru>,
        Ping-Ke Shih
	<pkshih@realtek.com>
CC: Alexey Velichayshiy <a.velichayshiy@ispras.ru>,
        Yuan-Han Zhang
	<yuanhan1020@realtek.com>,
        Kalle Valo <kvalo@kernel.org>, <linux-wireless@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <lvc-project@linuxtesting.org>
Subject: Re: [PATCH rtw-next] wifi: rtw89: phy: fix uninitialized variable access in rtw89_phy_cfo_set_crystal_cap()
In-Reply-To: <20260323140613.1615574-1-a.velichayshiy@ispras.ru>
References: <20260323140613.1615574-1-a.velichayshiy@ispras.ru>
Message-ID: <4345cdc5-0ffe-4836-ac50-74ee8f08090c@RTKEXHMBS04.realtek.com.tw>
Date: Mon, 30 Mar 2026 09:49:25 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Alexey Velichayshiy <a.velichayshiy@ispras.ru> wrote:

> In the rtw89_phy_cfo_set_crystal_cap() function, for chips other than
> RTL8852A/RTL8851B, the values read by rtw89_mac_read_xtal_si() are
> stored into the local variables sc_xi_val and sc_xo_val. If either
> read fails, these variables remain uninitialized, they are later
> used to update cfo->crystal_cap and in debug print statements. This
> can lead to undefined behavior.
> 
> Fix the issue by initializing sc_xi_val and sc_xo_val to zero,
> like is implemented in vendor driver.
> 
> Found by Linux Verification Center (linuxtesting.org) with SVACE.
> 
> Fixes: 8379fa611536 ("rtw89: 8852c: add write/read crystal function in CFO tracking")
> Signed-off-by: Alexey Velichayshiy <a.velichayshiy@ispras.ru>
> Acked-by: Ping-Ke Shih <pkshih@realtek.com>

1 patch(es) applied to rtw-next branch of rtw.git, thanks.

047cddf88c61 wifi: rtw89: phy: fix uninitialized variable access in rtw89_phy_cfo_set_crystal_cap()

---
https://github.com/pkshih/rtw.git

