Received: from mail-yx1-f99.google.com (mail-yx1-f99.google.com [74.125.224.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94CFB42BC50
	for <linux-wireless@vger.kernel.org>; Tue, 28 Jul 2026 18:23:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.224.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785263002; cv=none; b=Sqjf7QidFm/O2oparol6n07klJfoZJvw1931yvOD2z0DopYeQP7VX+yoWgnSh1HTyGnHz16605XzL51K0k8hYT/Y7remaZ51qtPtXRlFYr2DQ9FxG/ubl5LPaw3I396FmPr2JRk2D4byK3s4rA0t4uc6vxw8M2+3YJfdw64SeGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785263002; c=relaxed/simple;
	bh=2ZMnfh2gm+z7DwlJzwXN+9iisoM++fsRSpgPAXHMX9o=;
	h=Message-ID:Date:MIME-Version:Subject:From:To:Cc:References:
	 In-Reply-To:Content-Type; b=LzyhDCMFVXglmQSsPcJjrgAQYX7i/C8TTHdC1m3elypIujqgfOrhiHqXaRDMW/0T09x0G245M34Bw2V1NwzyQX7YDR+YbcNwoyWFWReL+P6aOuRk5SJsZyBE1laGveaO67VUodFthk1M/o1VzWkY/RRmom0aqmkeLMLC8RiwxIk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=KldYiSZY; arc=none smtp.client-ip=74.125.224.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="KldYiSZY"
Received: by mail-yx1-f99.google.com with SMTP id 956f58d0204a3-6681e7911b0so5863048d50.0
        for <linux-wireless@vger.kernel.org>; Tue, 28 Jul 2026 11:23:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785262999; x=1785867799;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:dkim-signature:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=o/vhj2pW8AaAC+A8m3nnuIMt5Yp3qwZU9C2fvtKyLjE=;
        b=dn8LCPbX26EWXVfyJsixAYgQO0gcLGbATgiPMsWnI6dJDMicf/LbbUp9eZwXDSWCjz
         rjhqwRdV8Nc+gsyxqP7CAZtNj9gQlDqrGGJGzZBzCVzehycYS/SsnYmhK41EGujgWBQV
         mJjvdcuNGJCvlLewu9oyu+9MQx6XyRjkgRpxjoyJ4R6XkWB/467pHIG2AkFDTxAugO2m
         TDEBTAudjZinNdb7J4fP1085SyOXMd/MYRrStlrBfyosnfXTjSVZpt+lhGDP7uY7HOgj
         e99MJ5NkvV/RBitu07C/DhxSYTRSVzDdZxAu5ifQux5K1S4xlIXUfyHhXOhXQi8FkHJR
         otig==
X-Gm-Message-State: AOJu0Yw4by0D45D8vkqZ5/73HzGijcpPp9ByjRNSXL60o8F78iaix7Ly
	WIXUjT7qp19NC/Ie/a88YHiTMgFWTAUCl0ruxq1bR6WpfKqVsAN6QAN1UK5k2ntX+KKBCjMdzYk
	2FQDZ2B+nyXbN4rHP51UDrm5rH+cJhndKo5+tJylZWQNcQpv5yIw7cSLusyLGpiwOVMGSgC1IWt
	nSTORM5g1G+zThoZqCpOEYtxBIlPI24yiaWWW6G7DslzNakPqqhAFZN5NQPuQQqq9A6D+/QfCps
	01J3y18mVWi7GRkEdQjc/I/cEqZ
X-Gm-Gg: AR+sD12F0OiWP/ad+YmnN/E/R15WjdnbEFQr5LMHRbu8b3W+USzO+7ACxVevMqAjgIZ
	GXkbDUjFvJ98sLUzkGWq6uEWcxkJw3kJdO+zfr+/pw4q4N87t+UfRoiSym6TpUau2lRnGj+ueJZ
	fPJxBwyKPjJpaefEKPoxB5X9gaPc3z4D8LPwbdwy/KySbrE8SvVhTCZtrFLYp4DrqjdflMnhYy6
	9pkxupMFakxGZivuCV/G/4HYL3ZhCdVT5Qd6HDBtcHNgf/Xw85ICVNe64wKPCFfwq0L7Jh0Rs/N
	nYh6RV5ivtLWTArWdRNGkfEwFDrR8xL2oIgHHxvbp89vhWPZBoycj4zX+hOkg6qqCbHGbbRVNvC
	ldvIlYOzLiBy8A0S90BDheqMekPJfc3iMkzTFnn1IW9E4LLTbGfCwEl3d7BCsJEgg3E1iL4qgjV
	rtgIsjujcvyqf6W9rb3qv42VFV+QsCtlzemDvYDNc=
X-Received: by 2002:a05:690e:43d3:b0:667:c766:a3ce with SMTP id 956f58d0204a3-6690580e99fmr1031753d50.86.1785262999346;
        Tue, 28 Jul 2026 11:23:19 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-26.dlp.protect.broadcom.com. [144.49.247.26])
        by smtp-relay.gmail.com with ESMTPS id 956f58d0204a3-6691263cfa5sm28372d50.26.2026.07.28.11.23.19
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 Jul 2026 11:23:19 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-388cfc4848dso149181a91.3
        for <linux-wireless@vger.kernel.org>; Tue, 28 Jul 2026 11:23:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1785262998; x=1785867798; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=o/vhj2pW8AaAC+A8m3nnuIMt5Yp3qwZU9C2fvtKyLjE=;
        b=KldYiSZY4S+T9a/Qp2Qzt0LBXw7U0DzWQv/6Fh8ziWtWrYeRKlbKbxNjHZ/he2wrpB
         GzmcRjyksdtM6fFIDgRlznzJKNhOgTdgDkk41cFNAFyLiCCRawwUg3hX5vS9Hj7lW1AY
         3nJryLoHe3c/wHiTPrwB5xsrK5+2G6O/pFrCI=
X-Received: by 2002:a17:90b:50c3:b0:38e:408:9d7d with SMTP id 98e67ed59e1d1-38f6a4acbe5mr3757848a91.36.1785262998049;
        Tue, 28 Jul 2026 11:23:18 -0700 (PDT)
X-Received: by 2002:a17:90b:50c3:b0:38e:408:9d7d with SMTP id 98e67ed59e1d1-38f6a4acbe5mr3757815a91.36.1785262997482;
        Tue, 28 Jul 2026 11:23:17 -0700 (PDT)
Received: from [10.229.42.78] ([192.19.176.227])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-31504dd42a9sm1193748eec.30.2026.07.28.11.23.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jul 2026 11:23:16 -0700 (PDT)
Message-ID: <2f901fed-faed-48a1-8f98-d2252576394f@broadcom.com>
Date: Tue, 28 Jul 2026 20:23:17 +0200
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH -next v2 00/12] wifi: cfg80211: consolidate cookie
 assignment for async ops
From: Arend van Spriel <arend.vanspriel@broadcom.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, brcm80211@lists.linux.dev
References: <20260728144549.2207061-1-arend.vanspriel@broadcom.com>
 <03bb72fdab133a4efa84bd57cad966d222fadb73.camel@sipsolutions.net>
 <19fa998cfc0.2873.9b12b7fc0a3841636cfb5e919b41b954@broadcom.com>
Content-Language: en-US
In-Reply-To: <19fa998cfc0.2873.9b12b7fc0a3841636cfb5e919b41b954@broadcom.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

On 28/07/2026 18:39, Arend van Spriel wrote:
> Op 28 juli 2026 18:18:48 schreef Johannes Berg <johannes@sipsolutions.net>:
> 
>> Hmm. Maybe it's not too hard to update the staging driver?
>>
>> https://netdev-ctrl.bots.linux.dev/logs/build- 
>> wireless/1136007/14715755/build_32bit/summary
> 
> Dunno. I didn't look in staging. Will dive in.
Indeed not too hard. I will fix it and wait for couple of days before 
sending out v3 to address any comments from driver maintainers (if any).

Gr. AvS
