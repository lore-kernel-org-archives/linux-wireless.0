Return-Path: <SRS0=/9EI=QV=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B700C43381
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 22:37:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 51D4321B18
	for <linux-wireless@archiver.kernel.org>; Thu, 14 Feb 2019 22:37:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="G7HHE9tk"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503416AbfBNWhG (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 14 Feb 2019 17:37:06 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:45782 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730079AbfBNWhB (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 14 Feb 2019 17:37:01 -0500
Received: by mail-pl1-f193.google.com with SMTP id r14so3878887pls.12
        for <linux-wireless@vger.kernel.org>; Thu, 14 Feb 2019 14:37:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=JyKRRZPNTRypqPZaS31yjq5esa6+1Lz29bFLtobTOts=;
        b=G7HHE9tkt6nNj5lkXa7w879P7ffPG1rW3Ri7AMaxzQZREfptgUvRXwLElmzg89bjAb
         wBokbtZZwPGDt07UMyiP0T8m2ouiP9BQVWrDdn/wzrpeDbi4kvFp9fYSj+IVgaAbTtYj
         7n9KDxeqRmBL/rbZaYrCgGHOrD4GkmCnc7e/8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=JyKRRZPNTRypqPZaS31yjq5esa6+1Lz29bFLtobTOts=;
        b=Ao4gZEWz2GeC64ASCzOQqv1XBdcQxMvtzSNgfAZWzRRNAeHK2r4IhuGpHIBx1JGjAo
         Edp2uvnRP8BCN+aXc2vVfJB20cidGQn56ZFupdZex5mJO/PVKiDgXdv5V2+as1dnXKX6
         y58bz746MXjvhhwZW6cFSSIUOVOy23S9CHfDR3YYnN8zGWUqpK5JxCnE/bfXnHHGcUJ4
         n1aRQRi0EA/AJSOYoAsiChT55Jo/xFdLF5ii36/lMO+Rc2KEgvQZ3/dtlNu4NrZpX1A8
         8dA8XrSs9PIXncXGX4zjr2QtA9e23OByMCxoIlSlCBFImFUtdNEXjjbuJrgpB13Q9E0B
         mriA==
X-Gm-Message-State: AHQUAuYFa0nKcudQUyIb4gsVQsv2hxd0IeKmNiKGD7H5rdIiJJYhOhdp
        /vZIQfGrZ/2R+q6q3FoSFC/4nw==
X-Google-Smtp-Source: AHgI3IZ6fZO0YOQCLJu5G2zZcVaOzcKrhO+I9zNTTs30p4AjP22BZojLqUgvEciIT+RSRLkO5nquQg==
X-Received: by 2002:a17:902:12e:: with SMTP id 43mr6758708plb.31.1550183820462;
        Thu, 14 Feb 2019 14:37:00 -0800 (PST)
Received: from [10.230.40.234] ([192.19.215.250])
        by smtp.gmail.com with ESMTPSA id 125sm4714215pfx.159.2019.02.14.14.36.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 14 Feb 2019 14:36:59 -0800 (PST)
Subject: Re: brcmfmac: NULL pointer dereference during brcmf_detach() after
 firmware crash
To:     =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        brcm80211-dev-list.pdl@broadcom.com, brcm80211-dev-list@cypress.com
Cc:     Aaron Blair <aaron@aaronpb.me>
References: <b519e746-ddfd-421f-d897-7620d229e4b2@gmail.com>
From:   Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <16ea722f-e08d-044f-216c-4ea745cc6344@broadcom.com>
Date:   Thu, 14 Feb 2019 23:36:55 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.5.0
MIME-Version: 1.0
In-Reply-To: <b519e746-ddfd-421f-d897-7620d229e4b2@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2/14/2019 11:30 PM, Rafał Miłecki wrote:
> Hi,
> 
> I've just found a well reproducible brcmfmac crash (NULL pointer 
> dereference).
> 
> Steps:
> 1. Wait for or trigger a FullMAC firmware crash
> 2. Wait for some skb to get queued on a flowring
> 3. Call rmmod brcmfmac
> 
> Problem:
> There is a NULL pointer dereference in one of the brcmf_detach() calls.
> 
> Explanation:
> brcmf_detach() first frees all "ifp"s and then deletes flowrings. If any
> flowring has a skb it results in calling brcmf_txfinalize() which tries
> to access "ifp" (struct brcmf_if) which is a NULL.

Hi Rafał,

Thanks for diving in. That was my suspicion. Does it mean you are 
working on a patch or shall I take care of it.

Regards,
Arend
