Received: from mta0.migadu.com (out-191.mta0.migadu.com [91.218.175.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D42364DA9B6
	for <linux-wireless@vger.kernel.org>; Mon, 21 Sep 2026 16:49:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790009397; cv=none; b=iYuFGmwcwj5TDLgvWbC8Puy+QIwjs6QZG2PHMlhrF+omODF25LP0wNqZJl07McuWgaUk13RCMjPKo3hRrSC7Jhb9pjV0ud7BttYdDb1XnF1R93qrUalUKsrJbN82Hw6PEtmsbJW9xiq5xR3h0vHVOWNPuGCZkgYDOV4vLmILhfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790009397; c=relaxed/simple;
	bh=NDobGIzs5b3Uefc445Jq7EmB+IvpyHSrD3Bm6iyA6K0=;
	h=MIME-Version:Date:Content-Type:From:Message-ID:Subject:To:Cc:
	 In-Reply-To:References; b=h/lBNsf90DDmUxHeHQMzsg5smVrnmtAo1ouO845AkQpoRis0QER1sca63dj5469GlasDFZfYqaVuOITDtn65P1lj5pgQxvILuQ2rzj+erZDcS1OSvdkd/nNQ55TeuEBcRKDI+jmNCqQGE875vy68kCE1Gg4+uGCjGF/FtsINAbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=GWvrLj+s; arc=none smtp.client-ip=91.218.175.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="GWvrLj+s"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=NDobGIzs5b3Uefc445Jq7EmB+IvpyHSrD3Bm6iyA6K0=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790009390; v=1; x=1790614190;
 b=GWvrLj+s+cJkD/03TqbByWhcmgraJpefPt6mgllYLaS8Bar4WFhG1r8+CKI3Yezk3KiTCshT
 NvaOFyLj9hOCqCDbqHeW693o0m9ohpJ0EumZvqzLrGI+AW55ts7UjfiFCykUOGoC8ynrD3Raf7Y
 FCelRi6mjdgY1K9mn4UgVwzQ=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id a8ff1c473300199e;
	Mon, 21 Sep 2026 16:49:40 +0000
X-Mizu-Trace-ID: a8ff1c473300199e
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Mon, 21 Sep 2026 16:49:40 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From: "Luka Gejak" <luka.gejak@linux.dev>
Message-ID: <31285267ebc43aab631a4199059a247a8d937814@linux.dev>
TLS-Required: No
Subject: Re: [PATCH v3 6/6] MAINTAINERS: add entry for the RTL8723B rtw88
 driver
To: "Johannes Berg" <johannes@sipsolutions.net>, "Ping-Ke Shih"
 <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, "Michael 
 Straube" <straube.linux@gmail.com>, "Peter Robinson"
 <pbrobinson@gmail.com>, "Bitterblue Smith" <rtl8821cerfe2@gmail.com>,
 luka.gejak@linux.dev
In-Reply-To: <45eb7d5908f8fff9a18cba603fd3a4abfe8695f9.camel@sipsolutions.net>
References: <20260921154347.82317-1-luka.gejak@linux.dev>
 <20260921154347.82317-7-luka.gejak@linux.dev>
 <45eb7d5908f8fff9a18cba603fd3a4abfe8695f9.camel@sipsolutions.net>

September 21, 2026 at 7:25 PM, "Johannes Berg" <johannes@sipsolutions.net=
> wrote:


>=20
>=20On Mon, 2026-09-21 at 17:43 +0200, Luka Gejak wrote:
>=20
>>=20
>> Add Luka Gejak as the maintainer for the RTL8723B/RTL8723BS support in
>>  rtw88.
>>=20
>=20How's this supposed to work in practice, managing patches to the driv=
er
> etc.?
>=20
>=20johannes
>

Hi Johannes,

It is supposed to work in the same way it works for other driver
maintainers. I would review patches and provide my acked by or
reviewed by them and Ping-Ke would apply them to his rtw-next branch.

Best regards,
Luka Gejak
