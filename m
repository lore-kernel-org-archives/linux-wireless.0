Return-Path: <SRS0=1+XV=R4=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83E34C43381
	for <linux-wireless@archiver.kernel.org>; Mon, 25 Mar 2019 22:14:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 492F42075E
	for <linux-wireless@archiver.kernel.org>; Mon, 25 Mar 2019 22:14:22 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=chromium.org header.i=@chromium.org header.b="P7XWrekT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730461AbfCYWOV (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Mon, 25 Mar 2019 18:14:21 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:32840 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729297AbfCYWOV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 25 Mar 2019 18:14:21 -0400
Received: by mail-lf1-f68.google.com with SMTP id v14so7278595lfi.0
        for <linux-wireless@vger.kernel.org>; Mon, 25 Mar 2019 15:14:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=VRdCcFgQLLDWWz3qnrffDNpSK5BWq9bf0WFwIbmMFV4=;
        b=P7XWrekTGY7A8nQ7rO4xgArFr75AKAK1G6X4jdBf3U5yvR2bFi7zOk9SqWf4qF5Va1
         hY1e4eBHzv7n4+hlsvGyGXPxh9eJ2P2L9X0Yz/rK6Azh9nz4lOzRd2EUzhirgM16oEKd
         CBFD9CznHjmzYU2dyznZQzy+m1YSFRDk2Fv5Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=VRdCcFgQLLDWWz3qnrffDNpSK5BWq9bf0WFwIbmMFV4=;
        b=Kw+rhzXNHVOOr9j3SitWJR/bRdI2LY5qAo0WBpwEkMmsqxz15XySRapNMgt/kf+ZDO
         aLFGRWgprRAc/hGPlN40OYIAd1Fach1BginNHGWc4JpEotzQ1w6ogLNN+qCeNqwffi9X
         lBJeTFE29kSd+1RWLMIZJPk+f8fUno1PMWDOuPjWIHLq/Biofs/CmIdp0adnF11zResX
         CjWj7OLFZ6sBthiYNCyTwuD6iHHD5lfQuRJj3DrROEVWqQcHAbzs+v03O8Dnaem9Z/YE
         mhLz2Fq0rCucFPFo/1Nh9oHaoONDcAIc5LOVp0i3Fz2Gde3GXqS7ad9d4PGgdSpdIuhO
         p8cA==
X-Gm-Message-State: APjAAAULFWwaTeP+d1D3wAQ3LAoRsweHxxVhfCpXAwhYxiv4d31i5FzG
        7mEs9gCrHJbYdLSdwZZIIQppXPEwtgg=
X-Google-Smtp-Source: APXvYqxzI8N8w0A6JQnm/rZcjsccYGM5vrclSbvE/c1zdkVHSTEXSZ0UTp+z1zGNjsmCbCam6HY5sw==
X-Received: by 2002:a19:7916:: with SMTP id u22mr13218950lfc.144.1553552058908;
        Mon, 25 Mar 2019 15:14:18 -0700 (PDT)
Received: from mail-lf1-f47.google.com (mail-lf1-f47.google.com. [209.85.167.47])
        by smtp.gmail.com with ESMTPSA id 73sm3949707ljf.72.2019.03.25.15.14.17
        for <linux-wireless@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 25 Mar 2019 15:14:17 -0700 (PDT)
Received: by mail-lf1-f47.google.com with SMTP id u2so7147946lfd.4
        for <linux-wireless@vger.kernel.org>; Mon, 25 Mar 2019 15:14:17 -0700 (PDT)
X-Received: by 2002:ac2:598b:: with SMTP id w11mr14160537lfn.139.1553552057087;
 Mon, 25 Mar 2019 15:14:17 -0700 (PDT)
MIME-Version: 1.0
References: <20190207014143.41529-1-briannorris@chromium.org>
 <20190325202706.GA68720@google.com> <CABvG-CWODF24BMeoCE98OK5fnGNgX0k3z5qTU8A0AD9ncH0jHw@mail.gmail.com>
In-Reply-To: <CABvG-CWODF24BMeoCE98OK5fnGNgX0k3z5qTU8A0AD9ncH0jHw@mail.gmail.com>
From:   Brian Norris <briannorris@chromium.org>
Date:   Mon, 25 Mar 2019 15:14:05 -0700
X-Gmail-Original-Message-ID: <CA+ASDXMRXMSFPXfzbG_2wKzBYAZmp2AVO1qsAJdALLOkPrVRCw@mail.gmail.com>
Message-ID: <CA+ASDXMRXMSFPXfzbG_2wKzBYAZmp2AVO1qsAJdALLOkPrVRCw@mail.gmail.com>
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

Hi Michal,

Thanks for the quick and useful response.

On Mon, Mar 25, 2019 at 2:20 PM Micha=C5=82 Kazior <kazikcz@gmail.com> wrot=
e:
> On Mon, 25 Mar 2019 at 21:27, Brian Norris <briannorris@chromium.org> wro=
te:
> > It would appear that this triggers new warnings
> >
> >   BUG: sleeping function called from invalid context
> >
> > when handling firmware crashes. The call stack is
> >
> >   ath10k_pci_fw_crashed_dump
> >     -> ath10k_pci_dump_memory
> >     ...
> >       -> ath10k_pci_diag_read_mem
> >
> > and the problem is that we're holding the 'data_lock' spinlock with
> > softirqs disabled, while later trying to grab this new mutex.
>
> No, the spinlock is not the real problem. The real problem is you're
> trying to hold a mutex on a path which is potentially atomic /
> non-sleepable: ath10k_pci_napi_poll().

I'll admit here that I've been testing a variety of kernels here
(including upstream), and some of them are prior to this commit:

3c97f5de1f28 ath10k: implement NAPI support

So this was running in a tasklet, not NAPI polling. But then my
understanding was still incorrect: tasklets are also an atomic
(softirq) context. Doh.

I guess I'd say the problem is "both".

>
> > Unfortunately, data_lock is used in a lot of places, and it's unclear i=
f
> > it can be migrated to a mutex as well. It seems like it probably can be=
,
> > but I'd have to audit a little more closely.
>
> It can't be migrated to a mutex. It's intended to synchronize top half
> with bottom half. It has to be an atomic non-sleeping lock mechanism.

Ack, thanks for the correction.

> What you need to do is make sure ath10k_pci_diag_read_mem() and
> ath10k_pci_diag_write_mem() are never called from an atomic context.

I knew that part already :)

> For one, you'll need to defer ath10k_pci_fw_crashed_dump to a worker.
> Maybe into ar->restart_work which the dump function calls now.

Hmm, that's an idea -- although I'm not sure if I'd steal
'restart_work', or create a different work item on the same queue. But
either way, we'd still also have to avoid holding 'data_lock', and at
that point, I'm not sure if we're losing desirable properties of these
firmware dumps -- it allows more "stuff" to keep going on while we're
preparing to dump the device memory state.

> To get rid of data_lock from ath10k_pci_fw_crashed_dump() you'll need
> to at least make fw_crash_counter into an atomic_t. This is just from
> a quick glance.

Yes, we'd need at least that much. We'd also need some other form of
locking to ensure exclusion between all users of
ar->coredump.fw_crash_data and similar. At the moment, that's
'data_lock', but I suppose we get a similar exclusion if all the
dump/restart work is on the same workqueue.

I'm still not quite sure if this is 5.1-rc material, or I should just
revert for 5.1.

Thanks,
Brian
