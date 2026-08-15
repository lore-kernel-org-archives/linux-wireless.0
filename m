Received: from mail-lj1-f172.google.com (mail-lj1-f172.google.com [209.85.208.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C0023264DA
	for <linux-wireless@vger.kernel.org>; Sat, 15 Aug 2026 19:06:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786820772; cv=none; b=ZyUdPtCL0cW8TLlLFnh8fxIZYLwhVudqQ6jkjVNmYhRm/gKAg8J6Cn9l2TUfd1zfN8hTmV7x6vAnI3ny/uwpjculriJOuGDfzJ6yF+s48GhUFsxkn/BWUDw9MMGKiuIZAMFe9pLb5PFqTVhgAHOsAUBJGv2qMZaWa40aW6/C+p0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786820772; c=relaxed/simple;
	bh=kc5EjbGES34mSo/y1zV3VR+mWn7CQtser0vdFBZB8mI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TT2Us14NxO34pWDG2fNjJRDg3T6R5Vtxw7xJa+8W8Egyn0fVNbh/pZSue6heiMKOSTgx47l5m4ovCtLStzgXP5eSX5/7M4gdS652CdwhSiENv6OQCQkw985j4eexXmiapWoWdcCZoy4tuftanxGC4tACtbunDbInibGJ15kOcNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=i5T2SPjD; arc=none smtp.client-ip=209.85.208.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="i5T2SPjD"
Received: by mail-lj1-f172.google.com with SMTP id 38308e7fff4ca-39f927721f2so13168051fa.0
        for <linux-wireless@vger.kernel.org>; Sat, 15 Aug 2026 12:06:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786820768; x=1787425568; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zXa2pyaIn29H9lp2gAhozozTffFlsxZSuqo0RAIo6mc=;
        b=i5T2SPjD8Tr9gZeilP2pwgEM0MjcIbRA2pvTObgnEc7MUCF3jwaelySijLLdC/bxNp
         hJjUGAAnXbKZrTrW4vxv1YKLvUpolqdSkwHugEFvXgf4uWVOWuHNyWIJQz3zhVmcKRCt
         Fj0komMBTqZDx1m5XfYC5LkKSHi3HmKkzQKZZsKMY7Rcopue5oNIA2TJEqSL9LkJngI5
         kBkjSl22OxNZEtFYKW6JC6KMdmKjtLe0IRB+DrBdI7jW3guonloiU6lw3AexTYs47Y69
         vvLSd2oE2HEBQYo+PhgUQRiI8J5Vx6zZhYCI9A2LP2ZC1BWrMj0i7OLL7u+1vGExHHLf
         iOWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786820768; x=1787425568;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zXa2pyaIn29H9lp2gAhozozTffFlsxZSuqo0RAIo6mc=;
        b=BTrf+1Bc5peWfvivX5ffndo7Iz6IUcl3lGWkpa8U3hFc+uWT8au8n4EUa/533b2+8U
         NhzQlmXgM19jIay7L5p11M5/puO0WO+w0LAwB7++BNm9l3gpdxUJwzvmdb0w7kW90Pdz
         /rlriNcE5Gbh+Z6Rdprdatpvx8l4TS4Qm+GdFrcd1zOxtgPgeZ8joQsjb/Jc5zXK1SXe
         HzmdXLOBssEfGvx4tWYqsKlPaMulSpVZoAyWnkgbVwffeucLJgMa4DM3zbjBu3wftUnc
         98Lghh/rPb1G//1euXYS5IRmFH0V8CTI5spm6NsYp21ydeUv5hc5Y1UISqIMc62dBfls
         rmhQ==
X-Forwarded-Encrypted: i=1; AHgh+RpFzkChqD+wmWSLNANH1/tfHHP7G0oZd8OXqjF0WV5//tBEjxNlIbPNixYM+tJ74DH41i57eCtwvsrBKWqtRg==@vger.kernel.org
X-Gm-Message-State: AOJu0Yxo1rU/da/2PKR8BzUJgIvEC5R5MV+EbJMM7ArQJs/dFO/6djsj
	vJye0WLXGulFowLLQt9mBZjOsVuGNHylBEOa60FcSF9nDMZqxTPBpmFY
X-Gm-Gg: AR+sD13wZs5mDMFta46/Fhv7be9nSuyJyOkbvdUgfE/tqAtF0wbkrlOUkYASlfdqMoz
	OMx7UZ6we+W43J7At6i7e58PkbJi4ac6EGbs95TNivk+vN3MzOmoJjWx8qLDhNSur75CQOmL/vn
	MZEWe8/OTgSwqE/gHUYIwqm97oJFHMtb3yG9Y3PBLMrQtgKrCvc7ytEd5o3GZU1eQht5QkvAStn
	YyUNfXbj4m7kbnf1nz3HGi3F33QNeKF75pnWSo8OPc1sil/IDW9i1R1tUvXZDddyfkJFP1qHQ9o
	caUIbiR0mtchS2iu0zLIAZRS+/l30/5koDy5BVOTNeN3ecfQAAdLdu4iKO0Z9N+gmu0fqqHsuB1
	qBnyWhMEPxUahBDc05/LqZqKXuFD4FtIEmrEzrv2jHRMCZb7rqOww5JXw9J+I5AN53n7dGRKjuL
	tM6Rf2FxQE0Q2PKu+mOENohZ7vOo106US1as7TyzzvvDK6EbsahdxMx1dX/M+LFxsHTjb75PDxv
	Wv2cuqEzbZOQFntkk0l/KP7f4HTRoXtDGdewBUcmvGTDSJpWqDbPsNUzYU0TT3SMzZJ+BSCsYAB
	xhiSiIaMYFdKNZMTBrsPvnat2Q==
X-Received: by 2002:a2e:a58d:0:b0:3a1:110e:a999 with SMTP id 38308e7fff4ca-3a13280dd73mr14816401fa.29.1786820768303;
        Sat, 15 Aug 2026 12:06:08 -0700 (PDT)
Received: from ?IPV6:2001:14ba:ee:4e00:66c2:a7fd:8a9a:ffb5? (2001-14ba-ee-4e00-66c2-a7fd-8a9a-ffb5.rev.dnainternet.fi. [2001:14ba:ee:4e00:66c2:a7fd:8a9a:ffb5])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-3a130d1b40fsm13859701fa.37.2026.08.15.12.06.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 15 Aug 2026 12:06:06 -0700 (PDT)
Message-ID: <16f4452a-97e4-4aa8-a64b-909334104358@gmail.com>
Date: Sat, 15 Aug 2026 22:06:04 +0300
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] wifi: iwlwifi: fix spelling mistakes
To: Mouri <mourimcbusiness@gmail.com>, linux-wireless@vger.kernel.org
Cc: miriam.rachel.korenblit@intel.com, johannes.berg@intel.com
References: <20260814130246.25259-1-mourimcbusiness@gmail.com>
Content-Language: en-US
From: =?UTF-8?B?SGFubmUtTG90dGEgTcOkZW5ww6TDpA==?= <hannelotta@gmail.com>
In-Reply-To: <20260814130246.25259-1-mourimcbusiness@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 8/14/26 4:02 PM, Mouri wrote:
> Fix several spelling mistakes in the iwlwifi driver documentation
> and comments.
> 
> Signed-off-by: Mouri <mourimcbusiness@gmail.com>
> ---
>   drivers/net/wireless/intel/iwlwifi/fw/error-dump.h | 2 +-
>   drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  | 6 +++---
>   drivers/net/wireless/intel/iwlwifi/mvm/scan.c      | 2 +-
>   drivers/net/wireless/intel/iwlwifi/mvm/sta.h       | 4 ++--
>   drivers/net/wireless/intel/iwlwifi/mvm/tx.c        | 6 +++---
>   drivers/net/wireless/intel/iwlwifi/mvm/utils.c     | 4 ++--
>   6 files changed, 12 insertions(+), 12 deletions(-)
> 

Hi,

The spelling fixes look good to me.

There are a few additional spelling mistakes in the files,
if you want to check them while at it:

   drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c on lines 2900, 4005
   drivers/net/wireless/intel/iwlwifi/mvm/scan.c on line 3444
   drivers/net/wireless/intel/iwlwifi/mvm/tx.c on line 500

Your Signed-off-by could include your full name.

Reviewed-by: Hanne-Lotta Mäenpää <hannelotta@gmail.com>

Best regards,

Hanne-Lotta Mäenpää

