Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.remote-ip=209.85.208.51
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=fail;
	t=1793592582;
	b=lkWNV5QvZwNGY1GlyPhr+FWRm9T4mWXAgLR4OFUrZIiNkWvn7/eJjkQJWFRUZPgaxUnb
	 sCiyaTyy0XFBeE7XBmGp22xv1A8ji65NNJN9JkXMPg+/7ZkFiyVo3M+9yGSzGW0T8IKtY
	 eQZ5XZbN+oRdyST/eGeAStQvAZgeDQg3W5cEN5afwNYdQDvOx57XdpqHkiaZk+pAyc/jZ
	 2o0MPHNIo5Hs9OW9MMoUmNG/8pFcgSdqZEDg32eX7M+Y7CdtDapik+aFZzRuQ9y4VlMqE
	 eI5cP0uRYJTtBACDyq3/G50Dxg12GizTeBZRm8HbaUB/UHmMVZOblfiUyPE3xieNkWg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793592582;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=oMe8V0wAAjhpcg5k07EFvoLZjdMDN1vdGTa6u17C93k=;
	b=fMGgks3jk7eAwhWKs3ypk68dxnIi5Scqb10U7/Ut4IvdTf+qHTy+ZXVp4/rryPy6Q7dM
	 DvsEo8qQlw8iZneqxovmk8U/5+8FHzfXBtx9i5sRqDk7v7JBqjI/sXJOT3z8iBfYKf2cc
	 nujL2u9o+wQfsaqCIC9xpwwKfgnoO09NPWpqvxgFWReAjO9mkO+6FVhBwEnqlORTAC63W
	 bZqnyj6AQyTJ2lwL+UQcdt3yLhl4n2/5FMF2VduNADhRrMH+Sbxs0Pp5yyP4VP4fC52pT
	 fH2/wPpurEy+XRC2S7+NK0qpm4dicSOCHBha2uNM9a0YlzmP1TwGLtCAP7T+7g3/tGA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=manxnVUc;
	arc=fail smtp.remote-ip=209.85.208.51
Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8D9A606A326
	for <linux-wireless@vger.kernel.org>; Mon,  2 Nov 2026 04:09:41 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B8D9A606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=manxnVUc
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-6b4a13789b0so3497568a12.0
        for <linux-wireless@vger.kernel.org>; Sun, 01 Nov 2026 20:09:41 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793592580; cv=none;
        d=google.com; s=arc-20260327;
        b=BaKj5atNQF/POAambOHBl2a0WbnGhp7q2aKEB6GXOiOs9k3YsPXtRfE8Te2bqPnVqd
         46XrDA6NcNj7cOGbhYnpcksPkjiRmUWq42mvAaWX+m8G2mWqas3bR0DtnCcKl4NTfGyD
         EtLAyCerclgzSBKcfS8XJAT9Nfjdcpxzi+TtHFiP+i2QuCArktDMVR3QJ5eGhjUU/H8S
         c3drX/oR8vBLuBLlgDpnsocvq+2TjDhnfD6OKwMJw31491bgv/qnOnDQggGdU4r5L7/I
         1uAnLrg601hsy3QfLy6MySG6NlAvYgU5CFVbnIftvRbVotB5mzwhtz3zD5ibdPGMCGdR
         ijuw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=oMe8V0wAAjhpcg5k07EFvoLZjdMDN1vdGTa6u17C93k=;
        fh=bn/o8qKFFLHQDmGUa+mkIbGhfeVyFhexi65OkFU1vNY=;
        b=HBkcVMIey4WAs8oFcd1gSrECl/6/ZZKo4U4AnaA+ye2HHGZyMoQmx4Woqe7SyczgXv
         f9+XlaQkqRGL//bkccksHyzNCow8xL7tTpZpM9HY0m6eU4eGO1soHg07hymgFK3mTzt4
         NXhld/G1enyeubH0jomZcuKio0uhruJ9Q4xo9Ap31oS/0+UM0g7bDtGlc8wS6wAm006X
         +LqIJtMuTPyiX0dG4zOqdwXmC7LmbFaeUU2qNCzp1kydAeZ25zBArnroEcXasX/fA2Tv
         5ZnNKFLPkuIvLcoajEj224850sUW4Rm24wkrNY9heUb7izB5eJ48feiO81Oa+NlCgy69
         0G9Q==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793592580; x=1794197380; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=oMe8V0wAAjhpcg5k07EFvoLZjdMDN1vdGTa6u17C93k=;
        b=manxnVUc8KeOoDen8Ui6END2+YERSoJVq3Iu6IkWI581JWz/iG7UkSSZD/Z11+xV4z
         skTE3gD2spnzTn/ql/WBXrS6Rsz5IqpGrMa4D335RmY8dopgEAtTiwfXId5gLmH1rE6c
         brhLorooVt+jQbp9osxORq8jtUE8tquoGm9zzRsJNP8RuQe0iNq/me4PbdrxyUmkQYm8
         eP/1UKQOh2UIdqT/XwB3NLl90HBLPkSUl8tROxgzLBK5flM7wqvdRgY2vKay+bzHWBsi
         sBuHfRPkRX4SNdQAeQkgPs74qHuTNMsD1tE8iXQAXEvC/RkS/apYCBa7XwuoyWtkuHT5
         bXnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793592580; x=1794197380;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oMe8V0wAAjhpcg5k07EFvoLZjdMDN1vdGTa6u17C93k=;
        b=fqOrjbJr9Rx28nWgKvXKZZyrMnDzA/17eBwcCVn6L/HgXlq3aBdSQ+HEbQYMI6qMyW
         //ruppKulBNniPK07XVtO8mAwae2s7rUoYs5Xeb2VNrJ/jnekgQm4LNFaUQABJXsvNak
         vND2LSVCp84/rJ03gGsx6FAKlTL5aP0QAL4+QhhmTkAKr9xnCmk1pS1QW67Xpp3gOUcT
         54G3x4vNN57sFsUZCUt85jsGWYODB4VlE5HJJJl+JKAXdkULfoqihsNb+iTmzXh7Jsfq
         E6rX2On5f6kE8v0TxgzKuOjZsFXE70DuppSLwexbDZ5PhEbFXtADYS69BfM9FtoGXBaj
         LSsw==
X-Gm-Message-State: APuU4Z/81+hPR4tHzk0TjcXdhxmNdJmmjpdECejXb0o8iHH2rrEPCc7v
	sDDhAszOY4G9anXv330di7WVA3WRzA1dni3z0aSrWyl5qIvc6xN7aKjUIfOrgTdFnTpXiFP/FqR
	wvGFwUv/jBD60vccTc6q+4uYhAK4iT/k=
X-Gm-Gg: AYBFou2oEk9VIdsiJGdu6USsebxGjCEx0emJJIKrTpECElyBzdWFxq8hjkwnEMTpJMY
	cjxC2eitLDsXNrTTd10H6FtX7bQqO4IRiqbWYU9j+Hsmv5YUWUHnpbK9Q8A28f1EwJNPDjhcdMf
	0wl6CoEhfpPT3D9OrQ068t8GOFWUEebVbheFmnteEGs5uaCszoi5YN0gRtIdECGzv9cRb0Q+0ni
	5hdoMfdiGs18MZdqCXob+rA094xAfKcZ1V67DIfAoFQH1zG7/c7whTTiC5oybMJb4qGoQvD7LkZ
	3oZhD9Q8PHd2xYy9LecpgfxqA10GhVqqk/XdgF17eCZsttO5fSSBsCgAEaPyTGK3NSwfjKlE3To
	T0Zf4Fmzk23qqDIiV+0BpQ/iXh92i/vZMQwAoUVvyfmubUD4OqBJDfCsfyWvWxtQ5E7FfOQ8bxv
	9L+f/SEDM8mZFU+0wyBBDWF/arjUwbQ4YfNGOIKxpZmWmXvInzVThWAdM18vmxZUuZl7754p8vb
	6b6OLLbr2l7tp9y7LgoI/o8FGQqdIMkmp9BPmOSwsURzyzI6Q==
X-Received: by 2002:aa7:da45:0:b0:6b3:e89b:128f with SMTP id
 4fb4d7f45d1cf-6b4d4d6d938mr4387808a12.9.1793592579961; Sun, 01 Nov 2026
 20:09:39 -0800 (PST)
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261101222535.34573-1-rosenp@gmail.com> <ebd3c83183464c3e9c218337a568b59a@realtek.com>
In-Reply-To: <ebd3c83183464c3e9c218337a568b59a@realtek.com>
From: Rosen Penev <rosenp@gmail.com>
Date: Sun, 1 Nov 2026 20:09:28 -0800
X-Gm-Features: AclHuK_jKe0Xxth3Cx5LMzpWC9m2Moacl_LQ9teKHl9xzgIDEwojGOVkQTWAUuk
Message-ID: <CAKxU2N9Bk71yaZY239w4kT3+o_p594xA5-jkNQ_BdWU8hPW+Yg@mail.gmail.com>
Subject: Re: [PATCH rtw-next] wifi: rtw89: acpi: check for _DSM function
 support before evaluating it
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>, Zong-Zhe Yang <kevin_yang@realtek.com>, 
	Kalle Valo <kvalo@kernel.org>, open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Nov 1, 2026 at 7:28=E2=80=AFPM Ping-Ke Shih <pkshih@realtek.com> wr=
ote:
>
> Rosen Penev <rosenp@gmail.com> wrote:
> > When the WiFi device has no ACPI companion, or the firmware does not
> > implement a given rtw89 _DSM function, rtw89_acpi_evaluate_dsm() calls
> > acpi_evaluate_dsm() anyway. ACPI core then warns on every probe:
> >
> >   ACPI: \: failed to evaluate _DSM e8c3a8d2-694b-004f-82bd-fe8607803aa7=
 rev:0 func:10 (0x1001)
> >   ACPI: \: failed to evaluate _DSM e8c3a8d2-694b-004f-82bd-fe8607803aa7=
 rev:0 func:6 (0x1001)
> >
> > Here the handle is NULL, and acpi_evaluate_object() returns
> > AE_BAD_PARAMETER. All callers already treat failure as "no policy
> > provided by the platform", so this is only noise.
> >
> > Use acpi_check_dsm() first. It returns false for a NULL handle and for
> > functions that are not advertised, so absent functions fail quietly at
> > debug level, as rtw89_acpi_evaluate_method() already does.
>
> The acpi_check_dsm() is to evaluate func 0 before actually accessing func=
.
> I'm not sure if all platforms will implement func 0. Do you know that?
yes this was only a partial fix. Will rework.
>
> >
> > Seen on an RTL8852BE in a desktop PCIe slot.
> >
> > Fixes: e897b0bef38a ("wifi: rtw89: introduce realtek ACPI DSM method")
>
> Does it need a Fixes? As I see, this is not a bug.
WIll drop.
>
> > Signed-off-by: Rosen Penev <rosenp@gmail.com>
>
>
