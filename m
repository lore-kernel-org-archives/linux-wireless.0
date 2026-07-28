Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A8BB41A791
	for <linux-wireless@vger.kernel.org>; Tue, 28 Jul 2026 09:40:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785231606; cv=none; b=Ffn22+hqvb12dC7OumvCj7m2lsiHNGol0gRnJ6HYC78g64LHuqtPhqau6VxIVz2Joe/iwIIoafhtZ68bjB8EDiRs0nYlE9sPaBPWyfdT9TKGKxXSI2id7YHEV/Xn6xU0NHnnPXZ7xvB8AxQxiX+4DdiUzyMbhVzuhF3hKzCsekw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785231606; c=relaxed/simple;
	bh=RXCi80jJJoeuiTYlNE5Vyy/b5imzD817AWX8SLHt5ag=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=KgArdGX+MMKnIsIVdpy2NIOO6birKs3ZQRbyhiaLiA4AYHW6ldW/8br+omcebRyJryqPdZC9sHUwWKp4Y/W6ws3CIdfQ84Z/jxbuybFNKMLKLCoJJQDXVXV4+EX9Cn6K0M5UM6OFYOEyvmU6GqNvlqoVtqIB/dTbe0DuF7spD6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=hvbZsnVX; arc=none smtp.client-ip=209.85.215.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="hvbZsnVX"
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-c9ef3e1337fso2501804a12.2
        for <linux-wireless@vger.kernel.org>; Tue, 28 Jul 2026 02:40:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785231605; x=1785836405; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=hK5fMzgWYkoFa9TR120mfcDFY/khLZ9IPeK5ODLUBiE=;
        b=hvbZsnVX5J3ttTe7r2oSG6+7m8tYw85La+texAnlV+TJs1kYGTU8Zw2HFcMYCLuVSp
         sKhmw8COywGecMh+5ZffZutV95agPgU0PyKCf3jSTbgcYclwRR/+EYEOKJlEly5H/ear
         J4IMASIPa3OU+hR+MNaAuX3abl9MMRz/bgBlZmhm3vIRHfJe6i3c2kxE/wVHt/1cyveq
         74MKs05iAkbPH1M+W86Htqf9sz/+EXb2nXYjmT2NCl0OG+8UCtSqfBmHKvC3MJWYdhsI
         Vq80nY+5C2UlNzE3sQ08ZaeQQfuP/P8DXymIeU+JkPb43sGHGmUXrGg+ATxU+KzP1zfQ
         yIZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785231605; x=1785836405;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hK5fMzgWYkoFa9TR120mfcDFY/khLZ9IPeK5ODLUBiE=;
        b=hYc5TlDB2Ucm5JNh7Rxg1SI/s1SPLqiluXbynfR/WCqW7riFFic0edetevG7a0gFPv
         HARWUwtDN1lJqoAs0pjWYqv+JN5eE9exWd5gmZUxoe9bCb0y8buKB7WuZ1cxRCCUt5fx
         0ch8XFCLV8mSUttwNIq4P4lFdKBrakBob/oiI+aR7p21G/0nMENkN3E3Fqg/RgF7SDI1
         dDsxWtDeg1i27RIY1lq79XSBBMVDWsZEWOsPGO3Td5xsrkSZKXWGJgdwgWKOFlzrP9/x
         hSuMqkKBNkn3XhcRNRpStnMmYNZ1LG+ZQmEJWVy+L2v9nhEQQo1ADHeg7nVBxwiehr3r
         j0zQ==
X-Gm-Message-State: AOJu0Yw/E4l9s0wck5sXUN0DZHa7Mb9WzdZZAYh/lzjbU4kzCiPkAs3g
	ZcBGdyr3+wf4OTq/ycVGBz8AKRHAkUruxe0zzV/YGa9phytKlI6V0qwV
X-Gm-Gg: AR+sD13qEEUi8G18jkdfB3GNMZ1bKorn9VUBA5Uh00lU/5k5/n43WC1gW5kc+CmpoWF
	o1sio6OPj59gY8pq7SLxtYBApCeeBIoSoLyxE9jmdpPFr9QM7/L4bIncZTLaHn4YDsdefxgIkTm
	ZkotiBIt2dnF9DABRQAHwvGs61ra//lEsIzdK7rRis/egYlXiR6u99fbEwuYsOQhNcjKeMCXmJQ
	931RZ32gVFqHkjrAbBR73nAbJblq5BfZvfTKmherPImE9w6SX+YLvo/YgS4pLobmIt/CJ27tTQc
	qsETQT1IB/VjBmYIqoQeihC12rK6CCp78PFGRktCLw71RBNdjZkg3NSgOhyzZ/xPRD/DP15NdwT
	VwEWRe9vScRnrFNV7IE4RT35e3x2eAUGJ952FCRLsaoR7xGWgRhp+m7s4+gauoFJ3PRsBtB29We
	8xGW0bekW1/mo70pnJo2Xh95leaRanLRnCQjf1X03so5W0hKs61DQ9DontZRqNiUvBc7aUUKNBN
	ms/77o=
X-Received: by 2002:a05:6a20:4324:b0:3b4:669c:ee32 with SMTP id adf61e73a8af0-3c8ba5bab93mr2125489637.37.1785231604622;
        Tue, 28 Jul 2026 02:40:04 -0700 (PDT)
Received: from nxpwireless-Inspiron-14-Plus-7440 (61-228-203-195.dynamic-ip.hinet.net. [61.228.203.195])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cbbb660deeasm4328676a12.3.2026.07.28.02.40.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jul 2026 02:40:04 -0700 (PDT)
From: Jeff Chen <chunfan.chen@gmail.com>
X-Google-Original-From: Jeff Chen <jeff.chen_1@nxp.com>
Date: Tue, 28 Jul 2026 17:39:58 +0800
To: Rosen Penev <rosenp@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	Francesco Dolcini <francesco@dolcini.it>,
	Johannes Berg <johannes@sipsolutions.net>,
	Kees Cook <kees@kernel.org>,
	"Gustavo A. R. Silva" <gustavoars@kernel.org>,
	open list <linux-kernel@vger.kernel.org>,
	"open list:KERNEL HARDENING (not covered by other areas):Keyword:b__counted_by(_le|_be|_ptr)?b" <linux-hardening@vger.kernel.org>
Subject: Re: [PATCH wireless-next] wifi: nxpwifi: embed rx_reorder_ptr
Message-ID: <amh47u3hQRDO2dAG@nxpwireless-Inspiron-14-Plus-7440>
References: <20260727002916.117754-1-rosenp@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260727002916.117754-1-rosenp@gmail.com>

On Sun, Jul 26, 2026 at 05:29:16 PM -0700, Rosen Penev wrote:
> rx_reorder_ptr is a dynamically allocated array which is done near the
> main struct allocation. Combine the two to avoid freeing separately.
> 
> Also fix the type to what it actually is. void is normally used to avoid
> casting but there's no need here.
> 
> Signed-off-by: Rosen Penev <rosenp@gmail.com>
> ---
>  .../net/wireless/nxp/nxpwifi/11n_rxreorder.c  | 19 +++----------------
>  drivers/net/wireless/nxp/nxpwifi/main.h       |  2 +-
>  2 files changed, 4 insertions(+), 17 deletions(-)
> 
> diff --git a/drivers/net/wireless/nxp/nxpwifi/11n_rxreorder.c b/drivers/net/wireless/nxp/nxpwifi/11n_rxreorder.c
> index c5819f89b08c..b2fd624497a3 100644
> --- a/drivers/net/wireless/nxp/nxpwifi/11n_rxreorder.c
> +++ b/drivers/net/wireless/nxp/nxpwifi/11n_rxreorder.c
> @@ -171,7 +171,6 @@ nxpwifi_del_rx_reorder_entry(struct nxpwifi_private *priv,
>  	list_del_rcu(&tbl->list);
>  	spin_unlock_bh(&priv->rx_reorder_tbl_lock[tid]);
>  

Hi Rosen,

Thanks for the patch.

This patch triggers an unused variable warning since the for-loop was removed:

../drivers/net/wireless/nxp/nxpwifi/11n_rxreorder.c:264:6: warning: unused variable 'i' [-Wunused-variable]
  264 |         int i;
      |             ^
