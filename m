Received: from mail-pf1-f227.google.com (mail-pf1-f227.google.com [209.85.210.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9301A3A4F51
	for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2026 18:43:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789411405; cv=none; b=uftUzJT3pCeJZCdHOyHzW9iGfgGCafv6Hnfvp0YqrCFJeF8x1pswoTxDkUQ5KnmUx9l3M4vr+vLYLjlRTvutDpcN/1NIi56IRO4jG1DtogeyeOZo0tySpmYJZoWOgD+aUywy3xvf1cAyvALsyIFupgNbxMX10ACnUgxX7V4gxlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789411405; c=relaxed/simple;
	bh=mtWjlL6opbGn5Z01q2KziQo4eyqJ4qENxxukKPKDwso=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o+fim+WOZnNAMvBFBv2nHxBJ0QXtMY2HtF7N7/WQw73eSs21q5j4SWVjSaS7K7zjGb/nzBE1YpYlbPrEv1/XRmT86J4GeWQu09ENm8O5Y8iGh9S/A575m10GW1gI5fOCu4hXSiZR+tqhw6HWtc1xTcBPLjnT+n0MdclldmlZ0+g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=TootGZae; arc=none smtp.client-ip=209.85.210.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="TootGZae"
Received: by mail-pf1-f227.google.com with SMTP id d2e1a72fcca58-86a1aeec07aso417262b3a.1
        for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2026 11:43:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789411399; x=1790016199;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=TRYv25iRu9fFTWg27vlxcds24V+T7PCoVZa9yNuXC2A=;
        b=m/DjO8g9mSBBlK32/C3LoBTWNczUCeWNVz78aSBFIMPEgYc/ASapN5h7CJ2FfLOTiu
         idYjghQuHY3VSmQ8YDnCn1HzPdtK3bm3g/7L4L9MPq4JvECQzFGdvD6h/RAskS7gsHEB
         IXrihI194yzgs1iEev/WofJF1/Od8MdbXfXvqeBbsd3d9jOleKygKKpIGCgl70K0ZIyV
         Yb4+9Ecv5ypSa/SO+w5EQ+WcXrlm1d2k+CYd+uf8UlsmwpUsJZYfjIwmd2bPTTh2pJJM
         iGi3IkC+BjfGRLHps/ecoF5XYfB3OgOqdiOYcHpVPrp0DvoIup6ImJhn4vydqWvm8ujl
         gjYA==
X-Forwarded-Encrypted: i=1; AKwUvBzU/R5s8jj9G5i9ESL0IB0u65lD0XN14uv7T/4WyUlFo0ii9FuVWyx58eAZC8vyskhe7uMshR7pTGKygGCHZQ==@vger.kernel.org
X-Gm-Message-State: AFuF++lFrXJGIuokYgf981w9/X3VTXWySYKR5zQXLMbNA0wL67QvvnFs
	Rsiy1RG0F0ndtrn0CoyKS2C3bjrOquI7Gwaryd54tla8qX+hDrYIHtRYMjq/ZnJoOVj13IUhIab
	4KhjVREAA4owVUEuBi1T0sTdZAuQyaGq9EuMsn4uqE/mKq9XtykKJgCMffB/H3QmlarkqHSa9n+
	lfn8Pi1jcfgmeFBzYNtvZ8NJAsmDJJlO3o1zfckSGy5M9M1HE0wd3zhRoTMawXW23UV30XBDosx
	0UebiG6tvlO6MB/E1JWiThhRvCzINk=
X-Gm-Gg: AYBFou0B5aZdezSj+uKFNdShAqWT9J8hGDXsLiylUXTMixH1ZxkMNG90aJYPQ5tUZmS
	hXTNFPgmjJkHoSAg2AVUD54PMTjgZaGKXojTamK/Ljiw4oELEkDN0jfNWuDkf+RyxFrKJ2SJnbA
	pJcJQCJo2kRIbX0Go3qdaWoce8zf4qMQiYF40OvnYw9lnlpK8wfSZW79rlBIGQHfbjigKQl/50e
	v79eB2YyFAYzvH7qvWTgU2vpvLu0XjkpiEE7N33Qx3C1t7WKQ2RJG70K+Smbginu1b3dtr9D/Zq
	Dxg1p2gj/oeh8ZiKrGaEKBHTK3b8tqmWhR31wHcjUgz+z71lbwXYHghxCjqKw79BtsFryWbj43F
	54xxLDIYFWBm7i6CCWKt3BdNTw4Lg7xdUAyuD/JoSDbpMhkdpEgETNmBGynH1RWZx1TqoCImKTC
	xMjluudMwJ3gO1KrSYYoIcg+PgGXCQW+8yYhO9xLw=
X-Received: by 2002:a05:6a00:1828:b0:84e:2382:f4f0 with SMTP id d2e1a72fcca58-86f83152fcdmr8024626b3a.4.1789411398839;
        Mon, 14 Sep 2026 11:43:18 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-77.dlp.protect.broadcom.com. [144.49.247.77])
        by smtp-relay.gmail.com with ESMTPS id d2e1a72fcca58-86b284c6490sm3058115b3a.8.2026.09.14.11.43.18
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 14 Sep 2026 11:43:18 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-cc1b8088202so3121841a12.3
        for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2026 11:43:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1789411397; x=1790016197; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=TRYv25iRu9fFTWg27vlxcds24V+T7PCoVZa9yNuXC2A=;
        b=TootGZae418iEWKwoGbK1fPI2ZYlJkNzuAhVdImGQwg1LnzMnWlXCwsrYJqpl9l4Uz
         wIXLzwJXdfeNqX22NnS/omHPJvj8SDiK9X8S4gNVWqzCaH4cx9ZwX0F32FW7tWmXeg19
         9UzCS6M8MXXj8QoI0GfMDFdJjJeHZx4nGkueo=
X-Forwarded-Encrypted: i=1; AKwUvBwonO2Jpz/EYwg4AmV72Ii+KFZboX+5o+XDMRZerZ0LjB+Aj6UDC1lr8nFuFN94xUgghgS2OOyKxPSt2YnQkw==@vger.kernel.org
X-Received: by 2002:a05:6a20:a11d:b0:3d3:adbf:7783 with SMTP id adf61e73a8af0-3db40672d49mr8756115637.24.1789411396987;
        Mon, 14 Sep 2026 11:43:16 -0700 (PDT)
X-Received: by 2002:a05:6a20:a11d:b0:3d3:adbf:7783 with SMTP id adf61e73a8af0-3db40672d49mr8756051637.24.1789411396577;
        Mon, 14 Sep 2026 11:43:16 -0700 (PDT)
Received: from bld-bun-02.bun.broadcom.net ([192.19.176.227])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-14365b347e6sm24621139c88.4.2026.09.14.11.43.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2026 11:43:16 -0700 (PDT)
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Jiangshan Yi <yijiangshan@kylinos.cn>
Cc: arend.vanspriel@broadcom.com,
	linux-wireless@vger.kernel.org,
	kees@kernel.org,
	linville@tuxdriver.com,
	brcm80211@lists.linux.dev,
	brcm80211-dev-list.pdl@broadcom.com,
	linux-kernel@vger.kernel.org,
	13667453960@163.com,
	stable@vger.kernel.org
Subject: Re: [PATCH] wifi: brcmsmac: fix UAF in brcms_free_timer()
Date: Mon, 14 Sep 2026 20:43:11 +0200
Message-ID: <20260914184311.1477250-1-arend.vanspriel@broadcom.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260815121043.938414-1-yijiangshan@kylinos.cn>
References: <20260815121043.938414-1-yijiangshan@kylinos.cn>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

On Sat, 15 Aug 2026 20:10:43 +0800, Jiangshan Yi wrote:
> brcms_free_timer() calls brcms_del_timer() which uses the non-synchronous
> cancel_delayed_work() to cancel the timer's underlying delayed work.  If
> the work callback (_brcms_timer) is already running, cancel_delayed_work()
> returns false without waiting, and brcms_free_timer() proceeds to kfree(t)
> while the callback still accesses t through container_of().
>
> Add an explicit cancel_delayed_work_sync() after brcms_del_timer() to
> guarantee that any in-flight callback has completed before the timer
> structure is freed.
>
> Fixes: 5b435de0d786 ("net: wireless: add brcm80211 drivers")
> Cc: stable@vger.kernel.org


Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>

Regards,
Arend

> Signed-off-by: Jiangshan Yi <yijiangshan@kylinos.cn>
> ---
>  .../net/wireless/broadcom/brcm80211/brcmsmac/mac80211_if.c    | 4 ++++
>  1 file changed, 4 insertions(+)
