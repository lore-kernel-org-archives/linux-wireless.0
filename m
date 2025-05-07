Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com [209.85.208.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1549028AB1D;
	Wed,  7 May 2025 15:26:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746631562; cv=none; b=Eaz3bPmW+K9RfR16xEhQluJixnoU06wS6KPqJ6M6Op0qKuMjr31LU8ND6aIKaAZ7+RYFTlLy9Qb4LK0wLva8UNdAoDcDcTW0FAcVX3vxVnBiKMTsjMHh9PFXBwF06Q1ZOsxWFNYfygS0hvbcRb1ZC39cGWy8KS0D09s4uvTrFbQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746631562; c=relaxed/simple;
	bh=m3/2HAo1H3TiNe6hddAepiWX1vfHKRzyl20PPZbSSjo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=kUUyPWoYVzM79c/3QRJDhkMkKaHLlIYpzlSzboi+/uskGtAFcZnE6WgeVr1foY/YIWAjvgZybbWbXJLLy6cDndjN1JBTpVm9kG9SKSFVOt7wvSxRQ1DqFN6jz74zhLRb1TEb5BkCx3vlv3URdfHcB0/Jh/O1IasqbigYhJ5DdSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QYTRWBVk; arc=none smtp.client-ip=209.85.208.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QYTRWBVk"
Received: by mail-lj1-f180.google.com with SMTP id 38308e7fff4ca-30c461a45f8so61988271fa.1;
        Wed, 07 May 2025 08:26:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1746631559; x=1747236359; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=IOsZx4HJytsBLGs3/H+pE3EnVi8A7/Xol6ZLjxEfUrs=;
        b=QYTRWBVk78JeumSCjOC+nUN8DIGWU+0iVGYJeE1o8YSG7hR+mND2hky+JBYVt2xpRt
         bA7xoZD4tXeTrUk8C4DduCz/+24xmuvnvxb03PBcURE2kJ6KUZjdOgzMYIWmcfNgkwSF
         0PkS8VNHM6B2k+Utychzt9VF1pK7KTf21oPf0hjDi1DnealgpxGWqETwZnKlhAu21mIZ
         rXwVyKKXnzV5FbA5F+MpfRwe72zbg5EVn8h3Dml6f9PtnC+Qck5nafVuYBXSw/DqByrk
         gQ/9HlhN7SMIp2aE25pDPpXLtfyuIBeEZDVNtDL51SnO12pqHTAiK+wQQmkHnA9Pb/wE
         EU1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746631559; x=1747236359;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IOsZx4HJytsBLGs3/H+pE3EnVi8A7/Xol6ZLjxEfUrs=;
        b=F3HJUOQaM7eXr6Wn/e9l25TVjaPWJP5XKNz0gX0kayPur0RdTb1WdJnx451nbvg5BC
         /V4qI+uweFTq8xhif4FGIcpzSVJhf4sO6QcfMKHs5Mv10lyVO6Ocl2kNCdmWa97gagst
         1siSG7RA3ROlO/ICDTfdG7O6VY1TJsrCzkFUN0fDjBk3o8Ae/twgCfyf1ATj4v5A8tMc
         R63rj2B722dfjKdZpeMXZe8twWnTzoWvUk5hu10MAtLQ6mZEDjSzquMjK5cZ9RS7FVu5
         tgY5+P56CSsOtLKxeEUGxt4EdcOXXyodVdYAohijvng06osdcb+pWrYoF53UimdMdKaP
         oqfQ==
X-Forwarded-Encrypted: i=1; AJvYcCVdQdzGRizqNvGLBGBv9rMGJIQNXbidR9Q2elnI85F5BqmX7r0rAxqWhEXNL3R7BBvBbna1leWV2xi2XSx7TwY=@vger.kernel.org, AJvYcCWEZ/P5GcwzcmRiKITOeNNU49cur+7QlLLvlmkl6w/J6AmUOtJlxUZ916C/j9utt6EWHUYg9TpN3n78ajE=@vger.kernel.org
X-Gm-Message-State: AOJu0Yw5Ym0zC7nDqdc1zQLgDHGYX+Is3PlDXxzK6TxlZYeLvjU0VTfQ
	NliNw7cAD0yHOLj1xA0sM/4/pVWce1K7F4BKN2PM8Ntbrt9o+5Yo
X-Gm-Gg: ASbGncvRLbqCVsXLUE7bPizggnEDXYURswNdOmzsF6yk6L8jLx96DindDdH0rJ9sPXZ
	rDrVEl1HgqSvniZCHHD/Ovo2XQl7PFcEm4VH3gYm60QpxLswkRXR3VnHSM0OvsGLPbuKQyn/7sf
	RL3CCCQwNgwAfvQP8lXSdPByYeGeRHYj6zX9uoVfFrN/ZuQy90eWZ+B0dbo+wUJeJxMYKpgQFiT
	Wju/fqP7DQKvv6xKBcShrZeWcMVQ6UDSAvKTvRGJ3dTtQ/6de3Q3KkzQ6pUAJnLjHVs1AfNdLDu
	NXDnrwdKNtCt3pD53l0QVRKxHXoeYOHwXO4z
X-Google-Smtp-Source: AGHT+IFytHsvqFYQzujqceKZpiUhUZEVuYpnWaH8GQZ2Mwjl4ZDW1lJsiiSzePyl9w5MeiDeZVxEMw==
X-Received: by 2002:a05:651c:1a0b:b0:308:eabd:2996 with SMTP id 38308e7fff4ca-326ad186e0dmr12529631fa.5.1746631558806;
        Wed, 07 May 2025 08:25:58 -0700 (PDT)
Received: from localhost ([83.149.199.15])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-32029306984sm22697481fa.58.2025.05.07.08.25.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 May 2025 08:25:58 -0700 (PDT)
Date: Wed, 7 May 2025 18:25:57 +0300
From: Fedor Pchelkin <boddah8794@gmail.com>
To: Ping-Ke Shih <pkshih@realtek.com>
Cc: Bernie Huang <phhuang@realtek.com>, 
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Bug report] rtw89: 8852b: IO_PAGE_FAULTs with beacon filter
 feature enabled
Message-ID: <7injzacfmvhrugcovyxkn4elnaxnzg27c26zmcqzrwhottyk7e@ap5ellaozcg4>
References: <uidltsdsuujrczrtzgerhh5cw2tztxktfen6yvztnc7gttzgvk@jccomj7f4gul>
 <148ed65c53be4ef29246d372dd0fef8e@realtek.com>
 <z54thedngt3wnhr5bfer3yg7id2c4uqgw2jjvyausv6p66ys4k@guqol77fpugz>
 <dcf695a6621f43e38a20eb860194191a@realtek.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <dcf695a6621f43e38a20eb860194191a@realtek.com>

On Thu, 17. Apr 01:05, Ping-Ke Shih wrote:
> Fedor Pchelkin <boddah8794@gmail.com> wrote:
> > 
> > On Wed, 16. Apr 00:49, Ping-Ke Shih wrote:
> > > As bisection, can I summarize as below table?
> > >
> > >     d56c261e52           firmware             IO_PAGE_FAULT
> > >    (CQM support)
> > >   ---------------      -----------          -----------------
> > >       o                 0.29.29.7                  yes
> > >       o                 0.29.29.5                  no
> > >       x                 0.29.29.7                  no
> > >       x                 0.29.29.5                  no
> > >
> > > If this table is correct, we will check the beacon filter feature in firmware.
> > >
> > 
> > Yes, it correctly describes the situation. My suspicion currently falls on
> > the beacon filter feature in firmware, too.
> 
> Could you help to test when we have updated firmware?
> 

Hi,

Were you able to reproduce or track down the problem?
