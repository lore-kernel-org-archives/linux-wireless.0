Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=211.75.126.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793668322;
	b=UvuVOjqaODBPOrM0UslCg2p8+wD+G/QjFUIE/xweAJ0ogP0iqSkJX2lfgEtUVm+aX1iq
	 36HVO+pW4n2dMOCd3I0wEiAa1hXlscfu1j1qnVjeJ53ixDuR+G+cDxAfU/1yERZPyG/9v
	 AukaPFIrfv9IQJHJs1pHDcFCorjAzHbNSdOIv6MPnhBOofDpyxTSRy62WNBqf4C6a/IED
	 jkXIE0T/EIbChdgCeNcHMRpqyDhMJw2sJ7S/5Jz3gH845N0kwMRdQVaQMWU3QNCWJcBNc
	 jUHGy5rtxM6TxIvunE2wH2cbQI97Kf65AKuCJ/Vaz9uJske+hwhtH3ANXL8aJlhdc3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793668322;
	h=DMARC-Filter:X-SpamFilter-By:DKIM-Signature:Received:Received:
	 Received:Received:From:To:CC:Subject:Thread-Topic:Thread-Index:Date:
	 Message-ID:References:In-Reply-To:Accept-Language:Content-Language:
	 x-originating-ip:Content-Type:Content-Transfer-Encoding:MIME-Version;
	bh=g68BmDax9DPmrqfuPZ7CwgmMydOtZqTwhRJz0n0hx5Q=;
	b=FKFK9AR4v4oWsZtqdND5agNxa31CJX0Sf+QM5NjrwWc6MxXtcMJ19w1/Xo9m+qyyHGWS
	 uf7yTJpJ993eReCcRSYlceqiAtIgfr11A7gDV6v9EAC1potCAgFYt5J3/chSZYOeQw0jE
	 Jr5dIrJWJ6wIGqEyazz/+tfzqGisVGJA7IptgkLPYfJa4ai/gVTg1I9no76HGajkjIRpA
	 MPhX3jxB10qaweYt4UP8Qt+iPsNTuGMnizFlac77Hubg8CSoo82U44sWXuvC30Tuc4aIw
	 uHm3FkFrS9ZHw3jc1aX8+JUzefvD/ovYCMjaa4pFrDoweRV9l0nU2tYDINH3xcFVmuA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=realtek.com;
	spf=pass smtp.mailfrom=realtek.com;
	dkim=pass header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b="Y8CHH/AP";
	arc=none smtp.remote-ip=211.75.126.72
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F257606A324;
	Tue,  3 Nov 2026 01:12:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4F257606A324
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=Y8CHH/AP
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 6A31BpQ322615101, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1793668312; bh=g68BmDax9DPmrqfuPZ7CwgmMydOtZqTwhRJz0n0hx5Q=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=Y8CHH/APoBRtIAYV4K358w5mSNUJ3c+tW482GyhcD5GCPT1IhG+rGVzUak7fok5VU
	 M1G8tnUdvv9NvZNg67AONZcyFLRQAzITYbZRcaHiIa1WmC9rJIeYRBDz4t/HezdiZV
	 ELAYJbHob1atdzWCQbl6bGE+gLvRIUP0yHK2xbHswln+0/5JSRp8iX7VtUpnw5QtEb
	 70sKSFhoXRlp8HFjq1CGACoXpq7HnpzUIGkc6/tCn4e4I5D2h2qqWCCHBHAwhwAHWn
	 2OmwJSybG/Qw1gzY4nAOR3VSJUwUusXD09gad1KDr3I1t6YCGRzrb41J6/klKII9Tz
	 Gk8Ug/2IEWDzQ==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 6A31BpQ322615101
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 3 Nov 2026 09:11:52 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Tue, 3 Nov 2026 09:11:50 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS05.realtek.com.tw (10.21.1.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.56; Tue, 3 Nov 2026 09:11:50 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([fe80::eeeb:c765:ca73:5eef]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::eeeb:c765:ca73:5eef%10]) with mapi id
 15.02.2562.056; Tue, 3 Nov 2026 09:11:50 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Kalpesh Solanki <skalpesh942@gmail.com>, "kvalo@kernel.org"
	<kvalo@kernel.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH 2/2] wifi: rtw88: ps: Trigger firmware recovery when
 failing to leave LPS state
Thread-Topic: [PATCH 2/2] wifi: rtw88: ps: Trigger firmware recovery when
 failing to leave LPS state
Thread-Index: AQHdatefIO21Xr9w40u1hjvcgWoU0bcbikbw
Date: Tue, 3 Nov 2026 01:11:49 +0000
Message-ID: <72513ffa32eb4ba39f613e4c835c23dc@realtek.com>
References: <20261102143702.24902-1-skalpesh942@gmail.com>
In-Reply-To: <20261102143702.24902-1-skalpesh942@gmail.com>
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
> Please let me know if you would like me to submit a v2 patch series rebas=
ed on
> rtw-next (either with the 3-retry fallback or with rtw_fw_recovery() dire=
ctly),
> or if you prefer to proceed with patch 1/2 alone.

I think you only need to rebase. No need 3-retry. Thanks for analysis.=20

Ping-Ke

