Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=95.215.58.7
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792932648;
	b=DR4LpXb+HavVED+Xjz6CCEEPy3mtN5/LrSBaNMiZV8lr+qqMysIFcBaTwCRTM8Rb5Ajh
	 yPxxDXDk7rqaOIQ7XFIF76klF6rFN8XEpS/cP7f2D2QatFmasYjUwtK9kzRj30+p+8EI0
	 P/bdxs/r28ZBVojc8T8eWVGlYlQ5DE27EQ8zbf6ruxutnkt6p9zGB9KaHytoZAto93Wqy
	 1Cdi//QMs9XuXJRPPL/aNON6sHnVc4TMcIgo9WTFhknTdWz795VYGYjpNrpm5nsCG7+EG
	 bepMRreMOrEppOTZfCsDqwh1Dxu93utH/8GFAhVPAs2Zh55EI5cQBunrj6B12zC+qGg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792932648;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:MIME-Version:Date:Content-Type:
	 Content-Transfer-Encoding:From:Message-ID:TLS-Required:Subject:To:Cc:
	 In-Reply-To:References;
	bh=cJ51G6pAmia1MscnsYfswwFx5AV+tMo1EILMAOCstQ8=;
	b=TUtIGMXS2yYJYmJGnlemOqpgoexYje0mgpp/nGFl+nMT7b5EIVfFbvoXfOvCoLNkOxiz
	 YTm7uR12YuH6PwdgXLt71brkG9TpC1IZ+X3ipS3CvcGgg2iIn6FsUB80L6VH+XrFcJbXI
	 S5zhKbOzS54KuP3m16FK3Wf1wrQeB7Bsuvz4QC8LSaNpT468Or2ANreirtFYv5esI8AAs
	 7KdrpnrOw3ABfdL3XJUc60Atg5IKGbmJZF806EuJQ2TTxXeZ9cDkODeLGSpNorIdJjBK6
	 oKMU89jioWgh8W3BZG91JmUUzeBBw+9l3S7ntqozK0zdbTCnQPpa4hj178+Z+wa3XLw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=o+YFH6E9;
	arc=none smtp.remote-ip=95.215.58.7
Received: from mta1.migadu.com (out-7.mta1.migadu.com [95.215.58.7])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A950606A31A
	for <linux-wireless@vger.kernel.org>; Sun, 25 Oct 2026 12:50:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9A950606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=o+YFH6E9
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=cJ51G6pAmia1MscnsYfswwFx5AV+tMo1EILMAOCstQ8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792932644; v=1; x=1793537444;
 b=o+YFH6E9hiMwoIwgOfBft1tB5r961JEuD65rDfF3YtfUMmX6O4NIQpOnQePRR3GVb1ztPkX/
 4skmivJOk4Gn90Q/0rHr87Mzi74KlMXeRfqgsJ04BAsfMCVmVaIazvLTgY8jLWHNZTr/jCAwrhm
 F0FXmzvOlNhG481S+g42FjA8=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id ebc4431b16746fed;
	Sun, 25 Oct 2026 12:50:44 +0000
X-Mizu-Trace-ID: ebc4431b16746fed
X-Migadu-Flow: FLOW_OUT
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Date: Sun, 25 Oct 2026 12:50:44 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From: "Luka Gejak" <luka.gejak@linux.dev>
Message-ID: <3d046336002a182f7751814750ddc522a53968e1@linux.dev>
TLS-Required: No
Subject: Re: [PATCH rtw-next v8 3/3] wifi: rtw88: time the countdown
 downloads from the TBTT
To: "Mehmet Fide" <mehmet.fide@gmail.com>, "Ping-Ke Shih"
 <pkshih@realtek.com>
Cc: "Bitterblue Smith" <rtl8821cerfe2@gmail.com>,
 linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
 mehmet.fide@screeningeagle.com
In-Reply-To: <20261021114543.4132776-4-mehmet.fide@gmail.com>
References: <20261021114543.4132776-1-mehmet.fide@gmail.com>
 <20261021114543.4132776-4-mehmet.fide@gmail.com>

October 21, 2026 at 1:45 PM, "Mehmet Fide" <mehmet.fide@gmail.com> wrote:


>=20
>=20From: Mehmet Fide <mehmet.fide@screeningeagle.com>
>=20
>=20The countdown downloads are queued one beacon interval apart, with no
> relation to the TBTT. A download that runs late past the next TBTT
> leaves a count out of the air.
>=20
>=20Queue each download 10 ms after the next TBTT, read from the TSF, so =
it
> may run late by almost a beacon interval; a later one is followed by
> the next at once. A TSF jump, an IBSS merge or a reset, restarts the
> schedule from the next TBTT.
>=20
>=20A TBTT just before the start may already have sent the first count; i=
t
> is taken as the one that did, so no count is sent twice.
>=20
>=20The USB chips raise no TBTT interrupt, so the TSF register is read. T=
he
> beaconing interface is always on port 0: rtw_core_port_switch() moves
> an AP there, an IBSS runs alone.
>=20
>=20Signed-off-by: Mehmet Fide <mehmet.fide@screeningeagle.com>

Looking good to me.

Reviewed-by: Luka Gejak <luka.gejak@linux.dev>

Best regards,
Luka Gejak
