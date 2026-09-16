Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F40637DEA3;
	Wed, 16 Sep 2026 04:39:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789533573; cv=none; b=dcWuN+X8kt6OeBgxyuVMm7UxgAQRRIlW2SYCjsDXEbpNr1rw9IFRmUeOOjYGJzJaze9s8HSaqS5Q9/O3ew148yE5CgsWIrjR2RHPtb2ylpmURK/tJZ5b/WyNrB92/jf7N/s+n+fzTIiT5reAtkz0lLpHGu//pNxHnK7oxTsVRzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789533573; c=relaxed/simple;
	bh=7jyW6x5Dembj4mVJPAXbyxoXCnn4hzRXH+Lt+USt+0c=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type; b=PVD8mtN3rse7f1m1+Yp7/J2uBDgGzQz73VtMCvxcDApgoBaUwKs8FtTzE300htAjfVddmiAtxB6SPVzc+n97ZCDtV5QQDpqXyyzar0Y4/QGk3Mxm2GliQ5CEajyA5afCI3IQBrYfIFuILw6RKvY6WmkZjfUoJvRMsD6WlG7qKtU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=l30WMeVZ; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="l30WMeVZ"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68G4dMi752086881, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1789533562; bh=kuFaR5Vjg1Wo2Z77QcLRwyuCslQ+ovFxEmY/9+uqMIk=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type;
	b=l30WMeVZqC2au807kQacdLlkZS3eer4q+roN1VNCAQyQWR9ksxcMESMa211SSGJGu
	 NayguYYAWoSDtMYWJqx4EXoSs08B4slOSG8XzI9loUFhwsuhj6nzc2PzkROUrEUv2w
	 +ArDZI21oaA24TBzI7VzJ2TU+nm/VxsxCom0iUbPOztHDXe0DyZnW5XMlDYH1NAOTw
	 7dLJFpqv+sb7bUsThmc6O7tNk3Sa6FmTeHC3V5rgVA11t8qVcA32Agjlah/3ChBj/b
	 uNdB2F+tvMHPXEpWyLcI+eKRJdEhmAPo202QvTkbVwnyNuJHMQNVHNPnHZL3IaLP5+
	 nV02Hz6PIEltw==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68G4dMi752086881
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 16 Sep 2026 12:39:22 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 16 Sep 2026 12:39:22 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS06.realtek.com.tw (10.21.1.56) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Wed, 16 Sep 2026 12:39:22 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS06.realtek.com.tw
 (10.21.1.56) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.49 via Frontend
 Transport; Wed, 16 Sep 2026 12:39:22 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Mehmet Fide <mehmet.fide@gmail.com>, Ping-Ke Shih <pkshih@realtek.com>
CC: Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	<linux-wireless@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<mehmet.fide@screeningeagle.com>
Subject: Re: [PATCH rtw-next v3 1/3] wifi: rtw88: usb: bound what the driver feeds the after-DTIM queue
In-Reply-To: <20260910081716.769081-2-mehmet.fide@gmail.com>
References: <20260910081716.769081-1-mehmet.fide@gmail.com> <20260910081716.769081-2-mehmet.fide@gmail.com>
Message-ID: <6d7ffef3-bd00-438c-8cc2-4db28995d2f4@RTKEXHMBS06.realtek.com.tw>
Date: Wed, 16 Sep 2026 12:39:22 +0800
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Mehmet Fide <mehmet.fide@gmail.com> wrote:

> From: Mehmet Fide <mehmet.fide@screeningeagle.com>
> 
> Frames routed to the high queue are transmitted right after DTIM beacons
> only, inside the ATIM window, while they wait in the shared TX page pool.
> The driver puts no limit on how many it hands over, so as long as one
> station dozes, any sustained broadcast or multicast traffic outruns the
> drain and empties the pool: measured on an RTL8822BU AP with a single
> client in power save and ~40 frames/s of mDNS chatter, the free page
> count at 0x240 goes from 1803 to 16 in about 100 seconds and stays there
> for as long as the traffic lasts. From that point every other transmit
> queues behind the backlog, authentication responses arrive too late for
> anyone to join, and the reserved page download fails ("error beacon
> valid"). The AP keeps beaconing and only a reboot recovers.
> 
> Feed the high queue through a small budget that refills below the
> measured drain rate (about 3 frames per DTIM, ~15/s at dtim_period 2 on
> the default 2 TU ATIM window); whatever exceeds the budget leaves on its
> access category queue right away. The high queue backlog is now bounded
> by the burst size under any load, so the page pool cannot run dry, at
> the price that a dozing station may miss part of a broadcast storm.
> 
> Signed-off-by: Mehmet Fide <mehmet.fide@screeningeagle.com>
> Acked-by: Ping-Ke Shih <pkshih@realtek.com>

3 patch(es) applied to rtw-next branch of rtw.git, thanks.

04cc8c59a3d7 wifi: rtw88: usb: bound what the driver feeds the after-DTIM queue
185971f1b4eb wifi: rtw88: usb: only let the frames a dozing station needs use the after-DTIM queue
cf8b516f6765 wifi: rtw88: widen the ATIM window while an AP interface is up

---
https://github.com/pkshih/rtw.git

