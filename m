Received: from mail-ot1-f99.google.com (mail-ot1-f99.google.com [209.85.210.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 068F329A309
	for <linux-wireless@vger.kernel.org>; Sat, 22 Aug 2026 18:48:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787424522; cv=none; b=ZFoTuTHiuTeJNpSDQrO9s9lrOfSVSGw74i17J8D52+V5Y6X3zcDIzrw1YgwnoKW9eMP2KmiqJn4Z8lWAUphH2NJ3GUgnPmxLdnJCo/x7ATHI5/g4v2oxR55k89tIRGaTxFGSizY38Y8iQ2whEDI3b1oe0ksugsFdWw9/d+rf/dE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787424522; c=relaxed/simple;
	bh=6d6rUdI0+Jfdk1co6jNNrUW/hr/DoSlzAd5JsktZzxk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gGzJ3AqIhqHImvxdp6boiZ16CB+yrOEsW5FgEkrMsRWOotC+I8djVusQTgIVp0/AVIGuRA33VuMmCkm/dKtUy9iz6quQn/rid85Mxw0pbNcf3WRT6pZ+3ps4RwXOALP5IVhqRrn7Q2Zl/FXJ1XLnDgJ4LZG2Sq1LGZmp9WDqmwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com; spf=fail smtp.mailfrom=broadcom.com; dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b=KhdzioXX; arc=none smtp.client-ip=209.85.210.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=broadcom.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=broadcom.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="KhdzioXX"
Received: by mail-ot1-f99.google.com with SMTP id 46e09a7af769-7e6b5737bb2so2937154a34.1
        for <linux-wireless@vger.kernel.org>; Sat, 22 Aug 2026 11:48:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787424520; x=1788029320;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:dkim-signature:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=cVsBYVWeiY0T5Pykgsxe7u4yfSLey0gL7CPFlINqPqE=;
        b=mnps9uGfU+5GUml8SFdOMKnN+qRflXRzeIYyt+U6uv3AFZ0fxLfdlaQDqufdUtmF5/
         xPWRbk0xDtlcYFbyDKefrlbee9ZUHIEsz2bORIwFqB9wCKlOfyZ30Vah5r6Tkagmk+SA
         Rb/ZxPyRVSr8LcwGLCslfsRTK4aXJt8UAKmoFhoIuBzkMsnlsfWPLIYjfH+IbvR8vuis
         blw9Q56Saa7+EZwJx5abJg/b8h2Y8yVL6I2uI2J+jt3XG4oALfIfnA4gi6S0coAu00cE
         rFSnx78jjdHJSL3C3k/3nBgu84JkD8Eu7laLMXjCIckMFIVtZpyJxUCfYdLI5ODtQ/nk
         vffQ==
X-Forwarded-Encrypted: i=1; AHgh+Rry9CycxPhBSNhhV1peLLdyFEn76sOKJZAiLkIt9793D/9pYmpcMg+mynueXmAPI+wU8QESJAshkETYLRUcbA==@vger.kernel.org
X-Gm-Message-State: AFuF++kODyiTySC2GLssr+kcJMNABFcp9cvg28YWc+EoTmnL222Up/Xr
	w773+L9IEiP76/P/KrMCvjCkZlyg0wQHMUC8LmupKCv1dpl5ANGXdGXQfl+9iJL/OICCC+yH4cS
	pPIGWiQ8Rx5dzTm1sGVDAmriVf2WIZNFZfQkeKl1bLIgJHZ3THl3nXDI22HUIQgZIS4ViCISBEF
	OlXubu0coge5yPNUlf8WqW32GpdgbpWnGTWpX5Oj32ket9En+LxEHlLFBnADN9YTsXyNEu0r3aU
	K2gl1ef+QCgErJsJL7UKSG0iA0g
X-Gm-Gg: AR+sD13FBTjYqedsy78in3dl1UXINPGZik9jzr+k2Iar6pCOLOweqKfCY4+G8Rumn4u
	p4XlGCCNRU6FXDuwvcs8/yop4aNDXeZ77SmogiAq0amMAKoul2zqEsqF7apRus0zKfpCF0k4q5C
	QRi/cFA8fODWheuAOCSIUGdLTDC56Q3Tq7mfG20RENhG+aHS3CXQWvuf8KsaIBKT4eHCJq6gO7i
	EIeM6PqG9zJGNgI+v5ttFvKiBMNxW8Wm7M4BL/v/6DuS6qyBnp+uUHt9m6nZkEPAPWy3kfgQUF3
	bY2ibvpBYUog4e4TvGOLnV0mSUawewU0XKDUBJANyC8/2IcbiKdQAHkAGDd0r+4hC77d5zS5LzJ
	kfRZYtKNBcKe0XV/fbcEQQmwkAX6iRLIjDF4KVTJjXnhxJ331sISgz3oGHJUM5f/cZqRn1sppNx
	FnWw+JuITma8U4jpUKzx6fRA0GdgwKqr+02mFw00M=
X-Received: by 2002:a05:6830:83a5:b0:7e9:c72e:e5d6 with SMTP id 46e09a7af769-7f4619f7498mr19128885a34.14.1787424519828;
        Sat, 22 Aug 2026 11:48:39 -0700 (PDT)
Received: from smtp-us-east1-p01-i01-si01.dlp.protect.broadcom.com (address-144-49-247-23.dlp.protect.broadcom.com. [144.49.247.23])
        by smtp-relay.gmail.com with ESMTPS id 46e09a7af769-7f43ffc5da4sm1924773a34.6.2026.08.22.11.48.39
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 22 Aug 2026 11:48:39 -0700 (PDT)
X-Relaying-Domain: broadcom.com
X-CFilter-Loop: Reflected
Received: by mail-qt1-f198.google.com with SMTP id d75a77b69052e-51c19493ac2so23872121cf.1
        for <linux-wireless@vger.kernel.org>; Sat, 22 Aug 2026 11:48:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google; t=1787424519; x=1788029319; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=cVsBYVWeiY0T5Pykgsxe7u4yfSLey0gL7CPFlINqPqE=;
        b=KhdzioXXv6CbS20kDuHTLMpxUDNHOJHw8LJYY0KM2uDPp7RHcYihUy5zdpBzx3hn4s
         ikeV3GSiH2UhcRiASFLld7BLfm5LbKHiHz+v7jnrHy0oBCNL7axDcZNqPArqAvLzp6M2
         ePaPwC6Rv90OUorLmr8vcDwPjZCL57pczooXU=
X-Forwarded-Encrypted: i=1; AHgh+Rq4WcevYnpOg2ckl09yVe/meEoy8yHvRieYzjUVYreWD8V4xRTwYd3O6yuRMJnqXGP1hyWleSsdIZqMZBZ8+Q==@vger.kernel.org
X-Received: by 2002:a05:622a:120e:b0:52d:7c2f:7561 with SMTP id d75a77b69052e-52df5c10d4fmr145141821cf.41.1787424518771;
        Sat, 22 Aug 2026 11:48:38 -0700 (PDT)
X-Received: by 2002:a05:622a:120e:b0:52d:7c2f:7561 with SMTP id d75a77b69052e-52df5c10d4fmr145141401cf.41.1787424518308;
        Sat, 22 Aug 2026 11:48:38 -0700 (PDT)
Received: from [192.168.178.26] (f215227.upc-f.chello.nl. [80.56.215.227])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-90c93931452sm19438796d6.26.2026.08.22.11.48.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 22 Aug 2026 11:48:37 -0700 (PDT)
Message-ID: <b97d0ca8-ba9b-4817-939a-ed064507cdd7@broadcom.com>
Date: Sat, 22 Aug 2026 20:48:36 +0200
Precedence: bulk
X-Mailing-List: linux-wireless@vger.kernel.org
List-Id: <linux-wireless.vger.kernel.org>
List-Subscribe: <mailto:linux-wireless+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-wireless+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH wireless-next v3] wifi: brcmfmac: Add support for BCM4361
 PCIe chipset
To: markuss.broks@gmail.com
Cc: Johannes Berg <johannes@sipsolutions.net>,
 linux-wireless@vger.kernel.org, brcm80211@lists.linux.dev,
 brcm80211-dev-list.pdl@broadcom.com, linux-kernel@vger.kernel.org
References: <20260820-broadcom-staging-v3-1-7d5741e37efb@gmail.com>
Content-Language: en-US
From: Arend van Spriel <arend.vanspriel@broadcom.com>
In-Reply-To: <20260820-broadcom-staging-v3-1-7d5741e37efb@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-DetectorID-Processed: b00c1d49-9d2e-4205-b15f-d015386d3d5e

On 20/08/2026 19:59, Markuss Broks via B4 Relay wrote:
> From: Markuss Broks <markuss.broks@gmail.com>
> 
> Those are the required changes for the BCM4361 PCIe chipset support.
> BCM4361 is a dual band 2.4GHz and 5GHz WiFi + Bluetooth combo chipset,
> installed on several mobile devices, such as Samsung Galaxy S9.
> 
> Tested on Samsung Galaxy S9 (SM-G960F), where it's connected by PCIe link.

Could you share the log when the device is bound to brcmfmac driver? I 
would like to know what the firmware version is which you tested.

Regards,
Arend
