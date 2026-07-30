Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F4E6382283
	for <linux-wireless@vger.kernel.org>; Thu, 30 Jul 2026 03:25:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785381910; cv=none; b=hQT1aovxeV4DmD2hMkt/jJj3zUbSXQcAwWGwX0WvKSfXblgsW4VGbbX4GQmd33odCF+qiLpE0QFaTDNRyMzWxlFz8p9XaDxI83Vik1+Yy6p+seom9eFwrGfFv84uBAVFZdXMlzlIG+3KTg1sLvrdZB3Ih6JTnR7fHfHu2f6Cs4I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785381910; c=relaxed/simple;
	bh=moxFj4LK5eQ0iKGvXBlohU775jHJeBxgyTnS3/nFR50=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LlVgyI14UcD0Ed9k1/XCJEaWx5hRt3k/0ybMyFubkiZ+Z8fqqLeXUWaSIJdWiAuxabPk8AjT7xkJ8yjUzx6F46+iVbDd28JtbyWrS925gbVjPnGeWVQyUXe/czn5WeSsuclumhdGDM/5wIkCp9iP8PHlA1th2XMxATd+en5km1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=kYm/gNJ3; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="kYm/gNJ3"
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-84830c774a0so1884856b3a.1
        for <linux-wireless@vger.kernel.org>; Wed, 29 Jul 2026 20:25:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785381908; x=1785986708; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=+MFNjhf4fLcryxrPI0kEcRFU59dAVTf4ieRyCYark9c=;
        b=kYm/gNJ3YBFXhzUhqCpvyn703+TDZ92HQ2AJMk4F2SN2rE5uFf60cVHBQvdJgI5hdl
         zkSCYVjdqCrQOYJL7p9q90JK99t47jigRGP6C0VQi1cfhvbkT6EP/HzgTlx7tyWHR0D+
         5nod/Xfc/4AIB57Al0qggb7dI63bMYM7UysRcOxzHjP8ewv41VPI4iogqV6B3znWMr9E
         PA5E5trwIXJpVIl8/xTIl6ZDYlmhtbDXYJMhZuxXE1HzBgr3w/S0Oh+ZcJaKz8XRI9kd
         ilkV0qDLHlFCpfAbPT2GzIbpqvPe0mDXq7I/QA3AnoJvFgWF+2q4xlTOzXFFWvghosYX
         wVuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785381908; x=1785986708;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+MFNjhf4fLcryxrPI0kEcRFU59dAVTf4ieRyCYark9c=;
        b=lXFhnHL72jjp1YPa2j3mw063+VP4GcAVj+8BJwCVsCFRuy+xNqaiYqJSzYb4gjlWV/
         IQ6ZPZobnUELlrWQHcwTzLQoW+mQNLcHxtWIBBmXrThYEgBGBmpqoysh2jXIWsFTkOUe
         KFM79FX69gwj2RNPHHEc39a9acHboYO33uQ64GwMRKbrKbkKuWkoSKiRVfijzkMZ9eHO
         7hk9eV/KUWsjAsol6CIqi8paIZTMJraIo71oXvNKTINqnTe5OWjRGuRYsF5wGkxvWbQi
         N7BB1fxUAldi8oG6D/NSAFdvA4fUVVH1jsC1DPV7EpyYsU269Ue7rFntwFGZtV+Unvpg
         JQJA==
X-Gm-Message-State: AOJu0YwESqGlMTqHCJiIMT7/Pwo70OQTsbKSY8LQLfXm3akF2m3whdWs
	MNJ0ivA+fcXuLu8sNgw/qbAw1oxSIcs3k7LohpurAzCUXJ+HPTOZdYFF
X-Gm-Gg: AR+sD12O04lM/NSYgmD+sM09UV+c0k6QR3ezWCc7CAn7Tw5Zw6wiQHKFVPsufYEU/k/
	YNJcmiyTQKRVFdUuSb7doISTi7MCYrIdef/lltxgAvKwQmgc2yow9KvbFPTArZL9emfGlYXvHjZ
	r0woOjp/Q7Or3G/NyNJ2dnyzIZh7WoSWgok09AAyWvYv97O60CGtR2quBG/saWE0hmM7D57f2pL
	L7gmjhIf4mzlhpndokd1MXmla0WJ4chJENwhtnrKkMveWdAUKKHE1TE5Xm3sBdIvkav2+w2ISr8
	xsQ4ZflqbrPerF8gCcsJX1O9wf/XHz4vjXhwwxa9aS0+1P7C03lCYAjakEVq/cUFVhEjd7x2MTa
	v7XcVPwG8JQ2sMOX86HsoD7ca0qMWoHZEFHjepDlP27bWmfYaOqDnHS4x4JBkaidJ+rvKPD9cMz
	BY3L7j9hs4OnhErik/F6hUYxFsQ3xF4uN9LsWNJdWrXpndGMHMTpguMZSlqb8TjNto8Hj6IkvND
	a56yOEpdQtzxaWxcAiHTaXVe1M7J/5cClUj2nom7u9fpKARDWxh7/M=
X-Received: by 2002:a05:6a00:e13:b0:848:438d:3665 with SMTP id d2e1a72fcca58-84ebc3ddc5dmr956581b3a.41.1785381908265;
        Wed, 29 Jul 2026 20:25:08 -0700 (PDT)
Received: from nxpwireless-Inspiron-14-Plus-7440 (61-228-203-195.dynamic-ip.hinet.net. [61.228.203.195])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84e9fe238ffsm2272593b3a.12.2026.07.29.20.25.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 20:25:07 -0700 (PDT)
From: Jeff Chen <chunfan.chen@gmail.com>
X-Google-Original-From: Jeff Chen <jeff.chen_1@nxp.com>
Date: Thu, 30 Jul 2026 11:25:00 +0800
To: Rosen Penev <rosenp@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Francesco Dolcini <francesco@dolcini.it>,
	Johannes Berg <johannes@sipsolutions.net>,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	open list <linux-kernel@vger.kernel.org>,
	"open list:KERNEL HARDENING (not covered by other areas):Keyword:b__counted_by(_le|_be|_ptr)?b" <linux-hardening@vger.kernel.org>
Subject: Re: [PATCHv2 wireless-next] wifi: nxpwifi: embed rx_reorder_ptr
Message-ID: <amrEDJZsZ7AwZ1dr@nxpwireless-Inspiron-14-Plus-7440>
References: <20260729183715.691287-1-rosenp@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260729183715.691287-1-rosenp@gmail.com>

On Wed, Jul 29, 2026 at 11:37:15 AM -0700, Rosen Penev wrote:
> rx_reorder_ptr is a dynamically allocated array which is done near the
> main struct allocation. Combine the two to avoid freeing separately.
> 
> Also fix the type to what it actually is. void is normally used to avoid
> casting but there's no need here.
> 
> Signed-off-by: Rosen Penev <rosenp@gmail.com>
> ---
>  v2: fix unused variable error
>  .../net/wireless/nxp/nxpwifi/11n_rxreorder.c  | 23 +++++--------------
>  drivers/net/wireless/nxp/nxpwifi/main.h       |  2 +-
>  2 files changed, 7 insertions(+), 18 deletions(-)
> 

Thanks for the patch. 

Tested on nxpwifi with iw612 chipset, running iperf3 stability tests.

Tested-by: Jeff Chen <jeff.chen_1@nxp.com>
Reviewed-by: Jeff Chen <jeff.chen_1@nxp.com>
