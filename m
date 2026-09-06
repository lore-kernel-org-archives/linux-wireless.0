Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A50441DED5
	for <linux-wireless@vger.kernel.org>; Sun,  6 Sep 2026 08:20:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788682823; cv=none; b=qzDn+FMTuNq6Q4CmYCf8v7KqSLqKNJnEODIsbuoAeDqfopWYVzYaDHgezOmJ/fVtYPJGZmY2NTBAHqOhOdsbNIG0DIuF1r5EPNW8QG6gAn9XlntQNycFjs+DQ5dr7UcB1iW7Oxe3vy2YWY6x4GlgAKMzLsWg1rHfCcvb5v3Lko4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788682823; c=relaxed/simple;
	bh=aIpw/5pYzi8Abvp25b2x2tcGOSbn2XKWW/NoDwdH4rQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IqdVYRYFhEUAaxtlqWi3+vyGLZpgbb4C+IuUHXF6YZy1OMEvGo+b3lfUME5Gf60bmfLyWZiihJ6RE+tOF0ukcn5cN5ii+pD7MCtrAuK616kbr7TAMNE4nmPOu8H5An2PI50nBk2hHOwAOdd/vNV+2HdVR16t7ne2NhE6YR0aiJI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bN3Zjgf5; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bN3Zjgf5"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-484392e3d33so1599402f8f.2
        for <linux-wireless@vger.kernel.org>; Sun, 06 Sep 2026 01:20:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788682821; x=1789287621; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=skUEh/fsWDrXfhaXpLnYhgK3w3JSqtI7bPrtN8rArKI=;
        b=bN3Zjgf5dWiZnq00HVzZczdnyyHrUd67wy5HngT7F5zqR3fzJtVJHFx/RxHZLrbeXs
         GiJoqiwv81BfyQbIJIz0sJOqDWL6BtoYmcs0ENlepFTEwnnBxq+K5lUI4HrPyaMBJkml
         XcsL9rHH0ZOvULBl3wa5cUjyAgfc+DYM81lLGp3VmZogydtomILnuwgBTDjhzSRhodiT
         7Hq5EoWHNqLFIG5xBNikwmqmoDhbSp0EdneP0P8us3XWACWkOV6Q4fPaUKBBZRqIZNkp
         5Yj4UA4mIk+W3cUs3ZGX0P3rEaEoai3T1VKrHJ6CD0LnwgHfcvHSPlUlgOPrKHwEXpIP
         c8/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788682821; x=1789287621;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=skUEh/fsWDrXfhaXpLnYhgK3w3JSqtI7bPrtN8rArKI=;
        b=ULpUdj1VRe0z3kPbL7dAQelX31iEo9MBoFF9YFOxk8OJzJi3RDjIF+2bkZIK3OCuT3
         FwFmUrzBxbAqLkRjNM41DrkNGUZiu7P6QasQPonVFISqr7tV2p5H3+aNo0o2xdosQLxC
         YHEWekiGHE2n36/Boq2+6FDRWX97n/olRnNVXy+Z4p9WAQ4kxT9F/SfWj0n7C/KATpaC
         KCwKfa0s0wfQLM/8IHeCGNdJ2ONlx48RS4fyDMU1d+NqM9q5CyJ+GgSjd2rimDe48qoc
         b7qVyZnInU55Pf4GUpE5j6lWBAuwRV3KBP9o5Hmu2a42Efea9Y5+q+1rQiKYAp95XAJ2
         0e2w==
X-Forwarded-Encrypted: i=1; AKwUvBxXKGwzKTQ30pAO+SoupB/S1O5m4unRcMBzGyVNuGUfxIMhw/pDhcMxelL3kxOAL7SsbuGIoBOcAwBcbIQHRw==@vger.kernel.org
X-Gm-Message-State: AFuF++lL1J+zzGBgcce/a9WI9LYrc3yDSvN9N7MwCPau9lmxIzq3MW8O
	v0YG0HpmyIoIM2Lr4RKNaGBe/JR7z4V2RkhiWNlMP7Ep/KmEevDm0ALp
X-Gm-Gg: AYBFou2NTynKET6t9znjEpTZQ2n8QbFx/ZyKAhS2ZZreYUuZTyRcTbgAyTp5HJrPdSc
	gALXsL60Br8jqJSdMjy2MIB2ULusnwfeIL5es74651mfJ4U4/U7Ey+DzTxOT9qF2Vwru48UnSqp
	S1rYa5K7BKk6/easJVTn7EQSptAwf8ZE/FrlWu8UpJIUWseyOpX1ykzpOlHhDF7iPDnvxm+XZp+
	HGhL8vjCobr3RqOZPfiZChk9RsY98Amu42sQaSvVsG4oTD/ftO2YQH2XZ7w2lluOwp9ngXRcDhw
	6Lnd+ua9yHpnZtVjj8bG4dSzKZAC2JXq9LKoCr004R7Bdw/dVk8UqMyd0cRmGodiYsdPfF+uCUf
	yQIk2/RFN5sgooEe9pL3sFbzyB4dgutSKSer9oRK53xY0UhOc9Y4uIwSUh0BRO3QB8UajjXnUA1
	v8Y44Ec32eRpDanH1Ahh7ZsojDYDMVyAx1hAs5p44+bbMVl5jhYklAfgfrZDhNjOwqJQ==
X-Received: by 2002:a5d:5f94:0:b0:485:8c17:975b with SMTP id ffacd0b85a97d-4858c1798cfmr13683055f8f.29.1788682820569;
        Sun, 06 Sep 2026 01:20:20 -0700 (PDT)
Received: from deb05.proceq.com ([213.160.61.66])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4858bcefd59sm15868241f8f.19.2026.09.06.01.20.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 06 Sep 2026 01:20:20 -0700 (PDT)
From: Mehmet Fide <mehmet.fide@gmail.com>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: Bitterblue Smith <rtl8821cerfe2@gmail.com>,
	linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Mehmet Fide <mehmet.fide@screeningeagle.com>
Subject: Re: [PATCH rtw-next 1/2] wifi: rtw88: usb: bound what the driver feeds the after-DTIM queue
Date: Sun,  6 Sep 2026 10:20:19 +0200
Message-ID: <20260906082019.909573-1-mehmet.fide@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <05f0cbfc6a744053863e3d7233e3ea15@realtek.com>
References: <05f0cbfc6a744053863e3d7233e3ea15@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Ping-Ke,

thanks for the review.

> nit: a blank line

Will add both.

> The pattern ' HZ / RTW_USB_HIQ_RATE' repeat many times. Can you just define
> the it as a part of macro? (The macro name should change as well.)

Yes. v2 will have

	#define RTW_USB_HIQ_REFILL_INTERVAL	(HZ / 10)	/* jiffies per unit of budget */
	#define RTW_USB_HIQ_BUDGET_MAX		16

and use RTW_USB_HIQ_REFILL_INTERVAL everywhere.

> Will 'quota' or 'budget' be clearer than 'token'?

Budget it is: hiq_budget, hiq_budget_refill, rtw_usb_hiq_take_budget().

> It looks like you shift refill jiffies according to the tokens you are adding.
> How can I understand '+= add * (HZ / RTW_USB_HIQ_RATE)'?

hiq_refill is the point in time up to which budget has already been granted.
When 'add' whole intervals have passed I move it forward by exactly those
intervals, not to 'jiffies', so the part of the current interval that has
not completed yet keeps counting toward the next unit instead of being
thrown away (the usual token bucket bookkeeping). When more than a full
burst has elapsed the exact position no longer matters, which is why that
branch simply resets it to jiffies.

I agree it reads badly. v2 will say the same thing as

	elapsed = jiffies - rtwusb->hiq_refill;
	add = elapsed / RTW_USB_HIQ_REFILL_INTERVAL;
	if (add) {
		rtwusb->hiq_budget = min_t(u32, rtwusb->hiq_budget + add,
					   RTW_USB_HIQ_BUDGET_MAX);
		rtwusb->hiq_refill = jiffies - elapsed % RTW_USB_HIQ_REFILL_INTERVAL;
	}

with a comment on the remainder, so the intent is visible without the
multiplication.

I will send v2 early next week together with the changes to 2/2.

Mehmet
