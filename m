Return-Path: <SRS0=SE/f=NZ=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.7 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9693AC43610
	for <linux-wireless@archiver.kernel.org>; Wed, 14 Nov 2018 11:41:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5B51121582
	for <linux-wireless@archiver.kernel.org>; Wed, 14 Nov 2018 11:41:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="FMuCCcpq"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 5B51121582
Authentication-Results: mail.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=broadcom.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728391AbeKNVnz (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Wed, 14 Nov 2018 16:43:55 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:36262 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727649AbeKNVnz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 14 Nov 2018 16:43:55 -0500
Received: by mail-wr1-f68.google.com with SMTP id z13-v6so16923842wrs.3
        for <linux-wireless@vger.kernel.org>; Wed, 14 Nov 2018 03:41:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:references:cc:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=jnKqbYjVEidtDKMCPwkGrZLBtF5zni8QCnxGLC8SpuM=;
        b=FMuCCcpq8rF4Mm3jpmHHF5+nRL5XoO88BIOrgdfYOM8fs/cOyl7QC/7Mor0IC/qskM
         dGQ6cOhZSksJ2Rvc31cbSnsGMI3EW2ASmvng7W8UR1PZhSrJQRwwYA7DqFpEanoBeyOX
         BycIdS6dngJgdPgWB6jLnqrDC9nVgVkcBjF28=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:cc:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=jnKqbYjVEidtDKMCPwkGrZLBtF5zni8QCnxGLC8SpuM=;
        b=MRUe1M4PWI1SGogze6SctnYyXCrFZPxmlPr/4ulotAuNjaOv0pFIBm7XH38/FFohGb
         P9qH3oy6u9UmOrgBk2mA1ePncql5j/IFg4bWFh7Jh1VAKCKfF8pwFGDo20FOi4vmXigW
         uzjJfV1cAMZUM3I1wCPq4vBqVebLkcN0aZvmvOekTQT4l6EZVQEI7n1/kUp5/n6sghfK
         DhEbsWNvz52C8y0SHrpKtqmfdtGk6pj8+DKNTFaMDrPC4Ei/J/LBGjpIewdVggBqVs35
         +3/BRejOuSziIemIjiTZo79b+Q+4qKru6KU7LHgzhNanxSBWaQ/7Jd+arIwdZCIzx4oK
         FDsQ==
X-Gm-Message-State: AGRZ1gJoVP+dIAkzU7dODeOGLZCP/XleFlrg1GdDLa6xxHQ6RdhL6owO
        GwV+TdiBHpqSgrlM51Hi4VZx2A==
X-Google-Smtp-Source: AJdET5eZ32OpUHgU0GXJRcbZr1Tcx73SuSuMjnYU1oLINQFa+fuaI/8llst7rUWurDyy/423GgMYqQ==
X-Received: by 2002:a5d:6585:: with SMTP id q5-v6mr1509953wru.141.1542195659903;
        Wed, 14 Nov 2018 03:40:59 -0800 (PST)
Received: from [10.176.68.125] ([192.19.248.250])
        by smtp.gmail.com with ESMTPSA id y21-v6sm11366259wma.36.2018.11.14.03.40.58
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 14 Nov 2018 03:40:59 -0800 (PST)
Subject: Re: AP6335 with mainline kernel
To:     Vanessa Maegima <vanessa.maegima@nxp.com>,
        "festevam@gmail.com" <festevam@gmail.com>
References: <CABACg+yVE+fuzT-qwjNnACqq24KQbNJOae22=v+J+0Q=8kuKRQ@mail.gmail.com>
 <85717463-11e2-e2e3-b08e-b758986687b5@broadcom.com>
 <1510916848.26896.2.camel@nxp.com> <5A0EDC25.7030505@broadcom.com>
 <1510932224.22506.0.camel@nxp.com>
 <d9a80a75-b3d4-d78e-a5bf-ab31732f040d@broadcom.com>
 <e14bdc26-5092-18c9-4caa-c45fd1d12984@broadcom.com>
 <1511347672.18886.2.camel@nxp.com> <5A15584A.9090601@broadcom.com>
 <1511450638.9102.1.camel@nxp.com> <5A1FFA17.6000703@broadcom.com>
 <1512413992.18900.3.camel@nxp.com>
 <CAF7Mx6q6mTOXc=4OFVCHAHd26pyfv5e6pK=TMNmb1S6=FBWUWQ@mail.gmail.com>
 <1512485878.9392.1.camel@nxp.com>
 <CAOMZO5DXoCFgTtuRRAq_jFjzkzFp6chMCwczXF5Z0bFaNfQnog@mail.gmail.com>
 <5A5E5EBE.7040301@broadcom.com> <1516276016.8817.1.camel@nxp.com>
 <5A61B43C.4000305@broadcom.com> <1521646672.13983.1.camel@nxp.com>
 <5AB4C8D5.40203@broadcom.com> <1521810882.19239.1.camel@nxp.com>
 <1522067092.4780.3.camel@nxp.com> <1522071220.8102.0.camel@nxp.com>
Cc:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "van.ayumi@gmail.com" <van.ayumi@gmail.com>,
        "embed3d@gmail.com" <embed3d@gmail.com>,
        Cameron Kellough <cameron@paloaltoinnovation.com>
From:   Arend van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <05ab43bd-0033-fc45-a992-0a20b91a0e74@broadcom.com>
Date:   Wed, 14 Nov 2018 12:40:57 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.8.0
MIME-Version: 1.0
In-Reply-To: <1522071220.8102.0.camel@nxp.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

+ Cameron

On 3/26/2018 3:34 PM, Vanessa Maegima wrote:
> On Seg, 2018-03-26 at 09:24 -0300, Vanessa Maegima wrote:
>> Hi Arend,
>>
>>>
>>> Here's the hexdump: http://code.bulix.org/trv3o7-306254
>>>
>> The link above provides the hexdump from the html nvram, which makes
>> wifi work on pico-imx7d.
>>
>> I also got the hexdump of the nvram file provided by TechNexion for
>> comparison, which returns the error "brcmfmac: brcmf_sdio_htclk: HT
>> Avail timeout (1000000): clkctl 0x50": http://code.bulix.org/mw4x62-3
>> 09
>> 095
>
> Fixing second URL: http://code.bulix.org/mw4x62-309095

Hi Vanessa,

It has been a while, but recently I was contacted by Cameron who was 
facing same/similar issue. After some email exchanges with him he 
uncovered that the problem with the TechNexion nvram file is with the 
boardflags3 entry. On my suggestion he change the value from 0x08101188 
to 0x101188. The dropped bit forces the clock hierarchy in the chip to 
select external LPO. I found some schematics showing a 32kHz signal 
hooked up to the LPO input coming from GPIO1_IO03. Could it be that it 
is not properly setup? Devicetree maybe?

Regards,
Arend

