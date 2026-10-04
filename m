Received: from mail-ot1-f99.google.com (mail-ot1-f99.google.com [209.85.210.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F090143F0A6
	for <linux-wireless@vger.kernel.org>; Sun,  4 Oct 2026 12:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791116934; cv=none; b=pw7KtplfS5NZfJJcPd1nbCvURbv5KdkFQmSAGRHIlBQ4Gu/lvRqWZe+OkaAjBkqWMAfuKQxS8QGtBxRq8DIg0nawjP+Dr1nGgU9RZQRK2H9i7zySAop/0kHNTl6JXEtkTJBOXMQ6yS2jm6kSlYc6ImiHz5oRG0HnaM7787Q5mJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791116934; c=relaxed/simple;
	bh=uqTDGLpLDiZjJGXJ7cXBmigd1ujQhtoqRZW9qtkfopQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JKQ6RMyxfhwc//GOwBUAZgLxIlNBiqJGq1qHhAHeIkNsIb46eUEOerjtBuySK03DRjRabRc15GqeJgYK3ca3G33rl28VLLvkkO3vVZKk2E1gRrb8af2bH9S4Y07QEIq4WghZ0PjRWS1PrswQ/F/F1fm5rRDZE4Jzu46q3te/0f4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=G50Tdfl/; arc=none smtp.client-ip=209.85.210.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="G50Tdfl/"
Received: by mail-ot1-f99.google.com with SMTP id 46e09a7af769-81ae6aefdceso1124374a34.0
        for <linux-wireless@vger.kernel.org>; Sun, 04 Oct 2026 05:28:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791116932; x=1791721732;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=48VB+6X5YIGbdqE6rZBZu2Xgbztijhzm4Tc1dAueWso=;
        b=WlgwrIakfmch8kn5lYVpGjrjHT5vd4UnfEsQkD/HHMKZ2+tF9LkAzCKMwKjkc+iDbR
         gFav3RSpsuDUGemvEE8m1jJrMH3GinzfyGlcE47wPF839baELmZPwGZdRB9uwywYzORq
         Rh1W89kY+MCCy93ehh+DTTZvzstIfVL0p9UxTOR3HDArU29zlUab7ytPKmzXqTvAuBAc
         DPELJC74vUHXDPZuFs2a8YpXBckTDpvHdv0mEcj1XwMNTgI6BSm9ETMr0iPurepYdF1B
         rDGC5AKjUMQQKYWUm+Cv+/HU2ULjL3qiIGER0Ruir9khi67l4EaZgyhSNxvEB6mMRR3l
         YqCg==
X-Forwarded-Encrypted: i=1; AKwUvBwAzWQ6hpY+Oul6ChCMUenre35RBJ/BFBi8vvVemda9rnfth5KiwrSoGuraVbSE9gWIVgdGwvFs8Aa3lpOFFQ==@vger.kernel.org
X-Gm-Message-State: AFuF++kzxSjYyT5P6/NyCbHy5Mn2wVI/bwNMFHR5utjjQSO3aP9a+aLl
	dMJ0SD8QNNevFTBR2FQwFqdW3a/KnVCA6l0KGSS4x3qp2Ig8YlV7OmplZVRu/xI3U8j3jtP2SSB
	VKhplAXBX37EtJtslwy0/B9yCzew+Gf7mrzRhqkogoDWc0tmS9fmaz8YfrZzdNuEVpsFw2Sep69
	cVc42DqAreaXlsu2t1fsujZT5zIPjx0309SwCIhfZJhclboZecVyHYNrSiOKoPb6y+5NILgtbBo
	FIcI1Xp1dkWyOn6wsm1Bfej1V+r
X-Gm-Gg: AYBFou3mpWVNEpMp90nt0gJOVFH1Kkp0cUge3yGGqvBFt3OUUIU1CX5NSEZnUmeUK2s
	mDsh/gK77SyXdK9lxrn6LmKbcrjR3Ay06EQyAjogu4YFDZAc4H8shFacsuzmKVBUacEGV4zCecF
	n5d3hp6r7ne4RODP8lpy4C+FEvdkTDNaHt5pOZldcnuAhLjQWPR1Iq7TLClSsWD4udq5LGD1ZOl
	MBLSNaxwbTzgqN+F1Prl+CtEQdAbnY/YY07+QLneRJozqp2Rs7x1LU5NkBAWjUGTrT2HvbpFIFb
	qx0uS5i93nFjtYuLgSaELRy87aaMR4OKhEW4wnBdYR/vly1n4bCA7vWhnZXZeGMH5F19e/Xh5vx
	ufUaDCiA3YwQ04lrRa8ogHbPfErhzMdg9AGzubNj9CD8uhNsQgKlHyn6lpPF65j3kOWgKl6H6s8
	I61S5zUGEWNxiUuBMXaxL5PLpKfYnVxbCvEXFaS4c=
X-Received: by 2002:a05:6830:270a:b0:806:9a8d:4b9b with SMTP id 46e09a7af769-823fcb252e4mr5011508a34.15.1791116931756;
        Sun, 04 Oct 2026 05:28:51 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-16.dlp.protect.broadcom.com. [144.49.247.16])
        by smtp-relay.gmail.com with ESMTPS id 46e09a7af769-8246baf4d11sm469681a34.9.2026.10.04.05.28.50
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 04 Oct 2026 05:28:51 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-dy1-f199.google.com with SMTP id 5a478bee46e88-3510d0baf63so1937909eec.1
        for <linux-wireless@vger.kernel.org>; Sun, 04 Oct 2026 05:28:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1791116929; x=1791721729; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=48VB+6X5YIGbdqE6rZBZu2Xgbztijhzm4Tc1dAueWso=;
        b=G50Tdfl/cyBmVad2dM+1fn73upmaxMVee6uJzWuoqe6oWMunv3UkOh1rjwtZ7sDBE2
         TjRYLdHMj6p1MpehPFzmLb8CTuXnVvC1EfZR4iQZCBfuwR4oW1VfgwYY+lJ1mti81iKo
         GT+4oDaXncmAZSQI9F4u56pwaf3BIs7+MRL2U=
X-Forwarded-Encrypted: i=1; AKwUvBzeireK9fE9HNnj3rNiAGscMRwwv6k/rWB8AYStktRJ4Cq497p1HRdHA049yMbpGqqJNni5VYRSByqlVGpmzg==@vger.kernel.org
X-Received: by 2002:a05:701b:2051:20b0:147:9ad0:cf25 with SMTP id a92af1059eb24-151c435c1eemr6422030c88.46.1791116929400;
        Sun, 04 Oct 2026 05:28:49 -0700 (PDT)
X-Received: by 2002:a05:701b:2051:20b0:147:9ad0:cf25 with SMTP id a92af1059eb24-151c435c1eemr6422002c88.46.1791116928821;
        Sun, 04 Oct 2026 05:28:48 -0700 (PDT)
Received: from bld-bun-02.bun.broadcom.net ([192.19.176.227])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-151fc39a7d1sm12234015c88.3.2026.10.04.05.28.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 04 Oct 2026 05:28:48 -0700 (PDT)
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Benjamin Drung <benjamin.drung@canonical.com>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
	linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev,
	brcm80211-dev-list.pdl@broadcom.com,
	linux-kernel@vger.kernel.org,
	Matthias Brugger <mbrugger@suse.com>
Subject: Re: [PATCH 2/2] wifi: brcmfmac: Add clm_blob firmware for brcmfmac43456-sdio
Date: Sun,  4 Oct 2026 05:28:41 -0700
Message-ID: <20261004122841.1391116-2-arend.vanspriel@broadcom.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260923203739.2560527-3-benjamin.drung@canonical.com>
References: <20260923203739.2560527-1-benjamin.drung@canonical.com> <20260923203739.2560527-3-benjamin.drung@canonical.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

On 9/23/2026 10:37 PM, Benjamin Drung wrote:
> On Ubuntu 26.10 these firmware file are missing inside the initrd when
> including the brcmfmac kernel module:
> 
> ```
> /usr/lib/firmware/brcm/brcmfmac43436-sdio.clm_blob.zst
> /usr/lib/firmware/brcm/brcmfmac43456-sdio.clm_blob.zst
> ```
> 
> So include the clm_blob firmware file for brcmfmac43456-sdio similar to
> the other firmware files.
> 
> Bug-Ubuntu: https://launchpad.net/bugs/2168109
> Signed-off-by: Benjamin Drung <benjamin.drung@canonical.com>
> Reviewed-by: Matthias Brugger <mbrugger@suse.com>

Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>
