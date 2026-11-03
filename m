Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=211.75.126.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793675838;
	b=S9mSykSA71dyf7WlC/fTxPxJdAmLuQ23h15bt4697FCe5VXbfidJ0KupFueuPdSkUET+
	 +Z4Sst+m8BJnLkIORJzUsEhfYTK246V1hFzE1Yjcfk1Uo/ScrcSMSVyPRW3Xp/sWCUa1I
	 G7/Y/6VlEhUnQ//9EI/Ok2PmdGaZjKQovGB+lIR3JM5ifki4/YnRkzAJxCf+gQua38MKI
	 b7nlm7bl76hsdAlJf22Nup9bA1m5P1dVxvqu8gjYuelx+Pnp5GxKoGHlXYrM7slsFYRbP
	 hnjHE3bjhvRRfXg/Z0eXFJvqXBw9iUWcI0r7swBcnlcOdYnYsupzFbtlhsNU795/Rtw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793675838;
	h=DMARC-Filter:X-SpamFilter-By:DKIM-Signature:Received:Received:
	 Received:From:To:CC:Subject:Thread-Topic:Thread-Index:Date:Message-ID:
	 References:In-Reply-To:Accept-Language:Content-Language:
	 x-originating-ip:Content-Type:Content-Transfer-Encoding:MIME-Version;
	bh=IAdP2i2NBcS81hl12RJy+QQRkMqywf9aixPAQsnRvxk=;
	b=EDhtnOwoX9lOoaWy4de3LCsYIQtx7xM47S7foUeJzeoUiK1S0xHUCUAnQW3RkkQYrOQR
	 +SkSiYEBxMVHu0wcxoNg6CfbPnuhm9WFB6L6LVljj2MRP/R4KW8FF3JLLHgsr91tYCVhP
	 oUqBX/indiuSbGHpeCxQeCoCrQbRS9n7GW6Q6+C7uFpmOQpOhNWlNcnDdIFr8sJL3sLUz
	 4aVep8CefSPetXQ7fuSY8iO+K26j3NsWb9qwRhpYmvQ1e7+kgZCzgG720kA04A3WND32k
	 wx2jYdtb1NDZG0RbWsAx46QgbAxteN8ucFsJnb2XnC9CuF9+Sgvnz0Zzf8Sa5ESCmJQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=realtek.com;
	spf=pass smtp.mailfrom=realtek.com;
	dkim=pass header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=Glvr9lJM;
	arc=none smtp.remote-ip=211.75.126.72
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9B41606A324;
	Tue,  3 Nov 2026 03:17:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C9B41606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=Glvr9lJM
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6A33HAXZ02695609, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1793675830; bh=IAdP2i2NBcS81hl12RJy+QQRkMqywf9aixPAQsnRvxk=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=Glvr9lJM/c5dOQXQXWdRugSCNWpEHQNH/fFQXHKmxxDAXVb+H1XZOM6ZzCmcLpn8j
	 +HcH/xAx4kGIgM8C7c9ICCWmVFcwLR+TfbESnOruMk+m3ZPTRnhKV0FOVI/pslLBak
	 cG3pbvA2Sgk0FaZkGZSSr+KRQ0U4uCxkZtT7PN/BkykN4Y+SycQc57m7WgcAAzGOEf
	 wnulcyx1r+j6ZQIogdlCzkobl/QjOMkL5I4RHHo2brQmBPzthRgCPnpmrJkrxLpyzE
	 86tP0bja661O0sqUkjGikuNlzd14YYiL41xg8SJ6HMACDjIKzQ/v0GAD0uW3hQC8IT
	 VJ03snc/sfZyg==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6A33HAXZ02695609
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 3 Nov 2026 11:17:10 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Tue, 3 Nov 2026 11:17:11 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([fe80::eeeb:c765:ca73:5eef]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::eeeb:c765:ca73:5eef%10]) with mapi id
 15.02.2562.056; Tue, 3 Nov 2026 11:17:10 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Kalpesh Solanki <skalpesh942@gmail.com>, "kvalo@kernel.org"
	<kvalo@kernel.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v2 2/2] wifi: rtw88: ps: Trigger firmware recovery when
 failing to leave LPS state
Thread-Topic: [PATCH v2 2/2] wifi: rtw88: ps: Trigger firmware recovery when
 failing to leave LPS state
Thread-Index: AQHda0GT5HJUjvdiV06CJvy/NMrA3bcbrQjg
Date: Tue, 3 Nov 2026 03:17:10 +0000
Message-ID: <3123351665ae40a4a4328fff35faa548@realtek.com>
References: <20261103031434.14449-1-skalpesh942@gmail.com>
 <20261103031434.14449-2-skalpesh942@gmail.com>
In-Reply-To: <20261103031434.14449-2-skalpesh942@gmail.com>
Accept-Language: en-US, zh-TW
Content-Language: zh-TW
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0

Kalpesh Solanki <skalpesh942@gmail.com> wrote:
> When rtw_fw_leave_lps_check() fails, the firmware has locked up or
> failed to exit its low power state. Currently, the driver only logs
> 'firmware failed to leave lps state' and clears REG_TCR, leaving the
> hardware in an unresponsive state where subsequent H2C commands fail
> and TX traffic hangs indefinitely.
>=20
> Call rtw_fw_recovery() when rtw_fw_leave_lps_check() fails so the driver
> can automatically reset the hardware and re-sync without requiring manual
> user intervention.
>=20
> Signed-off-by: Kalpesh Solanki <skalpesh942@gmail.com>

Acked-by: Ping-Ke Shih <pkshih@realtek.com>


