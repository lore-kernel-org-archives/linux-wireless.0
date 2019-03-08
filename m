Return-Path: <SRS0=wltO=RL=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97ABBC43381
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Mar 2019 17:20:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6A0AD20851
	for <linux-wireless@archiver.kernel.org>; Fri,  8 Mar 2019 17:20:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nHGYAzUH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726578AbfCHRUN (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 8 Mar 2019 12:20:13 -0500
Received: from mail-oi1-f193.google.com ([209.85.167.193]:33970 "EHLO
        mail-oi1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726275AbfCHRUN (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 8 Mar 2019 12:20:13 -0500
Received: by mail-oi1-f193.google.com with SMTP id g16so16453674oib.1
        for <linux-wireless@vger.kernel.org>; Fri, 08 Mar 2019 09:20:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=FbKaZnV1zno2T462ec6awy4pnwOB6Mar9C4IiZcfKt4=;
        b=nHGYAzUHRl7OTF9ExhEwV+BG24iOkUiYNqrDkzy6m/HelCNC4svpYxWc39hkMAIb+E
         lGQz6J9KSndHvjKw96LftBEF9mTUWfQ2hyQ7muzTTsNm0ihTH7qIApLgRcILdbNwuxKA
         AEB11w7tnatOezmjVnkn3HxzSzu7IVbSvb4iFSRG5A6yvwz4sos2UDs5qzyF6bCEUulG
         FnTEVATRyyEbCqxDBcxtjxS2+qIkv1aZZr6l+/0tq3PnYymv2NRJbzg/LqXSin4TBUMn
         3MrGezrb1Qc/UHUzHEBcWwzBafLnEO9TnSiqSMKdvz0pN9RT7Zr17MCnM2q5VgwqCNGD
         ga3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=FbKaZnV1zno2T462ec6awy4pnwOB6Mar9C4IiZcfKt4=;
        b=pl5yymAAtjGgphUhF9+XgKv5CmZxHo7G9GfLHoQR1OZLr4QX/kWaRLnvOzItSADlxi
         qI81kF2Jb2imy0mxm6uTHPV6FypAyvc7W1n+9b+k1suPcGc0QcRp54vnHtkxkXqBMr1p
         fXQv/OT6pd7j23CHWLtbBMfn/TCBQgro0L0BiCLqJKTkavqJHKijPcYMqIGjTnMoh4oc
         2fPxGfDEhKg5iJOjQ16QQwJqj9W4j5+nYPhs4/2NVwtkQ+k2riAvsgsnJ0NfdjZVvOul
         mo9bcYFeD6rDO7rZklwtDIIZUpsOiChJEiiWxRDiSmzP/a3Rt5WMb7nFAZbjDzAn6ipe
         R/iQ==
X-Gm-Message-State: APjAAAUTKDNkuCgvaX3AG/ohWzcm0HfSbqewwABBmS82n7HrAz64lWlB
        FD90rSRliN5U/zCn9Ld4NXM=
X-Google-Smtp-Source: APXvYqySIPfSrDCKOPZTICu8enfpGM0zFZ5XxQW6zhPNlt6+wPonUltAUSDrbTyUop+lVFWitDZSLA==
X-Received: by 2002:aca:5e82:: with SMTP id s124mr8435966oib.7.1552065612620;
        Fri, 08 Mar 2019 09:20:12 -0800 (PST)
Received: from localhost.localdomain (cpe-24-31-245-230.kc.res.rr.com. [24.31.245.230])
        by smtp.gmail.com with ESMTPSA id f26sm3140966otl.20.2019.03.08.09.20.11
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 08 Mar 2019 09:20:12 -0800 (PST)
Subject: Re: [PATCH v6 14/14] staging: rtlwifi: remove staging rtlwifi driver
To:     Greg KH <gregkh@linuxfoundation.org>, yhchuang@realtek.com
Cc:     kvalo@codeaurora.org, johannes@sipsolutions.net,
        linux-wireless@vger.kernel.org, sgruszka@redhat.com,
        pkshih@realtek.com, tehuang@realtek.com, briannorris@chromium.org
References: <1552053343-6513-1-git-send-email-yhchuang@realtek.com>
 <1552053343-6513-15-git-send-email-yhchuang@realtek.com>
 <20190308140619.GE25768@kroah.com>
From:   Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <f69bd329-f974-7f82-11dd-c864ee283762@lwfinger.net>
Date:   Fri, 8 Mar 2019 11:20:11 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.1
MIME-Version: 1.0
In-Reply-To: <20190308140619.GE25768@kroah.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 3/8/19 8:06 AM, Greg KH wrote:
> On Fri, Mar 08, 2019 at 09:55:43PM +0800, yhchuang@realtek.com wrote:
>> From: Yan-Hsuan Chuang <yhchuang@realtek.com>
>>
>> The rtlwifi driver is conflicting with Realtek's new 802.11ac chip
>> series driver rtw88, remove it to avoid racing with the same ID.
>>
>> The rtw88 driver can be found at drivers/net/wireless/realtek/rtw88
> 
> The only objection I have here is that your new driver does not support
> all of the devices that this driver does.  So why not just rip out the
> PCI stuff for the staging driver until the USB/SDIO code gets added to
> the new one, and then you can drop the rest of this code?

Greg,

The staging driver only supports PCI ID 0x10ec:0xB822, whereas the new one 
supports that ID plus 0x10ec:0xC822. There will not be any devices dropped when 
the staging code is deleted as long as the new driver is added.

Larry

