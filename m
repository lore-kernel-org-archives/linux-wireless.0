Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4D2D3FBED7
	for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 15:24:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784301895; cv=none; b=GnsAH9qt4gDYl1k5ThupRlX26LPlsHtjBBtJPqDGTNIntlfsk+j7HFsnpmHG3dT7XV5e95CofILYaGP8bb/cuQFj0Fp5ZR8qgRc4dQ1Nqv1Dc3nYW29rHy8g4kX4Zqkb4EgzAkCzLJeytTa2vGwxOvCVQzKL+/3oe3+Le52XjR8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784301895; c=relaxed/simple;
	bh=A10EGDsM7fnlda5quAJGXi662WwFMP2QKJ0NHlL8aYA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Gb+f5fxO3GpZCPSxtTU8Qnq3MrEZY2MB+uTaTg4lNHUxTo3PIcG+23N+Q4L2fB/NU2dDvWrpR6TJZN9HOG0ecFwOl2N9tV99Zbr6x43KzxUuDUxAW4xAMq1Fc+g7DIWPmA2zbzE595wXFEKQGLcPXexEC2ycGz5yb1eevHgocfQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ByGqIq8/; arc=none smtp.client-ip=209.85.216.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ByGqIq8/"
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-38dc69c74b8so5982856a91.0
        for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2026 08:24:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784301894; x=1784906694; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=FJVdc1kiVvVGnfbOizavZ8Ol26pZFn/sLDtAlJRqRqI=;
        b=ByGqIq8/Pp0L4Yp954BClegYk782jXFl0PGTbR12OnFNj3ZrZZi62AMJvDrwnxyfSG
         EPFA8Mn1qaQjpTVxKJUhgwg09lTmFN09AAQV82XeZWiIM6ZBaMGDp5qMGdnpdCjCtFNR
         4q3AoI20R4RBmBshOF7I8c3kIcBr/bVc62aTUR6RxoTO22QNi/4s6iWCtND/jIGAlMze
         jtADuk6MU/HmTkPTHfQh85z5RC9ZQDRBPLeSgV0jE5bmxmRBLK/vcL26+opqQARSm3hw
         TgAZpHPHWVWNRSHqFmUSeXPT8pjg8dSQ1djYvU84QznHSG3L3gf1/ZSW0ep1JbHWR+eu
         nh6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784301894; x=1784906694;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FJVdc1kiVvVGnfbOizavZ8Ol26pZFn/sLDtAlJRqRqI=;
        b=a2QTAdCgR3Sctgnn7d59SDLcESHdFkanBI48KXNx/lldFVjpOieR1OWQP00AyGE3TI
         /gK5E3YocLHKl/YQHv1haqWT50LobjIohAnTjzcUZ9V25IMCpP4xjfL22/31zWDFYgnF
         F0nzbuLy1iR8YOBbmHk57ksvVj0QYcE7YOS4PMeAaQtAucLwYMj4QWOItKtLgb9FIQ7i
         FFdPymgQFzn16YG3EtYBcvJJqYC//ecV+OMOtKFu0QoyzcXgrwW5EYCBVFDY33y29q2N
         5vyXSy7EHbjm0saU+NM3PKLB9xxpRK0Lryi9Rf0lf57jqArXs0gtGhRD4Cmtbb6X9u/d
         X0Eg==
X-Gm-Message-State: AOJu0YyVgJ/u3D9vnNimJcSSufMaHxhJFf83cHFT0O0ERN7lD4DogfHn
	4MJWSqOWCE7aMqnpLGpPCoJc/MJIXPfx3hC7CYfcRXPNgKv1vAQPPJu6
X-Gm-Gg: AfdE7cmsJ/c/DN8J4cVspQlRrZR1EjewSBoXgUtEZaYdclQERB0VjmD6c0/iCOv4Q4f
	n6n4qJIFIvL1WRYgIj6sjSlEGBxBnqo4zNbYTeib8eAKaFm5MSu9R45rSSi9Lx1vALvyz3jeZhu
	MDRamNmEpwK5+zbUOjUZbC60lwqpFwbBeWBEh+MzTypvKKRdSalnM+EhZy0p24dbgCQ1KdjzFhK
	nBVsGcOQkhykf0dtZtKdKa2OetZFa2IfxiLKhsBIRz+z3JoKWmxdRJF3Jh/RCP60DWMsLsVFrBo
	auqLWzz4xmrgDWEti9+vuVJZHl2dx77m7LPR7b3zyHuk1xoOhV8L47JzP0IxuWzriFKhEdvTPWU
	xa990N2tNejMLq42oFbfNEb/vjW6Yu822RSSwC7imS+3H3PPitscRKV453a6WxQI9KdoHMhEkan
	rmpBReug==
X-Received: by 2002:a17:90b:224e:b0:37f:9ce0:af36 with SMTP id 98e67ed59e1d1-38e4b5a823bmr3108631a91.33.1784301893953;
        Fri, 17 Jul 2026 08:24:53 -0700 (PDT)
Received: from embed-PC ([2406:b400:d4:bfd7:14c7:7a3a:e3a9:7bf1])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3142a1ddeb6sm10026606eec.20.2026.07.17.08.24.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2026 08:24:53 -0700 (PDT)
Date: Fri, 17 Jul 2026 20:54:46 +0530
From: Abhishek Tamboli <abhishektamboli9@gmail.com>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wifi: rtw89: 8852au: Add support for Mercusys MA72XH
Message-ID: <alpJPj6m5rjIBFNf@embed-PC>
References: <20260710030055.57438-1-abhishektamboli9@gmail.com>
 <9bfdb983981d4bb98a4692ac6f1711f6@realtek.com>
 <8fb9ced500144618b7f43e54c12a25ff@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8fb9ced500144618b7f43e54c12a25ff@realtek.com>

On Wed, Jul 15, 2026 at 09:16:09AM +0000, Ping-Ke Shih wrote:
> I seems that my Windows desktop can't access this link, but
> Ubuntu is fine. I have not idea why. 
> 
> Anyway, the reporter is still not confirmed if this patch works.
> Can you post the update here when getting acked?
Sure, I will update here.

And sorry for the late reply.

Abhishek
