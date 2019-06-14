Return-Path: <SRS0=mNjQ=UN=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 16C27C31E4B
	for <linux-wireless@archiver.kernel.org>; Fri, 14 Jun 2019 17:45:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E1B0D217D6
	for <linux-wireless@archiver.kernel.org>; Fri, 14 Jun 2019 17:45:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Cujw9M+N"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726599AbfFNRpo (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 14 Jun 2019 13:45:44 -0400
Received: from mail-ot1-f65.google.com ([209.85.210.65]:45422 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726082AbfFNRpo (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 14 Jun 2019 13:45:44 -0400
Received: by mail-ot1-f65.google.com with SMTP id x21so3386551otq.12
        for <linux-wireless@vger.kernel.org>; Fri, 14 Jun 2019 10:45:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=7YR1zzyIqEKcXCftNMQz50qO47JyXP/bQkNB0DilVjI=;
        b=Cujw9M+NsrnHRJXpa6MLUd40N92CxtYdeJ6bSms4SgiwUS8nAGaYI6lTMsFta4RHK5
         hgUHsqlsEC/vszgIbqLQ3GkP6r9Bxr/vZzofbeESS2J2gEWn3B7e9AaGiYjJ9cfuDjeZ
         wob4Gx5o1Tig+XAe+0Cbe6rfk4N7Bk/91okdC0Q+rkS0M0+B9T8kqTVYNr3MJHDtcUFf
         iQMUbUe8z/Kic6QQYEkQGp9BhaNXVbLULSIjZGUB+SGsk7nRHDpiIg3r0A6+sCC5sh0W
         K/DYAGPOJzJu6zr9BvGiSWFt+dxi9iMM6trbNjyB6Y6p8PNm+d68AWVZrZgQwIHZ+JO6
         zqPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=7YR1zzyIqEKcXCftNMQz50qO47JyXP/bQkNB0DilVjI=;
        b=PnSNjNFHmXrtucKxO8xYR2uYER88gTSXdhK4FefxU1gqmsicdbUWRICTqh4o+gazlY
         bWOSfakJrxX1U5dLS5sSG1371Atci0Iv8m4xW8kReAJSIVm9so/I6j2GxSvVdA3zqCwi
         8uKIthL/gp6SHwMmm7SJjtY0ZnAeaXzZUfN8DN34FPJRCf0mneEdbTyStDreIjeTwfNp
         XLrfXMgopyvIAxGTS1WKfTGuV7kzdb7/v115ZAQdF/hk1EEvq7paewRD27xPCLgFLg4x
         fvAix7wMWGAF0SBRYpXD2HEcFbS8TLMje5/Dpqbu/KTEfUr9sHXN45Y/fwsxk1kd+K4/
         +mUw==
X-Gm-Message-State: APjAAAVIOmTpAZM+i09MnSRDjJ8kwdohLUV/bJgCQZZ7/lEZ5gLYQ18S
        s0WDntQZx6PJZPJ324kHYV6zLiwXn7lqOoiub/pJSw==
X-Google-Smtp-Source: APXvYqyTUB8uEm4wtg+UfgZFgwZynP6V2p/Osx8NDmHA7sxcnkH4dwu80bP68/IVSNz1/f3qlsV+pV50srPXbAzp+nw=
X-Received: by 2002:a9d:5510:: with SMTP id l16mr522924oth.63.1560534343133;
 Fri, 14 Jun 2019 10:45:43 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6830:2015:0:0:0:0 with HTTP; Fri, 14 Jun 2019 10:45:42
 -0700 (PDT)
In-Reply-To: <dc9039be42df8d241b14d4f673f3c472dc113991.camel@sipsolutions.net>
References: <1557307533-5795-1-git-send-email-mpubbise@codeaurora.org>
 <fd3addc01fc3f5362dba5771ee82659cf01c195b.camel@sipsolutions.net>
 <c8484254-f4f7-9955-e3f8-8a423cc6c325@codeaurora.org> <CAKR_QV+dVx+LK1HyCo6CQZQ7ZX_u6ON0hEH5adNiJTB+XaP3WA@mail.gmail.com>
 <dc9039be42df8d241b14d4f673f3c472dc113991.camel@sipsolutions.net>
From:   Tom Psyborg <pozega.tomislav@gmail.com>
Date:   Fri, 14 Jun 2019 19:45:42 +0200
Message-ID: <CAKR_QV+5oY-5z4UB+HKV_57r5NneDme+TBg_c26h4C7Sy8R+UQ@mail.gmail.com>
Subject: Re: [PATCH v3] {nl,mac}80211: allow 4addr AP operation on crypto
 controlled devices
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Manikanta Pubbisetty <mpubbise@codeaurora.org>,
        linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 12/06/2019, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Thu, 2019-06-06 at 20:41 +0200, Tom Psyborg wrote:
>>
>> Applying this patch instead of v1 broke WDS operation between two
>> Litebeam AC Gen2 devices:
>
> I'm confused, and not even sure which version I applied now.
>
> Manikanta, can you please check this and which version I have and which
> changes I might need?
>
> Thanks,
> Johannes
>
>
>

Never got reply. So I checked and definitely wrong version is applied
(v2 or v3). Try to reproduce this yourself, I've posted details here:
https://forum.openwrt.org/t/wds-client-wont-stay-connected-prev-auth-not-valid-using-recent-snapshot-builds/38194/20?u=psyborg
