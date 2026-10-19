Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A08525392A
	for <linux-wireless@vger.kernel.org>; Mon, 19 Oct 2026 01:59:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792375193; cv=none; b=D09YUmZSlLm+q22seu3Afti5Fjui8ev7Tk6E5WanCKvFgyI47tXMioBtwIJMPm2Iax2fYecE1rUD7RNdlqJ8uG/5bVaYx2TT6Nj9AV35W/CQFadryErj7EJsjDCAPkE4SbBQmpa0G7K2OwlYxhIlfCskRCcCkidcJeRa7N0EhsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792375193; c=relaxed/simple;
	bh=ASBULkq0GlNtT4EpdhLwlMJHawVQLQg1ZkkQx1jW5eE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=HspMNB24qOoGsAAuHkDuyiC/ktxOH3ZlytLOTOabr5+4jxm4rdM+nXrzpMwZQeam4HzpIfigC+rod/RoCWpmTmQ3VR2Q9LkqY5in/RS77vnVWEdWweEs2HERcPirFlpzKIpr3ms1DGmpYmwHjTVKeRRxxt/ABCJNCr1BkqIC+S0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=wL3gJr/R; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="wL3gJr/R"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 69J1xbD931465343, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1792375177; bh=UiAnUfKR7u9oUVVMlXMu6MK38LwnX1ptJ/VMD9LO/t0=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=wL3gJr/RY6oyZkLD2VRlPX/TYp6gIEsU38I9w1EEs1+LOVdF5YSevy0F+dQY7VhEG
	 kVkMEUfld8V1hu8YmSbbPYXFwB7VGv6Z6b4zUEcW8nbBXQSXhZpXtjLli9FjA6Zefv
	 NjstY/YqiDV1geS07PFUmndQCu5dxeA34f4/npnpwv1WzFlv2hLqZB4ACu+DTwgkOk
	 vdJJl0vU5HLK0EKBwXSiTostnf/xgfIKPPD2lAiYI3XhdNPvbG/m+fdjW90M4O7O4r
	 niRegC14FZXKJSddXKRutsGdEe9UGferrx1sfl+N4LAYgPtdJuVcuNGCzVm0Mf8l2x
	 udI6ZfN7Bictg==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 69J1xbD931465343
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 19 Oct 2026 09:59:37 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Mon, 19 Oct 2026 09:59:37 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::b3cc:c263:b82d:e87c%10]) with mapi id
 15.02.2562.049; Mon, 19 Oct 2026 09:59:37 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Carl Quist <equalizerjr@gmail.com>, "luka.gejak@linux.dev"
	<luka.gejak@linux.dev>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH rtw-next] wifi: rtw88: 8723d: add iface combination
Thread-Topic: [PATCH rtw-next] wifi: rtw88: 8723d: add iface combination
Thread-Index: AQHdXbduQ6aiRpZMH0mQK6ZTehenWbcBBocAgAAhaACAAvMr4A==
Date: Mon, 19 Oct 2026 01:59:37 +0000
Message-ID: <b35b82f1331141faa3603574fa3697ac@realtek.com>
References: <DM71TCO0TBZI.1W7JBUVH0CMG7@linux.dev>
 <20261017124050.33663-1-equalizerjr@gmail.com>
In-Reply-To: <20261017124050.33663-1-equalizerjr@gmail.com>
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

Carl Quist <equalizerjr@gmail.com> wrote:
> Ping-Ke, does that approach look acceptable to you, or would you prefer
> to keep the combination limited to 8822c?

As you confirmed RTL8723DE work well, it is okay to me.=20

Did you setup an air sniffer to capture packets? I suggest you can have one
to check AP behavior including:
1. The beacon is sending on time. (100TU)
2. Is the behavior expected with DTIM=3D3 ?
3. When connected station goes sleep and AP send a packet to the station,=20
   the corresponding TIM bit is set?
4. broadcast/multicast is sent right after beacon (by ATIM window register)
5. Combine 2 and 4, checking corresponding TIM bit is set?

Ping-Ke

