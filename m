Received: from mail-pj1-f99.google.com (mail-pj1-f99.google.com [209.85.216.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A1A7369990
	for <linux-wireless@vger.kernel.org>; Sun,  4 Oct 2026 09:45:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791107161; cv=none; b=Yumey5LVX6Y6Df5+IC+O85/sxs1WPTcI06IbqjuaawnqyTT8LIbNmRwU0boP94Bh9NL253PthG3ErtBIPIN+BjRvJZfrB9DwVQkHQ5rcc47h/F4z83+BV4QhfDtdanJb9iyTY6P7kcIp7zZTZ193lqvfui5VJupPga3zigPnJF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791107161; c=relaxed/simple;
	bh=u+vYm56YwNMck27Per+ZsEAji+EkicSsZhqAv5T9Xcg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o+wTOiIN2+bzPSdtrXYbexnV0o5p9Nl+5Zo57u31byUavBWFSb19Ewu4rYYzD4Gvf69P57G9EEz/yXcLi1ISGVUKSenxyNsZgR5NqgMDdPO7EwHcV0FSDFffTCXs3IcLag8rmO3k5LCFc+8A8Uq8nZC54369FHtMX+c8BBbb1Hc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=G8ke1yEF; arc=none smtp.client-ip=209.85.216.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="G8ke1yEF"
Received: by mail-pj1-f99.google.com with SMTP id 98e67ed59e1d1-3a0aaa0fd13so281537a91.2
        for <linux-wireless@vger.kernel.org>; Sun, 04 Oct 2026 02:45:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791107153; x=1791711953;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PyyofAU4SJtVBmzx571gZStp+YRjOTEqsRVPq36CL2U=;
        b=mZZy+NzVK+7ONMqz77b8JZG1L9tSSyL9ApWbrkWX2tnYQa8x7OY2eJ+FYZegbwitZ7
         0+jNracDwUqRT2R+L3+ARUeq1nxrOWvq3S8eiM+C35Ht1wXmIxjNKLohKimMRgDoKbEd
         3K6dB3P2zSJ6kmU2mNpTp8QjHWWIWoTebwsjiqaSDQhlK1iOoMLyWYPl5uqOnl6tHhOR
         knftb/zGqIXrqbRsbQUeTVDpTRHhzQspKmAC2CE8lr3/Oh72JioBCx1BUVNRZTvECbZ1
         cibs5hrWBG+Ve60joDopdhHuWSBdh/cbGPLHBCvf6tyyllfxWC5Zl9lDg+VYBnhY+2NP
         z6gA==
X-Gm-Message-State: AFq9FYKSl0gCOboDU+smb3tRG0fJbmXJLCyp4E6OxPjv2pvA7G3MvBDa
	Q3h0lFgzjAr7nub1tkTi+IBmFDz6tcgc44kweSMye5no6ZAKAeMcUr1d5UxXNqVEo5xRGE2SliY
	/VLl9KdN4onAfNLyltGTwwpp6BuA7cgQ9vidmUvp/6G9//svpJDZ0uMcMb8MYSzgmzB57jalD7z
	U7W6JotGkyIi++saxhLdpD5efXJN6hzuPwZ+LzBUMdd3DL+G3qgo/QprBzOeI9bjjDTIfBzEySl
	TmeaO9uv1RISiRy0gzR6R7MDBky
X-Gm-Gg: AYBFou2gBiX6FSBoy+JRUepXdg0hiEDlaMiaZBOKRDFnDDEeOsIuYA003Yv6knNH0Wf
	UFrOcmYSxY+4zciGuVqkuGiAZn7rbd+5f1eVUCp+2CNvh5fzbzz3Y+5solTPmXlblpgGkg5CSJy
	20WufozqwJS9aVWt06AscI1hubnUvI635H99dBNbViEvkvkoF49Vaeb/2fKrRNvX3+amhkCkStJ
	+ilGotsoopO5jFMLPwyap/JQhQePj5gL5lfEvZd6Ej9eaDduapwVjfBi0+tl1D4L1AiJyGrWGn1
	3Sz/tNPBj2KLbW7MexjXkVyqcSP1SqlkS7H5IKkiHsW2x/kEsMnuG7yTaSC/46Go4rIku/KX919
	QXbTheMV4OJSDkzwZvzYk16AycQrGePjJNsvIIW8ykrFHaTiFWQX3Gq7bx0whhKD5+R5srgxkEQ
	RolChbPOPeN2g8hk4h35Nsq2YwoFtIA9EzZ3V6QfIajw==
X-Received: by 2002:a17:90b:1c10:b0:3a0:3673:dbc0 with SMTP id 98e67ed59e1d1-3a6ced24dffmr7492976a91.49.1791107152908;
        Sun, 04 Oct 2026 02:45:52 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-125.dlp.protect.broadcom.com. [144.49.247.125])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-3a78e4269a4sm2433023a91.4.2026.10.04.02.45.52
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 04 Oct 2026 02:45:52 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-341eff9e381so1648231eec.1
        for <linux-wireless@vger.kernel.org>; Sun, 04 Oct 2026 02:45:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1791107151; x=1791711951; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=PyyofAU4SJtVBmzx571gZStp+YRjOTEqsRVPq36CL2U=;
        b=G8ke1yEFREXyWRwnfYmsdve3/1ZWIWZOYELE6RkNsNtdEDdawXK4oZIq8bLkzrjon/
         JC45idp792Hs4yj0TXJH+Fnqg+KlxntFc0gusOkqN6Dbs3TXx+TSUUoQsk9lWbOSeS2Y
         qAmiByC5Xgz4Xur60bKf93OqlAi/QT1yXl5wo=
X-Received: by 2002:a05:7300:80c4:b0:328:3542:b73e with SMTP id 5a478bee46e88-34f150c28eamr12941729eec.15.1791107150917;
        Sun, 04 Oct 2026 02:45:50 -0700 (PDT)
X-Received: by 2002:a05:7300:80c4:b0:328:3542:b73e with SMTP id 5a478bee46e88-34f150c28eamr12941692eec.15.1791107150271;
        Sun, 04 Oct 2026 02:45:50 -0700 (PDT)
Received: from bld-bun-02.bun.broadcom.net ([192.19.176.227])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-351272d5103sm3595747eec.27.2026.10.04.02.45.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Oct 2026 02:45:49 -0700 (PDT)
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Pengpeng Hou <hppiscas@163.com>
Cc: linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev,
	brcm80211-dev-list.pdl@broadcom.com,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org,
	Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: Re: [PATCH v2] wifi: brcmfmac: bound NVRAM comment parsing
Date: Sun,  4 Oct 2026 02:45:45 -0700
Message-ID: <20261004094545.1324258-1-arend.vanspriel@broadcom.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260920034414.16948-1-hppiscas@163.com>
References: <20260920034414.16948-1-hppiscas@163.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

On Sun, 20 Sep 2026 11:44:14 +0800, Pengpeng Hou wrote:
> The NVRAM comment handler searches for a newline with strchr() even
> though its input is a firmware buffer with an explicit length. A comment
> at the end of an unterminated buffer can make the search read past that
> input.
> 
> Keep the input extent in the parser and use bounded searches for newline
> and NUL. Preserve the full input length: the capped size used to
> allocate the output is not a bound on the input, which may contain more
> than 64KiB of comments. Leave the outer parsing limit unchanged.
> 
> The issue was found by our static-analysis tool.
> 
> Fixes: 3e99b08ab53c ("brcmfmac: enhance nvram processing")
> Cc: stable@vger.kernel.org
> Assisted-by: gpt 5

Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>

> Signed-off-by: Pengpeng Hou <hppiscas@163.com>
> ---
>  .../broadcom/brcm80211/brcmfmac/firmware.c         |   13 +++++++++----
>  1 file changed, 9 insertions(+), 4 deletions(-)
