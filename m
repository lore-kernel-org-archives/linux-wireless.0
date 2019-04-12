Return-Path: <SRS0=gYL7=SO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_PASS,SUBJ_ALL_CAPS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 842ECC10F0E
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Apr 2019 21:21:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 50CC62171F
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Apr 2019 21:21:35 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="YvV85B8u"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726905AbfDLVVe (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Apr 2019 17:21:34 -0400
Received: from mail-pg1-f175.google.com ([209.85.215.175]:41804 "EHLO
        mail-pg1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726755AbfDLVVe (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Apr 2019 17:21:34 -0400
Received: by mail-pg1-f175.google.com with SMTP id f6so5769994pgs.8
        for <linux-wireless@vger.kernel.org>; Fri, 12 Apr 2019 14:21:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=FPVVhcDMSBGqql/0CsFFShR7PebtkWiRbew4CUXGXOM=;
        b=YvV85B8uOLeQjZWzGyHXcMJdPBWH8P0d0ugRnSQi9PocsVxiWNgB155kdgkfhvkk2Q
         mjKM42obaKCMHB9I2Hn+PQXFn0n/Sxbw6U/BeZB54L3ylFRH8bnl+UDWunduYfxOaTE2
         wfLq2ntuUc7uaHjjDH5lnadsLDJMFu3q106Pc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FPVVhcDMSBGqql/0CsFFShR7PebtkWiRbew4CUXGXOM=;
        b=egF8tuPavtnWdOIwX/Vfh9KRaoKSotrirM2/jhoGfJKw2XEAjGSKuqScundYT2sXiX
         ST3S0Qu+Xm1T8m9D/Rsx0Uvtnld4tO6IvdgFcjOi0eNEkSrIVZ6+toBsR7+SD25OUPyK
         GkMeQKGaCZM+EulzeUEJq4iAGBNlFJ3gRLjD5ufSfoAde83+6v2ni7hOnOPiAVrWpUdk
         TtvOciVp5oeDPqWSxSsCYecYV8xmBUew1ukXQRQ5lZHuzBqeEVLbDftKYlztJI9Wbgx+
         lISKXCptE7F80JKLzYNBTv0P4B7L88v2T3Z1N2G633ukfk+KtfSj7/HTM+xbo6o2oj+5
         cBUw==
X-Gm-Message-State: APjAAAWwv7Y3btFeWT4jimCbTR8vnZGBM7O43/FslHRxlXCwo7EE+yfp
        Kkhk6OaagxohTTCm/kR4fEk7Yg3JQFDtR+pZxjNj3UbOlkK9Yqu4A3nBsnt+OlwGFaoVImAnZXN
        wD4j/3dNFGxqLw19PARDWnCxuYH06uodKAakBEIOlL3f47r5YYxARUT7Qf34pVajjUguWoM6jF9
        3pSX1tjI2sZkAKjg==
X-Google-Smtp-Source: APXvYqyw7MiSsgjpufiVLSr73fZry5xkNGsi7J5J22e8OoPeYwAgzVjKhRPqrDjk8EDXkbQgofXITA==
X-Received: by 2002:a65:6148:: with SMTP id o8mr56509684pgv.153.1555104093237;
        Fri, 12 Apr 2019 14:21:33 -0700 (PDT)
Received: from [10.230.40.234] ([192.19.215.250])
        by smtp.gmail.com with ESMTPSA id k1sm50100139pfc.83.2019.04.12.14.21.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 12 Apr 2019 14:21:32 -0700 (PDT)
Subject: Re: NL80211_SCAN_FLAG_RANDOM_ADDR ?
To:     Denis Kenzior <denkenz@gmail.com>,
        Sergey Matyukevich <sergey.matyukevich.os@quantenna.com>
Cc:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <e09a9bc7-9774-334b-53e8-13e1d781bee3@gmail.com>
 <20190412092623.46ygdnec3wx26zvd@bars>
 <241d2caa-6f41-6363-5164-d2ac83463beb@gmail.com>
From:   Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <4af24a86-8c0c-cb8f-b03f-4377fcd31465@broadcom.com>
Date:   Fri, 12 Apr 2019 23:21:27 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <241d2caa-6f41-6363-5164-d2ac83463beb@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 4/12/2019 5:00 PM, Denis Kenzior wrote:
> Or put another way, besides hardware limitations, are there reasons why 
> you would not want to randomize probe request address when connected?

I was hoping to find your answer using 'git blame'. You might already 
have tried that. The wdev->current_bss check was added by the commit below:

commit ad2b26abc157460ca6fac1a53a2bfeade283adfa
Author: Johannes Berg <johannes.berg@intel.com>
Date:   Thu Jun 12 21:39:05 2014 +0200

     cfg80211: allow drivers to support random MAC addresses for scan

     Add the necessary feature flags and a scan flag to support using
     random MAC addresses for scan while unassociated.

     The configuration for this supports an arbitrary MAC address
     value and mask, so that any kind of configuration (e.g. fixed
     OUI or full 46-bit random) can be requested. Full 46-bit random
     is the default when no other configuration is passed.

     Also add a small helper function to use the addr/mask correctly.

     Signed-off-by: Johannes Berg <johannes.berg@intel.com>

Unfortunately it does not answer your question. My memory is lacking 
quite a bit but I think at the time it was not considered useful to have 
random mac address for scan while being associated. Your permanent mac 
address would be flying around anyway.

Regards,
Arend
