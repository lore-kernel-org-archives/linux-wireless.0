Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02F97447238
	for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2026 22:19:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792189172; cv=none; b=jj3DoIy4cdlXvPfCuYMN+ZwASaCpemiqRm05AOclb3/1uIPrml3BinU6cxVYn2yIiNfmzCjOznlhefyUQVysUqHu6pyaiPljQm2HbKzjoMkL/WLBg64j1ifb/6ylfqWYcBktFMl9dwTjln2ti3l8dxwuSm8DC7MY27oH2+hGlJ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792189172; c=relaxed/simple;
	bh=CczPsXEzRRfqJ9GyVserx+qYU8CP5SVMLNDQ8x8WOsI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZbYjPlCXrZeUG8mvBWbyNhACAr9KyO8wT3LJ5up4BRBYuPa1y/U271bBlYgpJ7OLIngXnGGTrFFTkp3OVurhC4HGSi9hiioB4v3ZLlpJnjrN9baSiA2auAmUrZz7dKqIodJklmU0j4/6uHBpUm8CGpzS1UqmaoztNB6C3tvzKMI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IZJ4gV2S; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IZJ4gV2S"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-48b0584ad71so186708f8f.0
        for <linux-wireless@vger.kernel.org>; Fri, 16 Oct 2026 15:19:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792189169; x=1792793969; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6OhD9xLYcSH+hZ3LcnQSTj3wOScq4AWKpIi8HmoA4vQ=;
        b=IZJ4gV2SKYIpM+47r9EHL/k91zdJ0x0Mhkz1OxMeDhgt/jgsXghaJRErhKbcspzZ6G
         e9mlKjoCZGc3rg2fZQisDHbI0aW8MHFBjQJkJ+OolHPry09U5HMFIyT8zuwQDhgQoE81
         95F/IMO69lecscsMxeiq6zAKWT9WJE4UysZV8tKqZkbT6odrBkdCBenaP9+lTgsow//v
         rhDEKtdpjQlZiKMCBOgODq17rLKknBe8AwfPR+W0e4ZULdn14AhVDFXrGD9bqDymvLjs
         8S9Zc/9KymPiM2zoSl3ZomAyYp5QsUFWmNPbntFrhF9Gw34ewqoQTUjUfCoTP1lxvB54
         AnmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792189169; x=1792793969;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6OhD9xLYcSH+hZ3LcnQSTj3wOScq4AWKpIi8HmoA4vQ=;
        b=Ugt1EukWXogaM2+8cjp7LgX6ZnPa07ClmO1Irxx8KWtHkDGWOP++kyOfC3GkW5IjjH
         Taax0eP4ghH2Z37sojVrCE6lT3tB2Y2VsTw4eUrSmDbNj8UQKsGbM1j6LVeLaPYYGc74
         KBXEsXZdlsRJRTS0DB5FSbEt2Z48RArAtlGB4JtejL8DMetjDmfVss50fCsuIb9YAW6S
         Vvc3PbsVG5pY1PlU2emFWGAJm8p5PbsARmaG98KPfwae1LArhBkIMozzriL3sG0/tMax
         wi0CWi3JpfrvJ2PYCpqim/9Xd0EBNXb53wvp89NRHNkpRZ8PUweuXddKFGxN7oe5iC/L
         0Eow==
X-Forwarded-Encrypted: i=1; AKwUvByKdwOz+1wxE+a/ziEvJq2xzBAynBhPaeYsujKXCYv6IHSBGlos2iYkYUi2U1NBvLKrDPlQHGzyYfK7a+5gpQ==@vger.kernel.org
X-Gm-Message-State: AFq9FYLDrwPiToS/hVobn/cBB4/cDvs2/ky0TXXHM3zHkffRlcROsLWe
	dhY2lAeJV0+gUYuRibZE78Z+3Epz9FjDmDYyGurt3C3VxvK+1WKc5b2P
X-Gm-Gg: AYBFou1yrkDJJQyqV2jjB0+uJuMS5hHJMap2WxFhsh7hhNgdemqQFIrMB3IArx0XFZ0
	KHpe39b/hnPEgG/vKuZcQRUmZyg2FR1i62G8nk6Yzo/qRlC/3bnNnHbwVTi9lPt+95FuhysVCnL
	GYPbQHwYJh4Tknm8vD9SnDeLfDDvaNEPLEbzqyb0tYjmaj8WSg+vrDMaKIn+G9BRd0iumy05z/u
	5ZnIviUT8zxsp5whfJ4seUYWkaHHDiEUIeaqYxxPGLSoEQVgJKTMjxOjpc6QUhKfCROMRtXy9S3
	iGD0rlNGzXWJewV5uWjdx9voxmzvFBmgLdG4XxPIkxb2dRGnN3izKt8tcKnkaQmvyVJajjSBjiz
	OXIUPJNK4nd4UGN4tloYwYz1V4UtDBHeHoOramokUqUvPz+9A4I2jrvxCpN/sqZ4sOSk7UeJo4Q
	JyzRpCMa3Xnds4OX+RPoV6UxMbUeyCNmPNawbnIPQM1hNwYdMSlgNYAroqBAJfskaMK0j7ZWLdY
	mbAVg==
X-Received: by 2002:a05:6000:469b:b0:48d:efca:5f3d with SMTP id ffacd0b85a97d-48e07f9c439mr1254947f8f.30.1792189169148;
        Fri, 16 Oct 2026 15:19:29 -0700 (PDT)
Received: from [192.168.1.50] ([81.196.40.70])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48dfd471877sm6416485f8f.1.2026.10.16.15.19.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Oct 2026 15:19:28 -0700 (PDT)
Message-ID: <637a1420-69bc-42bc-a1aa-df70faf769da@gmail.com>
Date: Sat, 17 Oct 2026 01:19:26 +0300
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH rtw-next] wifi: rtl8xxxu: isolate the USB register buffer
 from CPU state
To: Kim Wooseok <5mghybrid@khu.ac.kr>, linux-wireless@vger.kernel.org
Cc: Jes Sorensen <Jes.Sorensen@gmail.com>, Ping-Ke Shih <pkshih@realtek.com>,
 Kalle Valo <kvalo@kernel.org>, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20261010-rtl8xxxu-usb-dma-v1-0-e670d9c08fdf@khu.ac.kr>
 <20261010-rtl8xxxu-usb-dma-v1-1-e670d9c08fdf@khu.ac.kr>
 <fd91ff33-d8a1-4ab0-83da-c15816c148cd@gmail.com>
 <CAH1Bc_w89ymu+E1Gx13M9JD7ZNmdQ3=y_zFwVvMkQMKk4m6NAA@mail.gmail.com>
Content-Language: en-US
From: Bitterblue Smith <rtl8821cerfe2@gmail.com>
In-Reply-To: <CAH1Bc_w89ymu+E1Gx13M9JD7ZNmdQ3=y_zFwVvMkQMKk4m6NAA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 16/10/2026 21:05, Kim Wooseok wrote:
> Hi Bitterblue,
> 
>> Perhaps it's a silly question, but doesn't this just move the problem
>> elsewhere? Or does kmalloc_obj() guarantee that nothing else will access
>> the memory near usb_buf?
> 
> With a separately allocated kmalloc buffer, the kernel ensures that
> CPU accesses to other objects do not corrupt the DMA data through
> cache-line sharing. It provides the required alignment or bounce
> buffering, and usb_control_msg() uses this DMA mapping path.
> 
> The patch turns usb_buf from an embedded member into a standalone
> kmalloc buffer so that this guarantee applies to the buffer itself.
> 

Okay, that's good then.

>> An allocation for every register access was not happening even before
>> this patch. I guess your LLM wrote this...
> 
> I did not state that the previous code allocated a buffer on every
> register access. That sentence describes the allocation strategy for
> the newly separate buffer: allocate it once in probe and reuse it.
> 
> If any part of the explanation is unclear, please point it out and I
> will clarify it. I don't think speculation about how the text was
> written is necessary.
> 
> Wooseok

