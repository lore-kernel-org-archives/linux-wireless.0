Received: from nova.nubenode.com (nova.nubenode.com [46.4.179.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CF234A64CE;
	Fri, 11 Sep 2026 17:00:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=46.4.179.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789146051; cv=none; b=s3M5FMG7EHn4TFXDbX26wySzIKKT+yyCFhFALoKM5aF1lfLcOZ9m2z1KGITqPpfEQwNvm0S+Mmn+8H/zPbd/aA7W4/pNNPs+ik2kGCeOsBboglqSOdToVP/e23+fFfFtUcmDYICMxagp+U2yxoJDJZId0tnvjT+9lMbeNNe1Gfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789146051; c=relaxed/simple;
	bh=nBLWWBP4HnJ5/4QWOz2ih+Lp5jFk0PRyzU9xK5ogK1o=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version:Content-Type; b=MKrgLXgF71TFrkg2oRItXgRS/vV2aYn2TWVUU9z5Hz2WFKLFUve/tcAwCQTCn3CkC6DPxEgHhE6GrCF1s/I8rjO1VWjCeQrRO0I8Ur7+qE3DTI4N3vKGH7s9E7ucSpBBsaM+JP0Kfi/dkV9v9Q5OEjARmAh5v6y3xqZKKgfhjZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cristiandeluxe.dev; spf=pass smtp.mailfrom=cristiandeluxe.dev; dkim=pass (2048-bit key) header.d=cristiandeluxe.dev header.i=@cristiandeluxe.dev header.b=JweRqEpF; arc=none smtp.client-ip=46.4.179.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cristiandeluxe.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cristiandeluxe.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cristiandeluxe.dev header.i=@cristiandeluxe.dev header.b="JweRqEpF"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=cristiandeluxe.dev; s=default; h=Content-Transfer-Encoding:Content-Type:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=E3vEeBimqjP1myNhIFvu5a7oTiE8fD/m5HcnS7mZ2BA=; b=JweRqEpFkIHt2pS8sHXQfsLPt8
	xAWs22xJ+6Ac8dxvx6LGy0nJj2brggLLzPrjDoh2c5ifh9o55rPssyXDP6hKGZrt/eQWNavvXpCPc
	LA8AWX6ZFUACnvAy7iMrARlkqDSnQvkCpPRnHxboJ2pLcDptpQjmgfLwPutyhr/7cXvD60iJX9V5r
	W5RjS3sxHOIBKgewbdSo39GqL4K2jVy0ll3UBMoh2JBkBBbQ99iH0mDFgGZxDrGDXzZ7JYCxb2fJk
	5d4PsmMB3SaZzfStVrpr4Ri1LrSgEsy5NE8nFvKJagWsnDYN2t6hMExMWY0/DmmQIzWcC50hvbsI2
	Zu8jCiTA==;
Received: from cristiandev by nova.nubenode.com with local (Exim 4.99.5)
	(envelope-from <me@cristiandeluxe.dev>)
	id 1x54cG-000000004J2-3vlm;
	Fri, 11 Sep 2026 19:00:45 +0200
From: Cristian Deluxe <me@cristiandeluxe.dev>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] wifi: rtw88: 8703b: repair the card-disable transition
Date: Fri, 11 Sep 2026 17:38:10 +0200
Message-ID: <178914109042.64584.1681714272474754544@cristiandeluxe.dev>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Mailer: sendmail (hand-assembled, git-email unavailable on host)
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - nova.nubenode.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [1103 978] / [47 12]
X-AntiAbuse: Sender Address Domain - cristiandeluxe.dev
X-Get-Message-Sender-Via: nova.nubenode.com: authenticated_id: cristiandev/from_h
X-Authenticated-Sender: nova.nubenode.com: me@cristiandeluxe.dev
X-Source: 
X-Source-Args: 
X-Source-Dir: /root

Two fixes to rtw8703b's power sequence tables, both found by comparing
them against trans_*_8723d and against Realtek's own 8703b sequence
header, and both tested on an RTL8723CS over SDIO.

The first is the one that matters. trans_carddis_to_cardemu_8703b has a
single entry where its sibling has seven, so the SDIO suspend request
and the 12H LDO sleep that trans_cardemu_to_carddis_8703b sets are never
undone. On a board where WL_REG_ON is the host's only reset and the
chip's rail cannot be switched, the part then comes back from every warm
reboot with its MAC unpowered while the SDIO function still enumerates,
and the driver waits forever for power ready. Nothing short of
disconnecting the battery cleared it; the vendor driver recovered it
every time, which is what pointed at the tables.

The second is small: the first entry of trans_act_to_lps_8703b writes to
the PCIe DMA control on every interface, where both 8723d and Realtek's
header restrict it to PCI.

Tested on a Denver TAQ-102 tablet (RK3126C, RTL8723CS on SDIO) against
7.3.0-rc2: recovers a chip left wedged by a previous boot, survives
repeated warm reboots and loader-mode flash cycles, and 35 hours of
continuous association across the pair.

Cristian Deluxe (2):
  wifi: rtw88: 8703b: complete the card-disable to card-emulation
    transition
  wifi: rtw88: 8703b: stop the PCIe DMA write reaching SDIO

 drivers/net/wireless/realtek/rtw88/rtw8703b.c | 34 ++++++++++++++++++-
 1 file changed, 33 insertions(+), 1 deletion(-)

-- 
2.51.0
