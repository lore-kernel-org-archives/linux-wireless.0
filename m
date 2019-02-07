Return-Path: <SRS0=Kusg=QO=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28CC3C282C2
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 21:08:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EC2F82175B
	for <linux-wireless@archiver.kernel.org>; Thu,  7 Feb 2019 21:08:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Hd/v1abK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727614AbfBGVIH (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 7 Feb 2019 16:08:07 -0500
Received: from mail-ua1-f66.google.com ([209.85.222.66]:36173 "EHLO
        mail-ua1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726832AbfBGVIG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 7 Feb 2019 16:08:06 -0500
Received: by mail-ua1-f66.google.com with SMTP id j3so444440uap.3
        for <linux-wireless@vger.kernel.org>; Thu, 07 Feb 2019 13:08:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/OH4DZP9zLyx+eZjFk9ncGqyjkneXat6fmYq2SQp1Pc=;
        b=Hd/v1abKa8d/zb1a4uzXfDpRloYMxjnOYi2OKB2QZF3bmDcLcGxfEp1yF5H0L6CznB
         AdPS6AijR5xne5W3bXceGe5xXPVOnUZfdMD7HMhYZvEGUjJsyAEJiZ3FR/oF5t7MQ4IE
         AnftinHVZNnDlAEQS9bZRB82e190Bl8PJIdUvPMYnbCvvBt2yqnK752QhtLz9N7R3WiQ
         NYHiYUxvjV6FZb6hiBIYlosDuD5vEOiVXqva5aMS8OeenIqavRep79gLBnfK4a46mx3H
         d8i0S7P+YfhjUuVUx9BZVjjNBrGuuXnUAhDyus3EWaSaxQjSEj0EdNff3bozOhyWqOsE
         BMhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/OH4DZP9zLyx+eZjFk9ncGqyjkneXat6fmYq2SQp1Pc=;
        b=KSa+TS1bcmCZkXnB0hs1HXKffJXap456yC+p682Qer7bjXTuSck7XJkMwxo777UQ2L
         EwVo7pSQmb+S8d4v5H21kFOR4+sffTPuUVpMTlmBaK45QTj9WOczOsUuqO8hBD7WkTro
         wk2rMUyY7udKl701o5hN59ovfWWONuT+4ilsEq7yi/+oAs0kqq7Miin8SRZw8NG53VUN
         UpvK5FGbTYJ6SBuNrnlT7d8jVUYKFjhvR8bJnC/jTJgYvAl05FpLgm1XhfGwDERWK4CV
         lHsitFPYjww2wtp9a8bQDJAX7j2jrU48wDhe2AcTK/IPP+gwJf9ZKHXCFfD65pGBnOI9
         +wxQ==
X-Gm-Message-State: AHQUAubewfZaXnn//4Hmp4+PPmYmhYEiYEkYaa75DBg+SE2ttyCzBjaO
        +5+UBqZD+HDz3tdJU5duupwta28fF/fF7vpX4O6r6mpo
X-Google-Smtp-Source: AHgI3Ia6Pi9w9Bxu6ixdL9JvmR2oEu4LDzaz4H8DUk4OvFDtjDUqvhs8w663WMYR/uLwyccdbBSneqZK21ycAN/BhNA=
X-Received: by 2002:ab0:550b:: with SMTP id t11mr7009425uaa.31.1549573685552;
 Thu, 07 Feb 2019 13:08:05 -0800 (PST)
MIME-Version: 1.0
References: <588b2e78-a2f1-49f7-4a15-baa4f8658cc1@agilox.net>
In-Reply-To: <588b2e78-a2f1-49f7-4a15-baa4f8658cc1@agilox.net>
From:   Emmanuel Grumbach <egrumbach@gmail.com>
Date:   Thu, 7 Feb 2019 23:07:54 +0200
Message-ID: <CANUX_P1DpjTU4RQcnu9uzUa8xABwOe_Yc-QEjM5jWYB-3FbbDw@mail.gmail.com>
Subject: Re: [BUG] regular scan timed out
To:     Lukas Redlinger <lukas.redlinger@agilox.net>
Cc:     "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

>
> Hi there,
>
> Debian 10 testing, Intel 8265, firmware 36.9f0a2d68.0
>
> 2 interfaces on 1 phy: 1 managed, 1 AP

Fun, and you expect the AP to send NOAs when it goes away? (This is
what will happen I believe).
You can open a bug on bugzilla.kernel.org, refer to [1] to do so.
Please look at the 'Firmware debugging' section in [2] and provide a
firmware dump with the debug firmware you'll find there.
Note that this involves private data collection, you can read the
privacy notice [3] for further information.

Keep in mind that this is not exactly a common scenario and that
impacts the priority of the bug...

> ----------
>
> [  715.890990] iwlwifi 0000:01:00.0: regular scan timed out

I am not really surprised although this should work I supposed

> [  715.891047] iwlwifi 0000:01:00.0: Microcode SW error detected.
> Restarting 0x2000000.
> [  715.891172] iwlwifi 0000:01:00.0: Start IWL Error Log Dump:
>
> [  715.891175] iwlwifi 0000:01:00.0: Status: 0x00000100, count: 6
> [  715.891177] iwlwifi 0000:01:00.0: Loaded firmware version: 36.9f0a2d68.0
> [  715.891180] iwlwifi 0000:01:00.0: 0x00000084 | NMI_INTERRUPT_UNKNOWN

This event will automatically create a firmware dump.

[1] - https://wireless.wiki.kernel.org/en/users/drivers/iwlwifi/debugging#how_to_report
[2] - https://wireless.wiki.kernel.org/en/users/drivers/iwlwifi/debugging#firmware_debugging
[3] - https://wireless.wiki.kernel.org/en/users/drivers/iwlwifi/debugging#privacy_aspects
