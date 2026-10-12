Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5E822AD36;
	Mon, 12 Oct 2026 01:13:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791767630; cv=none; b=Mxs0TLLB9qegCUWP59qY+AFCtNlHxrE+MMFeLL64h9qcnGZ3eWDAD1CT25M/YQ+1BkCC5R+3Qns2auyS0woCjsYT0YNkN0UtHEw0b0Jx2NbICWI1JPF9VJ5FcErxoIsW01nPFK8objRN7lNCcfIFpN/ZsFWliqIkfaHmLS52Wzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791767630; c=relaxed/simple;
	bh=/2+O7pfoOUX5sod1x8QsxeF5lEbg+181hMpw2pvo/s4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=sx9dLrxMgzsE7HorPoQtS4htfaR5Eq8Y8FXse7LO3+yt0BZsnaIZQlw+MvKJzSzgnPXZn+i4gnQSVxjiCCeMnnxks28z+Ni4rjl8j5YzMbEz08c8CNByk8bN017bMbUTMdqAb/bCHsa5L1VaaK3CZUXE6uWoyikxwtUYI4Aes1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=nfJh2V+e; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="nfJh2V+e"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 69C1DMTb83413846, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1791767602; bh=/2+O7pfoOUX5sod1x8QsxeF5lEbg+181hMpw2pvo/s4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=nfJh2V+eg7c0rHZINyruxi0dV+E5qCquhZ81ixYOboFR+zRG4Nk4T8HyRNDA/JhXf
	 hI1LCYMyVP10M8MNA2LxDa4Cev2BsyAAaK13UbCmytWw7Y3Ehc3kAThGlkXdBH5BRD
	 5GU+fMDrGdERQ+XK+z5wWuS8+bevmaCQiL+qdWGWh9BwdcVQbwF+1U4a6n0mGwVKqF
	 MDt1vxqnXFeajvIpROfW1pq0LYGXZklvLwOSnCYm1mKvg4mAWmrPYcF+cI3PeCjXTj
	 8FvyeNSzmVxPgznpbaNZ6nz8UNqfp5XNtVObLOS5GKYt/WaXsrGAjUv44ZlQcOXYBp
	 vZ90qJpU8emLg==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 69C1DMTb83413846
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 12 Oct 2026 09:13:22 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Mon, 12 Oct 2026 09:13:29 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::b3cc:c263:b82d:e87c%10]) with mapi id
 15.02.2562.049; Mon, 12 Oct 2026 09:13:29 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Hungyu Lin <dennylin0707@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Bernie Huang
	<phhuang@realtek.com>, "luka.gejak@linux.dev" <luka.gejak@linux.dev>,
	"rtl8821cerfe2@gmail.com" <rtl8821cerfe2@gmail.com>,
	"johannes.berg@intel.com" <johannes.berg@intel.com>,
	"u.kleine-koenig@baylibre.com" <u.kleine-koenig@baylibre.com>
Subject: RE: [PATCH] wifi: rtw88: sdio: copy RX status after updating the
 frequency
Thread-Topic: [PATCH] wifi: rtw88: sdio: copy RX status after updating the
 frequency
Thread-Index: AQHdV5CQXUvj2qVYXEy8IlheATldy7b5HoyA
Date: Mon, 12 Oct 2026 01:13:29 +0000
Message-ID: <b909ccb2e29a4594831312297441ce0e@realtek.com>
References: <20261009014941.29137-1-dennylin0707@gmail.com>
In-Reply-To: <20261009014941.29137-1-dennylin0707@gmail.com>
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

Hungyu Lin <dennylin0707@gmail.com> wrote:
> Sent: Friday, October 9, 2026 9:50 AM
> rtw_sdio_rx_skb() copies rx_status to the skb before calling
> rtw_update_rx_freq_for_invalid(). If the frequency is corrected, the skb
> still carries the old value when it is passed to mac80211.
>=20
> Move the copy after the frequency update, as the PCI and USB RX paths
> already do.
>=20
> Fixes: 53ed4b25a79a ("wifi: rtw88: 8822c: Parse channel from IE to correc=
t invalid hardware reports")
> Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>

Acked-by: Ping-Ke Shih <pkshih@realtek.com>

