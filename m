Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.224.52
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1792878511;
	b=ngGeKIAB6jWHLpnV+Mqj4ixSHBhL3rnPtxe1LD5I6xphAoiq2KXs4tP4HWL3u2MMSlo1
	 2orzsAbTmHE0Uezuq3oQyPW1ylEZx4RP4vXtptqugT+8wiuuQH6ok8H7Qqx2aqSSQwdpK
	 6nskibccvv5Au3T1hT8Li89HqiNIo5sKv6AF4hUsCnH6yNh5lfoN1Jb27WFkMiIYTU22j
	 cwJP3A0JGlEYzdqiV4a9L3VDvOWmzBOhsy6SK0HemdCZP+XxHDWsejv3E9f0Pn56An9VY
	 JLsfJJVbgWA1vT4Kk2pHmM/SsAmSnl6EfA5uRMfi0bbxnBts+g2nmNsPlULA/DPkbEQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792878511;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:From:Date:
	 X-Gm-Features:Message-ID:Subject:To:Cc:Content-Type;
	bh=B22PeW0KSxJOptnl4CVauMg+1WFHTB5x2jSa9vro5So=;
	b=xAabcnwwd7fCccbe9kOoEx7G+L9lyepIOhgvXk38omHy6oFGHZV9jnUBpDq42aLKArXp
	 qJJTUfogu17XzuWBmVoRofQ+81maQG8oZMvzacgHe6WbTYT+hNi9ia7nD8+HhRykYItX3
	 YyScaxsMvXnB6faQeZpxzbZBJeHdhl8FZSgnmLGr5to3grf2Iu4IQ8dM+cecheq+mZpWK
	 2H82DQBIfbNv9NUMH+4foyJxCmREGHMJOINyRA2NusuuapnFDZp3gNFbHeUxTAl68iyZr
	 EVXSWn3JXoSLeIiQrRXFr+D0zxVCMNMeEwGBEN6SIZjgFZbQNhQcGpcdMGxjX/vCaZQ==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=FYYih7ir;
	arc=pass header.oldest-pass=0 smtp.remote-ip=74.125.224.52
Received: from mail-yx1-f52.google.com (mail-yx1-f52.google.com [74.125.224.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69B54606A31A
	for <linux-wireless@vger.kernel.org>; Sat, 24 Oct 2026 21:48:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 69B54606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=FYYih7ir
Received: by mail-yx1-f52.google.com with SMTP id 956f58d0204a3-6798eb0d190so1370355d50.3
        for <linux-wireless@vger.kernel.org>; Sat, 24 Oct 2026 14:48:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792878510; cv=none;
        d=google.com; s=arc-20260327;
        b=KcerkAQ45EtWCMk6XBg5F1oUcUPjT+8c/uwOszuOAvOGsImdxyXZHEtO4RAN2lB9Kl
         l7kj8efulHBikiFL5TgQ6s1QiJ0hBGtGlpk0yIFYLPNPk2AbHNdu+wV7BFHxSX+jxO8c
         3vMcUk7yi3ZCE+/dYUG0oImtohD04MiCRHsVSp0/dcqwm/XNHqcfO3pnZpQgxwGMH28V
         Gge8KVsQgF04dV76LuIfIwfGQc6cB651xeqcOojvvA7KCMu2m9DjMwnZIZsjPtxOrzwB
         hmyGE/0KCpXh5j2pKWEi39HOZXwZsODbHuss8H3wQawF18LTGo9HbbKsS0nYHfexndLG
         LVNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:mime-version:dkim-signature;
        bh=B22PeW0KSxJOptnl4CVauMg+1WFHTB5x2jSa9vro5So=;
        fh=FOIvcG1gnFljPdvKpHXd86G81BXv9yfg69STJYa6qHE=;
        b=TE0AGY/ZTwnxyeUX0NeeOYi4eVymuwGewqz4DysFs0OLQjvGNaNcTpKUm359UB6LJS
         qTf1H/PTnj+PBgJiijLNlWJFVt5KXGWD+Jhf2pSZlgDuaiY7jWFFQ9ME7LT4b/2VxCcH
         NaP2h4llO1umw7IRXptNVSrdDoSXL7/TwuSotxh70aqqFfAc4mYfXhYZkL9w5SULfpwk
         kFo4jQ+bMuln6V88prEh9Gw2xtl4lxPF4/b6h6N0Av7Rb8qY0hdVP7jEp2ARmZ6NWUjk
         mQRZbDQh6NRgd1j1K9uMjFEpoieZzJnACRyp6RLsU1ehiXSwTHC7hvbwWOP+4wMwIv7M
         ZxuA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792878510; x=1793483310; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:mime-version:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=B22PeW0KSxJOptnl4CVauMg+1WFHTB5x2jSa9vro5So=;
        b=FYYih7irORKyWGJ3ZZI/05Okn7FDdIaZ9RtOcJ0cCCZ84oFQMnEkbUNFLY411Ryc8e
         b20DJViHGxuEIXFQvT7NuHt8GB2WcJ+OZsnNyiLE3t15KThOjHiHFKSHitSsBLmzuR+E
         Wqmwi1z2i1rw2t/8BZ7G278NOycmuTsBfsK0UKitxUfEl13bUjNy5x8PlszdLPuuL93C
         cJkoNIzDvgMBq6GE8akEZr9q7IJvNpCg898/6zv38sMOgDN+tF6Vx51iUzWRvUVAVNRY
         wfeSMf/eRVQagZ79jAwedREiVOjQbeo5dqJTZyN6WnUfj2mOP/PYz2SMnAaetTkK2qYy
         QH0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792878510; x=1793483310;
        h=content-type:cc:to:subject:message-id:date:from:mime-version
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=B22PeW0KSxJOptnl4CVauMg+1WFHTB5x2jSa9vro5So=;
        b=SFPmStfWYwOJjHh7fZbTtDooCqgnxPp2ks07x/zrCVR3HwZqsCEHFcb+O0RQw27Cp+
         3wuUitPIDQJEww/cG7RgDF8YOnV8oIe/LC/VdFP7C5yrT+CW40e5Z0bcDxBcbZR8xaVl
         b5zO6+U9ThD9zFbjNjOvm376C99T0RANmkJQlnAtAeBl05ynJdKW1xgCASOm61KkF6Sv
         AjBn9Yg2LiHWWJ+n4oB9CJzEHBv+xq6qdggN0MG0nwjg5DAmbO0re0aqxOgzhLh0jxpI
         1jNgEpBznlh41MgJchpxvRTQSmFJgmWRp5AIzfp0+ewjz/luWZ31VsLrrTgCpxHi/3Es
         NBCQ==
X-Gm-Message-State: AFq9FYLerKFSXb0mxkSqVxFtWKwoyUnrp4nMyQ29rTu6EgrKRMUQ2AnR
	y/Tkc9xqKfpESB71SVxCDCJnLn+0HdBI58mwFe11BVh/5dY49iteMGhpWh+Vc3U0HVNHbTEZzCT
	MA6fY4JKnpxg1gszjkNueQazLWQJHoNB3ajoJDoc=
X-Gm-Gg: AYBFou0mRw5eoda3aZyeIpBKx7/db0/hv7roYmRkzrj/d7Q1nNmHID2xgsaviWc6tFD
	ZivQe1Msl9zuOITwnONfTuRM0IJD590v9IukcdPVQ05kgJ3aB36AWpfqBUsG5m+w17gAB7CtwwS
	/QTWfW1EhOcBgG186CKOkRE9nv+kTylyTezsM8lt7xLon72OmtbCO3hr5eoWow/GKSs5DZOsRCz
	ojH9Qhb+Iy9Uy9noV4EwPVRNyP/ZNAg8+9lHoxDzBLZOerlqBGkRjS/McNyXfmgLlQnHtF2Xa3q
	gbKgc9UvR+jXQs2EY2c7TfkmmbEdUVV1IFauUC64gDWlYew7C5Ze9aLCdDSh9PJWMoVSOTTQgLp
	NjS5FmDb9LvrNiYndED7edJGu5pu8heAIiWya59jMpmHp5p1HwgMRVkvNbb1DdB8KaOKo
X-Received: by 2002:a05:690e:4402:b0:677:ceec:5eb6 with SMTP id
 956f58d0204a3-67a4549f020mr1731583d50.91.1792878510400; Sat, 24 Oct 2026
 14:48:30 -0700 (PDT)
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
From: Luca Casati <luk00casati@gmail.com>
Date: Sat, 24 Oct 2026 23:48:19 +0200
X-Gm-Features: AclHuK_JlPRfhqgk-dIAhc7Duvk3jv4nFMsVJPa5857f4E-xR1JaGe3jcyIyi1Y
Message-ID: <CAKM5oscz9UfiqFr_wSmzjcpsZ3QEWvUJuVa0kLhmz1TnF+aBoQ@mail.gmail.com>
Subject: [RFC] b43: N-PHY fixes - OK to cite wl MMIO traces in comments?
To: linux-wireless@vger.kernel.org
Cc: Johannes Berg <johannes@sipsolutions.net>, 
	Arend van Spriel <arend.vanspriel@broadcom.com>, b43-dev@lists.infradead.org
Content-Type: text/plain; charset="UTF-8"

Hi,

I have been getting b43 to work properly on a BCM43228 (14e4:4359,
core rev 30, N-PHY rev 16, radio 2057 rev 9) and have a small series
of N-PHY bug fixes I would like to submit:

  - TX tone sample table loaded as all zeros (operator precedence and
    a double fixed-point conversion before cordic_calc_iq())
  - TX IQ/LO calibration: inverted busy poll, result copied the wrong
    way, missing rev7+ cleanup
  - rev3+ RSSI calibrati is written instead
    of the selected VCM, plus a wrong distance term and rounding
  - 2057 RC calibration:re it starts
  - a missing field in the rev7 TX_PU override (compared to brcmsmac)

Where brcmsmac has the same logic I used it as the reference. Where it
doesn't cover this radior accesses against
an mmiotrace of the proprietary wl driver (6.30.223.271) running on my
own hardware. Only the M did not
disassemble the driver.

Some comments in the patches mention this, for example:

  /* Values from an mmiotrace of wl 6.30.223.271 on radio 2057 rev 9 */

b43 already has similar comments ("Extracted from MMIO dump of
6.30.223.141"), but I ware comments
naming wl and the trace acceptable, or would you prefer the values to
be described differentlyat all)?

Later I would also like ues (PAD tuning,
aux ADC midpoints) taken from the same traces, so the answer affects
those too.

The patches were developg assistant. I
will mark that in the patches according to the kernel's documentation.

Thanks,
Luca Casati
