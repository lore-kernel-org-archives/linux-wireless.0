Received: from mail-pj1-f98.google.com (mail-pj1-f98.google.com [209.85.216.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 403DA3BCD0A
	for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2026 20:04:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789416269; cv=none; b=Za/RwTnbIMJdUiBkUrW/VMk8RSS26ET8mclcg1mcouxI0CuvQo4byGUt/ywT74rJSrLiOsK2m7lXzfQR/4wU4E1ykZAOWTXxMTIKqM2+qsaJXKICLjUZYGzhx9MjkSdfI8/NOWorLhxn0m6pL+zitljiGfJw5gpe5GL+qQbSZtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789416269; c=relaxed/simple;
	bh=9K65xndLLRrYwT7rCvaQd1+hBqv//v0SOM13WYuHQNU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sb6siQw2A3BJoO/S1WSi/lOUshHihrj3ckCFv4XJ4A4EFKd0ZBN5UmxZ7zwPR+pLvyFxf7XIvklVAZfEwPMXsAqHdBtfGf52Qf8el2ZXyNMxq+ypTNuFCdOqVqVHbBSggKI5xW9H9kQ4GdR47P4JZD+IkZyHtr+sBvRSJBf2sbQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=ETn6qWzB; arc=none smtp.client-ip=209.85.216.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="ETn6qWzB"
Received: by mail-pj1-f98.google.com with SMTP id 98e67ed59e1d1-381b831d535so6679772a91.0
        for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2026 13:04:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789416267; x=1790021067;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:dkim-signature:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Mf/bi/6NPrPAKOA8SzbYzyoM+XnS0eq5q/YeLsZr41k=;
        b=C1fX8bVMxcdvcuM9GMpLRFnIGk/0PsHyK4+HNw14/TdWNQKQtPQ8MAlElp1WOlufn2
         6VYU5IoiSs3tSeOMyA+Qd/k+33nDWSIz5Rr8k+0WzRAmYZYLMTrVYcunSX/XHb5yDoV7
         /ZSOuRoztNSXmkHl5O3PB9DCqe36+Y/jLw67x8gofNdGTV4gdWKioa4aKoEIFeqJKCH8
         TUh8h0PGFyJ5L84/7ojSAAOzlOP8B/VDTXTK8vlYB1dzBPimrYm8ZwbE2m5SjyM/xxXW
         grAlvZE2aOOCcopMXMQxoKcdNHF4RxCiUZ+wLuuC7k/VChZ/CPBe9FeTGH993tqfyQMv
         gZHA==
X-Gm-Message-State: AFuF++m+JEG76UVXKptTBbw28mLUDFYToJGrLQfo4ZwfLhh8Bh+lwoGw
	3CBtqMRn57L9Yb+AdGR3DF0u64qsxPXNMv7ltS82GR8WWvFeSPYgzRjd6Ne8L1gNBSbfKT/hbgL
	sMqdNEEmLfywes6q3ttq7I6kxXk2NxZ+0mjzmI2UbG75WkqL7WscNZwvKIQiLPLaiMGVBDKYSJU
	Sn0qRo1pNgncfdts0frY1KRU5vYZUsBgfJNuohKnJLP7Yy7MSD5EKWob88tTOuCJ/rWArsvVYNn
	KKWhcp7TNmGH2rRMpxNTKl9GSrO
X-Gm-Gg: AYBFou2A/nVggHbO7/hHmnolPOBZ7qNQOX4IPJmDnmXQi8+5fxd0wOu+jXZcwhipQsE
	cAuVeSfal2cF19ZRlFXmqqOBLOsJet9WBDUHI0xE1TxvrFvWmUvtqfli3RMCLq0eRWHpMoD7X6C
	FWx/Amf98LLi3eQQYqfLmDIFUZRRgfUq9siVWawWKWzx8vL9k9ibWR4BDKA63WccgYSeCriY6o1
	Yah/KCHq6TOG7bgp2kvl/4//jO/Sn0CSJientPvf0JiAKyNWWqreZXRPujqZ5K/PdJp2Cmjy7n/
	zx3Q/4JRD9XigE3EWMbkWa5Dlm53as5+78qgw1wFzUCDRbBIdW1RKZaAcjyS3geCx5s6ZMaNodq
	Q70sOzlUfuTWBShJ9dzdCTyjZNxmDDzmE7o0ECNj+2pRne9aJRB1zqDmUwrQyLCN8GDaaktTkza
	hyuiWFHKJZ6UpEsrV95gm8JnkkenQ7bMLOtPt8//Q=
X-Received: by 2002:a17:90b:4c88:b0:399:ecd:d68d with SMTP id 98e67ed59e1d1-39dec0e0267mr7803840a91.22.1789416267367;
        Mon, 14 Sep 2026 13:04:27 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-25.dlp.protect.broadcom.com. [144.49.247.25])
        by smtp-relay.gmail.com with ESMTPS id 98e67ed59e1d1-39dfd76c1f7sm306254a91.0.2026.09.14.13.04.26
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 14 Sep 2026 13:04:27 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-90e8dd8be81so48263176d6.0
        for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2026 13:04:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1789416265; x=1790021065; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Mf/bi/6NPrPAKOA8SzbYzyoM+XnS0eq5q/YeLsZr41k=;
        b=ETn6qWzB9bH9aa2Xbxj7WUMY1VfHQ+i/uJ3XFXhds2KcxTkiH5xeYHGUC9rdV/eHNi
         PHECbW4t+48W7JBfPHTNOzAjUgrstjFE7E2ahsVfhIHnkSHHOIGlg0YfBkqTb1edPIst
         sM7Gk2MjgoAJ4hKepeyCFrlEC8vi4f3xd5r1I=
X-Received: by 2002:a05:6214:4709:b0:912:34c4:92ec with SMTP id 6a1803df08f44-91234c495e6mr9907096d6.26.1789416265464;
        Mon, 14 Sep 2026 13:04:25 -0700 (PDT)
X-Received: by 2002:a05:6214:4709:b0:912:34c4:92ec with SMTP id 6a1803df08f44-91234c495e6mr9906166d6.26.1789416264798;
        Mon, 14 Sep 2026 13:04:24 -0700 (PDT)
Received: from bld-bun-02.bun.broadcom.net ([192.19.176.227])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9120f47a6ebsm103068516d6.22.2026.09.14.13.04.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Sep 2026 13:04:24 -0700 (PDT)
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Jason Huang <Jason.Huang2@infineon.com>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>,
	brcm80211@lists.linux.dev,
	wlan-kernel-dev-list@infineon.com,
	Carella Chen <carella.chen@infineon.com>,
	Arend van Spriel <arend.vanspriel@broadcom.com>
Subject: Re: [PATCH v6 5/5] wifi: brcmfmac: advertise firmware fast roam offload support
Date: Mon, 14 Sep 2026 22:04:15 +0200
Message-ID: <20260914200417.1744264-3-arend.vanspriel@broadcom.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260911065656.1269623-6-Jason.Huang2@infineon.com>
References: <20260911065656.1269623-6-Jason.Huang2@infineon.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

On Fri, 11 Sep 2026 14:56:56 +0800, Jason Huang wrote:
> From: Carella Chen <carella.chen@infineon.com>
> 
> Advertise NL80211_EXT_FEATURE_FAST_ROAM_OFFLOAD only when firmware
> reports FBT or OKC support. That lets userspace provide PMK material for
> firmware fast roaming without enabling the path on devices that cannot
> complete the offloaded roam.
> 
> Assisted-by: GitHub-Copilot-CLI:gpt-5.5

Acked-by: Arend van Spriel <arend.vanspriel@broadcom.com>

Regards,
Arend

> Signed-off-by: Carella Chen <carella.chen@infineon.com>
> Signed-off-by: Jason Huang <jason.huang2@infineon.com>
> ---
>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 4 ++++
>  1 file changed, 4 insertions(+)
