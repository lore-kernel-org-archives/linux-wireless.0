Received: from mta0.migadu.com (out-221.mta0.migadu.com [91.218.175.221])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90FB94119F7
	for <linux-wireless@vger.kernel.org>; Mon, 12 Oct 2026 11:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.221
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791804721; cv=none; b=usQAcgxARRsqPhmA5S6+ZMNZeARePMH18ki76XoGpFOcz+LUGkIf20032FkX0B9QkhWz+9lddrw1iaRPQ44+LniGS65ly5rykdnj0Zebd8PhSL+GpKvCWpviHvzbX9GJNA50EGksA7CwAmNDDCrxRI7bgTADgM+IuBUNwUw+Ong=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791804721; c=relaxed/simple;
	bh=cIPz+FcRLCJYG26UTeh56lynHdfsK0gkKwxriM3p/Wo=;
	h=MIME-Version:Date:Content-Type:From:Message-ID:Subject:To:Cc:
	 In-Reply-To:References; b=USdravQ0QW7S9436QI4TtBEVCrn1oZTX1xsaG4wKgnzgnGhh7FbUlXnQI2jGaRkdLBw9RhQRW+svHuIT+zIpGUVkInwimD5tbWAfYtBnYRObW0lJgMwuHaXEMF0SeGZ50fHUvFxcteKWpowQXxXr3zN1eSS2e/OaoqBP2U1XvW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=qeuEclMT; arc=none smtp.client-ip=91.218.175.221
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="qeuEclMT"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=cIPz+FcRLCJYG26UTeh56lynHdfsK0gkKwxriM3p/Wo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791804717; v=1; x=1792409517;
 b=qeuEclMT7bMZtt9C+j04hFRJzwUzEg47SxGw/3QVYtGKI9EwE7077y4T1XK5u6RDGAgt9rdI
 V2PE5KYKstswpkhFA+Q9Qb4wUaPCx7rTRv2+5UPgS6Rpk8J9uJj6LbQqZb0yOdjtZjgdKACD+vN
 eCwd4xfHT+594djSkmbQz08U=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 0f2951c553dc3202;
	Mon, 12 Oct 2026 11:31:57 +0000
X-Mizu-Trace-ID: 0f2951c553dc3202
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Mon, 12 Oct 2026 11:31:57 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From: "Luka Gejak" <luka.gejak@linux.dev>
Message-ID: <4464409846710dfa13134265f0f99523714cfa92@linux.dev>
TLS-Required: No
Subject: Re: [PATCH rtw-next v8 5/7] wifi: rtw88: 8723b: add the RTL8723B
 chip driver
To: "Greg KH" <gregkh@linuxfoundation.org>
Cc: "Ping-Ke Shih" <pkshih@realtek.com>, linux-wireless@vger.kernel.org,
 linux-kernel@vger.kernel.org, "Michael Straube"
 <straube.linux@gmail.com>, "Peter Robinson" <pbrobinson@gmail.com>,
 "Bitterblue Smith" <rtl8821cerfe2@gmail.com>
In-Reply-To: <2026101046-transport-unnerving-96de@gregkh>
References: <20261006130701.120460-1-luka.gejak@linux.dev>
 <20261006130701.120460-6-luka.gejak@linux.dev>
 <3db085e6c3c14545ac9fd4221e0715ed@realtek.com>
 <df4a73de51784e35c15a39e85e4dae9629ba1132@linux.dev>
 <e983dedfeb9341ad9d8cf159656395c6@realtek.com>
 <df8313a72bdef1dc8859a4ac018370b24b606766@linux.dev>
 <d403e88ca53841fba87190764e2a45cc@realtek.com>
 <2026100746-delicate-carless-a04c@gregkh>
 <3028b229a6fbe02d2bcfa30c497b6a768ba8c928@linux.dev>
 <2026101046-transport-unnerving-96de@gregkh>

October 10, 2026 at 12:18 PM, "Greg KH" <gregkh@linuxfoundation.org> wrot=
e:


>=20
>=20On Wed, Oct 07, 2026 at 10:35:25AM +0000, Luka Gejak wrote:
>=20
>=20>=20
[...]
>=20>=20=20
>=20>  Hi Greg,
> >=20=20
>=20>  I have sent the patch, and I think you are going to like this
> >  number: 66186 deletions
> >=20
>=20Very happy :)
>=20
>=20>=20
>=20> Not sure what people are going to use to learn though. It seems to
> >  me everyone is repeating the same patches.
> >=20
>=20Yeah, we need to dig up some more out-of-tree kernel code to add it f=
or
> them to churn on. But really, this is a good thing, it's nice to see
> real support for this hardware finally.

Hi Greg,

As both of you and I know there are not many young people in the
kernel community and the steep learning curve is a big reason for that.
I was not sure whether you were joking or not about the comment
above so I decided to find that appropriate replacement for staging
rtl8723bs. After searching I found this interesting xradio driver,
which is a mac80211 based driver for some orange pies and other devices.
It is around 18,000 lines of code and upon check it out I fixed bunch
of security issues per se and lockups that caused kernel to hang and it
is decently stable. I'm not gonna claim some extreme stability but it
is at least usable and it has many coding standard issues. It is a good
candidate because newcomers would be learning the modern architecture
and on top of it there is a lot of janitor work so people can learn
the workflow and etc. Link is [1] so you can see for yourself and tell
me what you think about it.

Best regards,
Luka Gejak

[1]: https://github.com/MocLG/xradio
