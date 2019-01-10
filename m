Return-Path: <SRS0=ogP8=PS=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD352C43387
	for <linux-wireless@archiver.kernel.org>; Thu, 10 Jan 2019 10:12:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B743E214DA
	for <linux-wireless@archiver.kernel.org>; Thu, 10 Jan 2019 10:12:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727534AbfAJKMY (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 10 Jan 2019 05:12:24 -0500
Received: from mail-wm1-f68.google.com ([209.85.128.68]:52186 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727257AbfAJKMX (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 10 Jan 2019 05:12:23 -0500
Received: by mail-wm1-f68.google.com with SMTP id b11so10646162wmj.1
        for <linux-wireless@vger.kernel.org>; Thu, 10 Jan 2019 02:12:22 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WXTOyxjzADYowIWSq3bLC8CQS530FCdkVP1s5gqZ8Jg=;
        b=gVQ0U68NVnXvjHqhHLudg/x51HQutcTeoj1t55fWGU/VeTLlaKset73qLeMDjawcU3
         mcaWNiYZ157FKybpIoobktN+jABY8sYv7wqlVaHk62uiTJ0Qr6Ea+AC4AO2KCCxdaGGm
         rKWfhUj8AKXdpllpwwoFoRd1mHJHwxbBESzYVpt90yxtla58PShAw9xL0+uqsQ7PNUkG
         TrzvmKUj6I1NhOlA4qTO15rreTqRnVhCH7AKKvqWXOj0eDqzaHCwHQresTuo+IZn+iJq
         QTfj9GuVUL9GM/hb7sswTICmqf02gEA67ehkfxxkxfJb8qIuGrIcfl5DEVPPjyL/SrUi
         +kYg==
X-Gm-Message-State: AJcUukfCFM0Xh6L79O5vQi5fgk+rmvsbZSmPQP8ZDc3BIyrjb0WKp/bS
        2P4MRIgPd5xkNSBWcCTgGOPqCQ==
X-Google-Smtp-Source: ALg8bN7DlArSeeJd8bcCQu1nZDsZBFMx1RffgML9LZ0qZguxWB6pn8/iRpB4a61PZvkaMxv1/j3nFw==
X-Received: by 2002:a1c:9d57:: with SMTP id g84mr9332439wme.16.1547115141535;
        Thu, 10 Jan 2019 02:12:21 -0800 (PST)
Received: from shalem.localdomain (546A5441.cm-12-3b.dynamic.ziggo.nl. [84.106.84.65])
        by smtp.gmail.com with ESMTPSA id v1sm78655237wrw.90.2019.01.10.02.12.20
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 10 Jan 2019 02:12:20 -0800 (PST)
Subject: Re: [PATCH] brcmfmac: Use request_firmware_direct for the clm_blob
To:     Chi-Hsien Lin <Chi-Hsien.Lin@cypress.com>,
        Arend Van Spriel <arend.vanspriel@broadcom.com>,
        Franky Lin <franky.lin@broadcom.com>,
        Hante Meuleman <hante.meuleman@broadcom.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Wright Feng <Wright.Feng@cypress.com>
Cc:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "brcm80211-dev-list.pdl@broadcom.com" 
        <brcm80211-dev-list.pdl@broadcom.com>,
        John Van Boxtel <John.VanBoxtel@cypress.com>
References: <20190107113401.6824-1-hdegoede@redhat.com>
 <d6dafb19-4e88-c2c7-9547-2ebd5b4bec2e@broadcom.com>
 <5b365baf-99b3-2033-1f8e-6ca38d6daf42@redhat.com>
 <55db0ecb-5386-7a10-f26a-fa1e50af9b57@cypress.com>
 <d0bdf1d9-afa1-2eb7-b308-a6ea5278d0f6@redhat.com>
 <2c8efe58-0c13-8dfd-6d5a-17965f65a71d@cypress.com>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <662d8d61-3727-e32f-6bb5-2d0578061878@redhat.com>
Date:   Thu, 10 Jan 2019 11:12:20 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.3.1
MIME-Version: 1.0
In-Reply-To: <2c8efe58-0c13-8dfd-6d5a-17965f65a71d@cypress.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,

On 10-01-19 10:45, Chi-Hsien Lin wrote:
> 
> 
> On 01/10/2019 4:50, Hans de Goede wrote:
>> Hi,
>>
>> On 10-01-19 09:16, Chi-Hsien Lin wrote:
>> So the linux firmware version is *three and a half* years out of date!
> 
> Thanks a lot for the reference. This discussion could be moved to the V2
> thread.
> 
> 
>> We are not asking you to do special Linux builds, Linux can use the per
>> board Windows files just fine, all we need is permission to distribute this
>> and then Linux users will run their boards with the same qualified firmware
>> files as are being used under Windows.
> 
> I remember that this has been brought up a while back and I did check
> with the Cypress bluetooth team about it. The answer I got is that the
> files were committed before the Cypress acquisition and our bluetooth
> team couldn't even locate these files in our server. So, unfortunately
> we cannot modify the license for firmware files that are not released by us.

AFAICT Cypress owns the copyright on these files, IANAL but it is not
necessary for Cypress to (re)distribute these files under the new license.
As copyright holder Cypress can simply give permission to distribute
these files under the:
https://git.kernel.org/pub/scm/linux/kernel/git/firmware/linux-firmware.git/tree/LICENCE.cypress
license.

Regards,

Hans

