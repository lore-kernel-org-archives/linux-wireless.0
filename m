Received: from mail-pl1-f228.google.com (mail-pl1-f228.google.com [209.85.214.228])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F184393DEE
	for <linux-wireless@vger.kernel.org>; Sun,  2 Aug 2026 10:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.228
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785665740; cv=none; b=RaiqWUyDAf3E1DHkH7XuWAGLj14+gXbqWEeMFsCZxB6O044oOvvn76yFny4lG322OTE+kBKe6nf6adex/gOQZyZxAI9rjl4zeNDsWiC6IrDjXwLcZkggoMMG+4MBqKjpggB7+eYfYhhrA+WIAuTAJtX4xig3NwPKBce3Fv/ApxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785665740; c=relaxed/simple;
	bh=MSSkEb803dp1gP2HBNhK12c9CPsMaiZ6pLgHJaHNeqY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LoXPlgmI2Cglmvz4F/a7puCOSGtDe+VQzY9YNSSEeDH0hNFJRpy/qSN7T09qhmOHg+eg5HAPotdsFYvDCy3K7fAxyRKMdJYa/ZgCIWc9hWJwoNnO2dsevb5qzNDIfbFj5pYsH1CrhNndjQS+Fi1MmY9FDLOQNoQrOqFjDYocT0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=RzPYTaDa; arc=none smtp.client-ip=209.85.214.228
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="RzPYTaDa"
Received: by mail-pl1-f228.google.com with SMTP id d9443c01a7336-2cc61541f8cso36214425ad.0
        for <linux-wireless@vger.kernel.org>; Sun, 02 Aug 2026 03:15:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785665738; x=1786270538;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1lDhnz0ePlnIggUFM9dMYWIu/4DcgouywlgpSKZ0Fo0=;
        b=RzrU+k1dWsRatmjB3lbTI2Q+r3xRmEB5HhynBOy/rf8/LdNOMtJRV268ufXlHM+Tra
         +ocVS/eKFNTzOmZ/9VsZCKy3NgGEvR7NlUIii0X2OAC9JGrB7WPcn8BglweJmAgPPSRF
         kNIrewpRstXsGwjulcvNZ9A6p0KRByktSWCFEHyx+c885GdUQ4WdDm0gc8S+c7EJnPRe
         c5d0498Hytx+9dpaQA/Yb8QrKr3cmmscV/as/AOQo31eIfajHWfAIFnUNq/IzCyTTrbd
         4COL9ieYW3jebuDrPvlQhdfGKaZ4yAfL07/oWroPCW+U1XYnhoW10fSGxq0sx9p6w6HJ
         VwWQ==
X-Gm-Message-State: AOJu0Yy0ipJh/X59PG4hrM7QKZ0oylBF06DvFj0FoJPEMqixYQL4vEy5
	SQ9ZRqrBx+sKWhUjX7k/ld8L8x19GjFOQJ0cO2XwVHYnOCpHsvVysaf6vXZjPQ2Ifz3oPi84ZHD
	PATipIyYqtq8cEmTeQ+01Brx71leIl2eHOBQP8t0yALkDVtBKCyLYYd1jHyzUoenbfQ2CynZEF2
	P32FwG3YV8QPyjCkzk4VEo0F26WjEj285v/+dD6nfUey0eJR46XAYEtgjOGNcsgVkkd0mgJKcbX
	8fDAiTPJ/hD48VLskAjCmoUJOyk
X-Gm-Gg: AR+sD10qssPzyZjpHyE6O8vUvyV9aOmOMgXwcjrmX/TG4cMlS8rVubhn1HcCtOGtM4A
	K+C0GSSef/EKNFJGYlf6qBN+XPio3XR3zI9M20kukw3/gxEm8EanSJbMK3DWRY5qiC4xi4Y94Rm
	WfroyUlrMsVhyT1fbKZV91NWEal3vg2d7QL+ag2BLLqnd7mbCrQ2Lin4GgX7jukZ6OHC18QB0ZL
	jsMtVxW7d+0ZoVv9s+quKwN3VdmBE44PpQRvQ4Ffci0iWxHr5N+chvJM8E9roTAbWuRbx0UJ9tb
	aguCDXlUxJsnJuI6dEmDoL/SsZxHURl6o+2vZgCHy7mKZBTvVE3gBXRcOu54LTY82ezlirIJ/O1
	hIkdSlziJ6Wj4RCSEFQglI5LRjQuES0fdo8hBIPfJ0LbnnRRV9pdsPzgddC5I614tOq/iOb/wH0
	0CXJ7JF3AlZ818P07hLV9O67hNjMbboym3Uh30cas=
X-Received: by 2002:a17:902:ccc7:b0:2cf:b9f9:18bb with SMTP id d9443c01a7336-2d053552de6mr55707305ad.4.1785665737867;
        Sun, 02 Aug 2026 03:15:37 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-27.dlp.protect.broadcom.com. [144.49.247.27])
        by smtp-relay.gmail.com with ESMTPS id d9443c01a7336-2d04b17053fsm6200225ad.54.2026.08.02.03.15.37
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 02 Aug 2026 03:15:37 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pg1-f199.google.com with SMTP id 41be03b00d2f7-c9c26587e67so2154669a12.0
        for <linux-wireless@vger.kernel.org>; Sun, 02 Aug 2026 03:15:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1785665736; x=1786270536; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1lDhnz0ePlnIggUFM9dMYWIu/4DcgouywlgpSKZ0Fo0=;
        b=RzPYTaDaEAtWfHQ1MtPCLY9UeDr4TDtbRLBMXLeznFenABMgzjI7WiwcXCUwkEbhGH
         2KSWQLU48MxEvkk2JFyf0H1LYjPAkeF23MtwRc3d1RgI/aqaLVfRAwQgfFDYL033Ob1Q
         dv+aiWA2HokC0BibmGqWu18Hrmm3mvb0iijAc=
X-Received: by 2002:a05:6a21:e598:b0:3c6:6f25:594 with SMTP id adf61e73a8af0-3c91aa0a4f5mr8073841637.38.1785665735750;
        Sun, 02 Aug 2026 03:15:35 -0700 (PDT)
X-Received: by 2002:a05:6a21:e598:b0:3c6:6f25:594 with SMTP id adf61e73a8af0-3c91aa0a4f5mr8073833637.38.1785665735336;
        Sun, 02 Aug 2026 03:15:35 -0700 (PDT)
Received: from bld-bun-02.bun.broadcom.net ([192.19.176.227])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3153dd9be04sm24193719eec.9.2026.08.02.03.15.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 02 Aug 2026 03:15:34 -0700 (PDT)
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Shivesh <chanelshivesh@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	brcm80211@lists.linux.dev,
	brcm80211-dev-list.pdl@broadcom.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 0/8] wifi: brcm80211: performance and stability fixes
Date: Sun,  2 Aug 2026 12:15:30 +0200
Message-ID: <20260802101530.4028803-1-arend.vanspriel@broadcom.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260731160646.3812-1-chanelshivesh@gmail.com>
References: <20260731160646.3812-1-chanelshivesh@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

On Fri, 31 Jul 2026 16:06:17 +0000, Shivesh <chanelshivesh@gmail.com> wrote:
> This series fixes several performance bottlenecks and correctness
> issues in both brcmfmac (PCIe/SDIO) and brcmsmac drivers.

Two blockers need to be fixed before any of this can be applied:

- 2/8: num++ was dropped from the subframe-parse loop. cnt is always 0
  on return, so rd->seq_num += cnt - 1 underflows to 255 (u8) on every
  successful glom receive, corrupting sequence-number tracking for all
  subsequent packets.

- 4/8: pmksa->fils_cache_id does not exist in struct cfg80211_pmksa;
  the correct field name is cache_id so this does not compile.

Beyond the blockers, please split the series into separate submissions:
1. Stability and correctness fixes (3/8, 5/8 TX-stall fix, 6/8 Fixes
   tagged part)
2. Performance improvements (1/8, 2/8, 5/8, 6/8 performance parts)
3. New functionality and comment-only patches (4/8 PMKID_V2,7/8, 8/8)

This makes it easier dealing with fixes that should go to stable trees.
For the stability series you can add Cc: stable@vger.kernel.org and a
Fixes: tag in the commit message.

Regarding patch 1/8: the patch also fixes a race where a ring state
changes RING_OPEN->RING_CLOSING while blocked causes a permanent
netif queue stop. The fix relies on the atomic counter so keeping them
together is fine, but this change is primarily a potential bug fix so
rephrase the subject, e.g. "fix blocked-ring race permanently stopping queue"

Finally, some of the commit messages seem to use LLM lingo so if there
was a coding assistent used please add an Assisted-by tag as required by
Documentation/process/coding-assistants.rst.

Regards,
Arend
