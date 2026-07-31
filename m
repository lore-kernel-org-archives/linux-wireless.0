Received: from mail-ua1-f54.google.com (mail-ua1-f54.google.com [209.85.222.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3D961A5B9D
	for <linux-wireless@vger.kernel.org>; Fri, 31 Jul 2026 00:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785456821; cv=pass; b=A9a6eOHkESG1baCgXxMAooG4F9VPocAWLFegQvqzC5HOAys3uwVu4WnB9XCuCuPVJH+v1CZq/S3CJ2lzyH7UZU4d/M6uWS/PBXNEX5xkOLslo2x3tGtdoWkEITiyuhDU753ecsPhqT3kBxkE+T+oAJ7i8JaOl2xjppqgX+FjIIo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785456821; c=relaxed/simple;
	bh=1ho3ErKIDG30cEwxUHtQjuJSbMIvEvEvT3BpBWfsVRc=;
	h=MIME-Version:From:In-reply-to:References:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TgUGoF42PnP8Qdcr9YvyUmcLrwFqGoJd5tBTLuz9EIapYaDRcPqG6oNjMcrwWPYSY5FBMbEB28iRw/PXNpnGPtmtKkEzSIFZiaDf4QZByXQZqFAW+vvZVO/wc9bF3BUgO2roh3MMLzN+Fw7ZAuxRHQl3rdT617WuFb5NMnNJc9A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com; spf=pass smtp.mailfrom=morsemicro.com; dkim=pass (2048-bit key) header.d=morsemicro-com.20251104.gappssmtp.com header.i=@morsemicro-com.20251104.gappssmtp.com header.b=GXp3JDlY; arc=pass smtp.client-ip=209.85.222.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=morsemicro-com.20251104.gappssmtp.com header.i=@morsemicro-com.20251104.gappssmtp.com header.b="GXp3JDlY"
Received: by mail-ua1-f54.google.com with SMTP id a1e0cc1a2514c-96935063700so202314241.0
        for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 17:13:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785456818; cv=none;
        d=google.com; s=arc-20260327;
        b=O3AV/ioDvwIJC2jr5S9FdxiG2gLvmBeri8675zW6phZ/8B6+ZAjcSXenZFmy+oarNb
         qi1Blh3+ORm/2Cm4EgGD8QjBbf6uALh6gbqqffCy4KVw8b2degjkpQfDGXgKLw5LmSLX
         /qAZPOugTn/xCLTg+uHNejbRCxxhLVSVs8cmwQMUMmiatOU4xep71TIs8qTNys6o2VTY
         cVU2VopF+0lgZ/B6uWuBC+acOFGh0gu+a/1J3rpcNftLfv0EHfGt3udperExNDusIaMs
         OiNa9CVAU5CFrFSDUGdjzyriUGlU5cVJejSl3CiSqZYFKMc5FN3O71C1qVVE3jiJZ3rv
         FCmQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:user-agent:references:in-reply-to
         :from:mime-version:dkim-signature;
        bh=1ho3ErKIDG30cEwxUHtQjuJSbMIvEvEvT3BpBWfsVRc=;
        fh=O1/3w3YCGN+d49iagL6DQC8X9KqrOsESVRBSa2Av710=;
        b=NjHkDVVrJhLb48bp8kMfd9OXv2o9kcbsWYmq/nXfyU/Xf+aiRgHwW3WVVherc9DAJQ
         01rZ1AvG3klCFOTPnmKJcmGh6Q9alozcq29EVHlRZwEkMHy0Y6MXUyyhbYGDmb8GiygR
         xCnEBe/pqAOcpxmSaOpI1cBxA6ZE5rppryws4Bi7trkiP0/ChwtI32WpWbbpIkYprcCG
         Ki1MqSdmcGuvAzJS+ANTiNwp94K+9bb8gkb0aYGLCYx5RWeS0U49t39+9Sv6MZzMLy7t
         VdgmyhrGB+duawvRre0bmSo1WPhU26A+XCioAJdjAL76/2mrEvZhduYIG0+Ho5t7iWLY
         0Ltg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=morsemicro-com.20251104.gappssmtp.com; s=20251104; t=1785456818; x=1786061618; darn=vger.kernel.org;
        h=content-type:cc:to:subject:message-id:date:user-agent:references
         :in-reply-to:from:mime-version:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=1ho3ErKIDG30cEwxUHtQjuJSbMIvEvEvT3BpBWfsVRc=;
        b=GXp3JDlYGbj7sapokSTtjnkZzFkH8ZkOkLsbH6GR2LGrB0sRQn5GRoOFEnCUmsE8K9
         bI3/A3d8d7cpE6Z8mOl0p+07pWdGFX8twx6MZn4fkovJQCqvz2/wO0cLTdGpnClBaEUs
         niG4ezQx4c1goTlC0dQKOx1Vf6nI67YDCt/GL+JGbHjZDjQNlif9UmIUBRriQP+zVvxK
         vk7Hdwd/wx1DH+SsRDpUH4G+h2pKPdX5Xujk4854c7V6jN5hgGXrPTUETf7M5n9sFVOC
         lW6CYNQb4GXw/YMk1mGRKW0HRvkFJFGwD6Wp7HJCFdw4r8GllA5fkrX5Pk+56BhbimmG
         vZnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785456818; x=1786061618;
        h=content-type:cc:to:subject:message-id:date:user-agent:references
         :in-reply-to:from:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=1ho3ErKIDG30cEwxUHtQjuJSbMIvEvEvT3BpBWfsVRc=;
        b=LR3vYSwpRtT7ggI/CwdC/pm65OVGmoZLRj2+nfmdcd2x78Z6aZrJKv2DZeeiu74eEQ
         2UvEkObZmhGsH7DStT3gUBGpf161fHF+19EsfSsBcAn5OYF9GMd1iGyhc+HT+fOVH5x/
         cqJ3eaft14llBPXI+UW2lI9ElO1B5EvLMHqi/dnbO1FDHnChH+6YncNtlxMjrP/wiZaV
         2BGXJgxKiHPlTlB7Qo3FB+x4+uT9kHdoXXgCGZCv+pndt5vU/RlgxwMb01hEW44N2ykc
         TQO9pw3qPor+btZcS7o1A6kNlAdToXDzU6fEK2WHZrvVFeZQ46g62COVGykVB1j62Oje
         yLtw==
X-Forwarded-Encrypted: i=1; AHgh+Rpl4Y4LtdsQWFogk6rAWX9TFji1/xdwER/slTD6JPUtSsbyrdVK14qpr8KUVR/iEJigI2o2X72AYzLULR2g0A==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxh+HYFyiQMbdOCrAyKb07Ow+fb+mhX6o2eYUHv1I2Lt6rUScqu
	0Hp/PHQjxeDKQyqgKzHofxd0lzwS+9pU8M8xBhi5ys0C2p3y252xG/opMeArJ+P2tDFBHiEQ0PI
	v73nXAXKxWnRjc0Kxj/rNcTA8Mxa3uSD2n5h4unxzkGkXea4Gl11ru1D4sA==
X-Gm-Gg: AR+sD11q3qkIEIZCoqdo4HbUvKYOPyV+NuOUMHjdB7bg5858aBXGms3b1VVFqaKfYQ9
	5UM6Hsh0avuvNeW42Du//Sqvbp0sa7jjWEQNOHo9hLbDj6Yx9tvjkeNJ4PyWtFbuIIt0as4U3fD
	mZK+CzL5L6A540ymZfrSCcMTnVoe1sHVV5r788ySsAYH1th21+AI0Pa6L+D5SJaRsHbdjJe2WU+
	sdg6w+3TmcbVhslnMBUQlmsz2NplW06ys6//FwH+KNyEUFimRzjzGkI1P5xpHjNkEHnZ/G9dFhF
	xulNep74t37f+64ofp/OzaB/W+aeMOLER7J1r93QlhY=
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6102:5e8b:b0:737:172e:e4f6 with SMTP id
 ada2fe7eead31-7574fa3fbe1mr1801565137.16.1785456817782; Thu, 30 Jul 2026
 17:13:37 -0700 (PDT)
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 30 Jul 2026 17:13:36 -0700
Received: from 753933720722 named unknown by gmailapi.google.com with
 HTTPREST; Thu, 30 Jul 2026 17:13:36 -0700
From: Dan Callaghan <dan.callaghan@morsemicro.com>
In-reply-to: <20260723113927.2370301-1-lilinmao@kylinos.cn>
References: <20260723092357.2362744-1-lilinmao@kylinos.cn> <20260723113927.2370301-1-lilinmao@kylinos.cn>
User-Agent: Sup/1.4-git-c20d8fe5
Date: Thu, 30 Jul 2026 17:13:36 -0700
X-Gm-Features: AUfX_mwzmzjHnUukxOrkUJ2WQOufxVaF7avvzYKRk-COjTPpv3lf48PMtDILzbs
Message-ID: <CACim9t4tHz57KSY7iJgCQEU=BEYB23GBnpxjaa1n43aLc5E_Tg@mail.gmail.com>
Subject: Re: [PATCH v2] wifi: mm81x: prevent timers from outliving teardown
To: Linmao Li <lilinmao@kylinos.cn>
Cc: Lachlan Hodges <lachlan.hodges@morsemicro.com>, Arien Judge <arien.judge@morsemicro.com>, 
	linux-wireless <linux-wireless@vger.kernel.org>, 
	linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Excerpts from Linmao Li's message of 2026-07-23 19:39:27 +0800:
> The three timer teardown paths call timer_delete_sync_try() and ignore
> its return value. If a callback is running on another CPU it returns -1
> without waiting, and it does not prevent a later rearm even when it does
> deactivate a pending timer. mm81x_skbq_tx_complete() can rearm the
> stale-status timer, and the rc and yaps callbacks queue work that rearms
> their timers. Teardown can therefore continue with a callback still
> running or the timer rearmed, so it fires after the associated state has
> been freed.
>
> Use timer_shutdown_sync() for these permanent teardowns: it waits for an
> in-flight callback and prevents any future rearm. In mm81x_rc_deinit()
> shut the timer down before cancel_work_sync() so the work can no longer
> recreate the timer/work cycle.
>
> Fixes: b1906cea00b0 ("wifi: mm81x: add mm81x Wi-Fi HaLow driver")
> Signed-off-by: Linmao Li <lilinmao@kylinos.cn>

Reviewed-by: Dan Callaghan <dan.callaghan@morsemicro.com>
