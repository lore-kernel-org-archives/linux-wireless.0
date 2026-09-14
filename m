Received: from mail-pg1-f227.google.com (mail-pg1-f227.google.com [209.85.215.227])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DF312BDC13
	for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2026 18:42:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.227
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789411368; cv=none; b=HURO9PQ7n+1aT5BVFBDxyETfZ21knLv8y7y7ZZRIW7nK7abm7FHfSq+yJ8g5h5VTSp2Z+0OUMAQGpbyQ7je67VQn6fB2UOjTzA66tim75CQuB+bSL3l7aAM9Ujq5hauEEPtjhGBXeURvBqJY7JcJrll2G0U+Kuu5bOc+tUpg31U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789411368; c=relaxed/simple;
	bh=dVM7a9s1TxS2aIq6AXPkZaCie1+K/qRV6xxe5PnGBH8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fRgVbW03oywmPW5sBsMQ1ygjLe2g2YolSCLxiPXTNkYAcxKYZI3AOwAPBHEKhmKDCfljbtdSbNqWjaH5lUUeg+boYazFHht/fKocCVkx6JBy99SVCGgJoMRp2DukRzN+OENCxSrvqptLdBudUlH94yWLGkZf1Dh+XXJLLeswVuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=P/DiOBZ8; arc=none smtp.client-ip=209.85.215.227
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="P/DiOBZ8"
Received: by mail-pg1-f227.google.com with SMTP id 41be03b00d2f7-cc4dbcf2b85so1721186a12.3
        for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2026 11:42:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789411366; x=1790016166;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=iBKsdBmjCJJD8VrVX2tmAkv65OynoDpaqNBhjTL5Aq4=;
        b=SCNrqWQN7LB4CFvnLHxvwVmdGKnx86tsxbW5+FqWdV5s2yHi7dIXcdR3OLDnO+CkOy
         gazhIVACYztC5VRxQCfHczm9j2jbPrwjPKF+94j/l7PisrNsvv9pNydmsxXB1ElyzqE7
         CYZyzfVfwatryOJgaxa2pPfTKULydUJMiKp46jVy+xxNRrjkXd2NS1G8dIy2dZgOt8ab
         e/WAdaWdFZU5W1jdaiUyA2l0k4sCOXv3E3LdsN9jKL/bZYmRiHLzC126la1ECTFm5Esl
         zjms7neuxvBILNKrPyH2OFWwtC9DeuBq5xQiZCduyKYSgzahbcaNBLKMzSiHGZL75Bo9
         vkmQ==
X-Forwarded-Encrypted: i=1; AKwUvBxGiEaTijsunWGelQtMtgZIMrAdvNc+a+iPVphI+3yQGePl3BRHVMxOovkVBKQF/XmmVhni9+gYvEWAcxfc9w==@vger.kernel.org
X-Gm-Message-State: AFuF++mpJF+w46OeZ8/BF6FaiYLKJ/tVTS/pgPPz99xkcL3yAvLyKqvw
	avQI53nJlGOQpt5q01Uv1L6W2gehGm0YYH1euKN/wkGeIpElPHMT714xVKXcCsLzTcNVLrBhz+t
	KCktJBwnre0+ndLrZq0PPTq9ohHhJ8oizGu2hDnsNu7xZSK0wiqEaw9J1pgih1/PTI+zedw6SsE
	XbXjUbJ68/Vb7SIfQjfiEdkARp0YzHVMCX/cRzQx3inTtTdQ6IDQ8adHn761VflN709gvS8Aaoz
	rhgpjeIGZj5/1ZbZN7c0CZDGETEjjs=
X-Gm-Gg: AYBFou3cCP2gExkzqn86biuZNVduUQr2mjFqZUFhFo1dyP7N27qutF7kdmeRF3vKOSI
	p5/Y5it4U+PW8Gtjo6pVSZlDNjMDrSOHsZWFQ9C/cv8lGqoBbAbL1CpaRt+NrYJtJsbbwbQkfHi
	QYb6MXyvJN5L1oekgnFGfh0sYpNm2ko3QLG4YE9CFfvOeUvDj/9+xzEFfppUUBOV4jyqGrfUqWt
	urNLAnKr4NcRN/b5AM+awhNjs+T962BEUb6HJhOth56vOgk3jYDlv6y4bJOFUnlgCUAWYGwOzn5
	O7DVsQDBd6gtvhYYnkCM5/7LYKJjVVDYmPmsl/uaJptwvSBokjzmKe0X7x+s0GsY1OXmgrpCme5
	jJgJuBUKBlJ4z5dFOQzT7Dl49tCSyJxF6EFLB3b8HkROMqS9emjhCMhrJ44/lnlo=
X-Received: by 2002:a17:90b:17cc:b0:398:9be9:ab92 with SMTP id 98e67ed59e1d1-39dec1489ccmr7357359a91.23.1789411365554;
        Mon, 14 Sep 2026 11:42:45 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com ([144.49.247.127])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-39dfdc8fa00sm203798a91.8.2026.09.14.11.42.45
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 14 Sep 2026 11:42:45 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-cc4fc935a11so320257a12.0
        for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2026 11:42:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1789411363; x=1790016163; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=iBKsdBmjCJJD8VrVX2tmAkv65OynoDpaqNBhjTL5Aq4=;
        b=P/DiOBZ8ZfL6VHuK/03FzBY0ba81W0oADNDeuKH4V9Z+Rt83PKIOAZ33A6hmIkuKfe
         cFXDNWMHP91PW692+cIaObcmQLx0dtMLSwkvG4vZ2+nr/4BIbKNxnlKmRzf5qLGH3b0r
         69ggTd2KOHrKE2DIf+jHRL2m8M6SsCFcLPrZE=
X-Forwarded-Encrypted: i=1; AKwUvBxmyWWp3y3jAb4F/l8zdtlDAGGov96hi3P8ed6mWxlkcwMvCN+J5kF15KuV05cvVMlRwy+Uo+T8SOHneESVFw==@vger.kernel.org
X-Received: by 2002:a17:90b:5785:b0:39d:f725:fb84 with SMTP id 98e67ed59e1d1-39df72615e4mr4353668a91.19.1789411363616;
        Mon, 14 Sep 2026 11:42:43 -0700 (PDT)
X-Received: by 2002:a17:90b:5785:b0:39d:f725:fb84 with SMTP id 98e67ed59e1d1-39df72615e4mr4353642a91.19.1789411363179;
        Mon, 14 Sep 2026 11:42:43 -0700 (PDT)
Received: from bld-bun-02.bun.broadcom.net ([192.19.176.227])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1438d89556asm364156c88.13.2026.09.14.11.42.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2026 11:42:42 -0700 (PDT)
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Karl Mehltretter <kmehltretter@gmail.com>
Cc: Arend van Spriel <arend.vanspriel@broadcom.com>,
	linux-wireless@vger.kernel.org,
	Hante Meuleman <meuleman@broadcom.com>,
	Franky Lin <frankyl@broadcom.com>,
	Pieter-Paul Giesberts <pieterpg@broadcom.com>,
	brcm80211@lists.linux.dev,
	brcm80211-dev-list.pdl@broadcom.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] wifi: brcmfmac: fix lost 802.1x TX completion wakeup
Date: Mon, 14 Sep 2026 20:42:35 +0200
Message-ID: <20260914184235.1457622-1-arend.vanspriel@broadcom.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260811082702.44521-1-kmehltretter@gmail.com>
References: <20260811082702.44521-1-kmehltretter@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

On Tue, 11 Aug 2026 10:27:02 +0200, Karl Mehltretter wrote:
> brcmf_txfinalize() decrements pend_8021x_cnt before a lockless
> waitqueue_active() check. atomic_dec() does not order the decrement
> against the check.
>
> [...]
>
> Fixes: 21fff75d2fb6 ("brcmfmac: use wait_event_timeout for 8021x pending count")
> Assisted-by: Claude:claude-fable-5
> Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
> ---
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/core.c | 2 ++
>  1 file changed, 2 insertions(+)

Please add Cc: stable@vger.kernel.org - the Fixes tag references a 2012
commit so this affects all supported stable branches.

Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>

Regards,
Arend
