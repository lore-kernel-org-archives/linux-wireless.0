Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.175
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792777089;
	b=0dKkQlgFgDxYdPQMgXsHpAFoo0+qG9TBgi/dCS0O6AhDjMVkY5eTOYXtLi9W624JsIMJ
	 7ZKwhKTV3z165HY23pjFSJImFlukiPYBPDaJoQGCy0UElRBE9xHv7pVeUKrmXjLo7d/1T
	 kAUSVg0hY5PQI1mKbO7dTYMTd9zZHk0auCoT/Ake6EUtc0Ps5mvOu5w7HrucEOv7RJQ+T
	 G744nC58tboEydxOfBz7Ow7rLTH9SSVV61XDsLA/O5OZnwtFQiBhkbRvC2ZYGGeWRymBn
	 uCQkreBRTN2qCQd0asDwMmAVzN2JA0puK5DZlVhG+Y8aPcpqkUVkP8VYmbSZFnHaEQQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792777089;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=7SleIgzgD0Ym0qkpIeLydzQGzolB+0IIJ55uqtkTIdM=;
	b=MRN3aNvOwx0oK0hcrIhOKD1TeNuck1ugjBV56ivX2QJ8db5v6IxMP9CXLdgAAVuHj5AS
	 2n/RyC0gO/SkDDqKPCs352S/VhfWkCDL7miK4YMHRTSFmyd7H8gxJeGoQqSbz34hQqrwS
	 gX6byK+5OoEAiO9Em+qVOWEMfmPnHO4Pi5nbe8e5wYQTKE8vdsfP32WfHYUC06qfn9n55
	 dARbkK5HOlMRInwC9xwHtoVv/Pov8+CXNwzz1D6ie7JdaU50eSadDvCVDW0/RC8Bmiayh
	 Pg5WbFU2Ti42egkd1FwzknAlvZQPC3fW6TWQoWOJdfGv31RnOEe2YvmYXvnsfdx6Cvg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=Ngfzo2V1;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.208.175
Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61B01606A323
	for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 17:38:09 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 61B01606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=Ngfzo2V1
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-3ab46699a09so9903811fa.0
        for <linux-wireless@vger.kernel.org>; Fri, 23 Oct 2026 10:38:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792777087; cv=none;
        d=google.com; s=arc-20260327;
        b=p4t5w5ha7tztXhP8ePTMb1Q5A0GbMfHE7hv5K+Daqfjau8AzY1xrYUSGuKbM3peIy+
         kKUDRQQp0GjdGkTQf/7i0f0uP2OFsh9UAw6gPDdv3GYH1SIzhUzhCwE9+ldN0pCeMjPY
         Uf590l10+n7ZJcKusRIr18OaSjW3YrFfhUzlyq3RNSrIeL0SJ2geYK4SYoJby5m0i7XI
         hpE2N7jEItTLNzwtFCQS3e1g60/tWChzb9jHRhZ7tM6bLq6m7diBRSOMEyLfHxgUXdt3
         RMCNaSwno/KvkKEmS+e+D/ezkgVui1z4vGgzpKg3/C7Q8FZXahIBGThSbWAtU7UiaMiB
         V2kw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=7SleIgzgD0Ym0qkpIeLydzQGzolB+0IIJ55uqtkTIdM=;
        fh=S8BbG/0kzLwOEf+3hahyxdJEDTdWj460JZvv2Xf9hHM=;
        b=G8gmsiEp1ipOeKZFiFbWMjVtJqE8jF5q3w1lHJyh/dke+unq80oK9vWj+KrtEUzfE2
         z2yAVYl90KuAM8tPzSA+9wl0tUXtw9HPxTvTdVxuF/Luz80pf8aX70gU+YnnxhJvVcR3
         JvpJpx4vT/QpSuO7IeUwBW2YOno/RfSP+fab+YQjl6JGlrWOuEBUSy07ASAB2udB2RxS
         NTmWd/coPXAdk72iFxMw3CPYHc+UktQ+Q3tJhDLTpOu68ZB3yQYQ+fCh1Zc0OcGs99Fn
         X09gJvxEQVQcK3ciYN81LO6mDi4GqN1pdpOPaasDVvbXJ4mlKZXGk8xx9flFImw4W59N
         rNGw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792777087; x=1793381887; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=7SleIgzgD0Ym0qkpIeLydzQGzolB+0IIJ55uqtkTIdM=;
        b=Ngfzo2V1ET5HUjzdZSEE8JxcMYN+IhgzyJ9w0ewfwVgrxDhCGoh8Nl2KY6J+/kA0z/
         PyCKIjyozYS/HGM/ryWq27DAEySR3QrVSSGbGs/BIspAlRFXHR++VFXlja+CnJIOsCOZ
         vdvs/uQ3Ugst/B79yH0k0YBsSq6s42YwZWvzedignRCGtdd4x10qVNay73hTd23XGiE6
         bH9hSBpW9K8kBaSytfvAFrjSJ9xOG16k1WMonk+dts15PLycK7HTdTy9vDgUkn3uFy0y
         Hsq59Vz6dpYaCZWAm2JPy41fuM7qfo580PNRB1nIB+gZkLS+svb3fYfNQt2SGNE3FU11
         3fTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792777087; x=1793381887;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7SleIgzgD0Ym0qkpIeLydzQGzolB+0IIJ55uqtkTIdM=;
        b=aBTSvdaFKrwb29sOzhNqNG8WTZe+bMMrdMCXHJ7b5Jm5KDlwKNQvaYTi9OKNnBxz18
         xZd5ZzCtFUBhPHZr4mlT4qopuY4bx0o1dgtag92As3lQOGLwsdLkFnltngyz4aaoyXvt
         +Vt7q4TfkIDBIEiNd1vm8WbNJza8STlcoc9/SqZW5MREWxYpGYue7SoQmw6yi/nUk+C7
         FcdV+viMvqyXvVWr2iIniF6jPg/umJdsTkhY//GKlP6meEujGKNgdYdQCtfhWuWirbZZ
         MnwFnviHemNo5UwM8gXUvqBBnaRG8NsD1oR8Uym0m1/xK96nju2BK/Yxnl/5FN/QZsHv
         Zvog==
X-Forwarded-Encrypted: i=1; AKwUvBzJn4RSo8GorZPkKpajbEteq3D4TQ07Tz6hz/yj8N3Kf+DzatIh9wG92Hmj7Jv8DS1J++aYmfhP5Wv8HzA1ng==@vger.kernel.org
X-Gm-Message-State: AFq9FYJub8+UttLraAAhGS9oqmmtfNPQ+fVB+VWEH8gYh/8ReuRTxPyb
	A3Tc0YoOEHqFqymmBPMIQHsobk3C5m5iA7COMKc4m78R5N8E2FXI+vkbs8ZtAoDGPRZ7bT8N9xi
	FSDOUC9UpWGSedyN91yw1vFYULampYd4=
X-Gm-Gg: AYBFou1Q95E3eqFZ1a/KPx4MhHIuI3Dozg5euHRp+v77AaUms0MnKMIk1eSsBT+X3PX
	BGULEwDS/+kPHpdixeuxsKS1GcVFb/9WL/vhpzPhQB+oGf3Rp0+DpuVq27yYMu9wOxKnfbV7Bj7
	D/3c7uAU68M0Bl0jtKJsv1FZ4di0RR36aBaFw68R7n2pvDSUZnctCAsOJcxl2whyOklQqmqmSB/
	CJq7pQlsrl5za6vycsO2hfJCcpFwFgnRJ3rHQ+RPmHwXwCtbJHU8RiUPZR8TC6rCXE8Uf7CfsvR
	YcAjZ230GWwf6EyqWEzRqdTLx/9cnKCHDuTPG/0ghrEjx7ch7AuPFDPv9IOMyo30o2k26QG61wP
	+5CFJv/xkW0D564dnLGdeK3nNHzfUs1eGD4HGTvc5L9ecEtbkQBEPuUJTVzabOUKphCtdoTY5Rf
	1/r4j3bJ3zu1n0gcmA
X-Received: by 2002:a2e:a917:0:b0:3ab:1fc4:8eaf with SMTP id
 38308e7fff4ca-3ac6fcc01bbmr148131fa.5.1792777087213; Fri, 23 Oct 2026
 10:38:07 -0700 (PDT)
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <CAAzpgGdksHZjx4jc20zqnAG_PQ2e1ggANQjt2eiycUiWc+vPHg@mail.gmail.com>
 <f32dfa8b-fc3e-4d8e-a010-20e822ed0c08@leemhuis.info>
In-Reply-To: <f32dfa8b-fc3e-4d8e-a010-20e822ed0c08@leemhuis.info>
From: =?UTF-8?B?TG/Dr2MgS0FTU0VM?= <loic.kassel@gmail.com>
Date: Fri, 23 Oct 2026 19:37:54 +0200
X-Gm-Features: AclHuK-M0RYmqjNYweqYpPwUynzkfhJb8RPOvxN8VMGCO80UPqv0N76SUV1cgDY
Message-ID: <CAAzpgGdbKP8YmPT7Z9tzw_Sy4BJ2VP4c4=dOf93i8rZQS1zfgQ@mail.gmail.com>
Subject: Re: [REGRESSION] mac80211_hwsim: beacons stop after host suspend
 (beacon_timer is CLOCK_MONOTONIC, expiry computed in boottime)
To: Thorsten Leemhuis <regressions@leemhuis.info>
Cc: Johannes Berg <johannes@sipsolutions.net>, Benjamin Berg <benjamin.berg@intel.com>, 
	linux-wireless@vger.kernel.org, regressions@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi Thorsten,

On 23.10.26, Thorsten Leemhuis wrote:
> - Test if a current mainline snapshot as of now is improved (the wifi
> changes were merged just a few hours ago) or wait till 7.4-rc1 and test
> that -- maybe it fixes things.

Thanks for looking at this. Benjamin confirmed the analysis for this
report, and I have now sent a fix:
https://lore.kernel.org/linux-wireless/20261023-hwsim-beacon-clock-v1-1-9b3=
f3ffc099b@gmail.com/

I'll follow up on the other report in its own thread.

Ciao,
Lo=C3=AFc Kassel
