Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 010E33D6CAE
	for <linux-wireless@vger.kernel.org>; Wed,  3 Jun 2026 17:05:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780506328; cv=none; b=BjsxQzVHvKBRyuisDQSmG9I8JkWz86dtYIntGITwjNdK0Gu4trDi6P5ovJTr7TzT0UjPCNZ0JTrLUufEv6MeiZJoIHXJSdQKgadan3NRMHprmJIzBk2rxVJPdcX5GCcd8opwwbOQh27hZdJv0ecxRdlsXAF9p5kFpwnkXjBQtI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780506328; c=relaxed/simple;
	bh=6jP9l6wgm0EYwglnpIZ8qZZceQZq1hiGQCYxwBbv/lg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bbhy/PVsazCfV0+JsHkwuG7OAE1xRgX9KxoyOFcHrymA1i2UekAuiKCQeMtuJrIyEOIltwrVI0UoWmgg7J+LbmIC+r4CBaAct5kuwg0mbtcXA9tL8/W9BLwcxJanJfXr7fThSfmCVE3ylebO1MDPCpZ+nj6nyREQI+waM8bRJ/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=qFkjzCrl; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qFkjzCrl"
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-c8584e80bd3so1996860a12.3
        for <linux-wireless@vger.kernel.org>; Wed, 03 Jun 2026 10:05:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780506326; x=1781111126; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6jP9l6wgm0EYwglnpIZ8qZZceQZq1hiGQCYxwBbv/lg=;
        b=qFkjzCrlyVItW6qN/jJMJE364NlxO/3eBfFgGTtUMAIpfFikUNHk3a+CcmoVQQAu9i
         cGttXhmzoDzgNBOXig8DFOW5QsmoqnBErY5IceksV1PQkZnODwhuDJbTn9TkUHQOwMFj
         3j2BGRgf2a/B53B7fyRTZ7DDFS/7aNLiHE6HhuNN+d2XW5I5M2Sc4kFgEsXayThQbP95
         soyA76TqEEhw1kKFDf2xPwEeFG1YztacUf3ekd4JXI4UilHo+tVa4xqwmMjK3o/BsPgB
         zbH/NS8fX7UCKPJuW58OOZkKss01XWQfY5D7fxPX6zzfFgQfizoct4PO0lDOVhFMMDJm
         jHhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780506326; x=1781111126;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=6jP9l6wgm0EYwglnpIZ8qZZceQZq1hiGQCYxwBbv/lg=;
        b=aSh6RDVOCY1J+Km+OC3AN48x+do47bSTPYHaEBUHxpZnPhb2t2ZumhTMKMCXptuj12
         Hg8oNp29xKud2lwCMEnrCKo04zf/N61Em6P8/lvE/B09udBY+5tQbWQCYhOy9WknVMGR
         g/LxbPHGFD/PqfoCQcSqR3m3+J9x0Sjn3Wh8sVT4UUmqYUElYJRu+gKYcjUfcbR2tzoU
         FaB8O8GkC1AQochudLzkfNWqaLnseEvryOlby8+vD2iPbpF7jRdkZk04xnkR0JbRr9jN
         zfzZXiW2qHcC50zPcaDJfbsOouIIHaQlzN+6gLDC/UfbuMu0BzMvd5flhN0gCZbrn8DA
         74Bw==
X-Gm-Message-State: AOJu0YwhSr8+JNZ3LzTwfhMmpab0/YHmG3ZbJVPAUBcc2wdpSGeKS07g
	oVrbppPHHWgwGPJwQXUGeqEixMBVG4xLcUh8sQ+KJ6aaw9KFE8Acw4ZB
X-Gm-Gg: Acq92OF+8U8HpgqHLTSJgmWRLSdeG0DMENXs7wAxjzU+1cuQICyRTXiqaIoi9+oxHzo
	1pnyocIV8B2kH0GL9mEqvV5oDXJl4wvka08ak0sihyueBJhPF67xIlG/KRfHnqix6stTsePoXkl
	oe334f4yJ0RnqSlid2Fb98+m3hPeifqQNC+vR+xR9qsDev39gwBLHcoI8aYoE0QbLdGuUwohFB/
	nmL6hG1/Kr28v1EMji2UMx6yDG2cepeSTT/E8K4fowtwMPMfCpV5sN5q8o5AGE1ndAcHJh+hF0L
	UeL3ZHQSWh/G6r64I3mZpBr2X+2W4p1j/5KTTUCfLCUb/KhAdJgF4gMAZCu96uw6jS4OtDo7Zyu
	A+SqXeRJkc3JPtxwbUObV2JnA2zF0jtBeKcdTwV/HVDyOpr9DXgmK24LtFvDC4a3KeFE5wHba/0
	hF/kGHFKeDiyCOXt5dIVFO+93l7wUNoVWnNOC0w4E7927hnFsVWEZMUvYJGi/rwC23byQ=
X-Received: by 2002:a05:6a00:8086:b0:842:2f28:4e53 with SMTP id d2e1a72fcca58-84284fad093mr4174502b3a.47.1780506326217;
        Wed, 03 Jun 2026 10:05:26 -0700 (PDT)
Received: from BM5220 (123-194-40-181.dynamic.kbronet.com.tw. [123.194.40.181])
        by smtp.googlemail.com with ESMTPSA id d2e1a72fcca58-842829188b9sm3644897b3a.59.2026.06.03.10.05.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 03 Jun 2026 10:05:25 -0700 (PDT)
From: Zenm Chen <zenmchen@gmail.com>
To: pkshih@realtek.com
Cc: linux-wireless@vger.kernel.org,
	rtl8821cerfe2@gmail.com,
	zenmchen@gmail.com
Subject: RE: [PATCH rtw-next v2 1/5] wifi: rtw89: 8831bu: Add support for ELECOM WD{B,C}-X600DU2M-B
Date: Thu,  4 Jun 2026 01:05:19 +0800
Message-ID: <20260603170521.3886-1-zenmchen@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <4779f2efe03a44f9973e3ebd9c853331@realtek.com>
References: <4779f2efe03a44f9973e3ebd9c853331@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Ping-Ke Shih <pkshih@realtek.com> 於 2026年6月1日週一 下午2:10寫道：
>
> Zenm Chen <zenmchen@gmail.com> wrote:
> > Add the ids 056e:4027 and 056e:4028 into the device table to support
> > ELECOM WD{B,C}-X600DU2M-B, two new 8831bu-based adapters.
> >
> > Compile tested only.
> >
> > Link: https://github.com/morrownr/rtw89/commit/9e2db2834b37c6adfc4b872a9ef56c927df22bea
>
> As I saw surface of this Link ".../commit/...", I'd ask you to remove
> the Link, because a github commit isn't so important to be a commit message.
>
> Look deeper.... The Link's content (the comment part) is to indicate where
> you got these USB devices ID, right?
> If so, maybe you can just mention that you collected these ID from [1].
>
> (change to this style instead of formal Link)
> [1] https://github.com/morrownr/rtw89/commit/9e2db2834b37c6adfc4b872a9ef56c927df22bea
>
> Then, if a reviewer wants to save himself time, he can just ignore the link.
>
> Please apply it to this patchset. Thanks.
>
> Ping-Ke
>

Okay, will fix in the next version, thanks!
