Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=211.75.126.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793857166;
	b=aho4mLEQIL+ZM7szM9Wq3q/Vdiq7vs0XgiI1FS3g6UYFH5cj5CtniE9jI94IOSu8f3PP
	 ynDRm2uYY/W57ejVK8SzEsTf46KjtTTHMa3aMRHkW9FElN9Q8UfOEVsOl1S/j6fsvNsas
	 qghD8Yhklx4Le8CyA91rVe2bB4U3xoiZfc0QIUSKgiyHlFQ3ZuBPi9gfDuzlSYjnzvo5w
	 4hE+HUp9G3CD48KrvJbR93gFDeAev0pMPUPEzrI5ytFJHaRW5cxjB8ss64NlgvrVtMDqy
	 pir0TScmJvjzDPBmZUInJdQQHqg6ZX83y8ckQm3JlEXHoeVbGlFU4rZ68EQk0sxeXMA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793857166;
	h=DMARC-Filter:X-SpamFilter-By:DKIM-Signature:Received:Received:
	 Received:From:To:Subject:Message-ID:Date:MIME-Version:Content-Type;
	bh=MblfcjcxVCPxFCIeKOgE8Yw23yuKQoSN9AdXHXRqoIM=;
	b=PVUvmsRaXbkOmYxOlpEISgqejHJt7gUphEN3OYjjYMyHHwjOWgFNZJ7EEXnLcLKkc9u5
	 Bv3qJa/C/Yu501aoNV+NPSU5iceTuC8lmDTAEs4sXdMELkKY7ygfeYX8kzV+fIEbDni1r
	 V88FZqu0nB16KWAWxArno+0udkVZ1k2JOL7L+bN/+8MzVU0J2tPDKHJc7sc38Hk9vml9/
	 HbX9KWflOwK37caqUgHmdCdpq8yXM1bU7APcbtmPFuT7umvZLW9rFjPE3bNPxGKlqbXK6
	 3orD0NmfTY2S+NuvSdC4udSWMyPMwrXP7k4KTNWO+xc2oRzOIHM8Bx1EFjN14IQJ+wQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=realtek.com;
	spf=pass smtp.mailfrom=realtek.com;
	dkim=pass header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=Ck0R3aXv;
	arc=none smtp.remote-ip=211.75.126.72
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9F3A606A330
	for <linux-wireless@vger.kernel.org>; Thu,  5 Nov 2026 05:39:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B9F3A606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=Ck0R3aXv
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6A55dMxdD505778, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1793857162; bh=MblfcjcxVCPxFCIeKOgE8Yw23yuKQoSN9AdXHXRqoIM=;
	h=From:To:Subject:Message-ID:Date:MIME-Version:Content-Type;
	b=Ck0R3aXvB21mHMrTT8ONIBLgGE72vu/OwWYv/hhusS8JD8iF9N/LJxgQOm4Juf9AI
	 4fQi6sz4x/uB9/RS7gafAEIMWHlxY2okikm/wiyolt/8e1U7U9yM74BWiSYSX4ThQn
	 5shfsQ2G8N7l9ExLUOOxnGC5EspLcZOHjjRTmV/iVklnSYAN0WlFr3A+hpEhsbbCnO
	 aX7cJi6dtfqhCRCnaP3bcwYmYW8LwyRBwLGCT25f2sgPb+n0tGq0NlrUM1woDQBL5w
	 4KK04CwipwFYKjxD7NnMrhUJPbpPmO9M2XdCz4W66okrFAK5xSqSx6kT5omTD+dZ2V
	 MaC5mSLyREpNw==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6A55dMxdD505778
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL)
	for <linux-wireless@vger.kernel.org>; Thu, 5 Nov 2026 13:39:22 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Thu, 5 Nov 2026 13:39:20 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS06.realtek.com.tw
 (10.21.1.56) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.56 via Frontend
 Transport; Thu, 5 Nov 2026 13:39:20 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: <linux-wireless@vger.kernel.org>
Subject: pull-request: rtw-2026-11-05 (for -rc)
Message-ID: <53f38754-ecd3-452f-b2c6-a42164a2e9e4@RTKEXHMBS06.realtek.com.tw>
Date: Thu, 5 Nov 2026 13:39:20 +0800
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain

Hi Johannes,

A pull-request of rtw to wireless tree.

The drivers/staging/rtl8723bs was removed, and people did migrate to rtw88.
However, the AP mode for SDIO devices doesn't work well, because high
queue (for broadcast/multicast) TX back-pressure causes TX stuck. That
makes bad user experience comparing to staging driver.

This pull-request only contains two patches, one is to move shared code,
and the other uses it. One question is that first one doesn't have a Fixes
tag. If this isn't good, I can squash two into one. Please let me know
the better way.

Thanks
Ping-Ke

---

The following changes since commit c4328134f3f7c2ce141121a8f82a5ec0cc8a709c:

  Merge tag 'wireless-2026-11-02' of https://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless (2026-11-04 15:00:50 +0100)

are available in the Git repository at:

  https://github.com/pkshih/rtw.git tags/rtw-2026-11-05

for you to fetch changes up to ff4d3699bf386b35b3d713a59d705f0cd5a49107:

  wifi: rtw88: sdio: limit the high queue to DTIM delivery (2026-11-05 12:25:19 +0800)

----------------------------------------------------------------
rtw patches for -rc

Fix TX stuck for rtw88 SDIO devices under AP mode.

----------------------------------------------------------------
Luka Gejak (2):
      wifi: rtw88: move the bmc high queue decision to tx.c
      wifi: rtw88: sdio: limit the high queue to DTIM delivery

 drivers/net/wireless/realtek/rtw88/main.c |  3 ++
 drivers/net/wireless/realtek/rtw88/main.h |  5 +++
 drivers/net/wireless/realtek/rtw88/sdio.c |  3 ++
 drivers/net/wireless/realtek/rtw88/tx.c   | 59 ++++++++++++++++++++++++++++
 drivers/net/wireless/realtek/rtw88/tx.h   |  4 ++
 drivers/net/wireless/realtek/rtw88/usb.c  | 64 ++-----------------------------
 drivers/net/wireless/realtek/rtw88/usb.h  |  5 ---
 7 files changed, 77 insertions(+), 66 deletions(-)
