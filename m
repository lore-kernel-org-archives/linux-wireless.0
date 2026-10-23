Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.54
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792790502;
	b=f/Ok6O6aaTqU1fH44udzKzdf9LBVAdhsIkRKnCaKXxNujfOxvNqY9l6h6JNXMBk0u5r9
	 ei3X9RtC2oveRgoRFNteYLHvPD3nY7FWWPpzX0brXHGj7+HEjVINJwYmsB5GRprmc/Hhb
	 Z1zfrcvJ35MsDh5isIGbJSXQVu2xZAzcWtZMmVY8zFkHIFFnjYjbAr645wUVUrCGLwX+4
	 uWXpnWxEwktf8NXKPVnXIcWcnLns9mZpQ3k8IxjISca4sGu1ibYdAVwLF9sSTKWn9he8A
	 94jztt11p0CLPPgGqx/HmulRUei+5v4Y4SnYLWddKXcAE87tvGHTMVGHGNrLAV3xIuw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792790502;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=AE0GbBfNma+sNfNfxTvMZspamc+IJ62E4ebI4HKJzHI=;
	b=I/o+9wbjSLCEo3mpB6hOjjILZ4osOHldNcaooyE3hj2hrRZXuLWiD/DLBUYSJGo7m46e
	 mslzh5Wmo0/nlxnPja0MPM6vNLR66mFyynTnfwQA5p6k7UIZMnMDj21ZFG9Mz7+s0HGSE
	 wip0Wf7/6dfVpR/aLZEFL1M/QtyOgLonbLj5MWF0QmEEn9Ktk2P1Bn5ev4hDj13uC3xsF
	 0aXi+UVZQpo43f/any0RyaNoh5dA/Rzgt7TwZxgj4akfn7auexOFNxA5T3aM28Qc0MK9s
	 EOrhVFx230dJ+lo9O518hHYz5Fc5/c5yEQdNGIj2VQemaeBVd1Ie+8wgBv+GVO8Leyw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=LNibhi+i;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.54
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6983A606A31A
	for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 21:21:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6983A606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=LNibhi+i
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-6ae305e3bd9so2153403a12.0
        for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 14:21:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792790501; cv=none;
        d=google.com; s=arc-20260327;
        b=VlLG9ETjeQGZHB3ih+zdTjVPQQPY5dsKUS7qXPWkP1o0+8Ncctvjiweu6GzFKaE3xj
         zooqPtUgJCGN00QwTVomj2huDmSRh4SOv71yiqfRDQ0KdxM7nkEbNSHdXUJqyNk63hL5
         3KI+jF0LMsKwLrnJTxRVu+fEmeDRA51eq+zGM7RLD6k2pZSZ9AxXk1ugcl6uTTVlZISM
         q1upsCyHUVmNN44sFcG0hnFr7C9ng/214/70FkkOopXtZhwbxQ1cNhM48KnD5glcIZXA
         23uVku0Z0o8C++wHX65bmnYb/fSRi71STwhge3AhC5pb5Gf1FUk6WgiuYWeUMREd6K9U
         5iOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=AE0GbBfNma+sNfNfxTvMZspamc+IJ62E4ebI4HKJzHI=;
        fh=kpWsed6Gl9Jw39uHHbCW8BjdBcTvPDR+t7LwYL3VZw8=;
        b=cL0mBQAcLAtHHucM9FcGrROlCSvMbSTZ4e5UI3bq+Qg3AEbHfm8Sz5LssIc2SUDUV/
         0cW0B/1hCtJCqVh5WwyEGG317z51kINl+LFH4DhVzINeHvgdUdiJvqmezuvJw13ZEy1p
         kU2be1J0i8uDzi8gut6KmSnQWBpJvSwEI/XzO+/m5rUTEKmZc7Ms4qAhcKChtwn390t9
         Jjlu+fpT2bcMTyOfGTxmQWfoqLHI+XCkcnSIZltoeKjlP5uvc2nGlOmXIu9AsKvKpVOG
         g+kCh2J1KUj37bxHh2xV2+01SGFpVNRow+2vfiEAeMvppxoHFEnII69iT7VS7zElTzBY
         No6w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792790501; x=1793395301; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=AE0GbBfNma+sNfNfxTvMZspamc+IJ62E4ebI4HKJzHI=;
        b=LNibhi+ilzYWV0TvVwj/ILgZRg3O8BNOUVlDKMjYBbf2alSGrhFE1ImXw0sfRqOrlW
         3tAwPIgjpg87VEAhnE/KWA8GzYxTANeK7+NOvkfGQc2CVED32HVR+a9GSDQdHyudUEGQ
         QoJicWJqQngB8VOuawmYrCUD0dsArr7awxJgAoZZJ63udfxlxKKpLXzrSiIK6ih9VDe1
         vAKuP35JnKk66f33Qg9xjFzX/HHw30ohXb4Cp4T1ahHuz6pfTV5JVwO3U1ITbHx7ISt1
         x2ZiOK0EfWDd792YmowRViLqOzzTH6wOa2hF9F1Dz2AD+3rbCof+k6BSSj2p0whsLliN
         99cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792790501; x=1793395301;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=AE0GbBfNma+sNfNfxTvMZspamc+IJ62E4ebI4HKJzHI=;
        b=wcIb64//3dCAPymJfPquBN1S7jxHnMwccL1iHxn4iAXynJjG7eCq0oBSyciWU5zvdU
         oP1CseSMapL7BJ0ypdga7ZuOsRi5xIwICC/+6MMDDA39LXG7EmSj6WXnbfNBv4eE4NkS
         qvuVv58/fZuYLy4fkEqlYew4Vqg0BeosAErCcCwSDG+fY2+yjeT83TLo7YHC1yGT8XNk
         dFTAb64PtFHrNmBTOIHooudQp7okp3RA0OAxs3NuWfOVIovRtlvi5UpV+w/FUlhAj8OF
         5Zoq2MQlkuc0+o/5soFAUno383LZIjeUPLunqQrnmBTZuwC4vLv+hsZ7BGgEjR59W6a4
         1YAQ==
X-Gm-Message-State: AFq9FYJNOxJC0RB2mBvIfaPbAhojcIz6iMsaZ1HYegG1M7YC3PM3wCHz
	x13hjkhlQmWPlS1WQTaWRj1U3+xFunZXT92UB1gturlDw6RShF/e+UOJWJJrv1Cpb+VHG4MYHk4
	3o9w86UGvG116xsDZlbwPoBQw3HLWRvyeZxTF
X-Gm-Gg: AYBFou0n6k+ThzhYqBg6mrUtWr+ToXwl7bX/FaeYYQeI3Wcm4E3ASMslqBw24wGCUg9
	ZlJVUscsHskbAtadhRwiVhoRYZZdKBo6rMm2fkHUKW8FBaz6BilCcLjLKyF2pfQZ+KhcvL8Dcgr
	BUqzYQE8/5jNENFfDojsTXBfH9uhqmFNgmflNH+CA9E57KVubpD8xRxr3I4WLD4PCQ7KmNPEUGl
	HzwIiegiYk2gGX1gX52bpBGliRq1PxxBgcHErUns3a0lYCzWvoEBh1FbVxG59tYbn5XdHNy+cmg
	1d6JXmgm4e1k+qMY1DawPXbfPduh7rjswbPWJvi//2FqrcBdRPX9gmGWsmkjveksJZo7fe/oG1t
	GolTpIHCfceoGRNvwexTmSf212g/HGsGepWTLpFqwDQDaopjj00U5LvSgyKMJowqzXrtRncOWfr
	XFhP4kyBYD8H5e3xLDmrhNPx1rimhxe6wLMRHPnBeKjc0/hsLcJ5kLDz6rRDlVks17s9NpY8gwr
	348s2f9j+hE/KvN0cVqcL0CAquD1SjV4Gz14jBZluk3Sb9X5Q==
X-Received: by 2002:a05:6402:1cc4:b0:6ac:bd53:d29a with SMTP id
 4fb4d7f45d1cf-6b442a80c06mr508793a12.3.1792790500756; Fri, 23 Oct 2026
 14:21:40 -0700 (PDT)
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261023190653.70741-1-rosenp@gmail.com> <20261023221424.2722795e@barney>
 <20261023224140.465903eb@barney> <CAKxU2N_1XgjVPdSrCMYzZx4Rb6yjgEe7kBZYyG4RASyBv5BtMw@mail.gmail.com>
 <20261023225745.696eef3c@barney>
In-Reply-To: <20261023225745.696eef3c@barney>
From: Rosen Penev <rosenp@gmail.com>
Date: Fri, 23 Oct 2026 14:21:27 -0700
X-Gm-Features: AclHuK9GRIFtl9lqIXhWNWjMucByyfNnLezcnXbef4n3dCMQ4w9XYcqaCpFWgVM
Message-ID: <CAKxU2N9i6Dn1yKmd-_9DvET6P_GNctTywWgOBXYd2tWoWKY=Sg@mail.gmail.com>
Subject: Re: [PATCH wireless] wifi: b43: map the RX buffers DMA_BIDIRECTIONAL
To: =?UTF-8?Q?Michael_B=C3=BCsch?= <m@bues.ch>
Cc: linux-wireless@vger.kernel.org, 
	"open list:B43 WIRELESS DRIVER" <b43-dev@lists.infradead.org>, open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Oct 23, 2026 at 1:58=E2=80=AFPM Michael B=C3=BCsch <m@bues.ch> wrot=
e:
>
> On Fri, 23 Oct 2026 13:44:44 -0700
> Rosen Penev <rosenp@gmail.com> wrote:
>
> > All code is tested on an Asus RT-N16. It runs on non-coherent MIPS.
>
> Ok.
>
> Describe your development process in human language during patch submissi=
on.
I assume that would mostly be appropriate for a cover letter.
> What has been tested?
> What has not been tested?
> What was wrong?
> What has been fixed?
> Why is this needed?
> Why do we need bidirectional DMA and most important why wasn't it necessa=
ry before?
Because the codepath is not fatal. One or two duplicated frames. Big deal.
>
> AI is great for code generation, bug finding, etc.
> But for patch submission, pull requests and commit messages it's absolute=
ly unusable.
> Please don't do it.
> Write your commit messages manually, please.
I've been burned by this many times before where maintainers ask me to
reword or mention something. It's not practical and wastes everyone's
time, which is why I'm almost banned from netdev.
>
> Please make your commit message be to the point and easy to review.
> And please slow the process down.
> You don't need to submit patches right away. Keep them in a queue and STA=
BILIZE them LOCALLY.
I figure since wireless doesn't depend on the merge window unlike
wireless-next I can send them whenever.
>
> Please do a little bit of research whom to To and Cc. There are scripts f=
or that.
Yeah. All of this goes through ./scripts/get_maintainer.pl

Do note this is an orphaned driver. I expect feature patches to get
clogged up and Fixes: to get in a bit easier.
>
> Thanks a lot.
>
> --
> Michael B=C3=BCsch
> https://bues.ch/
