Return-Path: <SRS0=0lX+=SQ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B75E9C10F13
	for <linux-wireless@archiver.kernel.org>; Sun, 14 Apr 2019 12:34:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7A07520896
	for <linux-wireless@archiver.kernel.org>; Sun, 14 Apr 2019 12:34:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="NqJZHUWa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726147AbfDNMed (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sun, 14 Apr 2019 08:34:33 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:43324 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725829AbfDNMed (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 14 Apr 2019 08:34:33 -0400
Received: by mail-ed1-f67.google.com with SMTP id j20so1981906edq.10
        for <linux-wireless@vger.kernel.org>; Sun, 14 Apr 2019 05:34:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:date:message-id:in-reply-to:references:user-agent
         :subject:mime-version:content-transfer-encoding;
        bh=ssR9jfJ65XhL5ubEbZo6YD0Z+YAnDW1BLqYamICXvNI=;
        b=NqJZHUWacIW8vrm1cf6dJj8kJMHQGawJi/0M8QZdX75QnmaejRtVsvweP+yJkc74ko
         iq9NTPWD4NJy+JSNHWI0Nul3mUWSTO0LdbBrs15gHJ/uHr6TrZD1licYDk8vO5nJ3Xy9
         Ww/Pa4yos/IYQ0fDNFj5KDGRnq2A5ZrlP157s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:date:message-id:in-reply-to
         :references:user-agent:subject:mime-version
         :content-transfer-encoding;
        bh=ssR9jfJ65XhL5ubEbZo6YD0Z+YAnDW1BLqYamICXvNI=;
        b=BVkWVxTkWPDmw7L8OT+KMv98f3Xe/B1EKwahnsHkU6Dm2hRitlzZgkU4/lr7CU2KIH
         lfo13M8mxS5N4AJ25HVJRbRWj32fA2xnpgABf7NG1LCx7IZ3Ob0FtMgZI+2vRF9Ziq4+
         qfdURGG80m6VSgkoGriRJvhUYa1WSrBavs6ECJVAWabeDSO/2hpSVz8U4abRmZYo1GYi
         JzqBggxw31c1U3B554Y96pSTKoteVbjn6wEhAVXsPhw0AA02EjGKN/ICNSYRFSlhxZUA
         wtRPwK/AKpXC7O+YL9utmyuinLglfIGb1QEuspq2XNJin/Mv25U0txCW4Y+a3F0Pcdwr
         bLgA==
X-Gm-Message-State: APjAAAXiX5i2RSTPKV+XZf25BImy3K8C2CKWtVTCQAnGpzyr8IAL7DEk
        11twVi1/AvCE9Kv2419wgBLV2A==
X-Google-Smtp-Source: APXvYqyxkGpetPwQ3Raoby85q3p8Z91obFGgyW0XODaXZNpLv7RGpUlt8IuYSHyIODzxu3T8X0w6cg==
X-Received: by 2002:a05:6402:1494:: with SMTP id e20mr25403237edv.22.1555245271589;
        Sun, 14 Apr 2019 05:34:31 -0700 (PDT)
Received: from [192.168.178.17] (f140230.upc-f.chello.nl. [80.56.140.230])
        by smtp.gmail.com with ESMTPSA id r23sm7561641eja.71.2019.04.14.05.34.29
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Sun, 14 Apr 2019 05:34:30 -0700 (PDT)
From:   Arend Van Spriel <arend.vanspriel@broadcom.com>
To:     Felix Fietkau <nbd@nbd.name>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        <linux-wireless@vger.kernel.org>
CC:     <johannes@sipsolutions.net>,
        Herbert Xu <herbert@gondor.apana.org.au>
Date:   Sun, 14 Apr 2019 14:34:28 +0200
Message-ID: <16a1bd77c20.2764.9b12b7fc0a3841636cfb5e919b41b954@broadcom.com>
In-Reply-To: <e912d736-a3ad-1e21-0cdd-6a065df96fbb@nbd.name>
References: <20190316170634.13125-1-nbd@nbd.name>
 <20190316170634.13125-5-nbd@nbd.name>
 <87sgvmvg9g.fsf@toke.dk>
 <773e4dff-29fd-22b4-e4bc-cd5a94c66dc2@broadcom.com>
 <e912d736-a3ad-1e21-0cdd-6a065df96fbb@nbd.name>
User-Agent: AquaMail/1.19.0-1434 (build: 101900002)
Subject: Re: [PATCH 5/5] mac80211: set NETIF_F_LLTX when using intermediate tx queues
MIME-Version: 1.0
Content-Type: text/plain; format=flowed; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On April 14, 2019 1:19:49 PM Felix Fietkau <nbd@nbd.name> wrote:

> On 2019-04-14 11:44, Arend Van Spriel wrote:
>> + Herbert
>> 
>> On 3/16/2019 7:14 PM, Toke Høiland-Jørgensen wrote:
>>> Felix Fietkau <nbd@nbd.name> writes:
>>> 
>>>> When using iTXQ, tx sequence number allocation and statistics are run at
>>>> dequeue time. Because of that, it is safe to enable NETIF_F_LLTX, which
>>>> allows tx handlers to run on multiple CPUs in parallel.
>>> 
>>> Cool, didn't know about that flag.
>> 
>> It is water under the bridge as this patch got applied already, but I
>> stumbled upon it just recently and didn't know about that flag either.
>> So I looked for more information about it and found the definition [1],
>> but the comment seemed important enough to send this reply.
>> 
>> 	NETIF_F_LLTX_BIT,	/* LockLess TX - deprecated. Please */
>> 				/* do not use LLTX in new drivers */
>> 
>> Here is the commit that marked it deprecated:
>> 
>> commit e24eb521fbf2a350ce879dfc1d8e56d4ffa2aa22
>> Author: Christian Borntraeger <borntraeger@de.ibm.com>
>> Date:   Tue Sep 25 19:42:02 2007 -0700
>> 
>>      [NET]: note that NETIF_F_LLTX is deprecated
>> 
>> So I am not sure we should really do this in mac80211. Maybe Herbert can
>> comment although it has been over a decade ago.
> There is a lot of comparable code that also uses this flag, e.g.
> batman-adv, bridge, vlan, various tunnel implementations. I think
> mac80211 fits well with those kinds of use cases.

Ok. As said I was not sure so I can/will not argue.

> If I remember correctly, the deprecation was added to avoid quirky
> custom locking schemes in ethernet drivers.

What do you mean by "quirky custom locking schemes"? You mean that TX path 
would use driver data that should actually be accessed under some lock?

When seeing the deprecated comment I wanted to know the why and was hoping 
the commit message would divulge. It just mentions it is not needed. So now 
I am curious as to why it wouldn't be needed especially as you say there 
are (valid) use-cases in the kernel today.

Regards,
Arend


