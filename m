Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792954073;
	b=R6n4lx6APdZWGeYGEjRdoTwHi5I8Jn9NhYi9/HsmKGHtxeKAybGaFXsmDc8vx2psJ7MN
	 ncIeuwCLDkzX0qeAD45sPj1ALs/wVPIUrvNGn7ekMo9jFckeoeJOV0yXJl9G1RnZKjVOa
	 BA+57Y+EBREe/hSAa/s0LutZN7Nx0SgVZ1Ohz1HpX9972ePUa4x36lb4hriY/ypDxB8vy
	 ZkNoLpbJajNdnFAy5XordJdyA2J2jPBEUAM4nKob5UI/CD5E9ZxzLG46skCvJHUpabfTB
	 8VeOCIXduh6IOsm3Ag8Id5L1LL9L3arSSqZwjBn98Nxm9mghWc4KwUmjxn+ZT3e4pFg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792954073;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=VOCIkcKgCSX57LQofypotIDpkWBFLUASfshW5R2G7lM=;
	b=wR9tFaW1qqGlcg/x7/LDdEZKK2SeClt9masu5R8of68Tp5eTI9Uy1Hggs0tVH8nSNbdl
	 tJHh4ECp/2ZcpeuycBhnCEMLMwKqKXvLEfxiEPY8HBNUhmzRRDABInoxGJLwRt8gHuOPl
	 3xN7qu7RKH2lPqra6Ohj1CePDAy6W3mhIJWrPVm1XtFGb6Xm8lrZ04xhepWtIvFYZ8oGG
	 Jr6woa2S32gIrcbmF7S4A9lgNis2SYxaFCWrw/fWe3yTlt8kst9w+xT8s75TerCbvzCNv
	 HgbV+9tmwKX8UPV1tQznVZa19WSnPgjS9oUncJXZKfvZYtdLeZSOZx6pQfKmAF014VA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=l0A6QTVH;
	arc=none smtp.remote-ip=209.85.221.42
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C1E9606A31A
	for <linux-wireless@vger.kernel.org>; Sun, 25 Oct 2026 18:47:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4C1E9606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=l0A6QTVH
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-48e0d1c095dso1377764f8f.1
        for <linux-wireless@vger.kernel.org>; Sun, 25 Oct 2026 11:47:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792954072; x=1793558872; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VOCIkcKgCSX57LQofypotIDpkWBFLUASfshW5R2G7lM=;
        b=l0A6QTVHPin0eH1+xnSaLQML5IYQNeSrdYtlsLsiCPMyNnun7hUAV7vx6EOcvEv+eX
         6nfSIIeYqhj+Gll+lNpctdEed8QGZ/E7pMPbrQbZsBf5I8dMF/3jfl+YbEyH+rR+9SrF
         GDAPt5tfNhlFMIH/WEiikoVhhfzeCZau4onnQmyxoFedfzEackOZx9Rgk+VNYQYU1XrT
         7FPYNfPcP+ZNrVtC5sNiZvswC4QaElSE0SkOieYWbDuonCUu7eT6Y4up76JUWJdhm41k
         avmThVXITY6MCbIjH6WpxpHs6g/HqHYUFDIbM16alxpYp4xioDh+mFyYHSBFSEQS2CJ5
         MoHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792954072; x=1793558872;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=VOCIkcKgCSX57LQofypotIDpkWBFLUASfshW5R2G7lM=;
        b=Pp12qwdWEmZHFQ7jHqhPC26CQo9TKORzqSCn+lrLYfBI7Xku4FYpaWNGO4P16bXbOU
         /qIZ9Wx4A174TcFHR/5e+8G71gd1mibbrlQV+7XeUUfxVLBLho9jFYnHbY/5NpJEQmc6
         a55QumG70FaQNBk8/pQ7AAX4MVbP5EobL4fCrW7x0oLTZcPW92LrzmuFQPOGQoPVLW9+
         AsMrsoNRI85EgUt/PqvOiXTyhLGZc3ww/EWl6bO4zEKnin7E4G2RZkyIYQWrdvpYGb4H
         JXK+Jmru55PiIfvvtvLVu3tr9lCj6kkEIZP/39D+b8atyH4KHn6/2Zsb+dQQLAP+5BUg
         /59w==
X-Forwarded-Encrypted: i=1; AKwUvBx6QqS/6ULcUCpppIiVzVo0H/QtPQmnmkcw7PBoog+AYF4lHZNJ/FCio4/EMHkM7/ppRwOhvDnoDONMAkiUEA==@vger.kernel.org
X-Gm-Message-State: AFq9FYK1mOrT1OBpnxYkoSGtpWz9I/mjGR6NROK/7gd3ykUQTRBM4uKU
	KhFnct8eaX6sISau+ViFsnfwqXdZHNmJ03GaJ2ua3MVpFRGKPNOfUgKZROgry0rV
X-Gm-Gg: AYBFou0/7fFr+Yj44yfyErJq3nT6kMREXumqhEaRXqy054d8Mqe15nyFUL12Rv2nfMr
	ZicrCnYcIlz09KMaDRpl/mq2VDndq2bpegX5jjwayadhmlq6yyDnr5lmPBccF5jeHq3QW8cvX9R
	PFYAxbQhDXLaVikj7evKQmHaCc6SziWxKQy0FoE1IMY1I9Ea8Ac7bjKPBkDf3Bsflji9CejY0KA
	Rq9T/G92/vgUzX4QsJe9VOotnDjyjnp2SzjPUwe1Eos7HS0VBDTPW2smJkRMN3B+TSBlJFvG1+q
	QJy4Ka/PmATq16vBkZCR654Jcugu+TaIZIMbThWU7dAXqOrIjeX1RkQdqtb9gMXAy2/s96yWk15
	QNTNY4Dosz+OVK10trq1qgbRUHOfgu1YH8NHKyWVNHmuAgNg4DdoD2x/VD65PQjBQa/0i704ZY5
	Pskhc9j9in8DdOa75w50JMS36XMFy4srNkhKyKOwID/sRSCNFfzDv3MU3XdegKMozYWSawWm497
	wpVGm5tJDBtRt7s8VkR/LN17i2C1F4RnYF0Fn7iSFtk0m6CB8hKr0OfylCw7NWmxExb4Swq2Vf/
	Tk0OvPg=
X-Received: by 2002:a5d:5d10:0:b0:48e:1c72:abc with SMTP id ffacd0b85a97d-48e3eb9890amr7896007f8f.35.1792954071610;
        Sun, 25 Oct 2026 11:47:51 -0700 (PDT)
Received: from deb05.proceq.com ([213.160.61.66])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e3ebc3bcdsm9979793f8f.13.2026.10.25.11.47.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 25 Oct 2026 11:47:50 -0700 (PDT)
From: Mehmet Fide <mehmet.fide@gmail.com>
To: Luka Gejak <luka.gejak@linux.dev>
Cc: Ping-Ke Shih <pkshih@realtek.com>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	mehmet.fide@screeningeagle.com
Subject: Re: [PATCH rtw-next v8 2/3] wifi: rtw88: support channel switch in AP mode
Date: Sun, 25 Oct 2026 19:47:49 +0100
Message-ID: <20261025184749.1045907-1-mehmet.fide@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <796598480d47c5bf474d11828769e864b8209558@linux.dev>
References: 
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Luka,

Thanks for the review.

> Would clearing csa_active in ieee80211_ibss_disconnect(), same way
> ieee80211_stop_ap() does, be the right fix?

Yes. I reproduced it on an RTL8822CU. mac80211 refuses the next switch
itself as well, so I will send the fix to mac80211 separately.

> Maybe rtw_ops_resume() could restart the countdown when the AP still has
> csa_active set?

Agreed, v9 does that. It is not run here, I have no 8822CE.

Mehmet
