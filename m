Return-Path: <SRS0=DNYG=S3=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F1AA8C10F03
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Apr 2019 07:17:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C38222077C
	for <linux-wireless@archiver.kernel.org>; Thu, 25 Apr 2019 07:17:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="VcArmuk3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730118AbfDYHRv (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 25 Apr 2019 03:17:51 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:41689 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729910AbfDYHRv (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 25 Apr 2019 03:17:51 -0400
Received: by mail-ed1-f68.google.com with SMTP id m4so45474edd.8
        for <linux-wireless@vger.kernel.org>; Thu, 25 Apr 2019 00:17:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=pZcr2YNCl8TcWNGw6ntjPqDUENWVzR6c52NG4J3TN88=;
        b=VcArmuk31uf/hSt/PsvJ849U53opjThVlbZfnqQ5c4bZYsF61QiHPHHhqKGOnC9hvO
         pkSw9SSP2vM9YPBrX3NUDgUabxcwzPz4Wv0V5LmzYZDesLSF/RFo+AAzf9g9F1G+Qr8c
         A6GjPj/MBAOFbmVX8jMVh1bQ1lBvEC29pfxWQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=pZcr2YNCl8TcWNGw6ntjPqDUENWVzR6c52NG4J3TN88=;
        b=Evp29mnv9AHYNTnN+rk2WHitr++AjADv0lcPgnyvOCg9EMc/KvfetIsj6ZjZy8jRdT
         5vpEdyBuVQQb8KdZ+LUO2bztmJF1UM5IXeLpMWHyiIF5OAb/+GRclaI9YaXL2UxGx3T0
         83+Cydr4QdYY9MowcI7iiA2rhhkb+oYI3duyc8/ce57a2UOOOSIZzWo//EbRIZQyJMoC
         u0y0SbyXemCjsnbA9dg03puQfgv+VNZAA3OzBXcOvrRYc+C4DUAqmVxtXoI4C32ywSRV
         QCXNXZS/5h5IIagXuinxIAz+0ezusWeHiLhmQioQp8gquvQeJ2Ggssy5r4haCCox/XQA
         AJ+Q==
X-Gm-Message-State: APjAAAXdtnaLV6nhld//IpAcdfCSh6Kj6Uw2I36iA2J1/aJMPsoyvCsl
        NypHhhv3QNk3IXJ/zk/b4lCFLA==
X-Google-Smtp-Source: APXvYqxTd1Fu8598VSQkK4hyUPqw4JvQd2QGvil0meIxIg7fWn32mpcZn/gwRJgIIM4vwBoJti6ufQ==
X-Received: by 2002:a05:6402:691:: with SMTP id f17mr15349450edy.50.1556176669564;
        Thu, 25 Apr 2019 00:17:49 -0700 (PDT)
Received: from [192.168.178.129] (f140230.upc-f.chello.nl. [80.56.140.230])
        by smtp.gmail.com with ESMTPSA id s56sm351669edd.35.2019.04.25.00.17.48
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 25 Apr 2019 00:17:48 -0700 (PDT)
Subject: Re: brcmfmac: NULL pointer dereference during brcmf_detach() after
 firmware crash
To:     =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        "open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        brcm80211-dev-list@cypress.com, Aaron Blair <aaron@aaronpb.me>
References: <b519e746-ddfd-421f-d897-7620d229e4b2@gmail.com>
 <16ea722f-e08d-044f-216c-4ea745cc6344@broadcom.com>
 <CACna6rxR4t1MpniasnUfyiuBhc9tTkJRx=O7GrMnmVPOXCZ-dQ@mail.gmail.com>
 <CACna6rwF7rai_PMY3VtYXD=uBAT+jHsr8zrWP28vKjUx2S7Uyg@mail.gmail.com>
From:   Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <e967a7b3-a8b5-5a77-31e0-a06515d37383@broadcom.com>
Date:   Thu, 25 Apr 2019 09:17:48 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <CACna6rwF7rai_PMY3VtYXD=uBAT+jHsr8zrWP28vKjUx2S7Uyg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 4/18/2019 1:55 PM, Rafał Miłecki wrote:
> On Fri, 15 Feb 2019 at 07:15, Rafał Miłecki <zajec5@gmail.com> wrote:
>> On Thu, 14 Feb 2019 at 23:37, Arend Van Spriel
>> <arend.vanspriel@broadcom.com> wrote:
>>> On 2/14/2019 11:30 PM, Rafał Miłecki wrote:
>>>> I've just found a well reproducible brcmfmac crash (NULL pointer
>>>> dereference).
>>>>
>>>> Steps:
>>>> 1. Wait for or trigger a FullMAC firmware crash
>>>> 2. Wait for some skb to get queued on a flowring
>>>> 3. Call rmmod brcmfmac
>>>>
>>>> Problem:
>>>> There is a NULL pointer dereference in one of the brcmf_detach() calls.
>>>>
>>>> Explanation:
>>>> brcmf_detach() first frees all "ifp"s and then deletes flowrings. If any
>>>> flowring has a skb it results in calling brcmf_txfinalize() which tries
>>>> to access "ifp" (struct brcmf_if) which is a NULL.
>>>
>>> Hi Rafał,
>>>
>>> Thanks for diving in. That was my suspicion. Does it mean you are
>>> working on a patch or shall I take care of it.
>>
>> It would be nice to have someone more experienced with detaching &
>> rings look at it. Is adding a simple
>> if (ifp)
>> enough? Or should that code get redesigned? Should we e.g. reorder detach order?
> 
> Hi Arend, would you find a moment to look at that crash, please?

Hi Rafał,

Sorry for getting back on this so late. The driver tries to gracefully 
teardown stuff by sending firmware commands to the device. I think that 
makes no sense as that level of communication is not possible once our 
driver .remove() callback is called. So I think upon calling 
brcmf_detach() we should cleanup everything bottom-up. I will rework the 
code and see how that goes.

Thanks,
Arend
