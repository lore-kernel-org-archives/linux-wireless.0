Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B92BC3CF69C
	for <linux-wireless@vger.kernel.org>; Mon,  5 Oct 2026 09:51:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791193882; cv=none; b=WAL2kKbvUdyEmi4IPOlDm+JjdUVrg2o9IT+6YT/7iumtx+4prC6ap3PZfHR0Aa1MNT0JmhJM3izSb95JbJd7me2GpLlvTHpoOUdRoqehFXrorvCUgootiDmnfVRymjKSZCKPWipKAh12z+CnTneCA+MD3kKaWEOo6/p+LBI+x+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791193882; c=relaxed/simple;
	bh=ZjAV1Hrwb3f8+S6+XkTUs1o41gse77Cms6u2uyzXKhY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JmlYZKw7dUdxLJ+rCN2jpsaXb6qnBwpeb1/ENtzC+qx1KVzHeMMsCu8T3Fg+3fLhYixxPw3CR6LfHgIkGlAlJsJs8K1GbOXxL6N8CK1aQBbmfATZ/KWZ/5C7B9621UloB9zSZ/y/PHny9PoDnmu8aQW4IAD3KKGfHyA7Xcxxzro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=qwsXueMg; arc=none smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qwsXueMg"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49ccf3ca626so10340775e9.0
        for <linux-wireless@vger.kernel.org>; Mon, 05 Oct 2026 02:51:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791193879; x=1791798679; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZjAV1Hrwb3f8+S6+XkTUs1o41gse77Cms6u2uyzXKhY=;
        b=qwsXueMgoLros3npUj3UTsUl11PlxGKNMmeUyxjA1sFBzp29R9Jc6PAczZBhFfxrBm
         0I8UarpI8Kxl9iL03jmTOzX0LlI0GW8DIZuoDKSKWspmcBjotp7aN9r2WBf3DNhyPTKu
         YsOVIiMiJVMgWALNRogaHoZ22lXxpG/zdZZLDlRL0BA4iXnnZEUSTRzSEiig99D5UwCB
         iiSOdhNvnBkOVqSvICXgcPDRN2PVM9LkdlPwutn6pTC+hRD/s2+cPlWGjCOVd8MG23Zt
         Xy7ZatVvxkFyEWqTrjvsf9RB/SKeAmAmQJJV7tnaSZhSSClrwX87PiUKah2xl08Om1Qr
         5V1A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791193879; x=1791798679;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ZjAV1Hrwb3f8+S6+XkTUs1o41gse77Cms6u2uyzXKhY=;
        b=cRbGcIhXocj0fm2K3nUKtfH35QFIFwCu3ZhLBJ/fbrTldamS1hiPJXex7A90Oi2SRz
         8gV1rF+zB39hDJuE00lXMdK1gnCwyAcN/f5m+6OAS3kk5dqlufBS0+Qy2Bg5KWN5Woxn
         /0v/6Ow/bfy7PhrQZ9iHY8eJbpBSZ7rOJ6lrLKjiECQacIf1mc8X3WLtwsrbKUA+WVz1
         JMVdLm9CZTzijvH9d6uE0WXmeINt8XXEsqDWxol129nt6oEORRIwlGfiK+Bgze6lvrfZ
         hDrkcvdYkdO2NgmdUq4okyG6LaMc+igOwoQSePjrUkW9mP+G3v/r5fpPp91XeNhJcv5q
         rW4A==
X-Forwarded-Encrypted: i=1; AKwUvBz3NYBqm3V314RSe/9hbhOGZHDaKhdFcMqI43MoCzbmP1XlzQFjxEotSfwbVYY+roOVGw+qXSWoyGU/pXPh9A==@vger.kernel.org
X-Gm-Message-State: AFuF++nh6lVPvNb4IQnz0433i0lm0YlwAl59XdRSyzGQrH1I0p/J/hb3
	wDAhTf0u5WIY1GDZQPBwEbZf8AR5xgvwyGvtfQVkLULaijh7ySIW3MJ5
X-Gm-Gg: AYBFou1UoIelZBOdGfb8dHK9LDk1kQ2F0+jgo38TAENy6eGUHPycXpZtB+qZsMwXeNg
	sf2dNKUEjRYprXemaGLCmfHw/EC1p0mSrI379Ivdurv7/I7vZy6OXUOPC3dVM4cpmmeh6FF4mnx
	2q3oKoQnEJ/iWVzfLHL5weq/myfiM7RGvzg9+tDsfz/tUwYILHlRn2Esoxi5H1zFCgn9rYKNynA
	l+xKBXTBALDc5kzrB0eIzK76cV+hjkTixdPDsqG1hlmaleRQSuiUNWCSnnOYaAvv38OaJq0rpk3
	bALTFNTV5r3bPV7FupBs2h9e5K6ayPEIUtje9mGazoEhFUbCqUNvFVrJfCWr4U0v1/tf8SxhEHV
	csvVXQjFEVZOjlmx9tTpxwjnnQFewgOk7NEn6B3BmDTmyZaJdguBh92RnqTy30pXcYkTOnOhESZ
	9PkkcTCdGyOyqb2udBJTV5sMNzV8VBDxf+GlMfUQKkSojGh3oCuP2bfV5JkMbYQoTPZH4wI12Ou
	sLVCw==
X-Received: by 2002:a05:600c:1e0f:b0:49e:6249:268b with SMTP id 5b1f17b1804b1-4a027697ef2mr166332585e9.32.1791193878854;
        Mon, 05 Oct 2026 02:51:18 -0700 (PDT)
Received: from deb05.proceq.com ([213.160.61.66])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a03ff6a82esm133721915e9.4.2026.10.05.02.51.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Oct 2026 02:51:18 -0700 (PDT)
From: Mehmet Fide <mehmet.fide@gmail.com>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: Luka Gejak <luka.gejak@linux.dev>,
	Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	mehmet.fide@screeningeagle.com
Subject: Re: [PATCH rtw-next v2 2/2] wifi: rtw88: support channel switch in AP mode
Date: Mon,  5 Oct 2026 11:51:16 +0200
Message-ID: <20261005095116.22186-1-mehmet.fide@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <135e11c2a24642d0af774d6fd3c7f5a2@realtek.com>
References: 
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Ping-Ke,

On 2026-10-05 Ping-Ke Shih wrote:
> Should we define csa_beacon_work by vif? Then, here we can get rtwvif
> (and vif) from work context.

Yes, v3 moves it into struct rtw_vif; the ad-hoc check and the wrapper
go with it, as do the comments. The hw scan refusal is in the last
paragraph of the message already, so I take it the inline comment is
what should go; done too.

v3 follows once the hardware scan path has run on an RTL8822CU, whose
firmware has scan offload; the dongle is on its way here.

Best regards,
Mehmet
