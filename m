Return-Path: <SRS0=Fc74=OH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91488C43441
	for <linux-wireless@archiver.kernel.org>; Wed, 28 Nov 2018 20:13:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 13AC42081C
	for <linux-wireless@archiver.kernel.org>; Wed, 28 Nov 2018 20:13:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="O2Lo7RCB"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 13AC42081C
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729143AbeK2HQo (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 29 Nov 2018 02:16:44 -0500
Received: from mail-pf1-f179.google.com ([209.85.210.179]:34377 "EHLO
        mail-pf1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726478AbeK2HQo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 29 Nov 2018 02:16:44 -0500
Received: by mail-pf1-f179.google.com with SMTP id h3so10723074pfg.1
        for <linux-wireless@vger.kernel.org>; Wed, 28 Nov 2018 12:13:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:references:cc:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=eNopX30qmPEIL2bNGjl99Kn9BqPbqlQMTNzNK5v9qg4=;
        b=O2Lo7RCBi92Yq3iKrXMzjLX72v8DfcqfCpBhomoJwl8O+hp9yU3uL1YKKCEkOlzKq1
         pQak1fc/uPDVyA8PhtZBmpwg6NJhZZe5UnSDhD1qrX2tXrTlalhK0g7v+/bbZKGNuqkB
         ilfYIAl5nJOfuteUybNoS79QASvveTYgPSRRg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:cc:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=eNopX30qmPEIL2bNGjl99Kn9BqPbqlQMTNzNK5v9qg4=;
        b=faQctATVFR5+WneFKrspLy7UUyxvm+TYjFxfZfqCbmIE4hiyf04W6b6UJmaM8ry3sZ
         yANIHWIBdnkmfKPUQlKceaqB2EXzrKSmLySrS7F5zGgckckLdqYcHWie0ZD6rzBOAokP
         YXmfhzIz25ED3jDy9BSAd6xt84OEzwBOYVnsOya84BVoHQY6k3YmUO6fu8C6QuHfpwUR
         Fyk7pslE9RsPalaX/pJZ9pZof/QdT/wJ8vArivfgJg7HrZJT9ChyI9i5c69BzlQMmz/C
         FfZnsI/hOyPLaSOGIkUi4+op9j0k2GjajP9EVfL7qKmOMQrUTgMtJcnsivy6UgoPWvDv
         OWnQ==
X-Gm-Message-State: AA+aEWZrtbk5laKnrsWRZsSRE46bI3DJPSnYcpzD1I/MG3cK673eKDej
        ficYjA0LCVK3GNV/He3GRda0cw==
X-Google-Smtp-Source: AFSGD/WuhMH4zaKOh0qj6lRYCGMY9FiDXUXIkzASTuoATWW5sQAodQ5jKj+3/AvZeDMGLtj1LL55Hw==
X-Received: by 2002:a63:d005:: with SMTP id z5mr34206940pgf.64.1543436033503;
        Wed, 28 Nov 2018 12:13:53 -0800 (PST)
Received: from [10.177.251.201] ([192.19.248.250])
        by smtp.gmail.com with ESMTPSA id q25sm9534138pgb.2.2018.11.28.12.13.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 28 Nov 2018 12:13:52 -0800 (PST)
Subject: Re: AP6335 with mainline kernel
To:     Fabio Estevam <festevam@gmail.com>
References: <CABACg+yVE+fuzT-qwjNnACqq24KQbNJOae22=v+J+0Q=8kuKRQ@mail.gmail.com>
 <1512485878.9392.1.camel@nxp.com>
 <CAOMZO5DXoCFgTtuRRAq_jFjzkzFp6chMCwczXF5Z0bFaNfQnog@mail.gmail.com>
 <5A5E5EBE.7040301@broadcom.com> <1516276016.8817.1.camel@nxp.com>
 <5A61B43C.4000305@broadcom.com> <1521646672.13983.1.camel@nxp.com>
 <5AB4C8D5.40203@broadcom.com> <1521810882.19239.1.camel@nxp.com>
 <1522067092.4780.3.camel@nxp.com> <1522071220.8102.0.camel@nxp.com>
 <05ab43bd-0033-fc45-a992-0a20b91a0e74@broadcom.com>
 <CABACg+wyLwYQna+HDJyjNA8V1_3cSoMRDyiBpq=K+UXVXDrtBQ@mail.gmail.com>
 <CAHWfWzm8Zwjc2tBQWVqpaa-cMYyEPWmUKYN7rspyb9W9spx2iQ@mail.gmail.com>
 <CAOMZO5C+r4s3Hn49QbP=0Y+hSYDT5-Y2ZY91E57JvAmq75CXLw@mail.gmail.com>
 <CAOMZO5DtqVBkWuD0iR5JHEG4G-MoWYYxU8aSu99rW8mpd3+PYQ@mail.gmail.com>
 <CAF7Mx6p1DpRieCKy_1qOE5YT4_76UO8vhLMBFUD2B0FrQ9BJGw@mail.gmail.com>
 <CAOMZO5Ah9CLGud3seRcru8Roy3-ChSVDRhiM4ojvMh1XrcDUOg@mail.gmail.com>
 <CAOMZO5D3d3ocHLkoQXTA+aSW=84X8CFN+xWTdZNuHasDqF8Azg@mail.gmail.com>
Cc:     cameron@paloaltoinnovation.com,
        Vanessa Ayumi Maegima <van.ayumi@gmail.com>,
        Vanessa Maegima <vanessa.maegima@nxp.com>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        embed3d@gmail.com, John Weber <john.weber@technexion.com>,
        Otavio Salvador <otavio@ossystems.com.br>
From:   Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <d36ab72c-a30e-deec-7fef-2127afcccef0@broadcom.com>
Date:   Wed, 28 Nov 2018 21:13:47 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.8.0
MIME-Version: 1.0
In-Reply-To: <CAOMZO5D3d3ocHLkoQXTA+aSW=84X8CFN+xWTdZNuHasDqF8Azg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 11/28/2018 7:08 PM, Fabio Estevam wrote:
> Hi Arend,
>
> On Wed, Nov 28, 2018 at 2:23 PM Fabio Estevam <festevam@gmail.com> wrote:
>
>> I am not sure if I can access this signal via scope.
>
> Good news!
>
> I managed to make mx7d to generate the 32kHz clock and now Wifi works
> with the default nvram file value: boardflags3 0x08101188

Nice. Regarding your question in the earlier email, bit 27 in 
boardflags3 forces the device to always select external LPO signal. When 
the bit is not set it will select either internal or external. I don't 
know what the criteria for that selection are.

Regards,
Arend

