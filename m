Return-Path: <SRS0=ZKB3=N4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1EB0C43441
	for <linux-wireless@archiver.kernel.org>; Sat, 17 Nov 2018 17:49:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7238B20817
	for <linux-wireless@archiver.kernel.org>; Sat, 17 Nov 2018 17:49:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 7238B20817
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=redhat.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726596AbeKREEM (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 17 Nov 2018 23:04:12 -0500
Received: from mail-io1-f68.google.com ([209.85.166.68]:42770 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726338AbeKREEM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 17 Nov 2018 23:04:12 -0500
Received: by mail-io1-f68.google.com with SMTP id h19-v6so19440336iog.9
        for <linux-wireless@vger.kernel.org>; Sat, 17 Nov 2018 09:46:48 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/+be3Yk76hNv5Br69ZKn41MJcPpeU2RlJVi8+yH0GLw=;
        b=AUikqymcnUPb8hlwjcsQvWpIVo8UgFhQTLTTus8iGEkxIJ4x/DYky+h40TnNRdX4iP
         OVf9BCzXOHrk1z39BkPXMFop3lcIL/4pVrzq35oJX7m/KHPSFeABtAI7DeCO+PxNJlW3
         7/ZSrfGX4TrpoeKaoW7bAnhUZgkDRy9OOAEkU1W+cGjjvJxnlc4rTkyAGTz+TO9QgnD8
         shNxsP9ldRafptrhvRCsbUEG15cBU3rlGCEeLtNQj20juvu8X4Wejt5nNj491Mo/LE5G
         zuhdVph+++2t6tfzgzFACfO3kfB0YSb02TWWJblDkY9T3kxLAfVwPDr5Q70RL+lIXKym
         sLwA==
X-Gm-Message-State: AA+aEWZ1vCpqdSb2/Rs1nu/r+j60LCFm8mPLfpeCQbkh9FhA7n88n87w
        999zI2zLP6VABZfFbLCD1hnaPaZXSBG9SMBtiiBHmg==
X-Google-Smtp-Source: AFSGD/V1OiWWopcvZAbZwjarvgnMZuFh6B6mfn5ZEShjcT12AHFR1I4IxTjP6aP9kzU1c6COMHB6BnOBi+JOVMkD+9E=
X-Received: by 2002:a6b:c502:: with SMTP id v2-v6mr12323169iof.297.1542476808121;
 Sat, 17 Nov 2018 09:46:48 -0800 (PST)
MIME-Version: 1.0
References: <cover.1542384797.git.lorenzo.bianconi@redhat.com>
 <98cf4a8f8a7f7840803b91b7c9078d8b61febee9.1542384797.git.lorenzo.bianconi@redhat.com>
 <87zhu83qji.fsf@codeaurora.org>
In-Reply-To: <87zhu83qji.fsf@codeaurora.org>
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Date:   Sat, 17 Nov 2018 18:46:37 +0100
Message-ID: <CAJ0CqmU5YoQu=sNU2pncLB_YJ-TZ=xtYxJqcsnW3L-zewYziWQ@mail.gmail.com>
Subject: Re: [PATCH] mt76: fix potential NULL pointer dereference in mt76_stop_tx_queues
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Felix Fietkau <nbd@nbd.name>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

> A very good commit log, thanks for that!
>
> > This patch is for 4.20
>
> Ok, I'll wait for review comments and then queue this for 4.20.
>
> BTW, it would make my patch sorting easier if you could add a release
> label in the subject:
>
> [PATCH 4.20] mt76: fix potential NULL pointer dereference in mt76_stop_tx_queues
>
> More info:
>
> https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches#tree_labels

Ack, will do next time :)

Regards,
Lorenzo

>
> --
> Kalle Valo
