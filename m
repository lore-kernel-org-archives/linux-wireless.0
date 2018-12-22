Return-Path: <SRS0=36rf=O7=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.7 required=3.0 tests=DATE_IN_PAST_03_06,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DBF1C43387
	for <linux-wireless@archiver.kernel.org>; Sat, 22 Dec 2018 17:22:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 46EBB2173B
	for <linux-wireless@archiver.kernel.org>; Sat, 22 Dec 2018 17:22:14 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XaWPjwpU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391347AbeLVRWN (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 22 Dec 2018 12:22:13 -0500
Received: from mail-oi1-f194.google.com ([209.85.167.194]:36215 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726009AbeLVRWM (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 22 Dec 2018 12:22:12 -0500
Received: by mail-oi1-f194.google.com with SMTP id x23so7320496oix.3
        for <linux-wireless@vger.kernel.org>; Sat, 22 Dec 2018 09:22:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=gj7y08sdBWoLZIQ/1pWhTCWvS6BzCq9U6XRZ/5IDMmw=;
        b=XaWPjwpUyjvtm40LSM5PDfrV9vLNJ0b89c8XzwalbIuIInTpVcnPDTry3JsDidvE8a
         hUMZQ1KHUinDBfHyYCvJsp7JZgYaxCKrrMwPCFLhr5CkR7nCLA+XIJHGK9aio3OLe7vV
         xnQ8zkwX/4wtJdviqGr8+ZZLOft100OYwENa1v8lZP67eDadIrEk76R9SbqwhOIrq807
         2A6A+qDw2iZgInfsVK64vsIqWOZo+uLizcxOIXIcchY9Dr6/gazhvjXHiVi9ZqshSUu8
         lGNjYjyxUkoXeosD8QwFpSJZ1eWBJVux9KC0kJOlPbmAqtLrawkfs159gYRoRdn7mmOS
         nFvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=gj7y08sdBWoLZIQ/1pWhTCWvS6BzCq9U6XRZ/5IDMmw=;
        b=jE9wW+6nuCowDH5ga/81T4NLWXpQrcOQQvTTXWaxZslFBPQcnQvJeTNcd3wKfAQRPR
         jr9aM6kHFqLVFb9FtB2fgyfXqqQ63qXbH4iHAgV+ED9QynZxqvNWlCI5BEwO0YxXAHxE
         9jX2Pwi0C5mPcARU1U2lFdnPafuB1gh4N8iC3h72Wkd+q2sYPZCdus5ypIlCJFD9CfzE
         Yoasz5hkT1z55xx9b/adAuxASJ/9l253ss6fNORpQa+vo60BgIa8+Ri1bR0b0sxi/iel
         kq5bK5ckajNHUul+OHOmnmGQNe8CbCZg7SYA2iculbs0rMmc+WhJjqOg6Orl5dJmeWdH
         Vvlg==
X-Gm-Message-State: AA+aEWYWhMFkKcxjm3F5d+Dpmtk4CWJV2ypOC3v35UBs+0VpTT1a+Iqi
        mpoDb5db9rvKCBPoPCGqesNp7GYeDVsJZI0FZkJkdw==
X-Google-Smtp-Source: AFSGD/X8YiIK9PNXKYwHzxZdBjUkBTUTl3otUrO34cxjqyFEyWkBWGWm3ni3u8L0cbaSAGjzv550hM2zW44HJgwsLAc=
X-Received: by 2002:aca:e7c9:: with SMTP id e192mr4003733oih.155.1545484334218;
 Sat, 22 Dec 2018 05:12:14 -0800 (PST)
MIME-Version: 1.0
Received: by 2002:a9d:6c19:0:0:0:0:0 with HTTP; Sat, 22 Dec 2018 05:12:13
 -0800 (PST)
In-Reply-To: <20181221095938.GA29536@redhat.com>
References: <1545318971-28351-1-git-send-email-sgruszka@redhat.com>
 <1545318971-28351-3-git-send-email-sgruszka@redhat.com> <CAKR_QVJeteexpQX=pJm17WrrarmihYw56hKuTbsNagbcA6U96A@mail.gmail.com>
 <20181221095938.GA29536@redhat.com>
From:   Tom Psyborg <pozega.tomislav@gmail.com>
Date:   Sat, 22 Dec 2018 14:12:13 +0100
Message-ID: <CAKR_QVKQMcGGpY_3ur9kFjuYpaKgca=YfUJxjSjLEfP1HELuJw@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] rt2x00: do not print error when queue is full
To:     Stanislaw Gruszka <sgruszka@redhat.com>
Cc:     linux-wireless@vger.kernel.org,
        Randy Oostdyk <linux-kernel@oostdyk.com>,
        Daniel Golle <daniel@makrotopia.org>,
        Felix Fietkau <nbd@nbd.name>, Mathias Kresin <dev@kresin.me>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 21/12/2018, Stanislaw Gruszka <sgruszka@redhat.com> wrote:
> On Thu, Dec 20, 2018 at 06:52:03PM +0100, Tom Psyborg wrote:
>> Shouldn't you now also revert the commits from
>> https://git.openwrt.org/?p=openwrt/staging/dangole.git;a=commitdiff;h=de1c58a64bd66319e770d2587da07d8c9c90174a
>> since they caused throughput regression?
>
> For the record: this is not about currently posted patch and you
> reference this:
> https://lore.kernel.org/linux-wireless/1538697102-3764-1-git-send-email-pozega.tomislav@gmail.com/
>
> I'm not convinced for reverting. I would rater fix the problem
> on top of the patches.
>

Let me get this straight: You made these patches to fix wlan stalls
when "arrived at non-free entry" error message appears, but in turn
they result in lower throughput. Now you are moving err printks to dbg
level since the printks themselfs are causing wlan problems. Why would
you waste life fixing patches that don't do any good? Just revert all
of them!

> Looking at those images, the performance vary also on "good" case and
> there is entry 12.6 Mbits/s there, where the lowest entry on "bad" case
> is 32.5 Mbits/s . However, yes, if performance do not drop for unknown
> reason, it is 51.4 Mbits/s with patches and 56.6 Mbits/s on good case.
>
> Could you specify after applying which one of those 5 patches
> throughput regression starts ?
>
> Thanks
> Stanislaw
>

I cannot test that ATM but the best would be to revert all of them.
And, for the future reference, please try sending them to the
openwrt-devel list first for testing before deciding to go upstream.

Regards, Tom
