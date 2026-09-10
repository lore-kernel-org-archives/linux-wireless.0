Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C8E33CF670;
	Thu, 10 Sep 2026 09:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789032455; cv=none; b=rWPeQV6QLszKI+5DKx7IcrtXE6YF5Ptwixwj1iuXATmMQ7uS4wRzZNVGvvHGxDRdFhNUcBYF1LCMkN9FL5l3movXyA/h06WDuwAIjqTby4Gl75rdIrc30ofEK6Y4ClTXsTVLEdnRlRy+v7qtvR/eJBQK4mgv9BbNEuGEPJejkqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789032455; c=relaxed/simple;
	bh=H7Nsp2q3uoIWn+L7K88CstEyoFEqqFhxu8vAG00TqW0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=slh8f/17akO6KLrFaB19J25T5w0A891jeLl3mzGuYVyJ758SR3bPnO2tmlnaCJ6UgUkos/AaC2e9H9v98Yjmrdrq5vTwuJYiaUth3omjb9jekXOSE8hyx3wbOxu4ocsWamJ5+Z9TEi0o9qUlbGNbtfe2wtRWjmIeHbP2TD3Q7/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=V8NsMYom; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="V8NsMYom"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 68A9RMPs81365863, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1789032442; bh=H7Nsp2q3uoIWn+L7K88CstEyoFEqqFhxu8vAG00TqW0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=V8NsMYoml4Rn4QCAp0K8J/9MkRNXhxakB0PXQz3+Dk9aD8kyTdvcdXTbJ+4CYg5Ws
	 zdA3C5s5JHaP7jS/7hRYRhciU4tbrKwe8w7Pc2sDyLkXD3ZAEHgHy3mjBDmKQAXY1R
	 BIZKXfbpjFwKmm9WAxdtnQI35TqU47Hjt0JrnlJV+AcawLL3BXnFclFcBFlLUR2+vB
	 7uJBx543PasRHR3LSJBI+yiTXACkpnkMfcIn51FAmlWvwqfgnjvRALf0Dpj2fxghYj
	 fuJMBikNZ7V7+lZcSKTUfVlL56GVBU12Z69ORJiBiilYKdOqvI1biIEFnNhk1Glrf8
	 fTMpjacep5Vig==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 68A9RMPs81365863
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Thu, 10 Sep 2026 17:27:22 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Thu, 10 Sep 2026 17:27:22 +0800
Received: from RTKEXHMBS05.realtek.com.tw ([::1]) by
 RTKEXHMBS05.realtek.com.tw ([fe80::a236:c445:ce4a:140a%4]) with mapi id
 15.02.2562.043; Thu, 10 Sep 2026 17:27:22 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Mehmet Fide <mehmet.fide@gmail.com>
CC: Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"mehmet.fide@screeningeagle.com" <mehmet.fide@screeningeagle.com>
Subject: RE: [PATCH rtw-next v3 2/3] wifi: rtw88: usb: only let the frames a
 dozing station needs use the after-DTIM queue
Thread-Topic: [PATCH rtw-next v3 2/3] wifi: rtw88: usb: only let the frames a
 dozing station needs use the after-DTIM queue
Thread-Index: AQHdQPzRmXZkdDBZmUWBfZh1sR4Hh7bHixBg
Date: Thu, 10 Sep 2026 09:27:22 +0000
Message-ID: <fe7df8dd883d40caad3133616e0b54a1@realtek.com>
References: <20260910081716.769081-1-mehmet.fide@gmail.com>
 <20260910081716.769081-3-mehmet.fide@gmail.com>
In-Reply-To: <20260910081716.769081-3-mehmet.fide@gmail.com>
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
> With the budget in place the high queue can no longer take the chip
> down, but ordinary chatter still competes with the frames a sleeping
> station actually needs. mac80211 marks every broadcast and multicast
> frame with IEEE80211_TX_CTL_SEND_AFTER_DTIM while a station dozes,
> mDNS and SSDP included, so under normal traffic the budget is spent on
> frames nobody waits for.
>=20
> Do what the vendor driver does with its default "allow special" high
> queue filter: admit only ARP, EAPOL and DHCP to the after-DTIM path,
> the frames a station coming out of power save has to see; everything
> else goes out on its access category queue at line rate. The frames
> are classified the way rtw89_core_tx_btc_spec_pkt_notify() does it,
> from skb->protocol and the network and transport header offsets that
> mac80211 keeps from the netdev path; EAPOL is the control port flag.
> Frames the AP relays between its own stations arrive as ETH_P_802_3
> and are not inspected, they leave on the access category queue.
>=20
> With the filter in place the page pool stays at 1803 through the same
> 180 second storm, a DHCP flood still takes the after-DTIM path (and is
> then held by the budget), and join/ping cycling without power save is
> unchanged (10/10).
>=20
> Signed-off-by: Mehmet Fide <mehmet.fide@screeningeagle.com>

Acked-by: Ping-Ke Shih <pkshih@realtek.com>


