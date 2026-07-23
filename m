Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7670940DB23
	for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2026 19:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784833880; cv=pass; b=l6iUfbgRp1nJlZhgva+ah5ERSVpyPvDQj8grvrbZEng8H05HhUyZt8tBPH9kEthzg1dhQD70R1jnPEGtEVpYrWMojKDBmdJbYeICiMtUhuZ7YRoCfb6kAstZcyfFm1dO5q0Fm98SYTj4vdBF9x+8gu8LJTBNAO8p4DRNF4nrHLA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784833880; c=relaxed/simple;
	bh=Jy4ZFM2hPqvnICpNDIshDTGRPiQJLz7rUIZXtr65qaY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MvUUJnLGmxHx4zKZu+6XOv3yTY4PRqPz3e4ta3EXXobhWDUnix91DM9YmR6hnpK4Aa30njQugJ/grByeTTfu/dZAf1NaoI+vgvcnrlwP6dIngxdP6oD0o0zMFJW5GY8YHisx3+D3TJUJWPXXWX7qY2oL/ofOrc0soVYnO2PcASw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Mi+QLYtR; arc=pass smtp.client-ip=209.85.208.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Mi+QLYtR"
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-69c7c8accffso1692849a12.2
        for <linux-wireless@vger.kernel.org>; Thu, 23 Jul 2026 12:11:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784833874; cv=none;
        d=google.com; s=arc-20260327;
        b=Vi71JzWwEfVEj83WKU7NdQ3Scm+MMb3H7Q20FPAw68p4JE+LLZ+J598FOEjafoD9wS
         dSJOMUQVCp1dvm0IJkXkSqsEpfsz/yTHyNEuRPRk7jAK1eZSXMctIKN+9zRts7bVNxiy
         niMKIr78r+6AWWxE0qBb8L0u6mf5bU425V17aujAfC6cNKz5mEp2W7DAkkI2UWeJBlz5
         gT75w2TwV2IcmGGNVNcAs1/BWaeAdX2/lRvUnE/qrqLt1Nui+ScL/7rCuLpMQktfWZ5J
         aZV4WR2CfMJMuCkExYZzsJDUmDF/sYk/fkic0fHDaT/rqZfnPFKySVLsidJH1PZwfG5e
         BNKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=eyesa2wDmxBN2egWZDKdQBqZPV4bAgzTIQgV8gXp914=;
        fh=C5sWzTxBEKYY/LVoEe/NunCantQBIv61beLmSuCbQmg=;
        b=gSehbSV9V1BVCPox+5g1T/ZFdqqSt9oea8XPJ2co0aIagcbATpcFpxr/HcxexzR4pq
         5n1tlWpU6uF6+tH2Ndwe3TOsJje9ens2Wvby7qggWRYSB12k/QXvlMIfukjrF/HvKIaa
         PVJIY58IyavoW+W+7whbYpw8B4e+QK0QdeGlPMQ3pWHgAV51ANVCGETEXcmsrUDZsWBR
         +/0wJNi+J9q6e+82cZyv7XIX2F+jD3kDEYuop1ILf/VNpmg6Z7d3V/7aWhb6qPgxZD+j
         XA9i/RHEiVyQ/FCYFz3Q0GW9vzTfePuKCreXP1qDFfFZMHt+HRpgHCvqzMpMB/up649G
         2H7w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784833874; x=1785438674; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=eyesa2wDmxBN2egWZDKdQBqZPV4bAgzTIQgV8gXp914=;
        b=Mi+QLYtRh+9Fx2PlyyTncQ6aBN9jBfTvyQKe0YyHouoCXX19nqP9ULsCeGn0qCBJYn
         HG/fbL4Fsao714ZCMVxNCjOPYU2g0YKCPuO1rEzECb66NzWyCA8QjrHvEf3vvFjBF44r
         ZdDfNuDK4HR/Az0PK3cbr4N+g3ne4kpQ9A6W81vawpp3z1SEfEIP7An+YHVCVfIaAAP0
         gzxkHE7t6RAhkt0TD/w96DDhIBRbA5w8V58PVCIZTcIhMmpTK7B5eyGiuD9JR6GL/EvK
         E3lN8o1I3usZFuQQ5Fycas+lls60tVwrrOVIE5ZkINyXy2y94pVhfR7YANfo7Z4GCQZr
         VViA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784833874; x=1785438674;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=eyesa2wDmxBN2egWZDKdQBqZPV4bAgzTIQgV8gXp914=;
        b=jb1srODIaX5ztJLQMrUuLUfkbJo6iTeRgianawtcyOoBinhD2gQMAxL5rPQEY4OMM8
         148PIggEZJ/QG4oPwNX+3w5s8+PemO3BWJPDTNkSC9SjHu3Pt78LUCF9Gyb0d7Ur8cqy
         ry/fJPLUv4sSH8nBID0Tg400oZQ4NbP46FBo8iE7ANhJ3sNAL+0WLERF0G8a8gbEKxtL
         WYfT879lSrz4puMJPb1GcTXxFcKZNmVuA/u85NLGHFukNih7JleTldoAw+IAyfeMrE2W
         i1+wp+a2vZ38GJk/+8G8q3k5suLpriipEp8SfFkr96allRI4TsRlYbdDg5lCdIcoj+Jz
         AQJg==
X-Gm-Message-State: AOJu0YwDaESFBUTctGvXcuUVuvSvvrIhLjGQ4kCni8VE3fkNM53MsGeq
	UFYlefFqqqyHcRjX3bEL4itDJ7Z1/153ICF5AHLcSOwQQci/UIrgARvgDJaMUaz9Zh3C2F1A9S6
	7k8MRadiQUwhORT/AgLZ2DwTiWHSS5AI=
X-Gm-Gg: AR+sD11dw85QrUY20x94SrLTf29lZyY6DPPm2acy4qlbGqJtyQp2bQXPPguuwUq8QUr
	DJaWaIMjLwIY3kZc0jfGZNyxroHjgiYF9Onutv8Jj8ajeCWgOMHY839buyMCjlb7gu/2YA1z8RH
	elCUlNWkwmZlmHdMBLa+JbdrVbWc4/MSnmNCXBK62V5Wlg5CXbxznErJWp0clr41oFYqfazxiOK
	6QXKfz7oyFT5SUL5faK8bQmmsUEQbCdtN/vcDUrboc0xbJe45Q6/naRwTWqRKdct2deg9J4QWRA
	291Td+ZhiTUZgNgICKPBLBTUoohlPnKhOq8xsb/Iz/7Lx5bRxCvxVkbEbgFktsIi/VZHgpyHg4Q
	+oB+LFHxSTdUa75ZDUnv0QPzwnNm3Nd2T1OaMIRDJvdtHsjVWNwxoztZ3ZZfKRcis5UWZ/IIlbq
	0g0RVzdgk=
X-Received: by 2002:a05:6402:210c:b0:69a:aa50:32b8 with SMTP id
 4fb4d7f45d1cf-69f6ccd4d4emr1761216a12.36.1784833874104; Thu, 23 Jul 2026
 12:11:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260717220052.824624-1-rosenp@gmail.com> <20260723083310.GC4577@wp.pl>
In-Reply-To: <20260723083310.GC4577@wp.pl>
From: Rosen Penev <rosenp@gmail.com>
Date: Thu, 23 Jul 2026 12:11:02 -0700
X-Gm-Features: AUfX_mzcWSPUJfftp6yxoaeZYhq3ma1BMmM4hLXAp2NCpC4gQmYXHZRQpIjyoqs
Message-ID: <CAKxU2N-pzAXW25yO09X26BzCW_3KHJz_nBupDJNqB=OdWBOScA@mail.gmail.com>
Subject: Re: [PATCH wireless-next] wifi: rt2x00: Use device-managed register buffers
To: Stanislaw Gruszka <stf_xl@wp.pl>
Cc: linux-wireless@vger.kernel.org, open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jul 23, 2026 at 1:33=E2=80=AFAM Stanislaw Gruszka <stf_xl@wp.pl> wr=
ote:
>
> On Fri, Jul 17, 2026 at 03:00:52PM -0700, Rosen Penev wrote:
> > The rt2x00 PCI and USB probe paths allocate EEPROM and RF storage with
> > plain kzalloc() and then free it from bus-specific teardown helpers.  T=
he
> > USB path also manages the CSR cache the same way.  These buffers are
> > tied to the device lifetime, so the explicit free paths add probe and
> > disconnect cleanup without providing separate ownership.
> >
> > Allocate the buffers with devm_kzalloc() before the mac80211 hardware i=
s
> > allocated, then attach the resulting storage to struct rt2x00_dev after
> > the driver-private state exists.  This lets driver detach and probe
> > failure rely on device-managed cleanup and removes the duplicated
> > bus-specific buffer freeing.
> >
> > Assisted-by: Codex:GPT-5.5
> > Signed-off-by: Rosen Penev <rosenp@gmail.com>
> Acked-by: Stanislaw Gruszka <stf_xl@wp.pl>
>
> >  int rt2x00usb_probe(struct usb_interface *usb_intf,
> >                   const struct rt2x00_ops *ops)
> >  {
> >       struct usb_device *usb_dev =3D interface_to_usbdev(usb_intf);
> > -     struct ieee80211_hw *hw;
> >       struct rt2x00_dev *rt2x00dev;
> > +     struct ieee80211_hw *hw;
> > +     __le16 *eeprom;
> > +     void *cache;
> >       int retval;
> > +     u32* rf;
>
> Nit, u32 *rf;
whoops. Should I resend?
>
> Regards
> Stanislaw
