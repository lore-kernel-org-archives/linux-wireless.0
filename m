Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99F8B395240;
	Wed, 13 May 2026 04:00:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778644803; cv=none; b=ZfqBlhVPrSqMTFqZXw/Udmt5gqtpeBAuIGIi2vryJs7xT/Svru2doyrvF5/u95CvY/kfY7FUAadDtQjIq0omlexaNeUhQ5Sn7gofappsU6L7W34h4Qz3KlCdyb9zfVXMakCyKMBwIjtAmRFBW0Hw9W2IBsaO1udiKriSCnYiwO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778644803; c=relaxed/simple;
	bh=QtJjE+CbmiE+OpG576qgFslS6Ex7K3H3jgtnZrcS5fQ=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type; b=QZTfv2KuJr7bblIcc+7GdzAptB2iCRUNr9wRTpR6HFMZaL9hCPqM2mVX1DyIAqd+rvYKyLW2TI0PvEvhilFMNbLECui1HqbGWqBSPxM3oQnDMVH9NPtWsqFMCiXX9qdQofiUibY0w7LRnNuIysPCGNcHFeTxJyZcdOUiPQIvQNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=ZYveWh0z; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="ZYveWh0z"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 64D3xlnW7489190, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1778644787; bh=UVbJ9kUDDMSfMp4LwhYTXHQ4kK7xEPdFRSuI8X7367g=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type;
	b=ZYveWh0z9NX13Me0kAdXSULCkhAwzXSYhc8hAFFSRljMx16vn+qMfTs1fL4jTmWks
	 DvkSyI4T1moKiaRaV6niML7Okzie+qMgaXSab/km/tdLDPx7jxmqCMWjrgejzp6JHI
	 8vRd113GXG3uiYVlOew7H3ZasxelkzKGcyQDCC5j8sg9WOnVOHEgnYqgG1Ux7Zq4nV
	 59NoHG3yPUJWyWv7Tf+Xaey7jNK9Voh/GQqOxuHWOIdrNpK9jHhsvSQLs8Z5Ld7sHk
	 fquGp4sz+U5CjXzqqgJG3sGWHjlEYOcpJ8Gda7W4lXBEy4Z3ovZXh8l/pXR3I77XZc
	 NtgFT5l007nNg==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.27/5.94) with ESMTPS id 64D3xlnW7489190
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 13 May 2026 11:59:47 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Wed, 13 May 2026 11:59:48 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS06.realtek.com.tw
 (10.21.1.56) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.17 via Frontend
 Transport; Wed, 13 May 2026 11:59:42 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Martin Kaiser <martin@kaiser.cx>, Ping-Ke Shih <pkshih@realtek.com>
CC: Bitterblue Smith <rtl8821cerfe2@gmail.com>,
        <linux-wireless@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Martin
 Kaiser <martin@kaiser.cx>
Subject: Re: [PATCH v2] wifi: rtw88: remove rtw_txq_dequeue
In-Reply-To: <20260507082238.889656-1-martin@kaiser.cx>
References: <20260507082238.889656-1-martin@kaiser.cx>
Message-ID: <6a7f8077-3c62-4340-93a7-624aba24f355@RTKEXHMBS06.realtek.com.tw>
Date: Wed, 13 May 2026 11:59:42 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Martin Kaiser <martin@kaiser.cx> wrote:

> Remove the rtw_txq_dequeue helper. It's a wrapper around
> ieee80211_tx_dequeue with just one caller.
> 
> Call ieee80211_tx_dequeue directly in rtw_txq_push. There's no need to
> fetch txq for every frame, we can do this once outside of the rcu lock.
> 
> Make the loop variable i unsigned long, it should have the same type as
> frames.
> 
> Signed-off-by: Martin Kaiser <martin@kaiser.cx>
> Acked-by: Ping-Ke Shih <pkshih@realtek.com>

1 patch(es) applied to rtw-next branch of rtw.git, thanks.

4c13e00cc679 wifi: rtw88: remove rtw_txq_dequeue

---
https://github.com/pkshih/rtw.git

