Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793366512;
	b=NrUV5wjDRPZNJl/vJroQJzaV8QonWCY9U0Q8hB6fc14mXmBcN1sXXNQk/Bq34bCEEg1K
	 AFlpMxxRZFoJokXD6u+IBJKutxemBaQBfGr5Znqz37gF6XJXmkCu2f5fwdJWCCkXwVSnn
	 4kfINVWFcg9SX8nyz8DumR9oxeDjZ0Focj1FZByVdp/yaGpG0uNek4iFtJqRzNCTW8pqt
	 KESwsqmMm6mUZgVJSam+nsNb+C510tmjQorwgiusmeWfLdsAGDswX656UCflamawb6vg3
	 jMZ7J6jE80BKsPwqR24Uo0N/I4BrT12XXNgTqs/cPppgRPA0aHSBLAp9TzVWg1cFOlQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793366512;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=HviuIgC87E/yRdmzffRcUTRCSi2vUjjI/a/n/qNyN10=;
	b=lBqPuH+pAy9pU8J71JFYMJMNG/zZay9icFMAHY4Cz4d7F5LdUaNIRvDyVijBLwt9IwL3
	 ORY04zfvx3J4A4ApPp3X01Ep36391+FvNCScgB857HeSvl95IWWG3O+Fq+FQZ+eJmXq6G
	 CAzM5tnNhvnk9Xl5+5RgyUj+xxaSDRNyK10mGlALS9rv86h6BMPEbs7dVEmcU7uwPbGLT
	 OmQYLfLgzcjUH25Umjaz8H1IxkAEjsWUJQp7nudGLS4RXJhB245644c+HbBjrlnkVPP4A
	 fjTgSgY3a830a5SU6Ro9gtDLapG3zSOQyPUzR4fg2Dxtk5BxAT8muw2hwy6UVroYNVQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b="fCdBm/fa";
	arc=none smtp.remote-ip=209.85.128.45
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55739606A31C
	for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 13:21:52 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 55739606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=fCdBm/fa
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4a5177d78c7so6974455e9.2
        for <linux-wireless@vger.kernel.org>; Fri, 30 Oct 2026 06:21:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793366511; x=1793971311; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HviuIgC87E/yRdmzffRcUTRCSi2vUjjI/a/n/qNyN10=;
        b=fCdBm/fa/JyARCTD9TVi/fK3vJTkZEiIKkIsKNBXfjERuJrW7l+eD58q6lNCqvJ0DA
         DYl4V6Tshl06yRP5PdXWEWKCcaEDwYjymZb7IIcbyzMvk6vxQeMXv4evwhfoUZdOyG0v
         2J8SWRpA/2bWWopGl7idEY27kcoqFPE45kVrcZqxZS1rMW6wWN3+zXMMEiR81mVJxm8D
         m51P+y8tqWDcwfZSY0AlVz7piv6vM9IWNwohCDPkVVc/Pus9Ki9w6kr2v4ATn4IarR/F
         o4YaGCy2cF7RCKhLhT4HXsW9GnYMqFpDjt425VfraEPBij432JNf528O3rHZJLPohItj
         WJYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793366511; x=1793971311;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HviuIgC87E/yRdmzffRcUTRCSi2vUjjI/a/n/qNyN10=;
        b=qFhTq53VfdIiJ81qeniEAgtPQWE53KzxEMstxbKLfHrKEylZBgI8bRjeQBjWqjy0qo
         qKqmB/D9mqe2tQRJiM+RvdVpi5q6sQMEhtmTeCaFwy/bkZK+wGyGVYw9bJBqJq8l2vAr
         lV+7hqjN+6szuyTRX49bpNOhspJI9PsI9SnHe+uS5GQR9MxwyhP4APWInY/swizXaTbS
         tOsvkfZMLE6P44zbdq9krEFb4eo6FA50T9vfqXSU4pd1UTBaZFAjOrRBNLuyC2ZF00ky
         a5fbTcyybewahMQOpBPI4MZq9a5fDv4MwxKe4mxV5QjRNSW9HOmr8Lsa65vLR6JLY/en
         LqdA==
X-Gm-Message-State: AFq9FYJcZhQ7nfI3oXLb0nHqzHzphPObVFy+wui1izX9gXA2qz6PgK4O
	8IdbG5gUR6ZzgLlQbbGVy8hs1Jo91/PEZ4k9QtrLIyOBJakfdzSG6CNb
X-Gm-Gg: AYBFou3lIKOUxMm0bwLEc9JpLusl0qY2xXho0vNgtDQM+U2VjfW92Ps3L/AgsakDrCn
	bIohbl5k66wmJP1Q4mAmD7LZGOqy/dM1rF5W4W4fKsU5FqttwBwGV9lhYGWeogs2WhvdOkxHKlN
	aFdJT+lJoNYUYUB1mYDyvXgDT/hnd273uXt1PXhXTpM/yCkJ/2PKIDTC065PaecCWH6l1rP3dLa
	680UGsJtoVxO2QBemjyUX0G9UZIlHcbsf5Gte4EaPBvHJrFYc2KbXsn3yMCXQamnT52rg3ZchRB
	OMJ28hUsF2861lNg7m7gFqaqzc5aW7s2UuwjkuaB+1EpGTtJsQjIwlE0PQx+M1eTra2seTU7lfw
	Lll7yaxczFsQ8gTTYJJMy7lylb28yK3H95dlLT4hdnSNa7wDm0xIiuYLoqiYKN+58tBduH9qnXP
	omJpq3JFWOm596nDmmwIJTWWlvFZogvqH1wzYk9hEsu4SVHlvzRUECASfNx03YNxxo/LXSpu6tc
	dyIRC2/rpb1fETD1pmp7sMiOen9bsQFneh7pIiMkTsTrS8PzT6OFvnmNv1bzxfGvtixzDR6oVpS
	JQRKvbPhjtOVw/2WRocHPj6TMRs9KeC1/K6HZgJ6r58C9RGRuiJueM8bgmfDslsmerCqqHqhM9r
	Y0FXD
X-Received: by 2002:a05:600c:4f86:b0:4a7:669c:c988 with SMTP id 5b1f17b1804b1-4ac18b7df2cmr50002535e9.23.1793366510349;
        Fri, 30 Oct 2026 06:21:50 -0700 (PDT)
Received: from [192.168.1.7] ([31.176.170.175])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4aa81a896ecsm144128695e9.9.2026.10.30.06.21.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Oct 2026 06:21:48 -0700 (PDT)
Message-ID: <2070cf87-bc38-4237-a58b-6554572a8842@gmail.com>
Date: Fri, 30 Oct 2026 14:21:46 +0100
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Post: <mailto:linux-wireless@vger.kernel.org>
List-Help: <mailto:linux-wireless+help@vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-wireless+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mac80211: move static function from header to
 referenced file
To: Jeff Johnson <jeff.johnson@oss.qualcomm.com>, johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20261017155509.128114-1-omer.e.idrissi@gmail.com>
 <20261017155509.128114-2-omer.e.idrissi@gmail.com>
 <b60d12eb-dad1-4482-89ca-155dfcb410b9@oss.qualcomm.com>
Content-Language: en-US
From: Omer El Idrissi <omer.e.idrissi@gmail.com>
In-Reply-To: <b60d12eb-dad1-4482-89ca-155dfcb410b9@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

>> Move static function from header file to only c file it's used in.
> why? all the drv_ inlines are in driver-ops.h
>
> first rule of commit text is to describe the problem you are tying to solve.
>
> don't add unnecessary churn to the wireless code.

i moved it because multiple files include the header and when those are 
compiled they don't see the tracepoint definition because the next patch 
ifdef guards it under the same config that enables the only file the 
static function that uses the tracepoint is called from.

this static function was only used in that file and i didn't see any 
obvious reason for it's existance in that header so i moved it to the 
file where it's used.

commit messages are kept in the git history. should i send a v2 with a 
better commit message? or is the patch series problematic otherwise?
