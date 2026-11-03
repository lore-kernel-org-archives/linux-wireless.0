Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.46
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793724280;
	b=HrS+HC0x1z9uWZL3PgksgM8oHxapQ/gKYrji3dFOFoILdqVBVdyIjIXG459JbTD06dkF
	 P3dFKOWqlNJ8mnIvsKH5YENMVrdE/jWAu+bEz28MsGvEmBuFuIfzADYnN4jqFmYS6inyw
	 3WtkuA1q6ymCCqF47Q0i/jhxHeP2f0fDQ028eQcelOg06Sh6f2tVQeR0PYCm8ZcXnP9E9
	 INksGjtbBecN69mWuV5kK9I/iFDgjG6ZYUaBc8dj3AyExUflJIZPJ4jqXCOTEPzZNCoVd
	 SsVnm386h4defa0a1QVKBBwRSBtXx8sjQVVtyHv2PsoYGOkFQKkdXnpAsm0D5hra5dw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793724280;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type;
	bh=Un7Sh/vOuUsV6xn2dwiqUFHaUUkNjRn1fxqbgvpHoaU=;
	b=SYdOSa5pTiCNPzVEUqDZaESchk5qGXHy7PS2jW8MOz4fp80KXTzDNj/VuY7cXzPbf+on
	 VWupI3ktBWLXESSijfqc93bUNxc163cL1hgldirJF9Wf/iQJCkCYv3DaP2F32zts3lb1B
	 LU9uicTbKe1K+pAkRUPQepozF3ZJRdXIIblEgBjKDxJXbaPzEloE0yRz1lJP4zpnLTbss
	 5e4Bq7mzFI6FQKrqP7krs3myKdWtHgTtWA4lcC6tGnbNSxT38vm2B0dWbaLWD1J2d2GFk
	 e4Mdz5ENbYjJIW4YkJ4kwmAgh4dilPePDcObtRW4ZK775opbawphi/goGNK2WY1yHMg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=nagashi.ma;
	spf=pass smtp.mailfrom=nagashi.ma;
	dkim=pass header.d=nagashi.ma header.i=@nagashi.ma header.a=rsa-sha256 header.s=ggle-ngsma header.b=OKQYqAhI;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.218.46
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F16966082BE1
	for <linux-wireless@vger.kernel.org>; Tue,  3 Nov 2026 16:44:34 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org F16966082BE1
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=nagashi.ma
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nagashi.ma
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=nagashi.ma header.i=@nagashi.ma header.a=rsa-sha256 header.s=ggle-ngsma header.b=OKQYqAhI
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-c315869241fso627817466b.0
        for <linux-wireless@vger.kernel.org>; Tue, 03 Nov 2026 08:44:34 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793724273; cv=none;
        d=google.com; s=arc-20260327;
        b=aC3pU3AwVpec1Fvx33HupxS0DbFwl71YJ5ODCC/HKka650FtIGvQrx2nfn75pGyNRK
         YtvAtYj/nVNgH3zaymt3ffMta4L3/g7xQwLK+nA5JZ4BWSGHpR1QdWPJqFY+HU3TfZKW
         nCON6Dfp8o2YSMHdroSITE73h+NPHJ+Ftq1jNRamqct/5EjzAf1cimp/Q+WnzO4JNRQn
         Nmkycckj5wDWpxdbK77MGkjQzV9ZKepP1L1632tfn5Qhf+Zmq7uJa/QLRpgROPnr08Q5
         IEs48/kARLD+AqiRcA9JaMyD6ubrqlsVozan1vWHqiOne86lj3oGdV1BSJ9Ity2rXd/N
         fPwQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=Un7Sh/vOuUsV6xn2dwiqUFHaUUkNjRn1fxqbgvpHoaU=;
        fh=7rD/GRoD6wInycTGKmsDAb0uPgwpS0YasA3tE+yhqzA=;
        b=IyhIx/9RoPjgQwQVJHR1KJ50lYj3wGrp609or9ZwYp05JKy4Bx2lmngTisSSbxu1xr
         W1puzTr3Cf7CPuxIkFj2VIXXqdvUhkNb/ApHwWNlpMO/x3yDy41HGcYpjztexdmxisKX
         uWc3wHPXFZ7T4+AkIStB6srbxDmS8MstI9dr96Y7UZXXQnhKS0Z1//HmLyzIhRFTiRRo
         oTli9o5SwWytnOlaHuKJYBPIeKFzeb/ZdDGsptEPHcPBirNoJZwL0BERoDSsRIvpD4Uv
         EROCD5CuQG/2Y76IIhXPodJB8CyR2cSUmbT2rzL7uUqbnW5WibdHNbPwS0yh5qeF1qcY
         b+8w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=nagashi.ma; s=ggle-ngsma; t=1793724273; x=1794329073; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Un7Sh/vOuUsV6xn2dwiqUFHaUUkNjRn1fxqbgvpHoaU=;
        b=OKQYqAhI8ZC0gkujkJ8+ll9rX4dVBYsezwiyOeNdZJMMtMfdkTmR2Mr3m7tuXk4xmR
         2MRRIlKgS+QpLwX5Ce46ZiNnQSyZ4npabPiff0xvhMksrOqCN8dSDSDm5i/OL1d7J8wS
         PFSUDshK+0ER2pplNS217hIQALKwf0s1owd3uA17EqdLk6XC+PLaNE3sdWptm08SvxQg
         14CEoD9VEu99sTmHt4Q16JT076NTYzZYpUNuylCxPLtfyXlbC1TMf0Bc1PaznmqsdEOJ
         dOMY9OhTUD97CvaPH3UEV9CXKYLsgaiv2bWPQKaMbe2pNveEWJdC269k8MstNbPm7QQk
         NCfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793724273; x=1794329073;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=Un7Sh/vOuUsV6xn2dwiqUFHaUUkNjRn1fxqbgvpHoaU=;
        b=iiu8dyfcH51RiVd2iS5X7dhN87Fy+WE7ZTUs08q2ccGSIwIMGmPT6QprZp7b7lDXRr
         QA43xc1yILjpcV7WzVnXxnmiWsOgDky0YFl+I7ftceZUwAtBwzNfDq+wAZ4GRz0c4iuT
         ErKhq5bxyBW9YjcZa69zJvwYqyjyuSe+W4dYyRgP0Wqw1BUrnPyocHNH8M/Y621SBvbW
         mqxQFWMyNDGOqs/qdYTtBeJLbNx3ZqpIBjJv6+Ly0hLT4M3pAokK2ukj0zjjcEvJX8XE
         sWWNHCF1n5YyrvMr7NI3hfK5ARC2GXwtCi+/HbKev59yOgPCiLGEwWHAOFaK7EUgd0/f
         TTRg==
X-Forwarded-Encrypted: i=1; AKwUvByNtGhS1Ch3Xc2nvsPxoyLPiktsC3xZ7sAPNHYvDsJJoZ5IhvKiLcBkWDeOL8VGdzOmds/re/RkR6/zYoMyxw==@vger.kernel.org
X-Gm-Message-State: APuU4Z8e4OCo3vxanQa9HG/0MlGHaNszLO3hbzo60NMbnD/OvzyL9LmM
	RQ+aSKaCQmkk3jPYyizF+HTYU3Ipnnq4FdjDXGMdP6TefeZQ5TOR4YGMBTQCl/+xvDUEKwon7oh
	71f5Kq7dgJzXz9h7cU3F7GdV5W2Lnpy6puGJMVr9R
X-Gm-Gg: AYBFou2JSzpzo5NLxLMBJVJjDvKS7Cp8DwwdCvIBfHIbD+5EYR/IUiZYlO5nSLj1Qyx
	hDmHb2un6qXxYH8bZrn78ohlKrk9VV+FH4v0HlUn783XAEMsIW+Sx96IMrjDsOWg7u/HLFJYsbX
	eJHdj0QRBKKMPWe8H1ekiMlzHPyQ33KVE/c7NRnMityzBSk4ZxaQXMlDiJl0CxpcSI3jSPju7n0
	1fFYRb+vVbfMusN4T8jS42CQ8k9hA62sWi5AV20QjChckoeGNnxebe+oDv2p+VPW3hQ3Tk6Ixrn
	XxU54xnJiAQyzgEK4GmoLXt3cJ51p7sL9ENlcq4Y02IXt4fRSIQDwqwsrMTiE7YrfKy371HnDcp
	g/NLqjpbEd1bI39yfMFkx1Tz5IgWB0VFNKoBw4Rt4FXl2a5FHtZkGzLGKSOPcxYSeVYEVxsgaES
	iXoIhnESarVSXu5VgYEogHrwYLcTxUjix0jH/IHegB3Bq5SBpAI/yDg3iY
X-Received: by 2002:a17:907:2d8e:b0:c42:102f:15df with SMTP id
 a640c23a62f3a-c4ca7a0dc8cmr1250439166b.8.1793724272776; Tue, 03 Nov 2026
 08:44:32 -0800 (PST)
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
References: <20261016-ath10k-series-v1-send-v1-0-c847697b3558@nagashi.ma>
 <20261016-ath10k-series-v1-send-v1-1-c847697b3558@nagashi.ma>
 <CAFEp6-2xY_gM=FRUp3R30TZ-NgT=-eYnyz_BPE0vxEenv+202w@mail.gmail.com>
 <CACB3TCKq--tdL6j+uGR_dxGdy-gHxQhY8p0h6xxqi_4Fd3VEOQ@mail.gmail.com>
 <c45bdcae-63da-4552-9e35-59ec6a71621a@gmail.com> <CAFEp6-36Fc15uDWSR=v+xCMhERbkhggZOBoEFTF7pAcRLz_vFw@mail.gmail.com>
 <CACB3TC+NVYPbNKeOu9aAnRaCUTTon4PAO+kp_QbLqL6qd37aeA@mail.gmail.com> <CAFEp6-0AJ3uGn0pR7y7+PLhjf6AMYb2aBvPpq9J3QFRk9XJv1Q@mail.gmail.com>
In-Reply-To: <CAFEp6-0AJ3uGn0pR7y7+PLhjf6AMYb2aBvPpq9J3QFRk9XJv1Q@mail.gmail.com>
From: "Nagashima, Shunsuke" <shunsuke@nagashi.ma>
Date: Wed, 4 Nov 2026 01:44:06 +0900
X-Gm-Features: AclHuK97lyxSBpGOAJS72d3gT5RDULXKKysd-w5qBGIFB_PFqSCBaZ_ICIFvFWc
Message-ID: <CACB3TCKw=BCtRpJQ6N=moO+qpVu-Zd+J8LfV6S8pX1JiKS5+7w@mail.gmail.com>
Subject: Re: [PATCH ath-next 1/3] wifi: ath10k: set the PMF peer flag on WCN3990
To: Loic Poulain <loic.poulain@oss.qualcomm.com>
Cc: "Conn O'Griofa" <connogriofa@gmail.com>, Jeff Johnson <jjohnson@kernel.org>, 
	linux-wireless@vger.kernel.org, ath10k@lists.infradead.org, 
	linux-kernel@vger.kernel.org, David Heidelberg <david@ixit.cz>, 
	Fabricio Akio <fabricioakio@gmail.com>, Aleksei Kharlamov <aleksei.kharlamov@gmx.de>
Content-Type: text/plain; charset="UTF-8"

Hi Loic,

On Tue, Nov 3, 2026 at 2:46 PM Loic Poulain wrote:
> If Linux-firmware ships 01387, someone will need to confirm that the
> MFP capability addition works with that specific firmware version. For
> QCM2290, I can probably test it myself and provide a Tested-by tag if
> you can describe the expected testing procedure.
>
> Yes, to Jeff.

Thanks. Then I'll start with the qcm2290 file only, and leave the
shared 01387 file until someone can test it on a db845c or an axolotl.
Note that qrb4210/firmware-5.bin is a link to the qcm2290 file, so the
change covers both.

Test procedure:

1. With the current file, dmesg shows these features (crc32 a79c5b24):
     wowlan,mgmt-tx-by-reference,non-bmi,single-chan-info-per-channel
   Connect to a 5 GHz WPA3-SAE AP (PMF on) and run iperf3 to a wired
   host, up and down (-R). Do the same with WPA2 on the same AP.

2. Make the new file (qca-swiss-army-knife ath10k-fwencoder):
  F=wowlan,mgmt-tx-by-ref,non-bmi,single-chan-info-per-channel,mfp-support
  cp firmware-5.bin firmware-5.mfp.bin
  ath10k-fwencoder --modify --timestamp=1706616060 \
      --features=$F firmware-5.mfp.bin
   md5sum: 58982403c9c56a4b888fe0ab3104d7de. Only one byte changes
   (offset 33, 0x00 -> 0x10). Without --timestamp the tool writes the
   current time and the md5sum changes.

3. Put it in place of ath10k/WCN3990/hw1.0/qcm2290/firmware-5.bin and
   reboot (ath10k reads the features only at probe). dmesg should show
   these features (crc32 f9e8f071):
     wowlan,mfp,mgmt-tx-by-reference,non-bmi,single-chan-info-per-channel

4. Repeat the iperf3 runs. Also disconnect and reconnect to the WPA3 AP
   about 10 times, note how long each reconnect takes, and check dmesg
   for "firmware crashed".

On my comma four (WLAN.HL.2.0.c10-00459), adding only this bit to
its firmware-5.bin, with the kernel unchanged, took WPA3 from 22.6-31.6
Mbit/s up and 21.6-21.7 down to 273.8-287.7 up and 242.5-243.7 down,
close to WPA2. Without the bit, ADDBA Requests went out unprotected and
no Block Ack was set up, and with one AP a reconnect took about 24 s;
with the bit it took 1-5 s.

A failure would be an association failure or a firmware crash. If WPA3
is already close to WPA2 with the current file, please tell me too:
then this firmware may not need the bit, and the test only shows that
it does no harm. A monitor-mode capture is optional; with the new file
the ADDBA Request frames should be protected.

If it works, I'll send the file to the ath10k list, to Jeff with you
in CC, with your Tested-by.

I worked through this with Claude (AI). English is hard for me, so AI
helped write the English. I ran all the device tests myself on my comma
four.

Thanks,
Shunsuke Nagashima <shunsuke@nagashi.ma>
