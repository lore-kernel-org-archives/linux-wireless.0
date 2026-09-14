Received: from mail-ot1-f97.google.com (mail-ot1-f97.google.com [209.85.210.97])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6BB231F9A7
	for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2026 20:03:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.97
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789416224; cv=none; b=Nv5bAEkFAmB1nzf516fEBfpgGyAwyz8VFWBn0xgTCCunvTD/ogC1iky+zZcV9qfE06axk9Up6K619CCV8/ibFWGdPuZk5TRrouzGH9ixD+LkPc3YTPpXzfKa1/DHAq+A8l7mTtXwC0AJsuAPe0cF1AXfaGG5TNRfajfjM4D29ts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789416224; c=relaxed/simple;
	bh=iGHNNVQOC0D0YNnZ4vMitSMlVZq1IOKF4aTaBo1p2b0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EoVTugzXQQZs9KOJomtZkDu1csM9zChxxnJ5INi3iRcrXxZY7xZdex7lAuTVN5GSXPYxcOeMGPVygteTS1ehD1uGm7w2Uns8Lmi/5/yp8Zx5Qd8T7/+LnJGer1iGg3+X9KnkDAB/HeSg0ia0WCavacZD4EX3kXWA+lYeWqujdKw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=NmIshWD7; arc=none smtp.client-ip=209.85.210.97
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="NmIshWD7"
Received: by mail-ot1-f97.google.com with SMTP id 46e09a7af769-8049e44d0c3so3430872a34.3
        for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2026 13:03:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789416222; x=1790021022;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=P+2cvsudH7ftH8jFsjvcC49I+38SHnXJ8HERpOnIBgE=;
        b=WZ3NZS8pzvWnPsoJAJqX03f6wqgEqxeQ4WQufxMgL2Dvocm2LfWDfRLT/9XXm50gS/
         yfwjA8DJv/m1Hqq8ff5MmORpH6T9yYHEhic8o/KHsK5dcEKXlftz69XlQXnTyU/j0DX2
         JXPrj+u0vYojboLFTTwz57LMa20opLhczXBVVBNqAc5WERPYTPRRbuxWK/6THxXJR21t
         WjKR7Y4dQlHB7+vl2u2Sko/o0WCbYbYkJ5wh7tu0qkhoZ8qQ/S5+uv3qo8VabkWlHjh5
         +Bob+nVfaAM+frU+4SX3qWY5S/uw36RmiO6tSYCxcQWqt4vb5mb8/XxnaKh1mxoUbsX6
         /9Dg==
X-Gm-Message-State: AFuF++kpD+q5nRUvBil+VCjkaSfRoVYwDyEpWpffy8DLFx0Jfyh6DBjd
	6lyK9q4sB/G51lQ1niXOqGkIH4whSoUQEuFm4jjbbFyyY8HuAhmzW62hEe4/m4l+G8x1t+v4PQP
	mazlEfzWwJlz6LQewe5ilzFKmw/IHk4X1xIf1Zi/MpSiSQxMLyUCXMb5kUaClmjKQlvt3fP1yk7
	MgKJjOC7zdVosLVSi7Nsa7uMHhG7pPO7HC0mOEwrpqD/6LxGdj5o43emopdscpaIJlXnwwkJV+6
	fiRu4+Z1H8/loxA7qhZgOP1mFRg
X-Gm-Gg: AYBFou1+wSYxDB1QCv3BbsPvauAjwdFFV2268vYfIzcVe0P/tlWv3DcO6hcu7AZXD0I
	nTB8GgQzEGVThdm+mMWVP/NNZx1D3ZV+k8+Zq85v7MMB0kjVFYncJksU8D7Y1ojPD+rNPVXU06p
	I5VMck0+Y3S+v70uTR0JvIV5FnCcw5vWnonBV4gZGR+fk75gNuWZPS5kVIG0ZtUw9H8SoMz5lpa
	FEgzK6uEYtBYb8ECBDDuM7/qPrIwhj9F6frSKHAUEh76QiaYdYIefDagWCx0mGzh6AdV7pz0t+5
	6RNPkZYlmLuKUE89qUWil99f9grZmUH//BaTJdXsSkrznLkAfmrcxlWNulLq2pZyeXAF69PNVsZ
	/X0nH6GX+uHE5csEfMsYMtF6/GXl5e3bfjszBOaYULijaWLqYaxe9HKhzmJA+plI=
X-Received: by 2002:a05:6830:6d0e:b0:7f4:e011:6b3f with SMTP id 46e09a7af769-808992673ccmr2836153a34.14.1789416221860;
        Mon, 14 Sep 2026 13:03:41 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com ([144.49.247.127])
        by smtp-relay.gmail.com with ESMTPS id 46e09a7af769-803f681202bsm6280718a34.8.2026.09.14.13.03.41
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 14 Sep 2026 13:03:41 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-90cddf4f59eso75984676d6.3
        for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2026 13:03:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1789416221; x=1790021021; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=P+2cvsudH7ftH8jFsjvcC49I+38SHnXJ8HERpOnIBgE=;
        b=NmIshWD7q+L/mPmx/iBb5DNwEM+i1HSjempw8DL9+fg70BlHVPoLUkOS9M9Q4b+a2e
         qHOkbPuj8x9zjqLDyuWus5TSEiKtPeJUsDz3IjCZdpxx+Ay7fND1EqOpR4HAec2Q/seh
         HjLcG3gwMyYKvhy/BST9rqJ6gMH18wy2GQMcE=
X-Received: by 2002:ad4:4ea8:0:b0:910:4da6:8354 with SMTP id 6a1803df08f44-9122e55cf24mr59329346d6.17.1789416220666;
        Mon, 14 Sep 2026 13:03:40 -0700 (PDT)
X-Received: by 2002:ad4:4ea8:0:b0:910:4da6:8354 with SMTP id 6a1803df08f44-9122e55cf24mr59328966d6.17.1789416220205;
        Mon, 14 Sep 2026 13:03:40 -0700 (PDT)
Received: from bld-bun-02.bun.broadcom.net ([192.19.176.227])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9120f477d42sm103209166d6.18.2026.09.14.13.03.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2026 13:03:39 -0700 (PDT)
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Pengpeng Hou <pengpeng@iscas.ac.cn>
Cc: linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev,
	brcm80211-dev-list.pdl@broadcom.com,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH] wifi: brcmfmac: bound NVRAM comment parsing
Date: Mon, 14 Sep 2026 22:03:36 +0200
Message-ID: <20260914200336.1742565-1-arend.vanspriel@broadcom.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260830135328.12321-1-pengpeng@iscas.ac.cn>
References: <20260830135328.12321-1-pengpeng@iscas.ac.cn>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

On Sun, 30 Aug 2026 21:53:28 +0800, Pengpeng Hou wrote:
> The NVRAM parser tracks a length-bounded firmware blob but its comment
> handler uses unbounded strchr() calls. A comment without a newline or NUL
> inside the remaining blob can make the search read beyond the current
> input.
> 
> Store the bounded input length and use memchr() for comment terminators.

Please add:
Cc: stable@vger.kernel.org

> Fixes: 3e99b08ab53c ("brcmfmac: enhance nvram processing")
> Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>

[...]

> @@ -215,6 +220,7 @@ static int brcmf_init_nvram_parser(struct nvram_parser *nvp,
>  		size = BRCMF_FW_MAX_NVRAM_SIZE;
>  	else
>  		size = data_len;
> +	nvp->data_len = size;
>  	/* Add space for properties we may add */
>  	size += strlen(BRCMF_FW_DEFAULT_BOARDREV) + 1;
>  	size += BRCMF_FW_MACADDR_LEN + 1;

size is capped at BRCMF_FW_MAX_NVRAM_SIZE to allocate the output buffer,
as some NVRAM files can be larger than 64KB due to comments. Setting
nvp->data_len to size will prematurely truncate parsing of those files.
This should be:

	nvp->data_len = data_len;

Regards,
Arend
