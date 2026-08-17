Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3507712CDA5;
	Mon, 17 Aug 2026 03:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786935624; cv=none; b=ZHgCbvmyUJQZomwsj/4qDxLtM1XWbxjnmC74Ql5PsebcNTM2NK19JmKPitPBmyTVg7/zigixk8wRHsI+YGkRpOm1QqPTb5ij3SCYeElOInV6o9Znon1pdvnjcE/KjPT9WU8NLvaqlhXcx+5TGXaqN67+6AriUABvpnmm10PW5QM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786935624; c=relaxed/simple;
	bh=sVsw1RZXxpmjWfRgqX8A21gryIMI9trWr8ekEEyasEc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=jX5NEUEBbIH05lnziYzKKJzXjKzDW4TLgiph+GALOUGtwz0Lp4DsBhhNrg+LRAvASTwB3fBObV4F8F5oCRtM6iGrJQoT2ekJZejige82H3Y3r+iokb5KL2F2XFkMzfI/cOm89tv1C0CX8otHTaZEJlYvcT1+D2P2lX1nG/bwNVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=haeO7Seu; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="haeO7Seu"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 67H30DaI43469146, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1786935614; bh=sVsw1RZXxpmjWfRgqX8A21gryIMI9trWr8ekEEyasEc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=haeO7Seut4njOcoSvHgWIjFpcsBirD0Ni7xyeqOrvdyXIkg1oEj5PDgRDBpDjYRMc
	 Sbz6SkyiWiJTkYyTS0d4ew4y68S2QGYjQAhZaCkcdaV6DgmclhM16am+udsa+p79++
	 U0vn+Wizz+qdI73sW/AsRudq3HXRIOi2rGl6YoqADHLYXKEV3zFysbIufRVbu/Gd+y
	 ryfkA7NggUY25Y25uQNnDrZd3Z+pNq8MqpJIWvqNZPTupx0DJ9JoZpMC5vsTt90eP8
	 nBJ28fNaLDV3ukj6rEClGIn7OEI+JCBsinCsCaFeLttK0DPF11bjczzDQ+5ZkMQyTz
	 rg443BnNU1gIg==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 67H30DaI43469146
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 17 Aug 2026 11:00:14 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Mon, 17 Aug 2026 11:00:08 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::126f:59ad:658:674d%10]) with mapi id
 15.02.2562.043; Mon, 17 Aug 2026 11:00:08 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Mehmet Fide <mehmet.fide@gmail.com>
CC: Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Mehmet Fide
	<mehmet.fide@screeningeagle.com>
Subject: RE: [PATCH rtw-next v3] wifi: rtw88: usb: route bmc frames via the
 high queue only for DTIM delivery
Thread-Topic: [PATCH rtw-next v3] wifi: rtw88: usb: route bmc frames via the
 high queue only for DTIM delivery
Thread-Index: AQHdK66WOfaBclcfS0e15NhvFyIcILahkYzA
Date: Mon, 17 Aug 2026 03:00:08 +0000
Message-ID: <b1108d885ffb4e87829af7b6d505b693@realtek.com>
References: <20260814053426.2473247-1-mehmet.fide@gmail.com>
In-Reply-To: <20260814053426.2473247-1-mehmet.fide@gmail.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0

Mehmet Fide <mehmet.fide@gmail.com> wrote:
> From: Mehmet Fide <mehmet.fide@screeningeagle.com>
>=20
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
>=20
> mac80211 already decides when after-DTIM delivery is needed: it sets
> IEEE80211_TX_CTL_SEND_AFTER_DTIM on bmc frames only while at least one
> station is actually dozing. Honor that instead of routing
> unconditionally: flagged frames keep going through the high queue with
> the MORE_DATA and HGQMD handling introduced by commit 076f786a0ae1
> ("wifi: rtw88: Fix AP mode incorrect DTIM behavior"), everything else
> leaves at line rate through the AC queues. This partially reverts the
> usb.c hunk of that commit, whose unconditional routing is what lets
> the backlog build up.
>=20
> On a bench AP (USB2, 20 MHz, WPA2, hostapd, a Windows client driven
> through disconnect/reconnect cycles): reconnects fail 0/5 on RTL8822BU
> and 0/3 on RTL8821CU before this change, and pass 10/10 and 5/5 with
> it, with the page pool staying healthy and no beacon errors logged.
>=20
> Signed-off-by: Mehmet Fide <mehmet.fide@screeningeagle.com>

Acked-by: Ping-Ke Shih <pkshih@realtek.com>



