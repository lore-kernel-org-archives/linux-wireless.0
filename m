Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE96DEEC3
	for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2026 01:56:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790733406; cv=none; b=LNaPwXQWQpEDkuo32Quk0yGhkHwx7eT1c5P1fLFpobPuHx+uD+vwui0mRYc+kGlPVz7tKxSdAgZtQNJEqnMc0kB62tPIXfB7ZiOwnv3ecDyGOZeJGbMBvtDcAxx/X3OUsUEodA/4QeCOX5xvXIEtxmwt7g4cQc4/J2u8XsbmbpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790733406; c=relaxed/simple;
	bh=zSeQEa48qDxDZdhTC6R2Csej1tp6iDv/IrOb/4iqqhU=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type; b=NB413xEBSBOzKB+K3PBDfZDjOImBtRYfJR3IwR76t7G4sR2vWtrVN/joHpcGucAzE6InuBYShBAFpgT9oOuNPAR3APpp4vwanzK5KmB3y4u4m7OREqDwqsQuEAeyhz85xgNxBzyFgfQ7M3Lw+Rmox4NUjQ9ePh0JRd2vu4/RCHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=C2gLVFsd; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="C2gLVFsd"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68U1ugGcB1759117, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1790733402; bh=cj4HB6awrysrrHzLgHSCSoj2U6JvJHXcpoBrJn4tYgc=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type;
	b=C2gLVFsdaEBMqSG1oGiHtDpEzge+iDZY0jGTKGYRR2Gzhzxuu82/5/v0GNzd2yBi5
	 m68uduAWfBr8hDNODY/e1oGVh0KxDlvR8Vcmyx6a5MjPvQOqmkmEkOQl6aLAAf8D8W
	 f/q0DqlSBpceFb93prXLQIOXkaJrqndcoBKv/S9DwYL0vfhvdoE8rAAXgGB7jYswbU
	 6UJCcxtxOe/qyvpOCdvczH7l4AWptn1z19umAEbD61NhChe/SJgHN38y+nxjTmH5Pr
	 whCUegQTKwFn/rHGTwwDchEHLEcBaBc+ayEZc/ONs6wosDD28usEWHMd/tfPUjTrbW
	 r9zm8YppUcJXQ==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68U1ugGcB1759117
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Wed, 30 Sep 2026 09:56:42 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 30 Sep 2026 09:56:42 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS06.realtek.com.tw (10.21.1.56) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 30 Sep 2026 09:56:42 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS05.realtek.com.tw
 (10.21.1.55) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49 via Frontend
 Transport; Wed, 30 Sep 2026 09:56:42 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Ping-Ke Shih <pkshih@realtek.com>, <linux-wireless@vger.kernel.org>
CC: <kevin_yang@realtek.com>
Subject: Re: [PATCH rtw-next 1/6] wifi: rtw89: fw: duplicate recognized firmware elements
In-Reply-To: <20260923054505.43329-2-pkshih@realtek.com>
References: <20260923054505.43329-1-pkshih@realtek.com> <20260923054505.43329-2-pkshih@realtek.com>
Message-ID: <d3924e77-51b6-408e-aef3-537270091774@RTKEXHMBS05.realtek.com.tw>
Date: Wed, 30 Sep 2026 09:56:42 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Ping-Ke Shih <pkshih@realtek.com> wrote:

> The firmware file contains variant elements for variant hardware, and
> currently whole firmware content is persistent. However, RTL8922DE has many
> variants and firmware file become grown to over 4MB, but actually size of
> necessary duplicate elements are about 1.0MB.
> 
> To reduce memory usage, duplicate recognized firmware elements as
> persistent memory, and will release firmware by next coming patch.
> 
> However, firmware for early chips doesn't have many variant elements, and
> no need to duplicate memory for the purpose, so do it only if firmware
> size is over 2MB.
> 
> Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>

6 patch(es) applied to rtw-next branch of rtw.git, thanks.

504bbf01735f wifi: rtw89: fw: duplicate recognized firmware elements
f31a3a3afab1 wifi: rtw89: fw: release firmware after recognizing firmware elements
0ba6a2d26fef wifi: rtw89: fw: duplicate firmware suit data by vmalloc to reduce memory fragment
86e0056aaaf3 wifi: rtw89: led: check if board variant assigns led desc
af5905e22a43 wifi: rtw89: support variants of FW elements
e55ca4e813e5 wifi: rtw89: 8852cu: take board ID 1 for FW elements 28de/2432

---
https://github.com/pkshih/rtw.git

