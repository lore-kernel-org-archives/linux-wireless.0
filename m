Return-Path: <SRS0=1+XV=R4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45CC0C43381
	for <linux-wireless@archiver.kernel.org>; Mon, 25 Mar 2019 21:20:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 15FC92084D
	for <linux-wireless@archiver.kernel.org>; Mon, 25 Mar 2019 21:20:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LKge5WxI"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730211AbfCYVU2 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 25 Mar 2019 17:20:28 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:41945 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727579AbfCYVU1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 25 Mar 2019 17:20:27 -0400
Received: by mail-qt1-f195.google.com with SMTP id w30so12145969qta.8
        for <linux-wireless@vger.kernel.org>; Mon, 25 Mar 2019 14:20:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=UgdEkDjhhrsx0zCPjTk0zLSfg8OJYnBMfZDsF0Vu/dI=;
        b=LKge5WxILPWQjdTlE5ARxuDkBAwvWoFyPmMM2YqgSOse9jMiJMpinW+Fbb5E3jAWVU
         C+/nZbjoOhh+0rRu/O0cLlwokM5tt0kEar8Hd1I43QdbbhlQaz517RlCvXIY3R10eA4V
         Yj2p0ezqBI+a1HRCXwY4qomF53L3SbCuBXlRC9KL0/DAMccoTOPxc/ucZ185uthDb5Si
         B4q7eKgA4KIK75mQhsul31Z/lUlFloWmTfFrHyqlGDElU/cuLful2mqVea6TivdhgiM9
         D1gjYZ2qPciVYBHIB8gfuzXF4RsnE5Bb9rA26oXblPADzL2ON639qHbO/go9mbm4bhwY
         r/5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=UgdEkDjhhrsx0zCPjTk0zLSfg8OJYnBMfZDsF0Vu/dI=;
        b=XxJuPuI4QxGWbBKwG+T1qbrgI8z6uwdGgL1GzazW+d0ApS1WpO7ftGsKXzxsitE6iB
         a9scRzHpHRNOv0Qz+cplTLhs4scvXKN2c+I6uDQTdAyIGLLi5ljsuV8DFuof8T+otsoi
         aArfhGrmZ/9nXjU9ejMz/HfDEMbV4w/Mf/E+WLiIn5DAbJkm+0rUeP6LUdfpkrg0Owez
         +syy6BfS7+sPAxCuXQZV8/8m8gQUp/jdC49b8iSEyLtUbAx9z5ecmcC+F15EfDdEqMab
         PjBAXCCHoFtHauL+spJPcgAKVQbtGUwzvHLo5O33BfnnwVSWQ+0I/8W2WCKTVfiLi1u5
         Tmxg==
X-Gm-Message-State: APjAAAXJropP4uJCuCdOwS6sSNEcjFymD5dczbP8CMLR+qjdMexN4K94
        MnW8FOOvwqGojBuCq5C4//X7X8PLDEXzAWYvAL4=
X-Google-Smtp-Source: APXvYqzu52sbt/XC8BDFAhZ2ZLsVAB4Cjr3EE87wF9dlXA3D5kJxX2BvRpJSCOr8ZXsfEH2T75Dr8vOV0DaM56PZB94=
X-Received: by 2002:ac8:3113:: with SMTP id g19mr23216998qtb.356.1553548826667;
 Mon, 25 Mar 2019 14:20:26 -0700 (PDT)
MIME-Version: 1.0
References: <20190207014143.41529-1-briannorris@chromium.org> <20190325202706.GA68720@google.com>
In-Reply-To: <20190325202706.GA68720@google.com>
From:   =?UTF-8?Q?Micha=C5=82_Kazior?= <kazikcz@gmail.com>
Date:   Mon, 25 Mar 2019 22:20:14 +0100
Message-ID: <CABvG-CWODF24BMeoCE98OK5fnGNgX0k3z5qTU8A0AD9ncH0jHw@mail.gmail.com>
Subject: Re: [PATCH] ath10k: pci: use mutex for diagnostic window CE polling
To:     Brian Norris <briannorris@chromium.org>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        Carl Huang <cjhuang@codeaurora.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        ath10k@lists.infradead.org, Wen Gong <wgong@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi Brian,

On Mon, 25 Mar 2019 at 21:27, Brian Norris <briannorris@chromium.org> wrote=
:
> Hi Kalle,
>
> On Wed, Feb 06, 2019 at 05:41:43PM -0800, Brian Norris wrote:
> > The DIAG copy engine is only used via polling, but it holds a spinlock
> > with softirqs disabled. Each iteration of our read/write loops can
> > theoretically take 20ms (two 10ms timeout loops), and this loop can be
> > run an unbounded number of times while holding the spinlock -- dependen=
t
> > on the request size given by the caller.
> >
> > As of commit 39501ea64116 ("ath10k: download firmware via diag Copy
> > Engine for QCA6174 and QCA9377."), we transfer large chunks of firmware
> > memory using this mechanism. With large enough firmware segments, this
> > becomes an exceedingly long period for disabling soft IRQs. For example=
,
> > with a 500KiB firmware segment, in testing QCA6174A, I see 200 loop
> > iterations of about 50-100us each, which can total about 10-20ms.
> >
> > In reality, we don't really need to block softirqs for this duration.
> > The DIAG CE is only used in polling mode, and we only need to hold
> > ce_lock to make sure any CE bookkeeping is done without screwing up
> > another CE. Otherwise, we only need to ensure exclusion between
> > ath10k_pci_diag_{read,write}_mem() contexts.
> >
> > This patch moves to use fine-grained locking for the shared ce_lock,
> > while adding a new mutex just to ensure mutual exclusion of diag
> > read/write operations.
> >
> > Tested on QCA6174A, firmware version WLAN.RM.4.4.1-00132-QCARMSWPZ-1.
> >
> > Fixes: 39501ea64116 ("ath10k: download firmware via diag Copy Engine fo=
r QCA6174 and QCA9377.")
> > Signed-off-by: Brian Norris <briannorris@chromium.org>
>
> It would appear that this triggers new warnings
>
>   BUG: sleeping function called from invalid context
>
> when handling firmware crashes. The call stack is
>
>   ath10k_pci_fw_crashed_dump
>     -> ath10k_pci_dump_memory
>     ...
>       -> ath10k_pci_diag_read_mem
>
> and the problem is that we're holding the 'data_lock' spinlock with
> softirqs disabled, while later trying to grab this new mutex.

No, the spinlock is not the real problem. The real problem is you're
trying to hold a mutex on a path which is potentially atomic /
non-sleepable: ath10k_pci_napi_poll().


> Unfortunately, data_lock is used in a lot of places, and it's unclear if
> it can be migrated to a mutex as well. It seems like it probably can be,
> but I'd have to audit a little more closely.

It can't be migrated to a mutex. It's intended to synchronize top half
with bottom half. It has to be an atomic non-sleeping lock mechanism.

What you need to do is make sure ath10k_pci_diag_read_mem() and
ath10k_pci_diag_write_mem() are never called from an atomic context.

For one, you'll need to defer ath10k_pci_fw_crashed_dump to a worker.
Maybe into ar->restart_work which the dump function calls now.

To get rid of data_lock from ath10k_pci_fw_crashed_dump() you'll need
to at least make fw_crash_counter into an atomic_t. This is just from
a quick glance.


Micha=C5=82
