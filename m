Return-Path: <SRS0=h0Fo=ML=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED90FC43143
	for <linux-wireless@archiver.kernel.org>; Sat, 29 Sep 2018 09:26:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A15B32064D
	for <linux-wireless@archiver.kernel.org>; Sat, 29 Sep 2018 09:26:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="d2veScRU"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org A15B32064D
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727765AbeI2Pxq (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 29 Sep 2018 11:53:46 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:36898 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727708AbeI2Pxq (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 29 Sep 2018 11:53:46 -0400
Received: by mail-ot1-f67.google.com with SMTP id o13-v6so8405277otl.4
        for <linux-wireless@vger.kernel.org>; Sat, 29 Sep 2018 02:26:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=ScI0UL1CmU0TFV/InxMm+Q5FKG4IN8iStb/N1/WWflA=;
        b=d2veScRULvHvTEXAHWoolVbPuMGsIDNG2aqzz7Sal93oiOjQrP6H19ptpXXXp//Dfi
         cfxhfHYyU6N9DKDIvPwSre6v/22xwQzBM86JCBlRPN+9fxuV0eXEcyhuaieESYzDF0Kw
         KXEFTFJxGWEf/pjRraphy4slPqpdhcZ6zl/DQ8Q/HAJtS7QjBipGgXJW4qPS6wK9T1OK
         Pa0aoq2jlkYPJOZRSpNrQ+uKNXlNAm972Z60W9jEkFmIAeBJeanVE8yv1BAdjmsFc1rH
         rSBeifO1BQnEWYAElimGxuLHPny3od3idMYR01Gdb8jWblHkLSlXLB6PnNDcHOuMTexy
         Q1SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=ScI0UL1CmU0TFV/InxMm+Q5FKG4IN8iStb/N1/WWflA=;
        b=GmngoY8KCRVRDhbkit9FCHFMzfc22RHHuWZp/nqYY83mdLqvD33vKIJhUEhjUzm/ee
         PWravWjNFhSrVTxDLc2haEkAq9+3GwNjP8Os1799e9N6wbPjgSSVDxzbk5r0e9aA/rpM
         B29s8rBXm/5RQKxWsr+dqg8Jn0UEwD59XoV9cPU4YNR63JOl+iz6oo4bS62DcRF49E0K
         nkTxHJaWtkSSRC7rmic/moO+ErxqeoFth1a43tKmQmgwaKvXD9QrDN+nBpk/I6o8LEyg
         7ynlyd0Z1g2cIANmfZZdYqh70mRAj2pAsd1cTM5OP4l3EBPWzx3dlgVBlC3K1MCQxZix
         ucnQ==
X-Gm-Message-State: ABuFfojCLXjb6S6Qx+Ve6tL2TFFvyQQIhsSi8bMZmLA/8QjJxe9iAu3+
        Zp8e5ZZ4v0Urrl0mnIZRAstmsypNbYwFzrwlYDzQCg==
X-Google-Smtp-Source: ACcGV615gDfKDm+c6OtSuAUJJj0yvqml2y6uapuVTzMmPx2FCll2GXB1nDCslMtGA8gRVu18nTRiRZ5Orhn9LAjBufM=
X-Received: by 2002:a9d:5285:: with SMTP id f5-v6mr1239772oth.247.1538213162406;
 Sat, 29 Sep 2018 02:26:02 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a9d:2834:0:0:0:0:0 with HTTP; Sat, 29 Sep 2018 02:26:01
 -0700 (PDT)
In-Reply-To: <20180919130456.GA26735@redhat.com>
References: <20180919110540.GC22689@redhat.com> <1537359450-8843-1-git-send-email-pozega.tomislav@gmail.com>
 <20180919124717.GA26590@redhat.com> <20180919130456.GA26735@redhat.com>
From:   Tom Psyborg <pozega.tomislav@gmail.com>
Date:   Sat, 29 Sep 2018 11:26:01 +0200
Message-ID: <CAKR_QVLjwwiamDtL-9ss76p5K=aju1KFYK4iJr=OTGhVsWKuUg@mail.gmail.com>
Subject: Re: [PATCH 1/5] rt2x00: set registers based on current band
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 19/09/2018, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> On Wed, Sep 19, 2018 at 02:47:18PM +0200, Stanislaw Gruszka wrote:
>> > Can you show us how will the problem trigger on dual band devices?
>>
>> When you switch from some 2.4GHz channel to 5GHz channel (or vice versa)
>> ->curr_band will point to old band not the new one. To fix that you
>> have to move curr_band assignemt before ->config() in
>> rt2x00lib_config() i.e:
>>
>> rt2x00dev->curr_band = conf->chandef.chan->band;
>> rt2x00dev->ops->lib->config(rt2x00dev, &libconf, ieee80211_flags);
>>
>> However I do not see the point of replacyng rf->channel check
>> to ->curr_band check. What you can do is oposite thing, replace
>> wrong usage of ->curr_band in very few places in rt2800_config()
>> subroutines to rf->channel check.
>
> Actually ->curr_band is used in rt2800_config_ant() subroutines
> not in rt2800_config() subroutines so things looks ok.
>
> Stanislaw
>

Things should be ok, still if you have some of these cards, it'd be
better to verify that.
At least my MS150N usb card would panic when I did the very same
change in rf53xx channel config, probably because of the way the
btcoex idx value has been set.
Luckily I figured that chipset is single-band only and the patch3 was
enough to handle that:
https://www.spinics.net/lists/linux-wireless/msg177430.html
