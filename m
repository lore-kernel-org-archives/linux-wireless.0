Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F24CF1A9F88
	for <linux-wireless@vger.kernel.org>; Tue,  3 Feb 2026 11:40:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770118837; cv=none; b=RHf1EPGFX1xUJHYAULjt7Dk6w17C5jjLyJQJSygTtV0rEGm8uqwgCQfyMYQAc/83L4BFrosPaA8/+F9F51pYXK3mbeuwZhFQvLeI2u2UGMnzLTcg9LRS8MR1Z7KFebOB77SV53n+NgzQOuFWSolpqB/VQw0+gEU4OUz8pev1LHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770118837; c=relaxed/simple;
	bh=72KSh0Gn/iKkBUQGK8XEpptvUQqVnIQe5e/2wXusc+Y=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uh9WcUfcj41qoeK9ha5ch2FdG7tcLYE5SwueEHuJVygUS39BNrp8EHX8atUVbsDYYYWdOQfRbFtXPkTk8Wopy24pSN6DxjaLSyJWp5Qd77ZttE9XYvBI/rBLY5LtyX6baxBYs7ejHHz0pUSMmafVUlk0etWiAdAWYZpn8T9G0Ec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com; spf=pass smtp.mailfrom=morsemicro.com; dkim=pass (2048-bit key) header.d=morsemicro-com.20230601.gappssmtp.com header.i=@morsemicro-com.20230601.gappssmtp.com header.b=AInPQ/Dl; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=morsemicro.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=morsemicro-com.20230601.gappssmtp.com header.i=@morsemicro-com.20230601.gappssmtp.com header.b="AInPQ/Dl"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2a0d52768ccso37412775ad.1
        for <linux-wireless@vger.kernel.org>; Tue, 03 Feb 2026 03:40:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=morsemicro-com.20230601.gappssmtp.com; s=20230601; t=1770118835; x=1770723635; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=1pcnAIim8KDbS40sQcNL5CYzieFLbFWCHWV1DC0gjEY=;
        b=AInPQ/DlpNCJqcbHJRfIrh9qc/oupBW6EwFZgTcjsAzbKmGb6bgh0lFiBPT5x8eyHC
         fJyN8NfvabO+3+zLFzocKzrMIiUpym4cJ8VFCkknAwMT7YBaoSGrk1dzjOzXXubWRP4Y
         NGyXOVefgvwY7yvjOUj/ADy0bwLniTCNRnffpmDBaUzp3lzwiCe4ao+Bwrh/LSsEe/uT
         U4Mwpb8F7/pQagd0HhpGzjfN2IWG665PIEhEcqPBca/xkTOTryv0mP2SF964I17SwDn9
         aJfvBXFLQTSXwcb8e6cwZDi9WX05sqCw139M3vWPMd8H/E7Gon/DaZj2m5tfOCI0JgEb
         cDwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770118835; x=1770723635;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1pcnAIim8KDbS40sQcNL5CYzieFLbFWCHWV1DC0gjEY=;
        b=KX2CSz4Sqsa42B+ZZ5VaP8h4zQdoyIq/a5uMpnpBlEZCtqjKhzYA7l721eWlKh9Izx
         L7ga6dSGU5urmHkcZv1wTp54RguRg5KlmJ2H4qao7RXUQK01PdfzRH4sHGYlBooCaf/a
         AEFluFQjdCAAAb/QGzgH/zUPfR3/kvZPZEEH2n3ZwEp9+nllvPUiccJUDprqoAot58H/
         z3NDNXtUwOPmEYLapEjiaYA8Rs5AAL1RyNwdmfmO01jrF7gEMS6C0VsnDC/oroJNkoJm
         W9gCFy3I38PNBUN9VFgdztwpf03OMV2xoiq24abvDkvTCu0sp/gmSF253KoLF0p4KBI3
         gRoA==
X-Forwarded-Encrypted: i=1; AJvYcCX+248prUrjX3bgod9f02YlBRofvQQWZEXORe4uHInN+xHGvaqsW8OZpQ9HIspLO6mvrNANxHZhMf/P8WN+eg==@vger.kernel.org
X-Gm-Message-State: AOJu0YyJf65geajJoWNrJlnVxRrb23AETvMwgSAVutHx5U0jg5GKJkml
	QSuH/1nKzeiTnKCM9FogIPQP7nWBeVbey99BCgFTiPiAoO4RjENzXau5r2qDKrmySgfk7Bsta6k
	I63Kq
X-Gm-Gg: AZuq6aKLLKQ6VBWYx9jec+LtJp+wMcijuXFsXfdzf/CyQLXB3dKvwmaZDxoSrR2KUUG
	RGcyJhhZkqKqLLanPEGh2B7pjeJ25hrT5kOQxm92imNFzyxHzx8dkTi8GJWR+8YkK9kREd+IHrL
	1hz/yoq5GvGP0iIlr5SBTYysz3LU6oo+On4JKLl4+4y3l7cPOb/Fz2/oDCMnhVNraiH0bqHNNmR
	dTg7ax3ujod9eZSiHe1thE845B6QH6t0qzQTaI1hokbVgV+0zzf5DDHw4yt9/HHrIlR++6VDtPE
	HhbG7yNu5k/x/QVFJSQBZuPLF0K7q/TK8YDTZySt34lZWY7cy6oUqCNs7JicPxPXc9y/TuGpHCI
	8CgkempKx6+I1ryuqFTZG7iXpuElxQNY0cjbkSSPuuWWegu94hW7i7OyhPg0oppk26FuxJF9qYu
	wSZJ1XJSe0MSr8OO57T3OJyV8NoUBIOlsZHNIavt9NPx4TNJSzWvtB
X-Received: by 2002:a17:903:2442:b0:267:a95d:7164 with SMTP id d9443c01a7336-2a8d9a7e152mr137748905ad.60.1770118835162;
        Tue, 03 Feb 2026 03:40:35 -0800 (PST)
Received: from localhost ([60.227.219.135])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a88b6e75aasm176218645ad.92.2026.02.03.03.40.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Feb 2026 03:40:34 -0800 (PST)
Date: Tue, 3 Feb 2026 22:40:30 +1100
From: Lachlan Hodges <lachlan.hodges@morsemicro.com>
To: Peddolla Harshavardhan Reddy <peddolla.reddy@oss.qualcomm.com>
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 00/13] Ranging support enhancements
Message-ID: <gxhpubndywl7jrqb6rmvta7yzcyid3drr5jtsz6xfiel7aiaig@q22wvfrfo3ik>
References: <20260130160039.2823409-1-peddolla.reddy@oss.qualcomm.com>
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260130160039.2823409-1-peddolla.reddy@oss.qualcomm.com>

Hi,

> Peddolla Harshavardhan Reddy (12):
>   wifi: nl80211/cfg80211: Allow RSTA role to be enabled without LMR
>     request
>   wifi: nl80211/cfg80211: add proximity detection capabilities to PMSR
>   wifi: nl80211/cfg80211: add continuous ranging and PD request support
>   wifi: nl80211/cfg80211: extend PMSR FTM response for proximity ranging
>   wifi: nl80211/cfg80211: add peer measurement abort command
>   wifi: nl80211/cfg80211: add role-based PD peer limits
>   wifi: nl80211/cfg80211: add ingress/egress distance thresholds for FTM
>   wifi: nl80211/cfg80211: add PD-specific bandwidth capabilities for FTM
>   wifi: nl80211/cfg80211: add FTM range report negotiation support
>   wifi: nl80211/cfg80211: add result reporting control for PD requests
>   wifi: nl80211/cfg80211: add MAC randomization support for PD requests
>   wifi: nl80211/cfg80211: add LTF keyseed support for secure ranging

Could you not just have "wifi: cfg80211: ..." for each commit? I think
having both nl80211 and cfg80211 just adds unnecessary noise when
ultimately this is all within cfg80211.

lachlan 
