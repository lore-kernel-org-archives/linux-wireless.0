Received: from mta0.migadu.com (out-138.mta0.migadu.com [91.218.175.138])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED6C24399F4
	for <linux-wireless@vger.kernel.org>; Wed,  7 Oct 2026 08:39:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.138
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791362384; cv=none; b=GQf20dA+K8RUiEeFTk0OPFAj79FBQAiLotWdARvkYhsqSpZDMp+Tg6HnWksiHgn1kZARisqsHy9pd+AMfPSJujFvhBqRgcuaaGb0dApE/UcPScI3EfO23as4NGO1pBCxT89HyxRDGNRAXLFB0lGUv0ftsIBOyv3S8RwAGQFHcQA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791362384; c=relaxed/simple;
	bh=9WXxY12b0GYBTAIFVH24B0Boge6q6M522SI4PJvLyGE=;
	h=MIME-Version:Date:Content-Type:From:Message-ID:Subject:To:Cc:
	 In-Reply-To:References; b=bcLgrf9/TOYoLu7aDFLeFe2qco8yogTG34g1rh0sd8116eNgxIDRwigPmH8g82c91qLhTDWIec0LJOOPZP3EcFXh1W1l2xn5eA5Z1vAHdp0Vla39Zly9MbRK+Vl33pkwssm4HN8C60wlfQ7iLCIw4lf2VHIjjBbp4/zhI54XMyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=S3P4Nheu; arc=none smtp.client-ip=91.218.175.138
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="S3P4Nheu"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=9WXxY12b0GYBTAIFVH24B0Boge6q6M522SI4PJvLyGE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791362378; v=1; x=1791967178;
 b=S3P4NheuCsgBBccvP1mpr8nmXJpX1cpCCAeBfC9MSyKdPQJ+C0A0YNXkJ1uS53bYRSLUEQcE
 5y6oV7MvrwAEgUsAXr10SA47JHeHWfBmSV9SqOWrkLEGUJWKMnmcJ0aIxcAwubzRuoS5QpMUpjP
 OsTTV9LqDLRKJFCROUIl5GGM=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 7e40719aa91f84dc;
	Wed, 07 Oct 2026 08:39:38 +0000
X-Mizu-Trace-ID: 7e40719aa91f84dc
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Wed, 07 Oct 2026 08:39:36 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From: "Luka Gejak" <luka.gejak@linux.dev>
Message-ID: <df8313a72bdef1dc8859a4ac018370b24b606766@linux.dev>
TLS-Required: No
Subject: Re: [PATCH rtw-next v8 5/7] wifi: rtw88: 8723b: add the RTL8723B
 chip driver
To: "Ping-Ke Shih" <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org, "Michael  
 Straube" <straube.linux@gmail.com>, "Peter Robinson"
 <pbrobinson@gmail.com>, "Bitterblue Smith" <rtl8821cerfe2@gmail.com>,
 luka.gejak@linux.dev
In-Reply-To: <e983dedfeb9341ad9d8cf159656395c6@realtek.com>
References: <20261006130701.120460-1-luka.gejak@linux.dev>
 <20261006130701.120460-6-luka.gejak@linux.dev>
 <3db085e6c3c14545ac9fd4221e0715ed@realtek.com>
 <df4a73de51784e35c15a39e85e4dae9629ba1132@linux.dev>
 <e983dedfeb9341ad9d8cf159656395c6@realtek.com>

October 7, 2026 at 10:32, "Ping-Ke Shih" <pkshih@realtek.com mailto:pkshi=
h@realtek.com?to=3D%22Ping-Ke%20Shih%22%20%3Cpkshih%40realtek.com%3E > wr=
ote:


>=20
>=20Luka Gejak <luka.gejak@linux.dev> wrote:
>=20
>=20>=20
>=20> October 7, 2026 at 04:57, "Ping-Ke Shih" <pkshih@realtek.com
> >  mailto:pkshih@realtek.com?to=3D%22Ping-Ke%20Shih%22%20%3Cpkshih%40re=
altek.com%3E > wrote:
> >=20=20
>=20>=20=20
>=20>=20
>=20>  Luka Gejak <luka.gejak@linux.dev> wrote:
> >=20
>=20>  >
> >  > Add the Realtek RTL8723B 802.11n chip driver: the chip operations,=
 the
> >  > power sequences, the efuse layout, the RF and IQ calibration, and =
the
> >  > chip specific coexistence handling.
> >  >
> >  > The RTL8723B chip support is based on the initial work by
> >  > Michael Straube <straube.linux@gmail.com>.
> >  > Link: https://github.com/mistraube/rtw88/tree/rtl8723bs
> >  >
> >  > Co-developed-by: Michael Straube <straube.linux@gmail.com>
> >  > Signed-off-by: Michael Straube <straube.linux@gmail.com>
> >  > Signed-off-by: Luka Gejak <luka.gejak@linux.dev>
> >  > Reviewed-by: Bitterblue Smith <rtl8821cerfe2@gmail.com>
> >  >
> >  Acked-by: Ping-Ke Shih <pkshih@realtek.com>
> >=20
>=20>=20=20
>=20>  Hi Ping-Ke,
> >=20=20
>=20>  Thanks for helping and reviewing the series throughout this
> >  upstreaming process. Just one question, when is the series planned t=
o
> >  be applied to rtw-next? I am planning to send a patch to staging to
> >  remove staging rtl8723bs and I need to have information when is it
> >  landing.
> >=20
>=20I'll merge this patchset and send pull-request tomorrow, but I think =
you
> should remove staging rtl8723bs until this patchset drains to upstream.
>=20
>=20Ping-Ke
>

Ok. Thanks for information. However, by the time this series reaches
upstream, won't the merge window be closed? Therefore 2 drivers for
the same chip will exist for one kernel version, and Greg previously
said that when a driver is merged we should remove staging so there
are no two drivers for the same chip.

Best regards,
Luka Gejak
