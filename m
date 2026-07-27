Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61E381F91D6;
	Mon, 27 Jul 2026 02:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785118011; cv=none; b=l+Rj2WhdvTOvGaVWEXTCUf3dNKYJ07+dmnwVXsXRA1p66RMxM6AHxV8lrNfrAihNWqisH0DTq/WLT/yf20tuCidOWajv/kvEL3rLyse18wobDNpvHmfzZXdnUQ43o6uMCvwCdshLMEPkFQVGlztPigvFghrLhOz49ZLT15PT0RI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785118011; c=relaxed/simple;
	bh=cEqmGPDboYvQfniQZNXUK/YpbfWEbTKZHSZTNmy4fSQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=j0O1PXflHu/aXukzEdIQk4w1WVW64+lQGfimpuOHa9mQKlHLUBwhgPPVuubfC4icPOJylmlCcMLxs5u4lclZHXqCgp+GLIU0iTosFha3TILGNwCGaNye0cfSQsAih28GiSixipvKd9zMYbACQsevlEDcJvntIRXcxB/ZNd9DCDE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=R0RYWf5g; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="R0RYWf5g"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 66R26loyE2755114, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1785118007; bh=cEqmGPDboYvQfniQZNXUK/YpbfWEbTKZHSZTNmy4fSQ=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=R0RYWf5gMFoYnvTJr75PYxp+fOVJtCdkKORG5hKraY2FB3xCeYddRgBDD7brYhdCs
	 F9Fdz3uK9qgdr0ZPDz0uCiOTeCF/MS0dxbt5eP686Xe7KsldwIzauuCM5UhY7OKin1
	 n+uS8RmfP48e6kllKK70rMtByRLX7JDGE/kp8NOymlTa6Kl+i67GoikoCikFFnqKmM
	 9PeKM15ON71v9vmq4Tz3Hxml2tWGZ3hL/KFxOY7PEl+V07rylSM5NZvHTbxM2m16IE
	 ttkcEmAiGaWjDpMoXW9NUKd15VAQNTio3TLz0SjTVdA3EcUTgu5Ap/870uR4zkdtcC
	 Ivuec8995/Zjg==
Received: from mail.realtek.com (rtkexhmbs03.realtek.com.tw[10.21.1.53])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 66R26loyE2755114
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Mon, 27 Jul 2026 10:06:47 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS03.realtek.com.tw (10.21.1.53) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Mon, 27 Jul 2026 10:06:47 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::e6fd:5a3f:8946:92c4%10]) with mapi id
 15.02.2562.017; Mon, 27 Jul 2026 10:06:46 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Sang-Heon Jeon <ekffu200098@gmail.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH rtw-next v2 2/2] wifi: rtw89: remove conditional return
 with no effect
Thread-Topic: [PATCH rtw-next v2 2/2] wifi: rtw89: remove conditional return
 with no effect
Thread-Index: AQHdHQRdh1DYuy98QUOHI3o+oSCrf7aAnrjA
Date: Mon, 27 Jul 2026 02:06:46 +0000
Message-ID: <67544abb483b49cf859ce38b2bcf5d8e@realtek.com>
References: <20260726134034.1385834-1-ekffu200098@gmail.com>
 <20260726134034.1385834-3-ekffu200098@gmail.com>
In-Reply-To: <20260726134034.1385834-3-ekffu200098@gmail.com>
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

Sang-Heon Jeon <ekffu200098@gmail.com> wrote:
> Both branches of the check return the same value, so the check has
> no effect. Remove it and return the value directly.
>=20
> This is the result of running the Coccinelle script from
> scripts/coccinelle/misc/cond_return_no_effect.cocci.
>=20
> Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>

I'd update the subject to be more specific during it gets merged.

"wifi: rtw89: remove conditional return with no effect in sys_init_*()"

Acked-by: Ping-Ke Shih <pkshih@realtek.com>


