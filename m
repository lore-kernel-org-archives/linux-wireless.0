Return-Path: <SRS0=z9X+=PU=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0205FC43387
	for <linux-wireless@archiver.kernel.org>; Sat, 12 Jan 2019 13:29:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C616920854
	for <linux-wireless@archiver.kernel.org>; Sat, 12 Jan 2019 13:29:45 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="cpFUmk+3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725843AbfALN3o (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 12 Jan 2019 08:29:44 -0500
Received: from mail-ed1-f42.google.com ([209.85.208.42]:37958 "EHLO
        mail-ed1-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725827AbfALN3o (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 12 Jan 2019 08:29:44 -0500
Received: by mail-ed1-f42.google.com with SMTP id h50so15260098ede.5
        for <linux-wireless@vger.kernel.org>; Sat, 12 Jan 2019 05:29:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:from:to:references:cc:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=0PSjKc+1AioAuPfQYWIy37TxDdsFzjR8HUcQ5bE0KdY=;
        b=cpFUmk+3qEw5iNd1LyQ5u8xX/9lsxYxfBs1AGePD3f9iuUOpvw2W/1VLRdEBLDfxe+
         gcqu/+6HwlTtM5xKFLBLzWOXv1IKy5Fo+q28pW9dN4j+2Ce6d6RBude6jYo6L19xX0rY
         LZgwWpAxNdb2FSlZddDNy4pNFJKr/AX0eFiTg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:cc:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=0PSjKc+1AioAuPfQYWIy37TxDdsFzjR8HUcQ5bE0KdY=;
        b=MUaBnAZKrsD1PRe7cj+JIfpYhoiXeoVAI1XGxf03XFM2i4pBUHnaK+XxxqHwna+oqN
         7GYmdnItOi1OSNwggkT6+8vJZtfAdj3Fzkzl18KlqpzBpxFvuzNCoXoCzt1bMTLxNiM/
         TCYl3WHhyJ93dkn9Oga5QvoPxKuYNAkUhqGtGSJ43mim/mjSloMWiL30SHJGnw2A11Cf
         K2cPypRfM7b6JNApZvHKgPtU/KKWjp3esxOVz5o65TvAWEmPMD+MSDiSM+aTteo/TFfz
         btT7Uk7i2ohqlPoroeajfgADelKIG+yEm/dINGWd1psFVQbBXUscY0PWfEj9ufFJ2DUY
         3sfw==
X-Gm-Message-State: AJcUukfWSdE0DX/ac8D2mwwBjtS+yplyCr7nap+5Oj8jAjFl0NJIKpU0
        ddzKrCz2QQeM2bRPyL9xSJKhv5tNpKE+5yxvv7aF1jjWHJzDVIeZNjpYZOlmRpwnizD87bvCenm
        qFp+CsRwLO1bObbIzFN8SdsCRFKYpIzIbnTPKhm8EohZmo8YtlTO4WHm1eFJqsGc1/vdreyimUl
        MoGhVwGEZEUFkqnQ==
X-Google-Smtp-Source: ALg8bN5hlkIVJYttKMu9kFG42Lc0oBvDBzgS/xGtR8d3x4fD/+WiY3Fc9waIXM/DZGd0+MlFzf82TQ==
X-Received: by 2002:a17:906:753:: with SMTP id z19-v6mr14978542ejb.175.1547299781358;
        Sat, 12 Jan 2019 05:29:41 -0800 (PST)
Received: from [192.168.178.129] (f140230.upc-f.chello.nl. [80.56.140.230])
        by smtp.gmail.com with ESMTPSA id r1sm2908931eds.1.2019.01.12.05.29.40
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 12 Jan 2019 05:29:40 -0800 (PST)
Subject: Re: brcmfmac regression in 4.19 ?
From:   Arend Van Spriel <arend.vanspriel@broadcom.com>
To:     Hans de Goede <hdegoede@redhat.com>
References: <08b120bb-484f-4c08-30ae-bb023f484a56@redhat.com>
 <CAF7Mx6qrbZr-hVFKPH3kMzTczBWTZmPqZbviKmMCb_uo6O+s+w@mail.gmail.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless <linux-wireless@vger.kernel.org>
Message-ID: <d21a57e6-3cf3-efb4-6fe3-3448a1b89b5c@broadcom.com>
Date:   Sat, 12 Jan 2019 14:29:39 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.4.0
MIME-Version: 1.0
In-Reply-To: <CAF7Mx6qrbZr-hVFKPH3kMzTczBWTZmPqZbviKmMCb_uo6O+s+w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 1/11/2019 4:34 PM, Arend Van Spriel wrote:
> - list (HTML filtering)
> 
> Op vr 11 jan. 2019 16:18 schreef Hans de Goede <hdegoede@redhat.com 
> <mailto:hdegoede@redhat.com>:
> 
>     Hi,
> 
>     We (Fedora) have been getting bugreports that brcmfmac wifi drops
>     out and needs a rmmod + modprobe
>     to restore functionality starting with kernel 4.19:
> 
>     https://bugzilla.redhat.com/show_bug.cgi?id=1658178
> 
> 
> Will look into this. Maybe it is similar to what Russell King reported.

Probably not. The bug report above is with PCIe device. The dmesg 
attached to the bug report shows user is doing system suspend/resume 
over and over until the following occurs:

[28151.874963] brcmfmac: brcmf_psm_watchdog_notify: PSM's watchdog has 
fired!
[29354.351337] brcmfmac: brcmf_psm_watchdog_notify: PSM's watchdog has 
fired!

PSM is the hardware block which processes the 802.11 packets received 
from firmware and passes them to the phy layer. When this watchdog barks 
the firmware will end up in a trap. We do collect a devcoredump upon the 
watchdog, but unfortunately that will not tell much about the failure in 
the hardware block. On monday I will try to come up with a patch to 
obtain more information from the device regarding this watchdog.

Regards,
Arend
