Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6956A4156F5;
	Mon, 27 Jul 2026 13:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785158716; cv=none; b=b4ZmKtF2fGS06d3URRPiNAu5psDbyJYyVUwESkg53rDrx3fKJATAO/ty2hlAhQDHEcw02f0B1JYbnFHIqdRaOStT/QjPGTaDT/l2MecQQTNLQNlHm9ASrb2n0mKOk3wVMV78hILOZUq+xS3J/kjmqHSp/nRbQ9yS2anA9R6xziI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785158716; c=relaxed/simple;
	bh=2oMWlduBxecwHxKYQKCQxNLhp+KcxrlrZ0hzIry90Qc=;
	h=MIME-Version:Date:Content-Type:From:Message-ID:Subject:To:Cc:
	 In-Reply-To:References; b=VqGgp1VJB1btsE51QPFi//quWT8J4Pjwa/DOPkuPWpBxNsIQcEsfgHY9aNKksluxVVxjfy6RAuyYvB81rrHO1exPTXo67pB+13XoRNhEv6Nncv4A01+FJG32YuJqK//wCGbxu0lhogyoCJW0rnllKmmT0n50EYYLg49huRp0DTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=lkbdXTFu; arc=none smtp.client-ip=91.218.175.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="lkbdXTFu"
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785158709;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Kh9JjkvLwO3YQZsvQilGFQqhJQd6B3LsjF6OvGXaCo0=;
	b=lkbdXTFu+1Y7WSEZDXMQJLuJQysP2fsXOyUWw+CkbRD6tUNXv8hRSAljUPWPn/qwdQ23l1
	LAW847mZqeuBoDdSDHjwt/1Xu/7C++xHTJuJ8kjinNIMNXmW4AKNSqjo/enrz4r+/DmKBn
	MzLfvlEOTr2Yk6a3DMAMmqPKB49GK9s=
Date: Mon, 27 Jul 2026 13:25:07 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Luka Gejak" <luka.gejak@linux.dev>
Message-ID: <2b742bc6c2a247888b3df630183b85e367f8ffbd@linux.dev>
TLS-Required: No
Subject: Re: [PATCH v2 01/11] wifi: rtw88: add the RTL8723B chip type and
 SDIO helper
To: "Ping-Ke Shih" <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, "Michael 
 Straube" <straube.linux@gmail.com>, "Peter Robinson"
 <pbrobinson@gmail.com>, "Bitterblue Smith" <rtl8821cerfe2@gmail.com>,
 johannes.goede@oss.qualcomm.com, luka.gejak@linux.dev
In-Reply-To: <774407603bef4fd38290f6b5d4b4a26c@realtek.com>
References: <20260725150427.93887-1-luka.gejak@linux.dev>
 <20260725150427.93887-2-luka.gejak@linux.dev>
 <774407603bef4fd38290f6b5d4b4a26c@realtek.com>
X-Migadu-Flow: FLOW_OUT

July 27, 2026 at 9:12 AM, "Ping-Ke Shih" <pkshih@realtek.com mailto:pkshi=
h@realtek.com?to=3D%22Ping-Ke%20Shih%22%20%3Cpkshih%40realtek.com%3E > wr=
ote:
>=20
>=20luka.gejak@linux.dev mailto:luka.gejak@linux.dev  <luka.gejak@linux.d=
ev> wrote:
>=20
>=20>=20
>=20> From: Luka Gejak <luka.gejak@linux.dev>
> >=20=20
>=20>  The RTL8723B is a 802.11n combo chip whose SDIO variant, RTL8723BS=
, runs
> >  a Realtek vendor firmware that differs from the firmware used by the
> >  other rtw88 8723 family devices. Supporting it needs a number of sma=
ll
> >  adjustments spread across the shared core, all of which have to be
> >  restricted to this one chip and bus combination.
> >
>=20

...

Hi=20everyone,
I apologize for the sudden silence. I have run into unexpected offline=20
circumstances=20and will be completely away from my development setup
for the next few weeks, due to family reasons.
I see all the review comments coming in and I appreciate the thorough=20
feedback.=20I will address every single one of them and get v3 out as=20
soon=20as I am back online.=20
Thank you for your patience!
Best regards,
Luka Gejak
