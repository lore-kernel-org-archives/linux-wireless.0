Return-Path: <SRS0=XVRH=MY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 35976C6786D
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 12:41:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F00C220865
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 12:41:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="uFa4zTOp"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org F00C220865
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728674AbeJLUOA (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Oct 2018 16:14:00 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:42823 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728131AbeJLUN7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Oct 2018 16:13:59 -0400
Received: by mail-oi1-f196.google.com with SMTP id w81-v6so9744123oiw.9
        for <linux-wireless@vger.kernel.org>; Fri, 12 Oct 2018 05:41:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=j9Eg5ndtu8zXHsJXtc16waSPZ+FbutNCMli08BjEhhg=;
        b=uFa4zTOp65JPyDNCwSnbveq42mRuEmLPNQY+M8H6CXML7J7PaScKqtWLnkjHce72HP
         W3jMzOI3rzRrNixnZtItm+QafpQaCAjFzCMnGfrotrAsIQ7TF490xV48k4su66V3RdDI
         aZ7eIMFAwVp+N5Y9qGi3+Y1F14fIkKmH2mU56+Pe5RPLj6RRP/EGCHP/Di8P4OUW+878
         sIYL3RYl4TkVQLRFdLKMdsjuRlvD48prt6DC3sG2zV+tPTgljR/VWIxS51B/JzrZkwiC
         RIx3LIx1Db5yuRCBgqaZ2J9LSb7cW13ExqudDVP/AxAV8KC+Dp0piXjQe75jGOhFuEYB
         oJOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=j9Eg5ndtu8zXHsJXtc16waSPZ+FbutNCMli08BjEhhg=;
        b=Scvo6D/3e0mpDry3mcwIRHFF3DXPXy5dAFBdC9S+PTR9MNmlr23TMD6N4r3zbBSUXA
         zQWSmC3Ky8fAbdmCPWam/gNF7BqRRdAw5v3fzNoh77wTazRcFOKyes5VL12a+klwgQtf
         DHVHpCWK1BtXJjKmyS4DQ3GgJU3/crSATbleq/9YojxTYE3HykMyARxiARf34kseieK0
         H96Khk+dZJiGX/Afefh4mkFZlVTVntFi+MiBCR8qFhO9zg24yR5CyqL9Dd3yRmfPuGA6
         P83062psAYhcikFzb+Y8IhznMKL/i31J3O2IeHiqAi/wCIVVgdguGpqpT0ZFJXA7Z4C6
         K67A==
X-Gm-Message-State: ABuFfogdcGTD8Ql1/OPCoaVCeWkQA9eeb3wsZS2968bnD46rtnx1YTea
        38G69tgWf8p0jv7WwIhwsddzAmk5ziw/bNsb3jk=
X-Google-Smtp-Source: ACcGV62vjR0UemVmDq13pB+MS6OKgtHwuMSenDV7xxaF64F2vBJ8il5Kexxf0SYFyXmbcr1Go9Wuqe5Bz1aLg0MC5iI=
X-Received: by 2002:aca:484a:: with SMTP id v71-v6mr3235984oia.163.1539348102106;
 Fri, 12 Oct 2018 05:41:42 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a9d:2eab:0:0:0:0:0 with HTTP; Fri, 12 Oct 2018 05:41:41
 -0700 (PDT)
In-Reply-To: <20181012122630.GB2668@redhat.com>
References: <1539334591-9965-1-git-send-email-sgruszka@redhat.com>
 <1539334591-9965-5-git-send-email-sgruszka@redhat.com> <CAKR_QVJ60VTDjyC59BEDsRKrKR495xjGwob0QqvX333L+L+=Zg@mail.gmail.com>
 <20181012113656.GB2118@redhat.com> <CAKR_QVKU8ZFs6SC0Bm8VFKv82uNah+mZMKfCqCB+PRe6Ew2pcA@mail.gmail.com>
 <20181012120329.GD2118@redhat.com> <CAKR_QVKKiRFASfB=Rs7eUXKNt-Sqm7dTp2tBikOBatJxKvkJ0w@mail.gmail.com>
 <20181012122630.GB2668@redhat.com>
From:   Tom Psyborg <pozega.tomislav@gmail.com>
Date:   Fri, 12 Oct 2018 14:41:41 +0200
Message-ID: <CAKR_QVLtJGzpBuz-BBi5yzFPoTUnadDdEXcwnR4XrB3DuWchjQ@mail.gmail.com>
Subject: Re: [PATCH v4 4/8] rt2800: fix registers init for MT7620
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     linux-wireless@vger.kernel.org,
        Daniel Golle <daniel@makrotopia.org>,
        Mathias Kresin <dev@kresin.me>, Felix Fietkau <nbd@nbd.name>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 12/10/2018, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> On Fri, Oct 12, 2018 at 02:20:07PM +0200, Tom Psyborg wrote:
>> > On upstream tree where this patch is intended
>> > additional registers where never programmed as proper branch
>> > were never used, because of additional check in RT5390 branch.
>> >
>>
>> on my hardware additional registers were programmed in regardless of
>> redundant check. that why i opened whole thread on forum since i
>> couldn't understand how's that happening
>
> I don't understand how that possible either.

i'd assume because device use external lna
>
>> > Patch does only change TX_SW_CFG* regs values for RT6352.
>> >
>>
>> i'd still prefer that we include CONFIG_RT2800SOC, and if required
>> move rest of the registers to that check, because at least on my
>> hardware driver would still recognize chip as RT5390 despite the
>> RT6352 defines
>
> As I pointed before you should add additional printk's and provide
> dmesg to make us see what is going on.

sorry,my hardware is broken, maybe somebody else could provide us with
additional printks
