Return-Path: <SRS0=jXAT=QH=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78560C169C4
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Jan 2019 17:17:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3A72320881
	for <linux-wireless@archiver.kernel.org>; Thu, 31 Jan 2019 17:17:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="h06SBsTy"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725854AbfAaRQ7 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 31 Jan 2019 12:16:59 -0500
Received: from mail-io1-f45.google.com ([209.85.166.45]:43817 "EHLO
        mail-io1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725822AbfAaRQt (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 31 Jan 2019 12:16:49 -0500
Received: by mail-io1-f45.google.com with SMTP id b23so3250570ios.10
        for <linux-wireless@vger.kernel.org>; Thu, 31 Jan 2019 09:16:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dXgJnMBXU34f6VOh2e+3mJhBuhTcpqJlqhHntV6OpGU=;
        b=h06SBsTyMECZXG0WM41cDw+3++BnvrKyQhOk9m3COqCgLB0xKGkYFJNCuj6GWqxFEk
         mC+8pAXk8jqoiZwakbayfnAOQqKN3TVHK19N1nkazmqlwpPIdun0UC8e8dX0QNREWEUT
         EpWmu+DpcPG9dIbsu4vUfUH/D4uf+fYCOiZmYCp7AFbszP11U5fgpx63ZZU2l49czR6G
         opkrPM+WdKzsamp9KC434sYyz/A0PQ5A0rf/1iU9orksOZvLizy2s9kNgHMhn3lwbx/s
         0Y8WDqFDn7Gmj1DTVv+lQiKygCOH0CmMkcSsaf3yGtDHuXwdYO2bvLGtVw6pPmwFBAwi
         yHHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dXgJnMBXU34f6VOh2e+3mJhBuhTcpqJlqhHntV6OpGU=;
        b=cHp3ALLKU6jXQECwkj7yvqHv7J9PEp8B1pANoZmDrazl3qzffjkFvDWzddaS3ym4XZ
         7luKH20d6bd8PpGOfVb0Sta3zJ+uSEZ7dV1Cmk0ownxGbMHs7vX4X4rWEO8TBpDUEjFA
         ykwEI3vhxTWFS7SWicZNuc9xJ3UDqKWw1OUFrHbZSDQi9YnljBbasU+aSEUPhdHKv9je
         /6y6TrPYIn8yMsISHE4Jpmnw9h4RHSHfeT2Z6FtIzKvIlqLvv1F5CUKKjppIB3ArNuVe
         f1kSEKjK+LkIX+DMzgOyBHvnZD1U6HaewIS5Bjl74qKJXRUZVQmF41IdjHLJQYCUAOOl
         QviQ==
X-Gm-Message-State: AHQUAuZIyq8UCXX5F41yD0FsDYvfjXLBYYbn1f8OuK0AFdeIp22Rueuh
        bTjRLPkofm3ECDdGLPK5oz2e7R2FxCmT96swIoLXKF5E
X-Google-Smtp-Source: AHgI3IZUFvZ5/pytwxhdCwLytwHzfpEE1vfDx0jRutEYD2NpLy/LLKzHm/ysAvUIXAYs3s6Xfyh+oCwFAl1k5Cgv0zU=
X-Received: by 2002:a5e:9915:: with SMTP id t21mr18139847ioj.4.1548955008351;
 Thu, 31 Jan 2019 09:16:48 -0800 (PST)
MIME-Version: 1.0
References: <d5834c32f2ea0a619e848a9aef644161cfeab6b9.camel@linux.intel.com>
In-Reply-To: <d5834c32f2ea0a619e848a9aef644161cfeab6b9.camel@linux.intel.com>
From:   Steve deRosier <derosier@gmail.com>
Date:   Thu, 31 Jan 2019 09:16:11 -0800
Message-ID: <CALLGbRJ6ayYMCPvLCriFnLwW2vfy5azOC=yvT6tnHKkCyPWVsQ@mail.gmail.com>
Subject: Re: BCM43602 system freeze with PCI passthrough
To:     James Prestwood <james.prestwood@linux.intel.com>
Cc:     linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi James,

On Thu, Jan 31, 2019 at 9:08 AM James Prestwood
<james.prestwood@linux.intel.com> wrote:
>
> Hi,
>
> I posted about a month ago about an Ath9k card that was causing my host
> machine to freeze/lock up when doing PCI passthrough into a VM. This
> was resolved by adding:
>
> DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_ATHEROS, 0x0034,
> quirk_no_bus_reset);
>
> to drivers/pci/quirks.c and rebuilding the host kernel.
>
> Original thread:
> https://marc.info/?l=linux-wireless&m=154689580213002&w=2
>
> I am now trying to get this BCM43602 card working under the same
> conditions but again I am seeing the host machine freeze when starting
> the VM. I did try adding a similar line for this card, which actually
> prevented the machine from freezing, but I am seeing this when starting
> the VM:
>

Since you've had the same issue with two totally unrelated cards, I'm
going to suggest that perhaps the issue is not a Linux wireless one.
You see, the only thing in common with those two cards, with different
manufacturers, different drivers, different firmware, is the PCI bus
and how you're using it (PCI passthrough on QEMU). Perhaps it's either
a QEMU or a PCI bus driver issue. Have you brought up the question
with either of those teams?

- Steve
