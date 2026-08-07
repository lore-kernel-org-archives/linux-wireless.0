Received: from mail-pj1-f54.google.com (mail-pj1-f54.google.com [209.85.216.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EE9646C4D2
	for <linux-wireless@vger.kernel.org>; Fri,  7 Aug 2026 08:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786091194; cv=none; b=YlbgmYtOYmQpFZR33+8xBCFIP3Uu1/trjq26KFir/vZLdyiNNDN5Q+oRsV3tk9jQHDOYtkqYFLTQrSuyRm1yT+zzljuFxbBJqEnfCaunaC3dlE6a8hh+Fc0gRHFLyE0/OXs33d2qcQ0UbQvzQT/iDJ1mpsXjwoS8oQcfPHz8tWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786091194; c=relaxed/simple;
	bh=StDQICSSTYfrDyqy3wyl3t6MvwAR/CjM2yoIGOCA/eQ=;
	h=From:Date:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AXM6/Dyn6sd+RAq6wGc84hxxNY/p+/XzCp9R0Qhgkaamz3ItPzAuYrF8QlxZ1ktA5A+i6tIIHVDUHkEyN93p5iPQd9hhfwbMzhbKnkCI5af0+D6ZmMYv00P5z9fm37Nw2CwayhY2M0i9kKL2b2hXPqWsCkTvpKEbNDgm+7oorQs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Odm4ol7y; arc=none smtp.client-ip=209.85.216.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Odm4ol7y"
Received: by mail-pj1-f54.google.com with SMTP id 98e67ed59e1d1-38125cebfdaso3883457a91.1
        for <linux-wireless@vger.kernel.org>; Fri, 07 Aug 2026 01:26:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786091191; x=1786695991; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=rzU8xub4Kt9oAWjkKq11oBriTEMhTM7pr8/P/jz7Ayw=;
        b=Odm4ol7ydpAVlxv2Tu8JZC5PtUTYXy2PRWIh4qlj7UtHSYvQgOnFW8v1qjCY1COJyF
         4BfncxHQ8bEf0F5B9vGRmqPMfsHvtB5ucGtpfd+tqWvks/b7FcN/6OKJFbzxNjBpGLbr
         M/rgtprpheYpi8pJwShXwaTs7IKyuSHJViyo+d2QO5CmDiTSMwSrjEZSPtzDKsYKxZcy
         mLeloD7Tzemgivpy5Qk7btRbxhahPfcJ9jhI2KGpv/F2UTSZxNO+YQX/eHqTliMlpddE
         /dqcJx3BHbQ7kZwc1bfUafZgoTPKi/u+7h+/GTdcAFXSJ1eD/WZt0CMenjOyFZNzjFji
         w9Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786091191; x=1786695991;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rzU8xub4Kt9oAWjkKq11oBriTEMhTM7pr8/P/jz7Ayw=;
        b=XkZ9V1kdV36QsKWegz0cy1jtvQDQ0LmVpN6pFr+nM7AFkMBdzieQHW+CFSs8FfupHs
         qDm4k+639OgyikTQtDYKC+C27NJBh1K6NeGn7zayV+F+nDjRpnUkHyqC95BqOCWVTyiZ
         F2+vuX+76AkIE9SDSa/pN1W6LvwmhcyV7z1JLCObUJWpOb/hRIcZCCP9CxDXQVk6IIPO
         67VKHZfJHLVDiWO9VLp4GnL7eswpDFpbLq7HBq6SUsjreF/Txb8H1FSMmcf+MZhKnl13
         HIUfyzyB+yn0yqvd0S34DDr4UWQkWVSe+GSdEVF0BckMqgwlgULxAtA0XWy2Vdp8tLAU
         NQ3Q==
X-Forwarded-Encrypted: i=1; AHgh+RoylfKKXoGaBxaF7r8nCbmUrwzl27w8QfBCh1QvPlzkziId5TukkZHGk0Pr4kSNoSO2R9HTXW7ZurqvOyF+ZA==@vger.kernel.org
X-Gm-Message-State: AOJu0Yzd1ZnRQBQTpAtkVfEG05eM+eKhB4Bb/bHt+aI6Efm1IH+hkJVa
	8Kkix77dWeZyBBSw9zVVmyX+PGm6uV8GzIrhjimZl2ro430p941un7R4
X-Gm-Gg: AR+sD13qcMQJgE8PhdC/DDjlhfkT2BExiALz7siOMww7MJwsMRtA00AgAlmcJcmlVKH
	SjXJN0C8fW+vyCc8PYaw9clSeGw5DF0IZF67ZyD/z36eRhZwOh2fCspb/ehHFgYFx9OhlKJvKOO
	l+8XfresWcMHsNhVvw3t521lzAipstHeX1GReWRHwafopcuqsYYRsBMudKqM3ZMvfILUtDVNOE9
	/HdJkggBTPvKz6vl95eid9RqTyZkntx+c/X/z5Cxw6tDRD8s2D+hk32IpxUeGoSeosbcZqOWmAJ
	nDHhGCRla5bS5ZPxqpN+HpQKJ4PGKbXDHByaMjvLuPoid8ZKYdmmeNwv0fu17n38vK7D/uNBRk1
	RUr+U/K2svgy62/IQ8a6LJjpL6uWdBzQUonwpGkkmd0r/DwwDyNmPpf9V+pCcY4yOMyATje9tuW
	Yhsa4gbxPd0wOvY0OgFTruO0ii2W/fe8JEX7rsEBMAjHyY5vW9FKpEFEbzzSmaoA7XvsKQpJS9a
	uzDLkZpvs6CSwcedmlIQrfdcq9AKsis6yiuYHtKFFgu/CJQBh15IYvHKO/Dd/cksA==
X-Received: by 2002:a17:90b:2dc7:b0:380:fead:448d with SMTP id 98e67ed59e1d1-392620e6e25mr2519576a91.13.1786091191456;
        Fri, 07 Aug 2026 01:26:31 -0700 (PDT)
Received: from nxpwireless-Inspiron-14-Plus-7440 (61-228-218-123.dynamic-ip.hinet.net. [61.228.218.123])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3925ff244aasm1558519a91.12.2026.08.07.01.26.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Aug 2026 01:26:30 -0700 (PDT)
From: Jeff Chen <chunfan.chen@gmail.com>
X-Google-Original-From: Jeff Chen <jeff.chen_1@nxp.com>
Date: Fri, 7 Aug 2026 16:26:23 +0800
To: Georgi Valkov <gvalkov@gmail.com>
Cc: briannorris@chromium.org, chunfan.chen@gmail.com, francesco@dolcini.it,
	johannes.berg@intel.com, kees@kernel.org,
	miriam.rachel.korenblit@intel.com, wenst@chromium.org,
	rafael.beims@toradex.com, avraham.stern@intel.com,
	peddolla.reddy@oss.qualcomm.com, error27@gmail.com,
	s.kerkmann@pengutronix.de, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v2] wifi: mwifiex: ignore ROM regulatory hint on
 WRT3200ACM/WRT32x
Message-ID: <anWWr80yAcOQaVVS@nxpwireless-Inspiron-14-Plus-7440>
References: <amsBes9fCF9ZdkCS@nxpwireless-Inspiron-14-Plus-7440>
 <20260731063118.26171-1-gvalkov@gmail.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260731063118.26171-1-gvalkov@gmail.com>

On Fri, Jul 31, 2026 at 09:31:18 AM +0300, Georgi Valkov wrote:
> WRT3200ACM and WRT32x routers always report a fixed US regulatory domain
> from the mwifiex ROM, which conflicts with the platform regulatory
> configuration on units sold outside the US market. For example:
> - phy0 mwlwifi 5 GHz, hard-coded region 98 EU mapped to FR
> - phy1 mwlwifi 2.4 GHz, hard-coded region 98 EU mapped to FR
> - phy2 mwifiex 2.4 and 5 GHz, hard-coded region US
> 
> When the system boots, it detects a conflict between the user selected
> region and the radios, e.g. BG FR US, and applies extreme restrictions,
> preventing use of 5 GHz and DFS channels. This also affects phy0.
> 
> Ignore the incorrect regulatory hint in the ROM of these devices, so
> userspace can set the correct platform regulatory domain. These radios
> are locked to the hard-coded configuration for which they are certified,
> so the only impact is that the region conflict is avoided and the 5 GHz
> radios can be used.
> 
> The change affects only WRT3200ACM and WRT32x routers, and helps
> overcome the incorrect behaviour of proprietary radio firmware.
> 
> [1] https://github.com/kaloz/mwlwifi/issues/173#issuecomment-307879699
> [2] https://github.com/openwrt/openwrt/issues/9956
> 
> Tested-on: WRT3200ACM, OpenWrt
> Cc: stable@vger.kernel.org
> Signed-off-by: Georgi Valkov <gvalkov@gmail.com>
> ---

Hi Georgi,

Thanks for the V2. The updated strings now match both environments.

However, checking board-specific DT strings inside a generic peripheral driver 
is still not a good idea. 

Since you asked about a better approach, why not consider the solution 
mentioned by openwrt-ai using the "reg_alpha2" module parameter? 

If OpenWrt injects "reg_alpha2=00" via a modprobe conf file under 
target/linux/mvebu/, the ROM regulatory hint can be overridden from userspace 
without needing any hardcoded logic inside the upstream driver.

Best regards,

Jeff
