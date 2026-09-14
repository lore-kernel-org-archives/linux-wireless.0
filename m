Received: from mail-pj2-f13.google.com (mail-pj2-f13.google.com [74.125.227.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 115A53F4831
	for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2026 08:19:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789373959; cv=none; b=h9aZLP36flmoiyqB79w3FKw8JGkIByeRv/FQHv0tGTX6zw9EOvU4oUZnCGAW/SuNYj6MCJF26Da0ux9YGi+bJV53rTa+4oGyqFSV/YqaD/NVDCviaTt7jIiLUmx0f5eZR9T94BoBQmG/ERi9xYUs4Oi/8qknBwBfht/QKIxBNpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789373959; c=relaxed/simple;
	bh=hCAZBJhhRP2u77lOKxQO5T4yhqsaUjMYlivSY9/HGgE=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=bSsB36sn9ZhDzMkvSgjyFrzpq80dAvkq0yynXxzrHUn5in+klKJmFBhZzyuWEqGz56CMhKWwDvPiwNoGPsMMNInSg0KreCQX9E4O5qzzt+bh2NFnAkts/FmLy4OZOVZJyadM0FCER14danuk1l6ria5J5G86EK8QZ5Z2KCL8ryc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FMIrVYTq; arc=none smtp.client-ip=74.125.227.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FMIrVYTq"
Received: by mail-pj2-f13.google.com with SMTP id 98e67ed59e1d1-39b2ad83dc6so1870239a91.0
        for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2026 01:19:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789373957; x=1789978757; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=hLvHDynvrNxOy0DrTZpZJULh7McezOs0yqokhrkRfvE=;
        b=FMIrVYTqYyz3hw4XyA/9JYPeEWYX5i9RFH3WCQhE+QJNpjm4gUDCq9aqtbtq46mTEl
         cl11K4l4DLmyVbZlHcSgYbHvkn8wqRk4UtdL1Eo5sJQdKPS+dd2876YHFfw2MKXhmeBB
         3ksM/i8JLmViS2B8jD7ZLJk8fAXXTP7BkRFww3koIqbPnkfa7HxiK8mumgpbpQqUEKAD
         yxODbQpfIi5MPFgA73vpIkFd8tgZdTqFoTuoghJ14NbTFCE5QpsYkNUWT8PlxY1mm2Sk
         Y3Y99onfzipP/yfQ//sUcZjMD7uZmqUrSVBQwwOmcPOJxtQqrLK3vLEM4JcSVxxsrQ/Y
         85uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789373957; x=1789978757;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hLvHDynvrNxOy0DrTZpZJULh7McezOs0yqokhrkRfvE=;
        b=fQBCSx7P1egDoVF+YnLhRP4vbkLpLgQRSObbwa2SOWKNiOr6BlSinstn1o4+4g+rRu
         EKQXRrGGpeygrUtv0x/wE2b0DNgfIjC3Uv3YRI9vhZlYdvtHDoxKMeUnkk9j17Jwdt58
         Va3PEcHk0oxjROmxrcj0UJxWfZi4Oc/HhI2svIRR4dCA6dVvr6Gs4wEw49EopdX1KHRH
         h82NH47RbH/UMApx898r1SzcmETfhlaELLWDS9ixG9V1g9VYhs59/0WLw6Kz66QXR2tL
         +JNsWVuqbtV7NPvnSXXzZcFuzd6ECjlfcaa6LnFDJNWjmMYBLygV5OlmUZccutcrKc9F
         l3ew==
X-Forwarded-Encrypted: i=1; AKwUvBz5DHhbC7NXQltib5Xhl1kUoSG3tLMJ6Bwep6AbjwmItDg7znJD/juwX5jAqDUeNj17uuSSzyVZYVXrIwTo2Q==@vger.kernel.org
X-Gm-Message-State: AFuF++kAGLRjZhmgrYi4UmEEI9NFZJMP8RGj4qx/LKTwjy2l/0Gn20FH
	f0Yry1ZvhiUGq4Ak7/3oQC+Pysoa4LqWqKPGGFjM59v2oPmCuAMSQYzx
X-Gm-Gg: AYBFou3EHIZKmMBxnDC8XWdfPN8ZlXVVLinIZMaJ95/kYYuD7jFUgmh+nWCxxcX/AdP
	F7pwau+uCm0BBQ/1LXKs5XrZI69/6Bfmiu3b8tX7OxLRT7PfWJIu2CFG1oLfaa+4Xh3shx8XOsL
	Mhbg6MwSZUpjL63sPqbZoYAMcklrEx8yEvyyqYzq1I/w0Tn0tzvC44ttILQHu6T9hNV1Gv255cA
	1ARzpcXUm9mIvXp4lTDCAR61thX/gNNxUmdtJ3yLyGgnt8Kvv/sU6NR6ay4Jp6LkG0pksPyue0p
	LuRmisypkihV0Vflk9YWV4hBEuQGnKGS73nYVcVzdo9L3PQkab6YNeNmxOxGC4GBxtU4e6GO1SK
	2b1NCmf1cFA+oHGkY2+4Jo437lNUHjiY4u5bYoxtHMqGDS85dKckWrwTPiA2p5o7KaNOYTpnip2
	tBAnyUIlRM1ow/lsP+dQ8dq1PsBjotl+NpIP62r5yEw4oo1HEQVx7WKX2ccAIghkRt8lg/0wn5V
	uZiuaryFFex6/R7NfuA+VRWjaUmboxdlzNM/nXPmJ1O0KD7uqqTJSRHP6CbHF8twtPU6dh7YW+9
X-Received: by 2002:a17:90a:1c8f:b0:39d:ec24:5ffe with SMTP id 98e67ed59e1d1-39dec2460a2mr2310184a91.9.1789373957212;
        Mon, 14 Sep 2026 01:19:17 -0700 (PDT)
Received: from nxpwireless-Inspiron-14-Plus-7440 (61-228-235-216.dynamic-ip.hinet.net. [61.228.235.216])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39d95092c06sm19955341a91.4.2026.09.14.01.19.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2026 01:19:16 -0700 (PDT)
From: Jeff Chen <chunfan.chen@gmail.com>
X-Google-Original-From: Jeff Chen <jeff.chen_1@nxp.com>
Date: Mon, 14 Sep 2026 16:19:10 +0800
To: Aamir Ahmed <elb12345@hotmail.co.uk>
Cc: Johannes Berg <johannes@sipsolutions.net>, chunfan.chen@gmail.com,
	Francesco Dolcini <francesco@dolcini.it>,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH wireless-next v2] wifi: nxpwifi: validate variable IE
 lengths in beacon parser
Message-ID: <aqet/hLbBlBpj3Xa@nxpwireless-Inspiron-14-Plus-7440>
References: <AS8P251MB00010E2945A1BE91EB5415F7C8BD2@AS8P251MB0001.EURP251.PROD.OUTLOOK.COM>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AS8P251MB00010E2945A1BE91EB5415F7C8BD2@AS8P251MB0001.EURP251.PROD.OUTLOOK.COM>

On Sat, Sep 12, 2026 at 05:20:31 PM +0100, Aamir Ahmed wrote:
>  		case WLAN_EID_OPMODE_NOTIF:
> +			if (total_ie_len < sizeof(*bss_entry->oper_mode))
> +				return -EINVAL;
>  			bss_entry->oper_mode = (void *)current_ptr;
>  			bss_entry->oper_mode_offset =
>  				(u16)(current_ptr - bss_entry->beacon_buf);

Any reason to use total_ie_len here instead of element_len?
Since we only access oper_mode->oper_mode later, would
	element_len < sizeof(bss_entry->oper_mode->oper_mode)
also work here?

The current check looks fine to me.

Reviewed-by: Jeff Chen <jeff.chen_1@nxp.com>
