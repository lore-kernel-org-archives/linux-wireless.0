Return-Path: <SRS0=9L0z=MH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A79C2C43382
	for <linux-wireless@archiver.kernel.org>; Tue, 25 Sep 2018 15:45:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 616492098A
	for <linux-wireless@archiver.kernel.org>; Tue, 25 Sep 2018 15:45:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="aEFpOvQC"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 616492098A
Authentication-Results: mail.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729632AbeIYVxy (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 25 Sep 2018 17:53:54 -0400
Received: from mail-it1-f177.google.com ([209.85.166.177]:39921 "EHLO
        mail-it1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729306AbeIYVxy (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 25 Sep 2018 17:53:54 -0400
Received: by mail-it1-f177.google.com with SMTP id w200-v6so7661418itc.4
        for <linux-wireless@vger.kernel.org>; Tue, 25 Sep 2018 08:45:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to;
        bh=SbTN/sLcEIj7wLbzWGqtoSBOvbJcdsDVu1mtocvMl0E=;
        b=aEFpOvQCcb1/5chXpdAyUF459kY4ehCJvVH7wtGNG6nETjUl9+7D+BrbGbZa/iFIZB
         mzSO2BfYi6pC58K3jFkAwQTVkAHMzEW0zQdA/UZ2RUIa8u4hz7tyg92/KU09U4eTk73r
         R3MtBfQ6iPU8nmdXWOAcJcJogNrM2raRJpSzam0UZiAQrucdG7o/oe7AIUT7DhnvKjFT
         ypH/DzU0EzaD4tutdpRcYRuXUSzNOSC48zq1KLzYhIa2lctD1CZK8LLCcVVL9kTPz7zv
         ujd0dr4PkPdtjvktmxFnW4Pi0Ki+KQ8ymcYVX1S8VYZLy/Pl9zl1p7QFNV8IRR3lYtXr
         ZfHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to;
        bh=SbTN/sLcEIj7wLbzWGqtoSBOvbJcdsDVu1mtocvMl0E=;
        b=O6Y+T9oRMXU7qF6WCvN09Nk/QR/bRsPggJR4wH7soJq+hxeL8hgnvcEVYeCJWECU/G
         RMc3+NMgFi1ks5RFL7mHY3dyHwYxmPYbS+BpDz689oX3CkQ0FjNH3SDf4ws9RgSX3A9z
         jvkpLGnkyrNOhjDg1qZWYZmTVYpjpsGLvuqip92rtnW6puh2G/7Yr3PvIrI81NdaiZcu
         KcAzMq1Nq3SHwbszLzDt6PI4Lm4piARLXIE8ZuYahbVr2aVI0kQ4KUwb3JDykLNgzhcD
         BOsw3FCNV8/8XgDFFDK5DZz05lRH3Ztr6wpCpJAZuakabic5GNMd2qlmBYfFcE5LTEgQ
         p6nA==
X-Gm-Message-State: ABuFfoiVGnw9azZDkR7G2wnxsXAV49NiKv3XgLKk3xqCqgk29kZFQ7/Z
        lfu9HT+jFMmUT9TXRq+fChuwYW0ZKJR3FT1zWThtdky5
X-Google-Smtp-Source: ACcGV62bI9bRxkf2vCPpzU0K16DJGAZcm/0Inn8u9vyxXpjFPuenZrVAhUvL/7kyIsTG6qhSfZvBQQBCgLhxVOqq3S8=
X-Received: by 2002:a02:62cd:: with SMTP id d196-v6mr1601899jac.39.1537890347812;
 Tue, 25 Sep 2018 08:45:47 -0700 (PDT)
MIME-Version: 1.0
References: <1537860139.3269.4.camel@sipsolutions.net>
In-Reply-To: <1537860139.3269.4.camel@sipsolutions.net>
From:   Steve deRosier <derosier@gmail.com>
Date:   Tue, 25 Sep 2018 08:45:11 -0700
Message-ID: <CALLGbRKDikkzVqEaMnDrWB4b5N0TzbVay6pO+YYZtjFAFFRjgw@mail.gmail.com>
Subject: Re: list archive
To:     linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Tue, Sep 25, 2018 at 12:22 AM Johannes Berg
<johannes@sipsolutions.net> wrote:
>
> Hi all,
>
> Konstantin has graciously added this list to lore, so we now have a web
> archive here:
>
> https://lore.kernel.org/linux-wireless
>

That is fantastic! Thank you Konstantin, Johannes, and Jouni! While
the development on this list is great,
it's these sort of toolings that make it easier to work on linux-wireless.

- Steve
