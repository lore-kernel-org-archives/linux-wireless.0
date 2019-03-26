Return-Path: <SRS0=Lwp6=R5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8F6DAC43381
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Mar 2019 20:35:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5BA9D20823
	for <linux-wireless@archiver.kernel.org>; Tue, 26 Mar 2019 20:35:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="Px31FPi2"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731736AbfCZUfa (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 26 Mar 2019 16:35:30 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:42808 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726207AbfCZUfa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 26 Mar 2019 16:35:30 -0400
Received: by mail-lf1-f68.google.com with SMTP id b7so5149124lfg.9
        for <linux-wireless@vger.kernel.org>; Tue, 26 Mar 2019 13:35:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=IIYy2qZrGPxroM+pVH/agfgTl3LGeNWN62YWWP94kP8=;
        b=Px31FPi23Jq2t9hh9FaGhbdmI3akyxQIPf/rRPaYAJp7sQvwY93jJHySOsoxid+Adf
         ecKobZ7UFSCjyc/oFwUUhP+Fwx5t01DBGqbaVpgG1Sy1q0kRk99wwdRFYJr2fd9aa9mz
         ptXa9/0zlVeHCNDzEsRoowCflfK+wfkU/w4RY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=IIYy2qZrGPxroM+pVH/agfgTl3LGeNWN62YWWP94kP8=;
        b=oIawLTtGiscgkrdT1X7F0EE+Zp3qCwI5OFsWXXr8X8CKWdQGvmX7ZQInGOVd6z7wcc
         /g8woSxLziu2oC4M+wdZNcw6bByoXTQuw7C3x8vNN5cdhGAy0hcJW4J4Wuit3R1OU4Lf
         HsKUPY3mn1nMMIIYqtUmd4FiRwXDYZRQHZy8Cuy51X4oy6Gk720pCudi+01w4jJbKglk
         UDkfBoG3759Pyt2tgdyc6OryVVrauy1YUYKGMbqBH/sOLuZN+sLIlBK5+zl1pGxEDF+N
         0+36UWVJBto4cacuqeB8bD+D+a9pkzfK6XvRbmMLQZ1+ek2z4l/nWDTvpWiaAQCHIAre
         07aQ==
X-Gm-Message-State: APjAAAXSt747ltV2uhARSXMebfrdbYfzZjchgpZfc9RxHmIU55gqhwne
        d0FKbBaIK3CUMbWMh/TEyggBL01mLX8=
X-Google-Smtp-Source: APXvYqzUzcCf3lF0Hbe4Ck+1F7dyMHC5isJMRubCbwgGvfRtEAQ+9mp46l/lEzSDrRFmVAYJMPI4bA==
X-Received: by 2002:a19:c018:: with SMTP id q24mr16451009lff.38.1553632527930;
        Tue, 26 Mar 2019 13:35:27 -0700 (PDT)
Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com. [209.85.208.170])
        by smtp.gmail.com with ESMTPSA id k19sm4081272lje.7.2019.03.26.13.35.24
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 26 Mar 2019 13:35:25 -0700 (PDT)
Received: by mail-lj1-f170.google.com with SMTP id p14so11394866ljg.5
        for <linux-wireless@vger.kernel.org>; Tue, 26 Mar 2019 13:35:24 -0700 (PDT)
X-Received: by 2002:a2e:3506:: with SMTP id z6mr17528991ljz.72.1553632524468;
 Tue, 26 Mar 2019 13:35:24 -0700 (PDT)
MIME-Version: 1.0
References: <20190207014143.41529-1-briannorris@chromium.org>
 <20190325202706.GA68720@google.com> <CABvG-CWODF24BMeoCE98OK5fnGNgX0k3z5qTU8A0AD9ncH0jHw@mail.gmail.com>
 <CA+ASDXMRXMSFPXfzbG_2wKzBYAZmp2AVO1qsAJdALLOkPrVRCw@mail.gmail.com>
In-Reply-To: <CA+ASDXMRXMSFPXfzbG_2wKzBYAZmp2AVO1qsAJdALLOkPrVRCw@mail.gmail.com>
From:   Brian Norris <briannorris@chromium.org>
Date:   Tue, 26 Mar 2019 13:35:12 -0700
X-Gmail-Original-Message-ID: <CA+ASDXO+qTj4FLxSQXQ7wLHU-OuY0taFkdRfb0fkEEYQwZRY9A@mail.gmail.com>
Message-ID: <CA+ASDXO+qTj4FLxSQXQ7wLHU-OuY0taFkdRfb0fkEEYQwZRY9A@mail.gmail.com>
Subject: Re: [PATCH] ath10k: pci: use mutex for diagnostic window CE polling
To:     =?UTF-8?Q?Micha=C5=82_Kazior?= <kazikcz@gmail.com>
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

On Mon, Mar 25, 2019 at 3:14 PM Brian Norris <briannorris@chromium.org> wro=
te:
> On Mon, Mar 25, 2019 at 2:20 PM Micha=C5=82 Kazior <kazikcz@gmail.com> wr=
ote:
> > For one, you'll need to defer ath10k_pci_fw_crashed_dump to a worker.
> > Maybe into ar->restart_work which the dump function calls now.
>
> Hmm, that's an idea -- although I'm not sure if I'd steal
> 'restart_work', or create a different work item on the same queue. But
> either way, we'd still also have to avoid holding 'data_lock', and at
> that point, I'm not sure if we're losing desirable properties of these
> firmware dumps -- it allows more "stuff" to keep going on while we're
> preparing to dump the device memory state.

So IIUC, we don't today have, for instance, a complete guarantee that
Copy Engines are stopped at this point, so these memory dumps are
useful mostly by the implied fact that a crashed firmware is no longer
doing anything active.

So as long as we ensure the driver is retaining exclusion on its own
resources (e.g., coredump buffers) while performing the dump work,
then we should be OK.

> > To get rid of data_lock from ath10k_pci_fw_crashed_dump() you'll need
> > to at least make fw_crash_counter into an atomic_t. This is just from
> > a quick glance.
>
> Yes, we'd need at least that much. We'd also need some other form of
> locking to ensure exclusion between all users of
> ar->coredump.fw_crash_data and similar. At the moment, that's
> 'data_lock', but I suppose we get a similar exclusion if all the
> dump/restart work is on the same workqueue.

I've cooked up a solution with a new dump_{work,mutex} to protect the
coredump buffers and do the dumping work. I still keep the 'data_lock'
only around the fw_crash_counter.

> I'm still not quite sure if this is 5.1-rc material, or I should just
> revert for 5.1.

I'll post the above soon with a goal of 5.1. If that's not considered
good enough, i'll post a revert too.

Brian
