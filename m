Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4CB53BB9E3
	for <linux-wireless@vger.kernel.org>; Fri,  9 Oct 2026 07:30:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791531042; cv=none; b=bH86pKN5tqsblHwev6/JudIavxB+wV0O5MqTdtbTo2Ji+41WyhUJ3gpB3OekSHcTr0C03m3qrIwjmzHbPpm7So0jpFFhioP4sK3JyzZ6DAQZd/gR2dyz1sQamUutBmIQ7fB5qhPmQ0I83V3ZqmVGcgy/+g7zCviwBTaovDa+xp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791531042; c=relaxed/simple;
	bh=m2sbDzTVz80zNixXWIi0WDat1SU37qeKuIL9ZzrWE0s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=n8p32DxRoHY2hh6sZNi4lxkWx/4ZopRc94uddYZLVyrK9dJ1m+OcbHvHn6pnGWh+XTfFX4yPuf6JJg0eL9Gt215C07lJOGC6fhExq+UMWmICxSay9J2NHSZuaIDx8nUjmX8AEw86383+uo7OGTO6i7El33PFixlLTg9bIZFg6Sw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TisiumbA; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TisiumbA"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-4a1635f7c89so62890125e9.2
        for <linux-wireless@vger.kernel.org>; Fri, 09 Oct 2026 00:30:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791531039; x=1792135839; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=QhfdgCnusoug/g1d4W12Bzr39jd94gg5/ulsL7PdlMY=;
        b=TisiumbAcAGgBzjagMugUD4vnd5QOPbyuCPbgGXc2bY11YasM0iNwBx90vl1OnQhBW
         0lIUXSaGBcnnkD3lTHRIZN1F6t7n9FchBO+t5uHEJdUAM+H6nI1jMlnD0eZpm/ymMSUT
         oPdnbxWZmMT/YSC+wiRo2R7q5jVgeUwQcJj/L/54jTi/pvv2YdaQvODC8QbNgHuE6PWQ
         cYBAvtdXW8KG591U4nJWV3r8usAFp3pXPL95DgUB2lSTxTUPDsC8QU/wwr2YTQhJpIT3
         EW153KTI7R8y1OV7WeMZ4MD0uw+IUvjXzxZ2+AtyrweGBGERMBx0lx/mYx+gJaFTjL8w
         dlVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791531039; x=1792135839;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QhfdgCnusoug/g1d4W12Bzr39jd94gg5/ulsL7PdlMY=;
        b=bFnvr46gtd5OYKXDoW2H4EZEd1kIaqtk6nTxpQSj6QiSM8hivw6iDTEWznMxNXqUd1
         JREuObD8Eu/Jw6UwYKPqo+0nRQXRxjPWETeSO0CGDXQDZ8Ug3sxnq1iwasvmTiWqXm/k
         u1poW4FLilfbA6utiy+DllP7jlREp4Zun54dYxdzCzsquasZevopE2nHLOsHLO4P5wVo
         3wrcQ5KYm9u/gzKOpUUJML7mFXk5WrFqAmNzLSJ02/L07qroroMF9CFeve2NqsZ+4VaI
         c00ripDRNDYOBjUbczCOHdpYueOzAWsHmGbD8aNRtOFlsA8BrmGpYYjpiU6L8hecqUF2
         T01w==
X-Gm-Message-State: AFuF++loKiao7bCpB1VXTIlKGSMR+8LYVEqSKhUIsnDQFg4ghif01yef
	FpANIqmWx5xksEFz3nbr+REsqg1GJfzJaQANFV9i13Dns2xtsRPpBxEM
X-Gm-Gg: AYBFou0+maipXKWUmwAyO/cC9a4oU4Dp1/hoX3OWG2jIQgVHuPY/V5V3SPVafL823wQ
	Nfjk3skAwJan/ZDcHjWWvv3JAERWk+BbYCfaTzajD+BZP04hb49x16+8Y+K25n4AB/q4iSdmgNC
	J9/04g4OJop3Ay9XIRUU9hA7HNT/mDCQiuthg201WNNQohDwV53QLKQG4+ABq6RYqb38mQAdOji
	z9yJMrzzilFdMOCdgEs4fGncYDiXKxuhFvf9PrjASXE9ldVX9ULTMkBUbyC5xUXb/mGd08i75bg
	j2HA5dQcIHBcwEFnxhEcaOEYaEkypmUA4251T3+cxvvVnySRWsWTLlvhWTu4fAR62evN2btOkzM
	I0hd0dX1c+ozzoMcJwvFlTuqDW68SE4jAeDLClzisx9BMHtoxCp1WaFUrMDjH2cP8OxD3Bxv0uz
	MT3FXfpEIV8EK5kXBei4lUddivrcgwHPp3wK3glusl2Uc0Vfh7c19mjONu77a88fYaFwez7pWuT
	WfbLi33+q8sekmlyGhJh+l8WsXYtllXCoskpZ8QMDchcm9S7yQFkznZxlkggOY+bdx/G2Qoz5G3
	QYwueMSTwwIMmz7h5FbDyRq+OiT1QrmgZNsiT5jdrAW/9yAw6/QRGOmsUOt1FXuEWXTLN6hgH9m
	e
X-Received: by 2002:a05:600d:82c6:b0:4a0:1fe2:d4c8 with SMTP id 5b1f17b1804b1-4a18e4a4c3emr19524635e9.5.1791531038809;
        Fri, 09 Oct 2026 00:30:38 -0700 (PDT)
Received: from unknown748F3CBA5068 (dynamic-2a02-3100-a128-aa01-297a-7094-853e-a20c.310.pool.telefonica.de. [2a02:3100:a128:aa01:297a:7094:853e:a20c])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a18bf31b83sm38426495e9.12.2026.10.09.00.30.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 09 Oct 2026 00:30:38 -0700 (PDT)
Date: Fri, 9 Oct 2026 09:30:37 +0200
From: Karl Mehltretter <kmehltretter@gmail.com>
To: Arend van Spriel <arend.vanspriel@broadcom.com>
Cc: linux-wireless@vger.kernel.org, 
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>, Clark Williams <clrkwllms@kernel.org>, 
	Steven Rostedt <rostedt@goodmis.org>, "David S . Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, brcm80211@lists.linux.dev, brcm80211-dev-list.pdl@broadcom.com, 
	linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev, stable@vger.kernel.org
Subject: Re: [PATCH] wifi: brcmfmac: avoid sleeping tx locks in netpoll
 context
Message-ID: <asiX75kRueyFqWuO@gmail.com>
References: <20260930185417.61865-1-kmehltretter@gmail.com>
 <20261004122910.1392318-1-arend.vanspriel@broadcom.com>
 <asR1TaKQJlPFqEvR@gmail.com>
 <802a092a-314a-4f77-aa1d-134b3d020069@broadcom.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <802a092a-314a-4f77-aa1d-134b3d020069@broadcom.com>

On Tue, Oct 06, 2026 at 10:27:27AM +0100, Arend van Spriel wrote:
> > 
> > Lockdep instrumentation in fcmode=1 and 2 confirmed that cleanup enters
> > without txq_lock.
> 
> This is an observation unrelated to the patch, right? You mentioned in the
> patch it only covers fcmode=0, right?
> 

Yes, the cleanup observation is unrelated to the fcmode=0 fix. I
mentioned it to explain why I kept brcmu_pktq_penq() for normal calls.

I'm looking at a separate brcmfmac FWS-path RT/netpoll fix for modes
1 and 2. The prototype defers IRQ-disabled transmit to the FWS worker.

Are modes 1 and 2 used or recommended on SDIO devices? That would
help me prioritise the follow-up.

Thanks,
Karl
