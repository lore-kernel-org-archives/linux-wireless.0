Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53AE23B14AC
	for <linux-wireless@vger.kernel.org>; Mon, 21 Sep 2026 08:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.227.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789981184; cv=none; b=RnqKjv856clJPDZ0mDCxWw5Bjogmjf8jH7HlEu/V7XjgT3QkDcpTiZUTq+VAEn3+rhMD04/V3ruaih9yEGihszR0JbI49X10Xj70uGFSK4OpjJLqCl/qCa5Qm/k5d/8SQGtNnGh1xgr39yOVtBNmXD8cvAdYPZPczcgXrFbwS24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789981184; c=relaxed/simple;
	bh=g2PzXxo1nAfiLbbWF0TW7v6I7XOSfEg0vPe+YU/85Io=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ofTNfPr+MNkld5JYNVV/td5FiFAcC4DqxVNccqDp2gEfoMPSvQ/knxZCJ/IhTeDXovpoz95nGKOM8O4vk7IeKGRxGexFakn3qG0oQyuab4ktcBx/zVvGgvcBe16DFHXBMrkmg6pge2JycTNMBbTzwRSRGGUmj6VgVmmvsNK90tI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ve67i/Jf; arc=none smtp.client-ip=74.125.227.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ve67i/Jf"
Received: by mail-pj2-f12.google.com with SMTP id 98e67ed59e1d1-396ccc09d65so2483754a91.3
        for <linux-wireless@vger.kernel.org>; Mon, 21 Sep 2026 01:59:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789981182; x=1790585982; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=w1PMcAHhFfs+SSNmNZjsu4ds+YA4TIgtvu8dO0EmsxI=;
        b=Ve67i/Jfw4Y1v/OvHNhKATjTTr+mWvCWFPIjYEoag3bJVQH2Flx8Nc0np8yZG2If6r
         8hGRMi0F4GyX6qIhG1pl7Y9KyoDpVUs1ufQq7pmvgNzWMePDpoL4jKH29H1mvHgI/wYf
         sjTydgiJeJ5ydhdXQZZo7EHXMQsFrFik58pp5Zmb46pHeGk0fhrwsJ8dKrg8FPW6Pmek
         4ooPCkyRCO036wg9DosmfAbqP1uIpmhgJdlSyc70sUw4xgF0ImE2XLL04XksuatyLB8g
         E1R+HoBWmbXvXnit6QWMOIvqVHnQpwxCaU2tU3QjIipOu3mt+tEN1sStm8GI64EpYCZl
         t9dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789981182; x=1790585982;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=w1PMcAHhFfs+SSNmNZjsu4ds+YA4TIgtvu8dO0EmsxI=;
        b=ci8YMe8jk3o4AoVulTAcXIMV5rwdJwaPug0V1uhZUfidNZzoYeyg+PI+ZgO0IDVgN3
         v2OztL+R4A/r2UqAIdIBCG+6zrVbwaKKKWO4R+squjbuMfT8V+2CP9oLwIe+CIaa6KvR
         HbXGuPfU4cezmxsxc2zJXhnpYsHV1WGXEr6TuQIb5XmyxC6h8tnewjttpH/mxH9rF4EZ
         Fqx5MD6CzUXriJPaxc8ueRuAfXCH7kdOhvH1wRQyBe37qrtXmRP1qQVwjWqGyAizMtH5
         aGzEKx3IjlnMoEnicuKkpea43ljgiTd993dMitvMo8m9kkn7lppnAuJw1aUjqGmtZgbU
         iieg==
X-Forwarded-Encrypted: i=1; AKwUvBzNt7GNqPlx2jkLoaBATI0Vccz/3ZMNs7YOgcMCbC0Clt2D2kkPTPgrGAiqBnVkONLQwPT2htbIrhjrarq46A==@vger.kernel.org
X-Gm-Message-State: AFuF++m5x5fG3asd+OqusUuoc0k8ZUDdXccQ+olgxPCUvC2U4qefhO81
	ZOGTVeHXl7rwKh/redv53/UeUr8SiS1jvI5tA2HZw6/EkRbIH2JWFJzccGnMk9cn
X-Gm-Gg: AYBFou20hwXHvlhVecLAu7RhHkHMgYKosCN1J8YmFXjBsIuIb8qkuChmolNqDdCeons
	4FZbaTGwPoco2sdxEB5eZ0CGbeLXkwdoYU0pajzCYjvWDAG/ccYSeXkLUeITuLcieYI4BPCtEZu
	Q3bFIe+x7MHlV3h16/M84sAK8GifotElwPxB1/Y+6ggmXENNSA30aYBkpSAFEtXyTAvCGoh3cfq
	W5cjWyTUPRbivGYgjW+OeLPyU3v27WCNh5xjL7k5jjne31LXaUwnXRTQrwCLAHp2xHnbtRY56Lz
	V2TpMYozPEoaoEOewjm2axAOhHvH2HNPMfNQZkmgYtEirM9gyVJw3kZ/geP8Y1COZEfMgcKjzdR
	lSIgkKbM9PPJRSkdbVcbSSyp4cou6KWfNZguSdM6A+V7EEJCcPlbBifwStRuR+JdJNznn3T1Rtu
	BmZx1ovrN8nUl4i/vkwFaCOSOqBhYJXYfWzzy6cbGlJ4wR6hh+tyHMJvGD5WovGJ/HptHdNs7pb
	EZTJAyI6mm2nCexSrIvzrzogH92HmcbkqOrA3Notw5W86P2Mr9TuReMuko4v2u1IlO2y90e5wBe
	Hsv9Iav9BjM=
X-Received: by 2002:a17:90b:2584:b0:39e:6c68:c787 with SMTP id 98e67ed59e1d1-39e6c68ca2emr9039676a91.61.1789981182536;
        Mon, 21 Sep 2026 01:59:42 -0700 (PDT)
Received: from nxpwireless-Inspiron-14-Plus-7440 (61-228-227-192.dynamic-ip.hinet.net. [61.228.227.192])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39e6ca50118sm13589453a91.4.2026.09.21.01.59.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 01:59:41 -0700 (PDT)
From: Jeff Chen <chunfan.chen@gmail.com>
X-Google-Original-From: Jeff Chen <jeff.chen_1@nxp.com>
Date: Mon, 21 Sep 2026 16:59:37 +0800
To: Heyang Tan <thy15333007817@163.com>
Cc: francesco@dolcini.it, johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/2] wifi: nxpwifi: bound debug info output
Message-ID: <arDx+VzL2IVXeZPx@nxpwireless-Inspiron-14-Plus-7440>
References: <20260919040253.590-1-thy15333007817@163.com>
 <20260919044439.1042-1-thy15333007817@163.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260919044439.1042-1-thy15333007817@163.com>

On Sat, Sep 19, 2026 at 12:44:39 PM +0800, Heyang Tan wrote:
> nxpwifi_debug_read() provides a PAGE_SIZE buffer to
> nxpwifi_debug_info_to_buffer(), which formats debug state with
> unbounded sprintf() calls. The same helper is also used for the firmware
> dump.
> 
> Pass the output size to the helper and use scnprintf() while formatting.
> Clamp the debug table counts and window size to the backing array lengths
> before accessing them.
> 

Reviewed-by: Jeff Chen <jeff.chen_1@nxp.com>
