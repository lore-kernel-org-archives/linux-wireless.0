Received: from mta0.migadu.com (out-21.mta0.migadu.com [91.218.175.21])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABAA8309EEC
	for <linux-wireless@vger.kernel.org>; Wed, 14 Oct 2026 13:13:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.21
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791983599; cv=none; b=IpFtwcAd/XbRf40ct/U0Pba+3GyAcGFinjos9Jv0bljhIZGPRbyQnVb/Y0aQaYXoJoBuZL7wEBCZO1B0K9OFqqmGYXOlgURdw4Gk2oNsHAjWeA6YgLXgUPLomGtrSFaNznX6EO1YZ73zTd+BzSfmWv9qHkwm9VLjAlYlRMnP51A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791983599; c=relaxed/simple;
	bh=MBQeS7aKBL9jc2BojvONKyZ7ZEKUC3n50pEkcwW+B4o=;
	h=MIME-Version:Date:Content-Type:From:Message-ID:Subject:To:Cc:
	 In-Reply-To:References; b=u46LJxgSuS70j7DwQyroU5RtJ+6mwh1QUt1t0GgYSurTZbAuwOblDugAZ9uD2ARWnCfqXt3+HPeo6LxYMG27g+nM6sHzsc+k44meVxeE7m5T2AjOe/NsgvPz9IaanZHhzEvSzJ7JRcaepMPt6wOmZSA8Xg3biIrEeVXsvjcN3ec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=cL+J4tlp; arc=none smtp.client-ip=91.218.175.21
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="cL+J4tlp"
X-Envelope-To: linux-wireless@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=MBQeS7aKBL9jc2BojvONKyZ7ZEKUC3n50pEkcwW+B4o=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791983594; v=1; x=1792588394;
 b=cL+J4tlpsyq9Z3S9DQgSL7F/Ow1MIn7u0t2j0JF+ijcmx0D8QXWLJKX1PM5KUAhtPoKGhdA+
 dVr/McxbQ2WoXnWuJFB9wU+msPR6IuaDRVfn/vWUQjLlpQ3fHWnd2t0kufvDPHHvQaGa0CQMq2M
 qd9DKJ1SerVSSdQ784Z5iAIo=
X-Envelope-To: linux-wireless@vger.kernel.org
Received: by smtp.migadu.com with ESMTPS id 0398f7b3c6b27810;
	Wed, 14 Oct 2026 13:13:14 +0000
X-Mizu-Trace-ID: 0398f7b3c6b27810
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Date: Wed, 14 Oct 2026 13:13:13 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
From: "Luka Gejak" <luka.gejak@linux.dev>
Message-ID: <cbf165fa6213c22e88559081ca1c160375c9009c@linux.dev>
TLS-Required: No
Subject: Re: [PATCH rtw-next v8 5/7] wifi: rtw88: 8723b: add the RTL8723B
 chip driver
To: "Greg KH" <gregkh@linuxfoundation.org>
Cc: "Ping-Ke Shih" <pkshih@realtek.com>, linux-wireless@vger.kernel.org,
 linux-kernel@vger.kernel.org, "Michael Straube"
 <straube.linux@gmail.com>, "Peter Robinson" <pbrobinson@gmail.com>,
 "Bitterblue Smith" <rtl8821cerfe2@gmail.com>
In-Reply-To: <2026101452-chapter-friday-dada@gregkh>
References: <20261006130701.120460-6-luka.gejak@linux.dev>
 <3db085e6c3c14545ac9fd4221e0715ed@realtek.com>
 <df4a73de51784e35c15a39e85e4dae9629ba1132@linux.dev>
 <e983dedfeb9341ad9d8cf159656395c6@realtek.com>
 <df8313a72bdef1dc8859a4ac018370b24b606766@linux.dev>
 <d403e88ca53841fba87190764e2a45cc@realtek.com>
 <2026100746-delicate-carless-a04c@gregkh>
 <3028b229a6fbe02d2bcfa30c497b6a768ba8c928@linux.dev>
 <2026101046-transport-unnerving-96de@gregkh>
 <4464409846710dfa13134265f0f99523714cfa92@linux.dev>
 <2026101452-chapter-friday-dada@gregkh>

October 14, 2026 at 3:04 PM, "Greg KH" <gregkh@linuxfoundation.org> wrote=
:


>=20
>=20On Mon, Oct 12, 2026 at 11:31:57AM +0000, Luka Gejak wrote:
>=20
>=20>=20
>=20> October 10, 2026 at 12:18 PM, "Greg KH" <gregkh@linuxfoundation.org=
> wrote:
> >=20=20
>=20>=20=20
>=20>=20=20
>=20>  On Wed, Oct 07, 2026 at 10:35:25AM +0000, Luka Gejak wrote:
> >=20=20
>=20>  >=20
>=20>  [...]
> >  >=20
>=20>  > Hi Greg,
> >  >=20
>=20>  > I have sent the patch, and I think you are going to like this
> >  > number: 66186 deletions
> >  >=20
>=20>  Very happy :)
> >=20=20
>=20>  >=20
>=20>  > Not sure what people are going to use to learn though. It seems =
to
> >  > me everyone is repeating the same patches.
> >  >=20
>=20>  Yeah, we need to dig up some more out-of-tree kernel code to add i=
t for
> >  them to churn on. But really, this is a good thing, it's nice to see
> >  real support for this hardware finally.
> >=20=20
>=20>  Hi Greg,
> >=20=20
>=20>  As both of you and I know there are not many young people in the
> >  kernel community and the steep learning curve is a big reason for th=
at.
> >=20
>=20Really? We average about 200-250 new contributors every kernel releas=
e
> until recently when it's shot up to 600-700 if not more. So we don't
> seem to have a lack of new contributors for some reason...

You misunderstood me, I said young people. I asked multiple young=20
programmers=20who were interested in linux why aren't they contributing
to the linux kernel and they said that it was hard for them to learn=20
because=20many issues they find in staging(which I believe you recently=
=20
called=20learning ground) have already been submitted or nacked.

>=20
>=20>=20
>=20> I was not sure whether you were joking or not about the comment
> >  above so I decided to find that appropriate replacement for staging
> >  rtl8723bs. After searching I found this interesting xradio driver,
> >  which is a mac80211 based driver for some orange pies and other devi=
ces.
> >  It is around 18,000 lines of code and upon check it out I fixed bunc=
h
> >  of security issues per se and lockups that caused kernel to hang and=
 it
> >  is decently stable. I'm not gonna claim some extreme stability but i=
t
> >  is at least usable and it has many coding standard issues. It is a g=
ood
> >  candidate because newcomers would be learning the modern architectur=
e
> >  and on top of it there is a lot of janitor work so people can learn
> >  the workflow and etc. Link is [1] so you can see for yourself and te=
ll
> >  me what you think about it.
> >=20
>=20If you think it is worth adding, sure, but normally we need someone t=
o
> actually care about it getting into the tree (i.e. real users
> somewhere).

As far as I know it is decently used piece of hardware so it should
have users.

>Also look at the bottom of the readme, shouldn't the
> existing in-kernel driver just be tweaked for this hardware instead?
>=20

Possibility,=20however it would require someone with sufficient knowledge
to tweek it, which who knows if it is as simple as readme says. And I
didn't mean it as a upstream ready driver, but rather a place where
new people can learn as I previously said.

Best regards,
Luka Gejak
