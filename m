Received: from mail-pz2-f12.google.com (mail-pz2-f12.google.com [74.125.228.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D0AA2AD35
	for <linux-wireless@vger.kernel.org>; Sun, 13 Sep 2026 22:16:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.228.12
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789337795; cv=pass; b=jUBcxyvIrNSoHv4u7SqTonmlEB4px/2VSzQYpBKXPvORgfhQvEUEJqx3O/TgeqONANn4VIxuaTyATBSTrc032PClA52egX8EehwCpWDyMWDPDC1lBoih9qInT6arv81Hxm5KInN90avRDcf1mxgoT8s/aZ+UVKLdyZcoNcAuP8U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789337795; c=relaxed/simple;
	bh=cFcUkK2nuEqNN4s8o5NV69iPxdq3RuDxEJaGlB2rHfY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=I29ISkibI/1Ppy52D0sAUNXE01UCdaLi9aj4rE6K0KyEBHD0uxqgDQhymvQ+/ruBHBYkwJbQNd9tCsHd3eEdpqFo1up3T+7jyLdvkspNwyWwOC+5EewR4PxwrY0LlvC9ELKasRnwbAi7lqD0n4VDdEQk+yNIpQClLSsAmfMrM/M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=Y7o1/Acs; arc=pass smtp.client-ip=74.125.228.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="Y7o1/Acs"
Received: by mail-pz2-f12.google.com with SMTP id 41be03b00d2f7-cc1cebad4afso1420656a12.0
        for <linux-wireless@vger.kernel.org>; Sun, 13 Sep 2026 15:16:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789337794; cv=none;
        d=google.com; s=arc-20260327;
        b=kVgkMAsRNi1Kemv3Aivy3tHJIDTBycs1LPcRsqkyS7pbDkzykSRO79HDYF6SyBUb9J
         SoDaA18ZqHqpVPxpfoEZO46IoVsAdn8BEZYGC/EyCt62uB2GP8YCKSfFjoruz4+kYjzn
         iOh2dsYif8syRZqhoDBgqvoch7UZ/D5y2e89+U/yFZ71nqxjgxFMn9jvz1fl3Lq6WAPm
         lKP/11Zb0jk3yNmR7hAsM6wlZEtn/q4thPV42qzyWCrZF3vxfyjgxtuEOa0ZqPk6sQKG
         iZCVn6vPnpeqwLqRGcV8t8A2ozrlJwCz0Ni+58rmOXrgFjjMKfEO0ABD34jgggOkvj0N
         ktcA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=cFcUkK2nuEqNN4s8o5NV69iPxdq3RuDxEJaGlB2rHfY=;
        fh=zFCB9yj6tbPtiNOgT9n/qK9LnQKfgtX1AWhCxXtoerY=;
        b=Mx8Z2t0NrmKzkbqlFmsCrg8hX+LRKIjUWaZ0bGywhtoU80vlnb8MQ66gK49cUHXdiu
         OL1h4T1547+yOKE3WXROgXuVYnX1fz8iwK9ToRIgQkahVJ+S+SdF2fyZjVD1gqNFsaSr
         3IJlFygExjtoU0NnrjIpDijn31K8MtYFSRWOkKXdmeI3LDRhOZQgDScFaEN7/WxKRGZD
         CWkcwNzouEnfE5euRvJCZpX3BjnkcDhsNpW7YdUVBXChhCHOVqb5eiekcTNRACWwy8G4
         hdWxFFyc3v8cOsG0TJDBd9RSVDqliL40JXyBE1xGnCjDpchEp9jX4Wz3JxfOjgCqenJj
         t6mA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1789337794; x=1789942594; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cFcUkK2nuEqNN4s8o5NV69iPxdq3RuDxEJaGlB2rHfY=;
        b=Y7o1/AcsUzeo5iOxFnF0+bsDtI7sMSIqXSoFabd79JUQhxYVHENCzVYCXsSqNVSAta
         GlZCdmRfccYmHbDAtKlNjD749otBvVZD6ZGtFawKfr1kRk9zKK6TSiphBWx90uXupVzA
         lLQJ1scs2HxvSZd9dtjbHN/RSZn0M3hVptUh3A5vIpVIjLdlJaX2p2/JtHE1F9Gr3rj2
         SOy4QSxrI7M3ZQu1WO5QkFaDpL65JczYVcqhzjjMn+tMf5vkiSfupMpcPKzyfxXxJg49
         Z5YJI29qe2cNFfRRyAiFKYzhR9PuBV17takJWG61J+ZBJvUAGF4p3jxRyMCb2vdvsPbo
         Pn1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789337794; x=1789942594;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=cFcUkK2nuEqNN4s8o5NV69iPxdq3RuDxEJaGlB2rHfY=;
        b=frsomdTLJCAQCjpUMVqJ7xnv+ECbwLVTNIEoqgLyFxlzBbyhfrv+8GlpxKU7s9b85x
         H/5Bx77z0js3xNaDx3yO1L+V+zLe+tuH/b5HhqFd4qm+BNyWDt273s8Tsudiu4LTnUKX
         lFsHGo8HipOvwoSOFVIBdWH0o4rdJ+P1tbY1XF1dj1OxJLvDF6dAOzacZx5Dxz9Gtj1P
         eksOsmxz6a420oBtIEawHhX4sHBUrL433Y7gMNsGVSj/1Vyi48fmqrCX8Phdgojzoe+k
         7TOuE0uAqjudLnaOqFcbjVdq+b1awW1e0iOlaRb0e+t4GqnSpVCoTHOQinRKv2VgIBFu
         Qd9w==
X-Gm-Message-State: AFuF++mSNRwEZQeA7EqlgyfuIm9etqmYTfHQVdlmaXKdij98HuZu/TSQ
	ieoo3zS3BlhCoO9ZxGqjXJO5OvW+L/V9o3l7ioAJzk4EdVWolKLdvggIOfruukn43H5lDwgzcPb
	iIKdg1Cqyjtjlcc0YmIj5pH4vmOOwIqY=
X-Gm-Gg: AYBFou0N+J0secATqDB6NW+9chks0B6zK+5vrbjut3ld/j5LlsI5DFJk4vWrPeuFAHl
	oq4HcSiCaUCjGARZkMp1x9Ioya0yYunkk+rur/GQrwnxBiGP4QLZ4MKsATCDSd30be8BqreZwSq
	wIB6D8kzjon6AGKQqrn0SADeF4yo60AO3MKkl8voGPvq5eC/xfMVjwIf3pjefEgleuQIx8WQq8X
	b5foxXvKJrOktcHgbPv4Z9qdmKxUeMorMECnlq/9aSVZgIrM5HbknHLk9doW2C/bFnSr5C+L4UN
	BjK0vj6YUNyh/w5dBpKZcSfEuquJtG1NMTAfVOSiFVgh6OigA8UI606whusAEDyO0Z1qALrDvZy
	DspcKUiwVj+m4YuGzIoJSheaPUmeAo/xkLhKbXhMUeEQM
X-Received: by 2002:a17:90b:4b90:b0:38f:2168:b9cb with SMTP id
 98e67ed59e1d1-39d9bd99cd2mr24385536a91.9.1789337793636; Sun, 13 Sep 2026
 15:16:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <CAOQMLZVB3_wedJ89yNoCKTXOsuXWNq+T785bVQBSr3Yh-TPqeA@mail.gmail.com>
 <ea2f5ee46c064fb9b3a45e9d705e2f59@realtek.com> <1f8a2a023b064bca87a8f1e6712bca3d@realtek.com>
 <CAOQMLZWhvwxTk9PNa0E=73pBOoah8X-2C+xN5-VY_gCSVtBkVg@mail.gmail.com>
 <CAOQMLZWpPDbm5yiBg89GjzXnCwuQn+t5V=AP617MoH6q8Zu2zw@mail.gmail.com>
 <fe2f2e2a52ed4565b5c2927d872d82cc@realtek.com> <CAOQMLZU31dc6ZvNi_veM6uU1fSXYNBdnWLkOwH5xXR45uOFx1w@mail.gmail.com>
 <CAOQMLZWPMq=CCFpdg5wwsJ_QnrUKx_0YouTxdaSePO_0YPqcLA@mail.gmail.com>
 <CAOQMLZUn30NJwU4pR0hL=nz38Mbp=73wgqd+CoQE2qSO3cf4_w@mail.gmail.com>
 <013f7d3cf223417c94df41a2a45fa540@realtek.com> <CAOQMLZXiOBsjn=UEO6UryngzkfCzKdo+Xa1RmE_vTtZoFKN0Ew@mail.gmail.com>
 <CAOQMLZVMALBLeCZUB3Jdvk75znt0D7HxrXyPMhGPvcKLx3j-Yg@mail.gmail.com>
 <0912165f66394229b4f2b4114ae28a50@realtek.com> <CAOQMLZUbZhNhOQyxGXW7YSOU-z6w-4jWqfqVkaeMhdx2kLDrmg@mail.gmail.com>
 <c52840cf65464f659635eec6fcd6de12@realtek.com> <CAOQMLZU9fzaFNh+vbFR=ZpvkyG=T9UDwaeBVXpRj3fvYZt2D-g@mail.gmail.com>
 <ed3fe21f453744a3ac45484839c1c9f1@realtek.com>
In-Reply-To: <ed3fe21f453744a3ac45484839c1c9f1@realtek.com>
From: Adrodoc <adrodoc55@googlemail.com>
Date: Mon, 14 Sep 2026 00:16:22 +0200
X-Gm-Features: AcwNN1WuFX4qYUpu6ECuYFxTc_MHlUZ-ZWlD3xlV_Pwzu4q22snTsAb02i193Qo
Message-ID: <CAOQMLZXAy+RoN9MEXFszNfwgZUP1PfNAyQsurNQCnzbEtPc01g@mail.gmail.com>
Subject: Re: Error in rtw89 using Kernel 7.1.4
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Sorry for taking so long to reply.
I have at some point stopped looking into this as I just can't
reliably reproduce this.
It feels like hunting a ghost.
I am not even sure if my issue is present anymore or ever was a real
issue with the driver to begin with.
Maybe it was just coincidence that I had disconnects at the same time
as these error logs.
I can confirm that even if the SER L1 error occurs that does not
necessarily cause a disconnect.
I feel like at least some of my disconnects are due to high traffic
during zoom desktop shares and during wlan0: RSN: Group rekeying,
similar to https://github.com/morrownr/rtw89/issues/109, but I don't
have reliable data to back this up.
I am very sorry as I feel like I wasted your time for nothing. My apologies!
But I am very grateful for the input you gave me!
I'll close the associated github issue
https://github.com/morrownr/rtw89/issues/116

Best regards
Adrodoc
