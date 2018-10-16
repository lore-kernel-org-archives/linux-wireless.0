Return-Path: <SRS0=k7+a=M4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71362C04EBD
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Oct 2018 11:32:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1FC1920881
	for <linux-wireless@archiver.kernel.org>; Tue, 16 Oct 2018 11:32:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="KA4rOE5S"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 1FC1920881
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726861AbeJPTWV (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 16 Oct 2018 15:22:21 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:37558 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726718AbeJPTWV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 16 Oct 2018 15:22:21 -0400
Received: by mail-ot1-f65.google.com with SMTP id o14so22163470oth.4
        for <linux-wireless@vger.kernel.org>; Tue, 16 Oct 2018 04:32:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=9b8De/vaPpTTkRgGZUF7bGM/h21mOWe0OjXPKW28rG8=;
        b=KA4rOE5SE7CpaOW/EqDwubrZUWJbrpgfTEZGBec4uLiYNQpGSr8+nk9ccmNIW0hrud
         PWv+49fYzIs2nlWGhHdE0gZfgHXyPvtDT+hNQH99H77fMR4rhY904zUdyC/7exgHVdft
         3/AhfBQdVP3DfVjm7Q6zWu91VJVChPbsc+ZAFm9X/HBLo3EI7isPsxTiuWjuA7GmNfRV
         h7fZ2Dg/DvA8mGcVbY3zK+bA1bxpULVOqJOJLGshiMAHiXmN5JPmkp3SnWlUww/0du3H
         UanwwuPB+lVYv2tP+eHdnl3iEFX4NS3NmtDZkTdkJrFMaHdxu4t5eD3Ng3VKTVRkNRUg
         1atA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=9b8De/vaPpTTkRgGZUF7bGM/h21mOWe0OjXPKW28rG8=;
        b=iaIxmJIwHRApUP6KB5nZmAJnUAZYRxr22/QMt4YsPesfplhJHjM0xm9QscOqdZXHse
         HWntE+83YU/2NQoHXw0RIp8Z+CbRB1C5GPzu6qcsCQFO+nQQnVRfY2jjenpjW84uGL6u
         nOBa8rQizOFhrgaCt1Si0PmM5RsYurRZavewsyZ3NQ9zRRRgqXhcSq5Xa0wCMK8AAqFY
         v0/F3A++vnSx24DCCUB+X6Mzrn4g5qaGCqebt47YqCySnKtlvLi47IR9V3ui+Mp/k0gd
         pzhtSzfdSuEE5QjL/fMVujofslGxBkhp1q0Gw882q6hsyN8FsUauShoiuP/7iqXfRJvw
         gKjw==
X-Gm-Message-State: ABuFfoj5CdO/7uJW0hNswUuI8LDpC7U5NiHqJIkrV5FSX020DLWgjHe5
        klx3zyc+yGTmb10giNRsQYTDH6Gd+uR6yudgQPI=
X-Google-Smtp-Source: ACcGV60F3X1Wvgf/AC5YuNKg/+U78ER0zbLzLK/oM8jdy7lQGNiWmhyDSDaTre6VbAYzk8LP+KKrsRXUOkt91Y92IXI=
X-Received: by 2002:a9d:11b2:: with SMTP id v47mr12681634otf.281.1539689539556;
 Tue, 16 Oct 2018 04:32:19 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a9d:2eab:0:0:0:0:0 with HTTP; Tue, 16 Oct 2018 04:32:18
 -0700 (PDT)
In-Reply-To: <20181016080922.GB4158@redhat.com>
References: <1539334591-9965-1-git-send-email-sgruszka@redhat.com>
 <1539334591-9965-5-git-send-email-sgruszka@redhat.com> <CAKR_QVJ60VTDjyC59BEDsRKrKR495xjGwob0QqvX333L+L+=Zg@mail.gmail.com>
 <20181012113656.GB2118@redhat.com> <CAKR_QVKU8ZFs6SC0Bm8VFKv82uNah+mZMKfCqCB+PRe6Ew2pcA@mail.gmail.com>
 <20181012120329.GD2118@redhat.com> <CAKR_QVKKiRFASfB=Rs7eUXKNt-Sqm7dTp2tBikOBatJxKvkJ0w@mail.gmail.com>
 <20181012122630.GB2668@redhat.com> <CAKR_QVLtJGzpBuz-BBi5yzFPoTUnadDdEXcwnR4XrB3DuWchjQ@mail.gmail.com>
 <20181016080922.GB4158@redhat.com>
From:   Tom Psyborg <pozega.tomislav@gmail.com>
Date:   Tue, 16 Oct 2018 13:32:18 +0200
Message-ID: <CAKR_QVJ9T3EOhMoWPUv3x7-+NS54Y7cCRafM34pqve_4eV-zJQ@mail.gmail.com>
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

On 16/10/2018, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> On Fri, Oct 12, 2018 at 02:41:41PM +0200, Tom Psyborg wrote:
>> On 12/10/2018, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
>> > On Fri, Oct 12, 2018 at 02:20:07PM +0200, Tom Psyborg wrote:
>> >> > On upstream tree where this patch is intended
>> >> > additional registers where never programmed as proper branch
>> >> > were never used, because of additional check in RT5390 branch.
>> >> >
>> >>
>> >> on my hardware additional registers were programmed in regardless of
>> >> redundant check. that why i opened whole thread on forum since i
>> >> couldn't understand how's that happening
>> >
>> > I don't understand how that possible either.
>>
>> i'd assume because device use external lna
>
> I have no idea how this could be related. But I think I found
> somewhat reasonable explenation where the problem is.
> I think below code :
>
> 	if (a || b || c) {
> 		CODE1();
> 	} else if (c) {
> 		CODE2();
> 	}
>
> can not be deterministic and can be compiled differently depending
> on compiler version and used options. Sometimes it could result
> in this
>
> 	if (a || b || c) {
> 		CODE1();
> 	}
>
> and sometimes in this:
>
> 	if (a || b) {
> 		CODE1();
> 	} else if (c) {
> 		CODE2();
> 	}
>
> So that would explain the problems you see. And indeed patch
> could cause regression on systems where second variant of
> initalizing RT6352 registers was used.
>
> Thanks
> Stanislaw
>

Hi

I am sending you two builds privately so please check if there are any
differences between the two builds and report back. Thanks.
