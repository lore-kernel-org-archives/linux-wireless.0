Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C5754028C4
	for <linux-wireless@vger.kernel.org>; Tue, 15 Sep 2026 17:26:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789493196; cv=none; b=NoTuHhGku3fmtbVWClrUGxtHb7k4TEEP1Nx4CshP7iP1qzA5wltbSGKN58f2jErZ9HSzFyWdKvE2eT1b7du8VwAQ0ooRPDZgNJDou8bkOMBgce5RqLLbyym5L+EoJe+ER5E/GGjo+q27P2M262Ku2q/HSOFmgE0O9tFK3KpOb0U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789493196; c=relaxed/simple;
	bh=8UbkferCh4G7xJ08bKzrNxvUDkn0u7D9hP2PlhUAMfE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=tYAoBLPUoWl8j0uI0c/7d+e+zOKHx8TDbZJtDaNdNNNOa4XdnMZckx9i59783bvzH2VWL+K/Bbh7tT2wRXDkc/JFF0wxN8nh91qTvo+OlUxiufJp5rLH92tt5/9QOzm/XhFzIeZgBji7g+MlQb1PIvx19coaitPu8Q/n2W0go3M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org; spf=pass smtp.mailfrom=chromium.org; dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b=K2Joys22; arc=none smtp.client-ip=74.125.227.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=chromium.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=chromium.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="K2Joys22"
Received: by mail-pj2-f12.google.com with SMTP id 98e67ed59e1d1-396ccd4f99cso7142a91.0
        for <linux-wireless@vger.kernel.org>; Tue, 15 Sep 2026 10:26:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1789493193; x=1790097993; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=IqiqAKtP9jwo6b7c6fPqWn0LoPHF2A3cHgQdurIrJGg=;
        b=K2Joys22+UG4d7VH2+S+pQp0xPmLgm1sHebBAUEYFzMjNWcKDkVQABsguAB0fzA3qQ
         6EhPY0CZtm+dY9UpNsFrCiCsQ8kcBK4HOehdHLnX4nXzFXn6Zv3clMXcKnvURmijhyIh
         5CZ6MEVUhIafM6peLLkFezF1hTi5czS2byymk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789493193; x=1790097993;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IqiqAKtP9jwo6b7c6fPqWn0LoPHF2A3cHgQdurIrJGg=;
        b=GhuEEmrQYbjiiXshl62tVRizd2+Wn4FHPEpD+QSj4F3x9vvkuzfVbjnzYP/py03Ixp
         PFrtjmNfXGjx1w/VNsTwgepS0xMuuLKDtkZMLcgdaE5X58BJHPbmhhbGTNtQqvIFx0ZX
         H/2SpUgXq8Rp2psE5vRmn3aVhFRYPcUSINKhlRjhgJwCShTwBjpZjKMjEHxEQVLWxC+p
         tJMbiH2IA6xz02AQcSCsXsutJAWhfB7QUVrx6iv9QWscTgGjnZvJWaEbvDXxGgVnbhuC
         bF67xEOpiqSf5GSO4BVhhCRhpHVlkUOiDimKKuDRLOsgBx3xIHlp/9TDfmJHxMaAYbH4
         ZCvw==
X-Forwarded-Encrypted: i=1; AKwUvBys72tHVfiz7oZPDTeRDVlwpt4cxEdpsGS0mbhTp3QIyu6wQdGLpGNbhurYpU8jaV1EwAT+h4nJyrW+6ZM3bA==@vger.kernel.org
X-Gm-Message-State: AFuF++kNBoe1ZWxVeLLBFEypoxM64JIyuSIBKJ2idHK+eC9XFFnovmd8
	7OWBGAa4Ke9sLfnFlu5mua8F2D8MX6bCCeFcNMn5O5Fyag3GRJkXMVpgS+It2lQ+vQ==
X-Gm-Gg: AYBFou3iB4UGjQDFrODkSp7ziKlzFITF/PSey+foEDqlmMDhpeVJ9eeK08vevYuHzi2
	2w02fMMM9WoRDfrOfT68/tengKF95jsrKbgiFn2KLYCuzdHmEezxjfwgf3TaK9miayGDlMeAduy
	f9sqF+/vqNwGlxu7k/pGtuKmeUi/BYbDhZMikUwWYoDQFx4N+ZsoL/vWYXzLpyTwPZBjBTwgDdD
	7SfeWJHv5JZtDGhBPHLCmlnRPGWdc9VVngRTsbzVz6sSVdWqbUcfmMBnXQXYokV0jF5uvT9eV5m
	+H3AI9T0yLuweBfcnQ/UIjAbaR/U/IqfEAay15TTmIAeQbT/JccarZgmKGdHPN1fUDBuJv0yqI2
	F9uB6bvtKgdDLXvGvwcO7k4aLXmOWt7irwXX8MDt18ZhXeAtY0renwY4tU1zgwXM8cFhdnm0LK3
	myOE7FDHmJ+Te1yg8QEyyy3btwykyRgYTVPOq9icolE3LXQ9CSHNDX9nkhizeUmPZOiCr+fsMzQ
	eIhKGf8SUcyb5y1RelbC2DyrqsGxv0Ubw8IZA==
X-Received: by 2002:a17:90b:17cd:b0:39d:e75d:f33 with SMTP id 98e67ed59e1d1-39e110961c1mr3185168a91.19.1789493193520;
        Tue, 15 Sep 2026 10:26:33 -0700 (PDT)
Received: from localhost ([2a00:79e0:2e7c:8:60c4:eed3:a48a:b9f4])
        by smtp.gmail.com with UTF8SMTPSA id 98e67ed59e1d1-39dfdd0ba9bsm6560457a91.7.2026.09.15.10.26.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 15 Sep 2026 10:26:32 -0700 (PDT)
Date: Tue, 15 Sep 2026 10:26:31 -0700
From: Brian Norris <briannorris@chromium.org>
To: Albert Esteve <aesteve@redhat.com>
Cc: Jeff Johnson <jjohnson@kernel.org>, Kalle Valo <kvalo@kernel.org>,
	Bjorn Andersson <andersson@kernel.org>,
	Govind Singh <govinds@codeaurora.org>,
	Niklas Cassel <niklas.cassel@linaro.org>,
	linux-wireless@vger.kernel.org, ath10k@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ath10k: clear QMI if failed during init
Message-ID: <aql_xwEy5POcVmyU@google.com>
References: <20260914-fix-ath10k-dangling-v1-1-15c5089682b1@redhat.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260914-fix-ath10k-dangling-v1-1-15c5089682b1@redhat.com>

On Mon, Sep 14, 2026 at 03:05:19PM +0200, Albert Esteve wrote:
> A failed ath10k_qmi_init() left a dangling
> pointer (ar_snoc->qmi) in the cleanup path.
> Clear the pointer on the way out for hygiene
> and consistency with deinit().
> 
> Fixes: ba94c753ccb4 ("ath10k: add QMI message handshake for wcn3990 client")

It's all going away (probe failure / removal) if we get here anyway, so
this hardly qualifies as a "fix". In fact, in a cursory check of the
driver, it seems the NULL-ability of the ar_snoc->qmi field is totally
irrelevant to this driver -- it never is actually checked.

I suppose you can still call it "hygiene" though, and it's probably
reasonable to do the same here as we do in deinit().

> Signed-off-by: Albert Esteve <aesteve@redhat.com>

Reviewed-by: Brian Norris <briannorris@chromium.org>

> ---
>  drivers/net/wireless/ath/ath10k/qmi.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/net/wireless/ath/ath10k/qmi.c b/drivers/net/wireless/ath/ath10k/qmi.c
> index 0d74548a5f34..08a64f737fb4 100644
> --- a/drivers/net/wireless/ath/ath10k/qmi.c
> +++ b/drivers/net/wireless/ath/ath10k/qmi.c
> @@ -1128,6 +1128,7 @@ int ath10k_qmi_init(struct ath10k *ar, u32 msa_size)
>  
>  err:
>  	kfree(qmi);
> +	ar_snoc->qmi = NULL;
>  	return ret;
>  }
>  
> 
> ---
> base-commit: bc35965f6940a9bf834d54187b6088b8eb09206d
> change-id: 20260914-fix-ath10k-dangling-15676d427cbb
> 
> Best regards,
> -- 
> Albert Esteve <aesteve@redhat.com>
> 
