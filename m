Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C3DF2EBBAF;
	Wed,  2 Sep 2026 02:38:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788316697; cv=none; b=YHIhsgJ2cEZ2AgIqVYVfTjb8nHtKUbQc2lmv7IETaRCr48W3RSB8GJby2cW5avLeyiLgBOj8PHbE6OCguuDYRigE4jlzy8Vec3lw6FkjDkjs8TofXVysSn9UgCWADiNK26Sr7ZwHY/5NsKVu5TfkaoGWfJEAQcHWkYL5JwiE1F8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788316697; c=relaxed/simple;
	bh=+LDmu95mIA9qk7b4Ep1tXU1p6CSc1sVjREbTji2svnQ=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type; b=IIBGnNBsdfJlai47fO+QKrsDy5DvDog+N2JvfclktsoYNXGnlkykmZ9pEKHVLsNSRzuUdqPKQ0xfrplT8/zHFXQu6Oe2nXIPo3K9mjmd095WGlRBTN1jg7AaJVKPx7lnkrDLJpX4yVobdmarbMWS/Xdyk9r6MMgTFQOCa+2YXow=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=i2O8/M2f; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="i2O8/M2f"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6822c5NX12250362, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1788316686; bh=5AMSXV+Rjzltqk1ChAOfVXsQyDZFu6CevPia9oU9pZs=;
	h=From:To:CC:Subject:In-Reply-To:References:Message-ID:Date:
	 MIME-Version:Content-Type;
	b=i2O8/M2fV+bf27X9iaIz3E291WyNFD8gzdGzjk5MJjvEOGUeJ8HrYV/eNzB8fJWTK
	 1GcqyrJBy1eXkiMMKMzTjlO5RJTGlWo7aBAZvbnjPHIf8hZwwzwJhebjEyPJ3tIKd3
	 hXTD70ReUJjnkfYvEnodqhAePXYZe3ysvjxRq/OV/W7XcYDY+kyBN3Fc+1EEahvc2S
	 FmhQI6KJpCrB7zX0RlyaYypq4n7PPNwzZfVpw4ZL7ZHKf4Lkv4xoGJC924TKfCIv5J
	 sEPar1RsSQO9HBRhdzBmGUIfSYblLlcJMr7Lrkq+gg5ozM5QhDgCQxAT6RAuMuX4n4
	 1raKiXgiKmUDA==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6822c5NX12250362
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Wed, 2 Sep 2026 10:38:05 +0800
Received: from RTKEXHMBS04.realtek.com.tw (10.21.1.54) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Wed, 2 Sep 2026 10:38:05 +0800
Received: from [127.0.1.1] (172.21.40.75) by RTKEXHMBS04.realtek.com.tw
 (10.21.1.54) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.2562.43 via Frontend
 Transport; Wed, 2 Sep 2026 10:38:04 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Mehmet Fide <mehmet.fide@gmail.com>, Ping-Ke Shih <pkshih@realtek.com>
CC: Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	<linux-wireless@vger.kernel.org>, <linux-kernel@vger.kernel.org>, Mehmet Fide
	<mehmet.fide@screeningeagle.com>
Subject: Re: [PATCH rtw-next v3] wifi: rtw88: usb: route bmc frames via the high queue only for DTIM delivery
In-Reply-To: <20260814053426.2473247-1-mehmet.fide@gmail.com>
References: <20260814053426.2473247-1-mehmet.fide@gmail.com>
Message-ID: <8bd87a9c-1ac4-4a8e-8075-36ad62c4891a@RTKEXHMBS04.realtek.com.tw>
Date: Wed, 2 Sep 2026 10:38:04 +0800
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
> In AP mode every broadcast and multicast data frame is routed to
> TX_DESC_QSEL_HIGH, the after-DTIM queue, whether or not anybody is
> asleep. The firmware drains that queue at beacon pace, a dozen or so
> frames per second measured on RTL8822BU, while one associated client's
> mDNS/SSDP chatter alone exceeds that. The excess accumulates inside
> the chip until the shared TX page pool is exhausted (measured: 14 of
> 1803 pages left). From that point every host-sourced frame queues
> behind the backlog: authentication responses reach the air seconds
> after the client has given up, so no station can associate anymore,
> and the beacon reserved-page download fails the BCN_VALID poll
> ("error beacon valid") because it needs pages from the same pool. The
> AP keeps beaconing, so the failure looks like a silent RX stall and
> only a reboot recovers.
> 
> mac80211 already decides when after-DTIM delivery is needed: it sets
> IEEE80211_TX_CTL_SEND_AFTER_DTIM on bmc frames only while at least one
> station is actually dozing. Honor that instead of routing
> unconditionally: flagged frames keep going through the high queue with
> the MORE_DATA and HGQMD handling introduced by commit 076f786a0ae1
> ("wifi: rtw88: Fix AP mode incorrect DTIM behavior"), everything else
> leaves at line rate through the AC queues. This partially reverts the
> usb.c hunk of that commit, whose unconditional routing is what lets
> the backlog build up.
> 
> On a bench AP (USB2, 20 MHz, WPA2, hostapd, a Windows client driven
> through disconnect/reconnect cycles): reconnects fail 0/5 on RTL8822BU
> and 0/3 on RTL8821CU before this change, and pass 10/10 and 5/5 with
> it, with the page pool staying healthy and no beacon errors logged.
> 
> Signed-off-by: Mehmet Fide <mehmet.fide@screeningeagle.com>
> Acked-by: Ping-Ke Shih <pkshih@realtek.com>

1 patch(es) applied to rtw-next branch of rtw.git, thanks.

c710c7c2e038 wifi: rtw88: usb: route bmc frames via the high queue only for DTIM delivery

---
https://github.com/pkshih/rtw.git

