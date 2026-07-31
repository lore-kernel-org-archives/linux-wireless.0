Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E42D2EB874
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 14:25:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785507929; cv=none; b=VhXkp2Z61sPTP2uGJY0uV1O6jhqSAQ3o08j5Q6W/y8sEi/KxOgP/d7pWEeSv0Q+hndNMqZZbe2XUWhnYfBrCNcL9tsqdRNghc2kln/4y3Mx2oswQl3WtFhLPj1On0ItrvmxsZKTkk53egoNHDxHGj244gCWzNATGDRC42IkYrVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785507929; c=relaxed/simple;
	bh=ixYtCl0NvsYGQOXtWDzVtKDRbS/OCvPCvl4JZPIeVDs=;
	h=Mime-Version:Content-Type:Date:Message-Id:To:Cc:Subject:From:
	 References:In-Reply-To; b=o5r3Pa5sgECuRCVuDHbg1nwFlXmsTzfw5U04xqplY+0nWm0O+Jc2sDlW5qZuAkjc0FZ8Hi1Q7uifq8m562ZKOxtAW4Ss8GQ5Z2VBdItRhuu+1eD+xdDHSX7VZa25MXGQOjiyjzyONVZjrvCMmilfgvpAY3nfONpZxb/Uo/ZvQps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CzPjCHfJ; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CzPjCHfJ"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c1f7666a90bso164063366b.3
        for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 07:25:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785507926; x=1786112726; darn=vger.kernel.org;
        h=in-reply-to:references:from:subject:cc:to:message-id:date
         :content-type:content-transfer-encoding:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=ixYtCl0NvsYGQOXtWDzVtKDRbS/OCvPCvl4JZPIeVDs=;
        b=CzPjCHfJsx+SCvnwurMMOiG8RWXbNUlV1tkdSWFV9hTDNCl1cndwk1CWvQVz/W5cnk
         yCPm0uLBsh+TIQ3hzShb71Ormnal2xeqmYBcE5p2SuC41aWKcGS2rW1F9/LOwtsF6nbO
         /wfQc35gA/zDKygPK8LxGa5vEgQgDafgcz6jdoN23tB4g648FPr4lg22U1RE5U+h0oxq
         Eq3vKdLXhWW54vkIFk+kqO8jQkzhSUb5Mi//yqLlUHeQcZ5bitpJTvj9g2MsXr/HiqnF
         bWExmsHGKU7loSLxW5buDTr/LOhYtJKCur6sdOVEE/6OlH7RsjVydVnSN/fQHpKVRErr
         c20g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785507926; x=1786112726;
        h=in-reply-to:references:from:subject:cc:to:message-id:date
         :content-type:content-transfer-encoding:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ixYtCl0NvsYGQOXtWDzVtKDRbS/OCvPCvl4JZPIeVDs=;
        b=ZIpxUeOgGf9QVZAVx3kWh0RTJBTNC7MaKS5Xv3PDf3rE8VBFANnykC2+O3YipgaHm2
         MT7+MNGW23fnDeVUXosNPsMBisL2xiN88npk9UQl722n7J/3RSxUs8o4VCpJQ8XTEdcm
         hKx7wREuUYY5K0xi7Wf63f2UpWIyuZbhgBCaGYwrs+d3fOXzPrIch7f5c5gA1YaiD3uk
         MZIZAfht9oTJ18aqjqLszbkbUXJzfgp0zgvROGZ/VC1WeKHVlbrpS8PHQZhjfmniUQKL
         seCnuNS/MvXH2BoP8sHwgsDtCVh0AmdPwECvs8u3RvS5GoNIaqAru7UVU/KmQucJjtIz
         wukA==
X-Gm-Message-State: AOJu0YyFJKoO8SUTDluvTMlbog/nWvTN0+J6btGK6dw/KYH31Qgdhw7+
	o6fbWEq2s2TJNJcfQlyteDOBY+jlLrIReTp8NCFcsVu6+xWbBmQmtEFYJputhw==
X-Gm-Gg: AR+sD13PF+8A+Zs7wcF1/IkISeVFUTE23PHepNe3LQhMZnCbIk6HIoIuAWhUbQkbOZY
	QcxJ12bgJy8BtucChZjpdUaXeTRWmkOYbvf2VDilnYyqOCFQh+yJ3BAVd8dmyCu4nUPvekrfEBC
	c3TRXNq4mJelkB4NcjbGTfSc5VKXac2jWVVuNVKz9Sp2pz1xt5EGQTJwvF2jB7zEIUcpELOXp1o
	F1ucUMtBfyNNSxD79297nBxdACkibR9By+Yy1GE1MJIJnWuyJrue7aqBoUwr/HA8TrXf/jxLlRu
	8kTHA1c9XwFcRHSZ0R+g6t+/q1CT9rhUNvBfNeIBjp0PFMxotjs27dy5NRyTMAtCEGHRpQSXZBu
	gvyTBsqUU5CgzNgNe+HCxAWVBA99nAE9hFnszRDxvgNFUAXLibltem1xIry/sH2jZ43SuNURMur
	51MfggvvKKId3O3bsEqUGg5j/65XqZAos3KeS4Y3NOi/5hK48HVCk98VyX3hvm6PhnMVNeatwt5
	yNqrYY=
X-Received: by 2002:a17:906:ee8a:b0:c15:ef0a:adb4 with SMTP id a640c23a62f3a-c1fd2712598mr129574166b.61.1785507925579;
        Fri, 31 Jul 2026 07:25:25 -0700 (PDT)
Received: from localhost (freebox.vlq16.iliad.fr. [213.36.7.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c1fd455f671sm149757266b.57.2026.07.31.07.25.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Jul 2026 07:25:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 31 Jul 2026 16:25:24 +0200
Message-Id: <DKCTQGTORU5H.H4ANSP32B0PU@gmail.com>
To: "Baochen Qiang" <baochen.qiang@oss.qualcomm.com>, "Nicolas Escande"
 <nico.escande@gmail.com>, <ath11k@lists.infradead.org>
Cc: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH ath-current v2] wifi: ath11k: reset ar->num_station on
 hardware start
From: "Nicolas Escande" <nico.escande@gmail.com>
X-Mailer: aerc 0.21.0-0-g5549850facc2
References: <20260730140306.133718-1-nico.escande@gmail.com>
 <4160b5e1-c82f-4083-aa36-18e4a42f909a@oss.qualcomm.com>
In-Reply-To: <4160b5e1-c82f-4083-aa36-18e4a42f909a@oss.qualcomm.com>

On Fri Jul 31, 2026 at 7:41 AM CEST, Baochen Qiang wrote:
> s/ar->num_station/ar->num_stations/ in subject
>
>
> On 7/30/2026 10:03 PM, Nicolas Escande wrote:
>> When (multiple) hw restart occurs, we end up in a situation where we
>
> by hw restart do you mean firmware crash and then recovers ?

Yes firmware crash indeed.
=20
>
>> cannot accept new stations / mesh peers. This seems to be the
>> 'num_stations' in 'struct ath11k' that did not get reset properly in
>> this case. In ath11k_mac_op_start(), it was indeed the only accounting v=
ar
>> that did not get reset so let's clear it too.
>
> the root cause description looks confused to me: if it is firmware crash =
and recover, we
> should run the path ath11k_core_reset() -> ath11k_core_post_reconfigure_r=
ecovery() ->
> ath11k_core_halt() -> ath11k_mac_peer_cleanup_all() and in that function =
ar->num_stations
> is cleared.

So about how I came up to this fix:

When I first saw it I though I would be able to reproduce it using the
debugfs simulate firmware crash feature, but I was not. Then from the logs
I had at the time I noticed that there were multiple crashes back to back,
sometimes while still recovering from the first one. I think thats why I wa=
s
not able to properly simulate it and find the race condition leading to thi=
s.

In the meantime I wondered why we hit the num_station checks and not the
others like num_peers for example, and found that it was missing in
ath11k_mac_op_start(). So I made this change as I do not see how it hurts,
and I've never hit the issue again.

>>=20
>> This avaoids problems like those:
>
> s/avaoids/avoids/
>
[...]
>>=20
>> Tested-on: QCN9074 PCI WLAN.HK.2.9.0.1-01977-QCAHKSWPL_SILICONZ-1
>>=20
>> Fixes: d5c65159f289 ("ath11k: driver for Qualcomm IEEE 802.11ax devices"=
)
>> Signed-off-by: Nicolas Escande <nico.escande@gmail.com>
[...]
I'll spin a new revision with all the feedback taken into account at some p=
oint
