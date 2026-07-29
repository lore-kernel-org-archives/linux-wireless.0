Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com [209.85.210.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5794D242D65
	for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 06:26:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785306380; cv=pass; b=a1Qpl/yhWEgDgY+mgUGRJ2oK2ugRWOLKU4iyO0YITN+tQsfa3gewVsJe2SAdQTX4sb/GgXqb+YH0lRuQAwhDKPz1MHocjYPawSevZo1aExAflAMODTu+R7e3McrGO8KozHgIn4qzyjhvENzLKhVh453CfpwkpbRzRSDFnWKsVmc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785306380; c=relaxed/simple;
	bh=LSi2RUXIEysPh9thAyzyp0K8SR9dam06K9HaKkGPSxw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TJPU6Sx/cjP8bYIGOiPJwULCENWUVwLa8ipxFoEzECjhiHiK1yVkidCjrFrlHv8HJFdrK58V51K5dQs1MKG2ZHHOod2WYiP54QiErpjPOW7h05vZucxE6fYWyd8MiX7chxcHakhTiGNI5nUE4aqPcLajZ9sMxjyHikpGJHafDNI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IO9caLA6; arc=pass smtp.client-ip=209.85.210.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IO9caLA6"
Received: by mail-ot1-f50.google.com with SMTP id 46e09a7af769-7ee4399c3abso570043a34.2
        for <linux-wireless@vger.kernel.org>; Tue, 28 Jul 2026 23:26:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785306378; cv=none;
        d=google.com; s=arc-20260327;
        b=ZRPvE9iJiZcYG4NoW4hQNPr904uu2azHlxqFn8DLsSf8KJQgZHBaUMrnZavOI4/t7L
         Q2FcwooVMP6JMsca5Zmjjo6SZpUXD0KFSYBReFE2pgMwEquPVzErVeZ+sVZHvYZhYarm
         UEJoDyoPAXb485SpJQlKb0qk1kW+BTYO+HjMPd7ndgNJrS1MaBtRJRRonNifW40g+as1
         IiTtk30zA6t8k8Yq5reegKFU+iSH9UBjLPUuHZZG/grgQP9QQVAQdnEhEEDh3mYHyPCg
         VRi0zyuuLaGYiSTjsZaUaSfzCRqelgsU+E/kX4tyhRrRAP6TWTtPF7S5VyeTN0mK7StK
         tKvw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=6JAO9B2A3qZcU5YD/J3vty+24gy5np2+bMuOX/eSSKc=;
        fh=HBXcHMnsGHPtuTOBD8crbBbmDT3BdYZnzOFq7i+VjEg=;
        b=oCJZOOzcFmnZ/BiinSlbRjVECw5eqivTBICyZGSERscUMxoRkM/o8VTsrW0GLUZkHE
         XloxA7bFkh4HEHuFkD/vTwhnm8NkvSki7VybhU9bm7gHOaqAyVevRWQvnKEnAzSJongl
         lgIcAIqLdYFoCxo+1lu4QQ9lFcwEAyO/Wwy6em3/xLQ6FqSzevTjNbb1XRFrKsmQOvMl
         bxVRzULYO+EuozDHbVDAG8bQYqpwHzG2nXKBueM3yY333JRE4DS5K0IEb8tXD4W/h3x0
         7jlFmMqwxZ/2HHatN/DqUp/8rxauQmLoogXlBjmsT4MW8Vs8H4CxhJ6tpr7YO5j8JEbl
         Blqg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785306378; x=1785911178; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=6JAO9B2A3qZcU5YD/J3vty+24gy5np2+bMuOX/eSSKc=;
        b=IO9caLA6sA77AbGmtG3yDXD94kGBvRQnNoNK9/oTVIUhsLxa68u/bB0KyBhT/FqbRL
         u5AzHBoUPw9awyVCHjnwCpXeaoJgWZebfeW8D9mk8OGo2o8dIE2kH/+pAj1hELGc2eNB
         HY247Tt2V5Li4Z83f2wbaFIGHNq87iX0NlXGbIByl+NNix2tXHSHR8nCzjykhE5cEBnP
         +VaCaHUIq2EX3yL4W5BD2/3RUkBDyGzexjtfLwu9aBc2fB9O9ErGyy8+UoVZi2CU1Jy4
         IVXTETtQzr1Hl7f0ca4EoVP4g35gV0RC+oY5VWnt19MrTXlbaRc2Ntvu4ovtLAE0neDF
         ra9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785306378; x=1785911178;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6JAO9B2A3qZcU5YD/J3vty+24gy5np2+bMuOX/eSSKc=;
        b=NLtJHpSfEHMt7JRCvlZQ5CGpZIJLUvgoT1H6tLzx0x2Zr0CI8BgBtintBzfgiVzXia
         pGdQ1okTXPu+CjZP2X0UEGdfj59ijsnkx+NsOIUa/cRy9cwQe0mN+hiud5NDrdzJqpKB
         hxaFYKgqfnCLwWRSTtLaha26aP0odPJxB67LHDMrFXk1RR/O3dpBzM/s9JUcqlKU65dq
         c7j5GLCPwB/Kv3qFmY9JmQEzIIcyQaChDV+EhyQmCJPEdH6jkrj7QWnqv6dsgOjVBwb7
         C4m7zsYOxcwnzBvRVSqumq6XjMPQkEXWKs7mtRwfrjesqGGf2UhTq9ow4Gs8Ep+HITIA
         LYiw==
X-Gm-Message-State: AOJu0YxpBRB8caAi6aR5L/+8XFreB8sHpPReirKsXgZmw/xXMSNY6Wvx
	xfhujY4bADA6iBFl92YX2vqllUC+Oy6iiegJy9AgZHxR1Qh0cfnGUFJRH8YdM39QVYsA6elQSXj
	iWFqAfdDheYjG7HISjxE1xigSKWTK/RI=
X-Gm-Gg: AR+sD10pwbzGS/USE/5Gmb5LC9313mQqqL52qQJoG3cBScJ/DC9IlsyMaptqG02mHVS
	BA8U1+N4RwkzzhpM4bO9rUP9yTjiD04UYgiFcYEhY2jml4lz+wSv1CGDqProzSMdMy2FbOQAKHg
	Ch/wYXG4BW6fgkbv6fhHBNhdY/xn/lFC1Q+Y7eZsqW1Qer1b8VCsLw2/EsPc7r89SQM8c1C0hhb
	9/2eedJJ3tXkUCNi/fRBb6T10mTQ41IRkpogpndQ4bJjMzYN2p+GAFoNqLtwqibEYGvM4We6NIv
	53Xd9n3TuHKA11B9YokrbQF3w+6J/7AJDOAbhEMrdh1WDR8=
X-Received: by 2002:a05:6830:6d12:b0:7ec:61e4:9d61 with SMTP id
 46e09a7af769-7efff08c2e0mr3145575a34.20.1785306378043; Tue, 28 Jul 2026
 23:26:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260728002048.19351-1-mikhail.v.gavrilov@gmail.com> <20260729061723.40895-1-lucid_duck@justthetip.ca>
In-Reply-To: <20260729061723.40895-1-lucid_duck@justthetip.ca>
From: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Date: Wed, 29 Jul 2026 11:26:06 +0500
X-Gm-Features: AUfX_mwInMNRHRVBTNmL3lOP1CjZNh54_jZJK68qyLWJACy_8YJvn3pNTMADm14
Message-ID: <CABXGCsNMef1DrKpoh0cna=B79Syq-G3nGUroU-=CTWpjvLeZOg@mail.gmail.com>
Subject: Re: [PATCH mt76] wifi: mt76: mt792x: drop redundant napi_disable() in
 unregister path
To: Devin Wittmayer <lucid_duck@justthetip.ca>
Cc: linux-wireless@vger.kernel.org, Felix Fietkau <nbd@nbd.name>, 
	Nicolas Cavallari <nicolas.cavallari@green-communications.fr>, 
	Bert Karwatzki <spasswolf@web.de>, lorenzo@kernel.org, ryder.lee@mediatek.com, 
	sean.wang@mediatek.com, shayne.chen@mediatek.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Jul 29, 2026 at 11:17=E2=80=AFAM Devin Wittmayer
<lucid_duck@justthetip.ca> wrote:
>
> Tested-by: Devin Wittmayer <lucid_duck@justthetip.ca>
>
> Confirmed on two more cards here, one of them an MT7927, which I do not t=
hink
> has come up in this thread yet.
>
> This one cost me both machines today, mid driver work. Each went to garbl=
ed
> colour and froze hard on the way down, power button only.
>
> Same base commit either side, nothing else changed between the two builds=
:
>
>   MT7927 / mt7925e, kernel 7.1.5    stock: rmmod hangs    patched: return=
s in 0s
>   MT7922 / mt7921e, kernel 7.0.5    stock: rmmod hangs    patched: return=
s in 0s
>
> Stock leaves the task in D and the module at refcount -1:
>
>   napi_disable_locked+0xdd/0xf0
>   napi_disable+0x25/0x40
>   mt76_dma_cleanup+0x16a/0x340 [mt76_git]
>   mt7925_pci_remove+0xe5/0x1a0 [mt7925e_git]
>
> Patched, rmmod returns immediately and the card comes back on a reload. s=
ysrq-w
> puts usleep_range_state right above napi_disable_locked on both, and noth=
ing
> warns while it is stuck, no hung task and no lockup.
>
> How I tested, since it was not a mainline tree. Both kernels predate
> 13b7e6a96a00 so their in-tree mt76 is clean, and I used the out-of-tree b=
uild
> instead, morrownr at 905c0d79, which is where the _git suffix comes from.=
 Your
> mt7921 hunk applied verbatim. The mt7925 one did not, only because that t=
ree
> carries an mlo_pm_work cancel that is not upstream yet, so I took out the=
 same
> three lines by hand. Mainline matches your base exactly, so nothing needs
> rebasing on your end.
>
> Two things from reading around it. These two sites look like the only one=
s that
> double up, since every other napi_disable in the tree is a suspend or a r=
eset
> that turns it back on straight after. And USB looks clear, because
> mt792xu_cleanup goes via mt76u_queues_deinit and never reaches
> mt76_dma_cleanup, so this may well be PCIe only.

Thanks for testing, and for the MT7927 data point - it shares
mt7925e_unregister_device(), so it is covered by the same hunk.

Both of your observations match what I found: these two are the only
sites that double up, every other napi_disable() in the tree is a
suspend or reset paired with a napi_enable(), and the USB path goes
mt792xu_cleanup() -> mt76u_queues_deinit() without ever reaching
mt76_dma_cleanup(), so this is PCIe only.

For the record, since you tested an out-of-tree build: Bert has
confirmed the patch as posted on next-20260727 with mt7925, so both
sides are covered.

--=20
Thanks,
Mikhail
