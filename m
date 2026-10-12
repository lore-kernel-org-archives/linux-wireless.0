Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFD663B103B;
	Mon, 12 Oct 2026 05:26:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791782794; cv=none; b=CxIrpH59I/w1nDPy/h3SERY6m2apEliCl7IfKCmIh/HlDiD0nGhVMxxHH2tAvtWrdCKECyxQoMxhoHe+Qj2uu0d/93Rvx0alIvYPvI83Qd6aU1DxX6G2VNBJp5xcHUGKdG8sN3EIF+jkjPrscwFyMMNH/AvHpSDJOZcklcQQUas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791782794; c=relaxed/simple;
	bh=GNJ6cVW2VhMuX4xm2cDhsJ+ZP8ANIoLtqT5UsY+5tCc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=pVzwNyxWp5dib2wR/bPc5pgbbU+uUWU3Dl1vJyHPivDib5wcmVA3LEm7IUTQcnoo8EnI/BKLCzVcbcIY4AvQqUHsNWW3b4TkCKM+QB22Y8iw47sT8Cz9HO+WmMnfsLwGYUg4zkhnuKakH+dwPlS+fcXCUIWlqptZnULH7d2VNhc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=IVnZO9MZ; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="IVnZO9MZ"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 69C5Q8YS03565457, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1791782768; bh=GNJ6cVW2VhMuX4xm2cDhsJ+ZP8ANIoLtqT5UsY+5tCc=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=IVnZO9MZOZ1rbcuIgt7y9EbsjmA3h7VZMZZQhcaqmYcMM50U30cUZ91MFj5bgUErz
	 H+tRib9ue4paFDp2msUf51ug80w8hRFqkZetlvntKOpN3pMjKRgILN+QtID3bwyRZM
	 PINcrH6oWKUu9FxynOItFVdyW1QW6b/kOhZZ5JCq+4/xwghy+3nPJVAxTjjUHm4WTK
	 XFLc7yHbaTiV9poPO+9U+B4kv51D8u5Y5CE5XR5mJFbg7Ktt3NvwaQg+sGuMSXrZYG
	 E4qOV45nOHJnd/hFQbvfJstAjn4vRavqn4M+EOGxze4ANkmTiVLi6ARAxoIGDBVZqG
	 ERpQA6hBbMsGA==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 69C5Q8YS03565457
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 12 Oct 2026 13:26:08 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Mon, 12 Oct 2026 13:26:15 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::b3cc:c263:b82d:e87c%10]) with mapi id
 15.02.2562.049; Mon, 12 Oct 2026 13:26:15 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Luka Gejak <luka.gejak@linux.dev>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Bitterblue
 Smith" <rtl8821cerfe2@gmail.com>
Subject: RE: [PATCH rtw-next] wifi: rtw88: 8723b: don't set channel_invalid in
 query_phy_status()
Thread-Topic: [PATCH rtw-next] wifi: rtw88: 8723b: don't set channel_invalid
 in query_phy_status()
Thread-Index: AQHdWAcjbRcO6v6s00uhKYQBFVNTZLb5ZD/A
Date: Mon, 12 Oct 2026 05:26:15 +0000
Message-ID: <3ba621799df94d20bb5aac0f08fcfb28@realtek.com>
References: <20261009155838.169058-1-luka.gejak@linux.dev>
In-Reply-To: <20261009155838.169058-1-luka.gejak@linux.dev>
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

Luka Gejak <luka.gejak@linux.dev> wrote:
> rtw8723b_query_phy_status() sets pkt_stat->channel_invalid, which makes
> rtw_update_rx_freq_for_invalid() call rtw_update_rx_freq_from_ie() and
> overwrite rx_status->freq with rtwdev->hal.current_channel.
> rtw_update_channel() keeps the center channel in that field, not the
> primary one, so on a 40 MHz connection mac80211 is handed a frequency it
> rejects in ieee80211_rx_beacon_freq_valid() and reports beacon loss for
> beacons the driver did receive. Only beacons go through that check, so
> data traffic is unaffected.
>=20
> Remove it now, so that the non-SDIO members of the 8723B family do not
> report beacon loss once they are supported. SDIO is unaffected, because
> rtw_sdio_rx_skb() copies the status into the skb before the update runs.
>=20
> Reported-by: Bitterblue Smith <rtl8821cerfe2@gmail.com>
> Signed-off-by: Luka Gejak <luka.gejak@linux.dev>

Acked-by: Ping-Ke Shih <pkshih@realtek.com>


