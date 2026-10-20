Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=211.75.126.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792462064;
	b=eiy/z4Dw8rTx/xF72HWNTY8QiEAV3G/kHHEhD+rB0bClOyhF1JIERD39eZYwE02SnbhH
	 zuhctvKrwuwsuG9ihQdvv0UVeCyAJ4rhm2/DR+4tnORrAJt0UZmakwKZsQhhRo/R50sda
	 LkKxEVFhnT7iErfp0Vm1qn+BrtzYRRW56a6WmSK2ymogubcVxij6GhDkcyj6Q2VVXuoIp
	 eojYAD976l7QOzs99hYPBBpKpmIMPFpobfoSc3N6sLYq+Ztd/ZGdf3vLSMDCNwGPc7eXR
	 ZqbED9thV/EUW5SHUTHoZg5YApczspr16vAfgVFveSYrMKXZAM6m4KXlZ3a0ArAD4sg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792462064;
	h=DMARC-Filter:X-SpamFilter-By:DKIM-Signature:Received:Received:
	 Received:Received:From:To:CC:Subject:Thread-Topic:Thread-Index:Date:
	 Message-ID:References:In-Reply-To:Accept-Language:Content-Language:
	 x-originating-ip:Content-Type:Content-Transfer-Encoding:MIME-Version;
	bh=p5CPfriTroDhT92SBcIMTFhXTUwle/OQzHWFE5QVjxQ=;
	b=KaULHPGEMeCSksQMX25EajEj1iiGiStDqpKSCS/OZjmNMko01aY7aQ6MUd80dJ856I76
	 d6N1UokhBsKV3SZ1wj4NHXNLNR9mFpgKaaabBSVo/gHZ7mgbgnSOBrzYAEJot99B+i16l
	 tpxZumB4BWD4hh7C7isA2mj8bIDb1/zQbE5SufPaqYYqQPb73hvAAekhh8FXS5RAyZHab
	 KFiu8Q5oxRwBZIzKQGfWpWzYo94WU0dYsimG5Rsc+QlubaNJ4Rlb47Um7wEhgeTvSwlfO
	 12bhxqji0FSlMl8TB7a6Nlv0/KEVnqxAqAXYgOAQ/SZnsJ3mCFMxBYnD9L07f1A1Uew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=realtek.com;
	spf=pass smtp.mailfrom=realtek.com;
	dkim=pass header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=ZksLQlJF;
	arc=none smtp.remote-ip=211.75.126.72
Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C889E606A322;
	Tue, 20 Oct 2026 02:07:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C889E606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=realtek.com header.i=@realtek.com header.a=rsa-sha256 header.s=dkim header.b=ZksLQlJF
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 69K27dStA2568172, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1792462059; bh=p5CPfriTroDhT92SBcIMTFhXTUwle/OQzHWFE5QVjxQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=ZksLQlJFKj8Z7LR36w4+zEHnS6jqQeePobCMIZQxEuZzk53k3449inw+O+2KrgpoT
	 1B+UoVf7+/Q7ZA8LjdA9wxoGWmqjnEaiS+N1qf1iac53BMfk4RKC3QIDqPvADJn2+h
	 tMkCH6zpP2jCCMdqFy02s0ZsCsM0RcxihqAlg5xd6VlNbLW/zsLwgnVf2ioGikTSQY
	 hnAo12B7e70PeEfRe7xc4KInMwjCmyjUD7G1z2V8cJiNbW0zqO4gGe0dfAtz3kIDbF
	 X7E5/cE6qu1Yrc7M8w1mhKvxstKEDSzpiKNbIwkZfEH/o0g6DsB4vF6YU12LBmfmnZ
	 Nxu85WS1xzPyg==
Received: from mail.realtek.com (rtkexhmbs02.realtek.com.tw[172.21.6.41])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 69K27dStA2568172
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 20 Oct 2026 10:07:39 +0800
Received: from RTKEXHMBS05.realtek.com.tw (10.21.1.55) by
 RTKEXHMBS02.realtek.com.tw (172.21.6.41) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Tue, 20 Oct 2026 10:07:39 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS05.realtek.com.tw (10.21.1.55) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.49; Tue, 20 Oct 2026 10:07:39 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::b3cc:c263:b82d:e87c%10]) with mapi id
 15.02.2562.049; Tue, 20 Oct 2026 10:07:39 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Hungyu Lin <dennylin0707@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"reza1234khan1234@gmail.com" <reza1234khan1234@gmail.com>
Subject: RE: [PATCH] wifi: rtw88: allow key removal when the CAM table is full
Thread-Topic: [PATCH] wifi: rtw88: allow key removal when the CAM table is
 full
Thread-Index: AQHdX+uKpKj5AeqD60mYtFtK4iFuvbcFrrNw
Date: Tue, 20 Oct 2026 02:07:39 +0000
Message-ID: <9bde49a2e7794e4fb6bc3ae104eef87e@realtek.com>
References: <20261019165103.5990-1-dennylin0707@gmail.com>
In-Reply-To: <20261019165103.5990-1-dennylin0707@gmail.com>
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


Hungyu Lin <dennylin0707@gmail.com> wrote:
> rtw_ops_set_key() looks for a free CAM entry before checking the
> command. When all pairwise entries are in use, DISABLE_KEY returns
> -ENOSPC without clearing the existing entry.

Is this the actual case you met?

>=20
> Move the allocation and bounds check into SET_KEY. DISABLE_KEY uses
> the existing key->hw_key_idx.
>=20
> Fixes: 10d58823cb44 ("wifi: rtw88: fix out-of-bounds CAM write when key t=
able is full")

Should it be ?

Fixes: e3037485c68e ("rtw88: new Realtek 802.11ac driver")

> Signed-off-by: Hungyu Lin <dennylin0707@gmail.com>

Then,=20

Acked-by: Ping-Ke Shih <pkshih@realtek.com>



