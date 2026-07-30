Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E75F368277;
	Thu, 30 Jul 2026 02:28:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785378515; cv=none; b=lemY9GLNsUoFZ1YopzgWRZOS5NDSL6N/EMHV7BnhVSuDxuHi4QNPTcQa8fKwtLhC18OAYaOLlGnWHkl+WfccU00IVMHxuarCWTISFCpTTheaRn3YRFHkOPMQsE5Kr7g0jgPLyUrHokpfiBy6LrcmyIpRJ75jBxT3zlPFvdPMIrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785378515; c=relaxed/simple;
	bh=SgYHEX86klePEVqhKLsVCmQV9uTdPvss/Gy5mM6FaR0=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type; b=lVb6bMqf0uVrajGIovBRbi1BRH7actSMyMGPfQ+CYhOusE/F1Sp9k1szW7TtWI/Rkx4YGebGXmqegCvv4SH0FxWijsF07KpvDJ0VrcQK/dQYIhx0i/cUJEJmohrwR2PzElXpEIjbpadj0Dwer9sABOXzO80t+x8epQsjC8AvKKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=O7syspbd; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="O7syspbd"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 66U2SU8C0901718, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1785378510; bh=AZ8+tXHQlEoB5GVgujpNvosaT1sT86TZNNNfA8ZA8UI=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type;
	b=O7syspbdTY4FSTiHOn45S72g62XuYxd4QBJHSDwylEWM4PQFRRTNiN7cL8tGgyVXk
	 AuPEPMprE9kXW8KHHloqUiRcR1+VluMfDrVTQm975GiyB0Oq8Mu1v8eXxgyhk+Og4U
	 TNLSI02iGwg47i6dyB32FULTMQ1z17rbiCZiNBxx8bND4YuG4mJ4dZAZOFD7ARxlSt
	 F+pUbSizPRgM74FXRp2Tsn3ABsYeRmQoEtHRaq/Sfc5h1K+trWNX2/ua/6PyhaVl3l
	 iQ7q7M+0+q8jtiEM115y2Dq1ITbLKOWeWJERh4QuU2xbJwYaAmqOHS/fxuLxYzP9gd
	 FBSLh5UxeDd+w==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 66U2SU8C0901718
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 30 Jul 2026 10:28:30 +0800
Received: from RTKEXHMBS01.realtek.com.tw (172.21.6.40) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 30 Jul 2026 10:28:30 +0800
Received: from RTKEXHMBS03.realtek.com.tw (10.21.1.53) by
 RTKEXHMBS01.realtek.com.tw (172.21.6.40) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Thu, 30 Jul 2026 10:28:30 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS03.realtek.com.tw
 (10.21.1.53) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17 via Frontend
 Transport; Thu, 30 Jul 2026 10:28:25 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Abdun Nihaal <nihaal@cse.iitm.ac.in>, <pkshih@realtek.com>
CC: Abdun Nihaal <nihaal@cse.iitm.ac.in>, <linux-wireless@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] wifi: rtlwifi: pci: fix error path in rtl_pci_probe()
In-Reply-To: <20260723120118.145383-1-nihaal@cse.iitm.ac.in>
References: <20260723120118.145383-1-nihaal@cse.iitm.ac.in>
Message-ID: <b68c0785-bc4d-42f5-901f-d41ddebcdb5f@RTKEXHMBS03.realtek.com.tw>
Date: Thu, 30 Jul 2026 10:28:25 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Abdun Nihaal <nihaal@cse.iitm.ac.in> wrote:

> In the last error path in rtl_pci_probe(), the cleanup functions are
> skipped due to a wrong goto label. Moreover, the successful call to
> rtl_init_rfkill(), ieee80211_register_hw(), rtl_debug_add_one() have to
> be reverted. Fix this issue by updating the labels and adding the
> relevant cleanup functions to the last error path.
> 
> Fixes: 0c8173385e54 ("rtl8192ce: Add new driver")
> Signed-off-by: Abdun Nihaal <nihaal@cse.iitm.ac.in>
> Acked-by: Ping-Ke Shih <pkshih@realtek.com>

1 patch(es) applied to rtw-next branch of rtw.git, thanks.

3c2999d13eeb wifi: rtlwifi: pci: fix error path in rtl_pci_probe()

---
https://github.com/pkshih/rtw.git

