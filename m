Received: from mail-ed1-f51.google.com (mail-ed1-f51.google.com [209.85.208.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C8C52F0C7E
	for <linux-wireless@vger.kernel.org>; Fri,  7 Aug 2026 17:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786123005; cv=pass; b=q+FPY9nqA8IGa4/st+Z9+T1WAj3+2MHC6nMwDoACO77+gHInhzoZ4EJXVEtvL70aQIWgf3d8pzUiSNF/N9Lp+FkH0ttAXtS4uBEemp9sIsPFzw/ClUkjaCPi2a0WP4Pv9I5QtSEKiNrbGu5tH6rS8TpPimqDwvQha4YQQRs/GxM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786123005; c=relaxed/simple;
	bh=Rtx8ZmZNm5nMH0poOJXM5HHavD/fWSB/wPvaR1ec6bI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bYL7NkVwqObDtev7BxtnSANbGckb2oKwkTIWaxkh58FUAPVIR9DkuWweowzDzFQQV4ydNZDgg+pmyVp9BMvEJAYdjftaCas6f3+fXefsk1kC3C+XZlEXtLCJU4FjYtKjUf+LD49go0wLYkoYIgC1hbH4KzWLNPhwoykla4eApXY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=oR3mxwnA; arc=pass smtp.client-ip=209.85.208.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oR3mxwnA"
Received: by mail-ed1-f51.google.com with SMTP id 4fb4d7f45d1cf-6a18ef236ecso405148a12.2
        for <linux-wireless@vger.kernel.org>; Fri, 07 Aug 2026 10:16:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786123002; cv=none;
        d=google.com; s=arc-20260327;
        b=I2uixtuuRzIXfLcg1WfdJMz7A/lbOWS/xe7chq9TdbAWAFGnEVG8N0KCCotoE3Zpk5
         b3iVfpW1le8ZcNGxqJrdWHRFkKoNgYuANOFSsv2Fn/493+CDKgd4aL59KnuDdu02sAq0
         n9WJYwbc7dKa5lEaHgsJ3ZodA+umgDqmav6twRdg/RBPTb0FzXyvaUruXIP/48L3JwwI
         SdiW6J75gHSrNkTPdf+E3TlkvCqSbe6GK5DJRZLLNEzDgoLtRYBN7Wkik8g+Ufwb4Nfo
         3Po9fHOcZ13rJ92FfK6z/0wFvxO/z49KzjWsLc/xe1cZAhmfPc4hEDxJR2Imf+ObOICe
         ldJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Rtx8ZmZNm5nMH0poOJXM5HHavD/fWSB/wPvaR1ec6bI=;
        fh=Cj9EXtgPnivN08TWWEWmQ/oqdEN/OpcZ+2isSsJZYLg=;
        b=BjHZznn9jOjQQCWuoLjlXquPQCtFBuFzNoKX+cFFPTDM5kWSMvgE+VpznqmCLMRyAs
         U1MrMypS99lVOGzVctIRTYMaTinx9EQ+YOOq/sn6wYaHTrwtJwZYv/F1g1C+Y33xZVoT
         KroEmehkbM292PEo4xK6XH1oiCIpGTsw8RFufJ58nbKcshmCeuYF6ufhUVOV9yZ3aDGw
         o2WyC1J04Q+i1JC0q1bsKgW3qdhGcFZvrKinXbAUlwg/3DGUCgTBwDsQWDj4DVEIdPCq
         RN1o/sKHlArCIlh40+gAWzGOxNxBjSG0FmQ9c//lYdGrjCco4Y+nTjQ9QazI3AIUnHRG
         HinA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786123002; x=1786727802; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Rtx8ZmZNm5nMH0poOJXM5HHavD/fWSB/wPvaR1ec6bI=;
        b=oR3mxwnA+tkTMgtqEhW1tsb85qlAwqf+87YN/egDgBM1uOGGAtbYi2ecWJPtp6HGnS
         tHPAn+aCvBhZHli6ewZ8HVWkOiEFsiC0oMWRkjaYIZ+JSIV1W8m07C7VEunEpFJ53yQT
         bV6doIG7teD7Hu7heSMQzU3KznmrPTbTwKc6XSA7J67UFkDL6j9tuRsIphHAuNk/vt4k
         D6Gl8QNooAzaa+DERYyp0muSa8nPuVyhSXz8vth/HOfM9Bvippi46V5/Aoj3y8UESDik
         BZBGCd/bJpuxGkxz545ieDiPMEPrv9u6lba+zMNqxe/WUfXWQ4FkKg5bxIzmdsQr9Y9w
         aoZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786123002; x=1786727802;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Rtx8ZmZNm5nMH0poOJXM5HHavD/fWSB/wPvaR1ec6bI=;
        b=MmHtuZQMJiBvDNA6MHEhRpPX5GUk68Io4aQKcZS+mQuSXZWNnxNvI98FqyjyEd+K+A
         N1dwp7YW5SnmsqMDUDS8aiDgeNMwaPsThlu4YgyFY5wws+xAlPRZtHJdejfVQBvDV+mh
         d4O0Y7DZr73dQlQJ4C9hm1JZa3GPBpG84gxChoyF89wUya5I5kjUoJQv4S3g6Sm4eofj
         slTA55NDNp7mBzYRC8ho1jWVvCVdk/UERZNwKrdyl6zFENr1y8PzYQJF0PMGOO92lBz8
         MGuMvuhoAwNSbcifFi0agCIwhLUlQeBv3F6gC0PwiNJz+8s5mX1UMh0Ut5gj6v3ZEPpG
         k4hA==
X-Gm-Message-State: AOJu0Yzyvg3d8zjb8T5fx8RgzQFlflrRc/fkHH1bXiFXBUgq0CWQ3myA
	6bwxrKKTjnYAMpsKFiFVQIDtaLDYexWGaoxpQ7XkhBuqfvajc2HdTr4rHgztEZVam+SWhHuarR2
	UO0aO6qMJc2s9RFHr9h/MilzqOOteoJ0=
X-Gm-Gg: AR+sD12eQ63YslUeobEoxgrMzGgGXvVDnOUN4CLwlJ2XdHbI0+zgUfkDPMdvohqcbYP
	qMT0zC3kjuO6CWvdw3Sb7DUPP4iWLcJzqzTse8ZfhqMaVh/kLncVCbkVgdGH4gsZ6nfgDD6/eCE
	5MlB3eG0K5iYXfSEgW7Td37DV1nDaiQPWv6JkAYNZbgH+yLN0M2/3phxrAQ7DwYjbaXtdN5+qqB
	/voay7YCUw1+Pos/du1LZFLtIMjxnN2N7d5bFdT1xsG0BJRB8Y04+s2wZOp9qDYiYWx6oWvZVMD
	59T7v6Fwsou+fwo0+hX5BcswYoeWQzN4o1X3+nJUXOT9s61ISAFBBi6uym151+1NETg4tAabfVQ
	Y5lOIaqW/8WHRqmuK5p/3MEzKvGZTt/SBtzj1iEsJqZA=
X-Received: by 2002:a05:6402:1e8e:b0:6a0:a4f4:bca4 with SMTP id
 4fb4d7f45d1cf-6a14f07c8e2mr6612492a12.1.1786123002218; Fri, 07 Aug 2026
 10:16:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260807163418.487508-1-bogdan.nicolae@gmail.com> <19fdd238f38.2873.9b12b7fc0a3841636cfb5e919b41b954@broadcom.com>
In-Reply-To: <19fdd238f38.2873.9b12b7fc0a3841636cfb5e919b41b954@broadcom.com>
From: Bogdan Nicolae <bogdan.nicolae@gmail.com>
Date: Fri, 7 Aug 2026 12:12:48 -0500
X-Gm-Features: AUfX_myiUNyTJjYFkszlm8txJvLhnyde7l5fcWYkuiyDB5Q-vCiwqt1JvwI0dCg
Message-ID: <CA+ORkNRRZ_qES77+12=Cx2rs_ntVqmOB0vzUtTOJddabpMvAyg@mail.gmail.com>
Subject: Re: [PATCH v6] wifi: brcmfmac: cyw: pass PMKID to firmware if present
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless@vger.kernel.org, brcm80211@lists.linux.dev, 
	brcm80211-dev-list.pdl@broadcom.com, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Sure!

Best,
Bogdan

On Fri, Aug 7, 2026 at 11:52=E2=80=AFAM Arend van Spriel
<arend.vanspriel@broadcom.com> wrote:
>
> Op 7 augustus 2026 18:37:48 schreef Bogdan Nicolae <bogdan.nicolae@gmail.=
com>:
>
> > Zero out auth_status on initialization. Otherwise, garbage will
> > leak from the stack to the firmware (when ssid is less than 32 bytes
> > and/or when params->pmkid is set). Then, pass the params->pmkid to the
> > firmware (without it, the firmware caches a garbage PMKID on successful
> > authentication and denies a subsequent association request that include=
s
> > the PMKID).
> >
> > Fixes: 66f909308a7c ("wifi: brcmfmac: cyw: support external SAE
> > authentication in station mode")
> > Signed-off-by: Bogdan Nicolae <bogdan.nicolae@gmail.com>
> > Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
>
> Hi Bogdan,
>
> Looks good so my Acked-by: still stands. Thanks for going with the flow.
>
> Regards,
> Arend
>
> > ---
> > v6: Fixed diff line number
> > v5: Fixed line length > 80 chars
> > v4: Fixed indentation
> > v3: Added Fixes, Cc: stable, and Acked-by tags
> > v2: Split into a separate patch
> >
> > drivers/net/wireless/broadcom/brcm80211/brcmfmac/cyw/core.c | 4 +++-
> > 1 file changed, 3 insertions(+), 1 deletion(-)
>
>
>
