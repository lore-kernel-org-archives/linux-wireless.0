Received: from rtits2.realtek.com.tw (rtits2.realtek.com [211.75.126.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88BC138BF7F;
	Fri, 24 Jul 2026 09:29:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=211.75.126.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784885396; cv=none; b=KYABxqIT+INpmfeVuB4Gy6z9QNKSeGWXzzcqBXRPjOHRAFNol7VS9GVLm38Dpz8jt4JdwkZsrJWKB+fJx7HroeP8+8UrN8T4sYTZRumEZeG0qsmmSQQqMVjTbgORhACJFb98sNxf97SkKsCkbLmSQTeZXM1kO0QbCl9UmXqjvz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784885396; c=relaxed/simple;
	bh=QbAX5r8MEL2GQOGVwCggevPWa8EXFUAaN0SPjjSlzW4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=QBK/pAEWdKYes4B2KsufJoHmb+FlkjllVEINJ62sp/OumhvK5pwHL/UgRkyJPwcX6EcNMUy+ivlrZ3CDGKXuFYhvIBWEP2iCytZBqACnWjfFSeHJW5JLRiHifbiidfGl96DMU3ZEoaFoynzFssAXXXTZvAivzx/m3K6ngBsmJ6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com; spf=pass smtp.mailfrom=realtek.com; dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b=ta/dGQ1m; arc=none smtp.client-ip=211.75.126.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=realtek.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=realtek.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=realtek.com header.i=@realtek.com header.b="ta/dGQ1m"
X-SpamFilter-By: ArmorX SpamTrap 5.80 with qID 66O9TfpuE1099265, This message is accepted by code: ctloc85258
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=realtek.com; s=dkim;
	t=1784885381; bh=QbAX5r8MEL2GQOGVwCggevPWa8EXFUAaN0SPjjSlzW4=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding:MIME-Version;
	b=ta/dGQ1m6xCimi7x9WLy9fUwdQwZptl7RLdSNvamC5zXzf+ksLiI0CgXiktyP2eRK
	 LOcq6K+GpWaGDUH2ykGynHnB2SxZL61d2PKR9QdffiB120RPAQVaKj/B6DRpKbQvsQ
	 X0K49RJRiG8Qbz7C3HEtnb/2FYxBxLujCTz1wk+oKy7DATAEj5LEJkmNhn17gQks4l
	 Jv+EeJnRhTs7k9Hz9A4yLI296DpsQLOpKv+/U2nad4Omx8DzDWFucDvEBcvVk4OOtH
	 wGr4qGEiwAg0cEROclBB1Ru2tU6KoZ68u0FLYvDGXKL65FtfQVb4qsLp6f9ZYn49tY
	 gITC5G7nzK+8A==
Received: from mail.realtek.com (rtkexhmbs04.realtek.com.tw[10.21.1.54])
	by rtits2.realtek.com.tw (8.15.2/3.29/5.94) with ESMTPS id 66O9TfpuE1099265
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Fri, 24 Jul 2026 17:29:41 +0800
Received: from RTKEXHMBS06.realtek.com.tw (10.21.1.56) by
 RTKEXHMBS04.realtek.com.tw (10.21.1.54) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 24 Jul 2026 17:29:41 +0800
Received: from RTKEXHMBS06.realtek.com.tw ([::1]) by
 RTKEXHMBS06.realtek.com.tw ([fe80::e6fd:5a3f:8946:92c4%10]) with mapi id
 15.02.2562.017; Fri, 24 Jul 2026 17:29:41 +0800
From: Ping-Ke Shih <pkshih@realtek.com>
To: "luka.gejak@linux.dev" <luka.gejak@linux.dev>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Michael
 Straube" <straube.linux@gmail.com>, Peter Robinson <pbrobinson@gmail.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>
Subject: RE: [PATCH v2 1/4] wifi: rtw88: 8723bs: add the core handling
 required by RTL8723BS
Thread-Topic: [PATCH v2 1/4] wifi: rtw88: 8723bs: add the core handling
 required by RTL8723BS
Thread-Index: AQHdGhVIJ3zQKvQe4kuuvRh5AuZE7LZ8Y82g
Date: Fri, 24 Jul 2026 09:29:41 +0000
Message-ID: <47e555f89dce4a0997e19d7ba753dbb5@realtek.com>
References: <20260722200337.135150-1-luka.gejak@linux.dev>
 <20260722200337.135150-2-luka.gejak@linux.dev>
In-Reply-To: <20260722200337.135150-2-luka.gejak@linux.dev>
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

luka.gejak@linux.dev <luka.gejak@linux.dev> wrote:
> From: Luka Gejak <luka.gejak@linux.dev>
>=20
> Several of those need explaining, because the reason is not visible in
> the code:
>=20

It seems like you misunderstood what I meant. You should add each necessary
functions by individual patch. Don't mix them.=20
(Sorry, I'd reply the cover letter you wrote next week.)

If you consider these all are necessary, send preparations as first patchse=
t,
and start to add RTL8723BS by second patchset. With a large patchset, I can=
't
respond quickly.

Ping-Ke

