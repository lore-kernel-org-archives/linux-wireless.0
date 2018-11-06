Return-Path: <SRS0=+Mnd=NR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18ED3C0044C
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 02:27:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BADD32081D
	for <linux-wireless@archiver.kernel.org>; Tue,  6 Nov 2018 02:27:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UQrwQS77"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org BADD32081D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=lwfinger.net
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729299AbeKFLtx (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 6 Nov 2018 06:49:53 -0500
Received: from mail-oi1-f196.google.com ([209.85.167.196]:35991 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725897AbeKFLtx (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 6 Nov 2018 06:49:53 -0500
Received: by mail-oi1-f196.google.com with SMTP id r127-v6so9449660oie.3
        for <linux-wireless@vger.kernel.org>; Mon, 05 Nov 2018 18:27:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=B+eYH9/aEooS3BD6ceFo/8ADncND0XY8U22utSprIjc=;
        b=UQrwQS77z2S8LUqiG32ioRf7N8Tau4DSkCjh2PtpBowGhAw73bkXDg82SKJ8yIE6mt
         8+GOne7QAvcBV562Ep90w7S3XT76/GiDx6L1zebv2bQsGlqSvX4Q2ghGtcaKWiRHnU3o
         5DdZY7xlbpzmFmS1k3d60dm+taaLGJi7R28IWL/mkE63+CNbiuSc3j8LjHhe+Ah2K4o1
         PE/xYZUoxKXbGfWgRz9WItBIGXdZFeQLyCLfMoWnbupjjyBTVOWFgEqVci8hcGeY56Gw
         h+yElHdWWl549ZqfoTnZoeIcuuxte5tlywyamMHWE0onedP4cYnbSEGD01ze1gC6IjWS
         5A9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=B+eYH9/aEooS3BD6ceFo/8ADncND0XY8U22utSprIjc=;
        b=CBdXQdbpndH0pAMQygXqqUpYVvqgw39snNh7uIKKfmC53kPQjz/Gp5CUSp2YBgHRjS
         7nuqrP2ZCHSj5S0wku7DjAVRPux+NfbkRK4stu0Ssnk4vZ8VEWkYZVins1obv33ehn2L
         11/ATHJjTbaLpfkif64g1XeYL0aFSpAHfwLgkd+l9b5D93kEDV36tdguCjx4AtNgrG1/
         8wLmJfSW3xQS6X9Pd8eyzg0YUD/Jnp2NNNTGMYDkJ4KdehcR7rk5EUyrWN6jRd6iAOp1
         zdMVapJHj8nRLy1IFfEd52SBMCJQ+Bn2Dsmf0naoBMtTTtUwoZ0qqxg+3OrH2IdfItX8
         V53w==
X-Gm-Message-State: AGRZ1gLAIM6FkoCM2QOj+IcBG0o3HbJauqTe97Ys9nnaQbPjZByAo8qa
        ORLXQ7QR0TTG5kuQ9tpiVdbuEQrD
X-Google-Smtp-Source: AJdET5ciOw7s7NPlm/jBMmhuq8Kd4XY1nEzEFrO1zh/mtKQI2IqcBWEyJggP3yTMkorISpytkvRj1Q==
X-Received: by 2002:aca:340b:: with SMTP id b11-v6mr2229221oia.118.1541471222940;
        Mon, 05 Nov 2018 18:27:02 -0800 (PST)
Received: from [192.168.1.118] (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id t43sm6283215oti.73.2018.11.05.18.26.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 05 Nov 2018 18:26:59 -0800 (PST)
Subject: Re: RTL8188EUS support
To:     Menion <menion@gmail.com>, linux-wireless@vger.kernel.org
References: <CAJVZm6dHuQPMrU+tSyZe_nsFcmmJ75byG+JbOzcHUeey9LpjDA@mail.gmail.com>
From:   Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <3cf02129-6be4-5665-e633-ca2c384dcd75@lwfinger.net>
Date:   Mon, 5 Nov 2018 20:26:57 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.2.1
MIME-Version: 1.0
In-Reply-To: <CAJVZm6dHuQPMrU+tSyZe_nsFcmmJ75byG+JbOzcHUeey9LpjDA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 11/5/18 5:37 AM, Menion wrote:
> Hi all
> I have a question about the support of RTL8188EUS chipset (which I
> have in a TpLink 0bda:8179 usb dongle)
> This dongle works with the wext staging driver r8188eu driver. Is it
> meant to be supported in the rtl2xxx driver?

Assuming that you mean rtl8xxxu, the answer is no. I have no idea what rtl2xxx is.

If you want a cfg80211/nl80211 driver rather than the wext-based one, I am 
currently cleaning up a new driver from Realtek with the possibility of 
replacing the one now in staging with a new version. It can be obtained with the 
following command:

git clone https://github.com/lwfinger/rtl8188eu.git -b v5.2.2.4

This driver will definitely handle your device and has pretty good performance. 
Using a local speedtest.net-type web server, I get up to 50 Mbps down and 45 
Mbps up.

The driver is undergoing fairly rapid change, but mostly to remove lots of dead 
code, thus you will not need to pull that often. It will build on any kernel 
from 4.20 back to at least 2.6.13. I am only testing on 4.20-rc1.

Larry

