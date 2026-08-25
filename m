Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 441DF35C68D;
	Tue, 25 Aug 2026 07:42:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787643775; cv=none; b=hGnBhe7tM8rEbSnfMM/B5LUASQn5aZM9yqc3EtzTTCav8umEnzwQ7sUi1mrh2CWVMi9OVwvZSLUtwAN6PNHvFtL9sy1E7P/ikglxCzjRdh0VvoE3JNEE0mNwnQfqDmwj6LNe1HnTp0ogzdd7d4F1/Ek722c7yw8BA5pC0DXZ5SU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787643775; c=relaxed/simple;
	bh=WvTjdu8yH5vjgdj5tJW2weN5qnCixnOw9T/0WylMwxE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=irZChDAHYA/i5ZwOR/ORnI/LbJ9w7Z//G6JwVzjyvRbvxD2pPCQhdaluGomlw2pdDYkpQL801+WHdszoOA9GI8SPFTWtEK1jom4zQvgsTGCTT7Zq6e7xph7UuxluHdqtnfjj0cCxLKOdMeN13DZ8lk4jd2wO6yEbEJe5rrYGB0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=LLQO8IPy; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="LLQO8IPy"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 67P7gojqF3611515, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1787643770; bh=WvTjdu8yH5vjgdj5tJW2weN5qnCixnOw9T/0WylMwxE=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=LLQO8IPydqKa3UreIOjvbeUx63ALwQVOgk/oZyJr/CMvybfdcewBEOkj4fmnB1ZQB
	 yeehezxgqyPq+LLriu7kiy1j2MMa+9MTv0NdDj3AxMs4Id7yjVvyhUCyNV6SSgkP5D
	 7ch3cDplDkJCFK411PWw9H0QDJPpAboVT9a01lCTcgtGDqQuARIhB6sGLMm3R372N+
	 p8Ae6SGVq5XLyynRrWuptAkVR5UuTorCq5TI1NVYm+yXEgo9CpRIHvKrffPUw61xwy
	 O0TWLHNg0TCje+1qf6l2VpTPdw6eaKvf89BUyygceiEOsSiHYOJ2N78MXS44iQJw9i
	 az2aYPE+lkuMw==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 67P7gojqF3611515
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 25 Aug 2026 15:42:50 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Tue, 25 Aug 2026 15:42:50 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS06.realtek.com.tw (10.21.1.56) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.43; Tue, 25 Aug 2026 15:42:50 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::126f:59ad:658:674d%10]) with mapi id
 15.02.2562.043; Tue, 25 Aug 2026 15:42:50 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: Arsenii Pashchenko <ulijg308@gmail.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH rtw-next v6 1/3] wifi: rtw88: rtw8822c: Use bitfield
 macros for DAC IQ sampling
Thread-Topic: [PATCH rtw-next v6 1/3] wifi: rtw88: rtw8822c: Use bitfield
 macros for DAC IQ sampling
Thread-Index: AQHdLJn77Ob2z7O5d0SItixpGB6YhbaucV8Q
Date: Tue, 25 Aug 2026 07:42:49 +0000
Message-ID: <0bcac19c8e3044f69dfb8ebbf5276b76@realtek.com>
References: <cover.1786784750.git.ulijg308@gmail.com>
 <b23c1d0c33b79728f5717b0f15d0cb7541bd9493.1786784750.git.ulijg308@gmail.com>
In-Reply-To: <b23c1d0c33b79728f5717b0f15d0cb7541bd9493.1786784750.git.ulijg308@gmail.com>
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

Arsenii Pashchenko <ulijg308@gmail.com> wrote:
> Define proper GENMASK constants for the In-phase (I) and Quadrature
> (Q) components of the DAC IQ data register in the header file.
> Replace manual bit shifting, masking, and rtw_read32_mask() with
> standard rtw_read32() and the FIELD_GET() macro to improve code
> readability.
>=20
> Signed-off-by: Arsenii Pashchenko <ulijg308@gmail.com>

Acked-by: Ping-Ke Shih <pkshih@realtek.com>


