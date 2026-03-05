Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 837AD27FD54
	for <linux-wireless@vger.kernel.org>; Thu,  5 Mar 2026 19:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.221.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772739198; cv=pass; b=iVmeakKUpPt/MrjF5olt4UcClCk8A4ZU0ztzXO0SCmFBa+NaNsKEQ09yzpyirfdC62xA8T4M2h74PGGyulIDOFynlrd/HBPIkVHCvbITCrvPWSdHwJSorHqxeZ6bsgIsh6Sj/8yXtl5ltMXcNaYs+H7B4uIXqsUwDCQMtOm8wbE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772739198; c=relaxed/simple;
	bh=3qFS8mp0A4He5fJiw82IIXCHjDSfPLpUJggQOZM0oiw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=m7C90C1a3KVb8jtnD72x7Qz9mBjxSs3Otr3DoTlJjPyUl6JEyIMjaYvWqYv8vn6gIHQauEbyVrEwMxjFS8yF69/cDr0YI5/HhJjhTSPY6me1K07yQWC6NiMvo5zdduB1Wr/aWlC0FRPW2STvlSH8yiGV0p19IxLVckNB5V97Q3c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jVeZOfAC; arc=pass smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jVeZOfAC"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-439cd6b09f8so1050374f8f.3
        for <linux-wireless@vger.kernel.org>; Thu, 05 Mar 2026 11:33:17 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772739196; cv=none;
        d=google.com; s=arc-20240605;
        b=FuqgAOYfR1ngyyBsyxJl/OrgzyVHv+5zKRnjmcXtPq0AiNGVy8FMCO63EN2Gy84hp4
         zzJYItj0ltB+cbdaEEyLwLAqD6dvCdpr0fxV4vj+7J4Bdgz0jiDtJnHgk0IgYR7Ar28G
         lk/2X8jxzs+y7UOKr1BwMMHuSuWcqbMHvbH8H1SfqMAbiVKC3zN9HgGqqp9gCQZ+u0FJ
         Vsur1ctXB4zGqIOlBoB/ZsPwP2EsIqQw0I3be3iZ2oHL0m3tw69uBKRMBKZh9SbLPvI/
         VjS7DGPBIPL4MPu8xsYynolfCW2BCRHIwproTtxrq2FOGaaYh9IaQpkJRfIsaempDru/
         MVPA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=3qFS8mp0A4He5fJiw82IIXCHjDSfPLpUJggQOZM0oiw=;
        fh=UZXJJrQmqEYHbZwQD8tNv2I+rmKJPcksSiE8mK73wHA=;
        b=J4V9T85iuqc1PKubuVm/A2kNbl7Lqzf4GuiaOJrpSNbJdf0tDsVR3mk3+gpjBZszY0
         r6ovkUTRmhNL2U8ysmUVL69wUi01Qxb16t255UsP7YhHBentXZ9ux/sn1VzGxfGrr+pS
         8oiwjlOB6cGrtjZLC/s4elLtlm/Z6pUf3FxLN5WYH8WCWFi7Ak+mg+1cKCd0Yorpkgt5
         Pr11KWOfv8V9z6ANhVeWR/D3re43SoF6WjTpQmoBXwjbU7zUh3aM7Tup7Ck+NQ9JaIp4
         /ugK1KwNtDx9NNL0OIs+ACaV8GV/+gLYIVdpIecPmzAKE641Zjn7w8xIRZpmkk9O39Bm
         9GcQ==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772739196; x=1773343996; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3qFS8mp0A4He5fJiw82IIXCHjDSfPLpUJggQOZM0oiw=;
        b=jVeZOfACPg/8VWD7c0bO3LaI/kL5nUbhPlYeOSdEfTHOF27afXdxGnlRqQy3x4KBPZ
         1Nm9UbzSUO7kjZpPI4DFnNmXW3D798vg8pR2z30ej+P2w4rHKXeC4KN/W78+LDbXnWGC
         xnaSmN46c+6c8yEgX6D6QvtkgUhsJ1G/lI0NtyvM3EeP3ZcNGG8++qjDkaHcZrSt2jhw
         Wxk6Ek6Aqxf4dI/5g/nqXwrQqFHpZg8RpvKRk2ez9wSuwas3rXG+s88ez0wDouD3EpB3
         1jU7fxTH5Xg2gsdAoiBXb7qEV4O4qG410kjIqh6/vlTR5Nb9mARFH74fptWt5EYCDrPj
         RlOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772739196; x=1773343996;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=3qFS8mp0A4He5fJiw82IIXCHjDSfPLpUJggQOZM0oiw=;
        b=PM14Sb2d+YkKPa8P29XTk/fP+dM5o8nKh6GK0oPX+7jwDpkIS/hYaxWofbMVwQ4oIR
         x9aWU9J+0yj76AkUYfrnnRRHTuBQIfeDA9xdR5dySvGXq3QyVtSBZ+P+9h+VCvDnu1kH
         kd3+zK+dFaNAh8kIKzsLEFrZuUe9hlT+vLXx16P68jrgvWg+KmBo93v2klN+PHTXuQun
         CGAMnmwPOG87r6MBrY4Fp7xgS/zdv8/EHYpzGPUZwbUbMZYyvbjN8zxPet+ATTpRznCP
         bTl/azPp3m6muZeUHDYVjG3i6yXlr7AX70mEhEi7/N6jG3Yl56W86ZgyMlLKjOxV6UWK
         9Gjw==
X-Forwarded-Encrypted: i=1; AJvYcCVpbvmNMPlFHViig+HqUQEXL4UzM4xk9aeB4Tf3zzeytDlgCHMNYpXadINZQrk9XYfzeAfUEtRBiRq4jvj1FA==@vger.kernel.org
X-Gm-Message-State: AOJu0YxELTcTbePV99TetXKA7YbUdEqskRVwTqnXNeaK7tjmYQ803G6H
	mmcc64zSD303+sNOBuRSNHxP776fxHquyV9/7hK/Y9quBT60//0M4b8ZIO+RjucBarklhtRIyIW
	LSmHqlh1tqVz/U9XpzCViNhOiXfFTUOs=
X-Gm-Gg: ATEYQzx7HQRamot5ESZ62LD2pTI2NsgALmb9ctI7/bmTSKNYabS3+qQUW6L30K2t0d4
	Kro7UFjng69DeHYAF50dlvP8rUzvWk0HIEks9ssl43lhEvSzh/CIJwj4fPpJxtTXdmY9SY17xI3
	GxQuhBD7TLih31/yJbD9+XQVqbqZoOpkkeKQXHDLh7iulU6xr5tQh471s1qWT9tnMpvhQIlx5TH
	mfkavkl0X9AqdrkkqF9xYhRnpD+XBiGYVTRZ+Yor+iKge7qG20cLCwk5gt9KWHM9y5QiDvmEHrw
	ePsFCgrz+zANPWlSyiB+vlZttoIwtCcf3q9ojeByZuN6PvzM8gMKHc+YQh3MmN2SdJLuBtcp3ks
	xLFX//SXnXFc1FA7Bwy68gX8=
X-Received: by 2002:a05:6000:2891:b0:439:be2e:7339 with SMTP id
 ffacd0b85a97d-439c7f62551mr14098972f8f.8.1772739195787; Thu, 05 Mar 2026
 11:33:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260305003253.1022386-1-kerigancreighton@gmail.com>
 <20260305003253.1022386-4-kerigancreighton@gmail.com> <dea45e4e-aebc-46e4-a245-3603da1779f3@oss.qualcomm.com>
 <CAN6+ztxfcNR8xR1qwgHQcHHM=zoQbMd-8oggb785ssPZ7f=y4w@mail.gmail.com> <CAFEp6-3JVicAVJB_+5ceSar2Jqstexo-0tyemg3C=qcznQsmxA@mail.gmail.com>
In-Reply-To: <CAFEp6-3JVicAVJB_+5ceSar2Jqstexo-0tyemg3C=qcznQsmxA@mail.gmail.com>
From: Kerigan Creighton <kerigancreighton@gmail.com>
Date: Thu, 5 Mar 2026 13:33:04 -0600
X-Gm-Features: AaiRm53h5gsIaUcJ-3bFQKEClfESn_bqkCltTUpNu0-wZ5K6CdZUoJq1mcxWf_M
Message-ID: <CAN6+ztxepeRaYPoTBj5rkeHZFhpZbNu4UYZ1Ajo-0cwsG4++Yg@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] wifi: wcn36xx: add support for WCN3610
To: Loic Poulain <loic.poulain@oss.qualcomm.com>
Cc: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>, linux-wireless@vger.kernel.org, 
	wcn36xx@lists.infradead.org, andersson@kernel.org, mathieu.poirier@linaro.org, 
	linux-remoteproc@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	robh@kernel.org, krzk+dt@kernel.org, conor+dt@kernel.org, 
	devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Mar 5, 2026 at 1:16=E2=80=AFPM Loic Poulain
<loic.poulain@oss.qualcomm.com> wrote:
>
> Could you please add these details to the commit message?
>
> Regards,
> Loic

Yes, I will send a v3 with more detailed commit messages for all patches.
I was asked to wait 24 hours between sending patch set revisions.
Apologies for my poor etiquette (sending HTML email).

Thanks,
- Kerigan
