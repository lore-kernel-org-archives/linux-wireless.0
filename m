Return-Path: <linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5472AC433E0
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Feb 2021 21:54:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1131764FB2
	for <linux-wireless@archiver.kernel.org>; Fri,  5 Feb 2021 21:54:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232825AbhBEVwx (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 5 Feb 2021 16:52:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232008AbhBEVwl (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 5 Feb 2021 16:52:41 -0500
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 815B9C0613D6
        for <linux-wireless@vger.kernel.org>; Fri,  5 Feb 2021 13:52:01 -0800 (PST)
Received: by mail-io1-xd2a.google.com with SMTP id f6so8736668ioz.5
        for <linux-wireless@vger.kernel.org>; Fri, 05 Feb 2021 13:52:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=hbrb/uI0k3ZNQuj2wdQIApcZWfCHPVlwvdeH8dEraSY=;
        b=kwrr3ILLVbxuNn95GOVOzUFj/I8VbmFN7DHQIjWHdZ4hzEzqzgLDBrHY6JAB6GK4rj
         e9NBMfC+5XT+VMc3rHcgzSGPUBjZpe9BfKeQtVfxnQx7JCw3LkFBRSVq3WlAAEaSLcyd
         S/vGxA2CQGbb9/zj3fT0EvapZyFTHavASX7aM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=hbrb/uI0k3ZNQuj2wdQIApcZWfCHPVlwvdeH8dEraSY=;
        b=rMz1t9TqvGkTn/nQLCc/Rhek1o+j3SkNOOFWJ0a/y9ImWygBBtwvlGFs0s7391UvjU
         kW8d4ldMnshxjNlUipXYaFUg8mPli9lwwm1FhY+JwmVq1ZLA/8fj+qqCNaSeL4JGyCaA
         h2iEUMKolZzZBouuzuEYxSMtuaeaLew90/xH6F0r3w6u1AMURJbpRuLJVb1N4oXh8zn2
         d1Lq3BnCJz+Umm+xhQksJMwDFcMkeA59cCCFiW/+jkWQ9QV+TzxngZg7btWw8KGbAuLK
         Ygu213NzNvW9BgjP+iQa+vxR44TW8TP+2UZlizxRvehrZ3l1wD1T8FRh72iDUuf6UIgf
         6urQ==
X-Gm-Message-State: AOAM530iMujWlGjvlbtQyahgxCoKXbeNlwdBGPULBXr8+++JYsuQeAjQ
        ge8ZRW6x/q2vDFincVxI1gcay8ESf0Dqrh7jGEFWQA==
X-Google-Smtp-Source: ABdhPJzcxriljsqWdvwW4z6b5WmkyWMVNRVz8l3AqIltHdpJpTta6xksckQ68Rk6RRFHzAX843Ju+/a3m4NKaUf9cnc=
X-Received: by 2002:a6b:7e41:: with SMTP id k1mr5944734ioq.81.1612561920905;
 Fri, 05 Feb 2021 13:52:00 -0800 (PST)
MIME-Version: 1.0
References: <20201215172352.5311-1-youghand@codeaurora.org>
 <f2089f3c-db96-87bc-d678-199b440c05be@nbd.name> <ba0e6a3b783722c22715ae21953b1036@codeaurora.org>
In-Reply-To: <ba0e6a3b783722c22715ae21953b1036@codeaurora.org>
From:   Abhishek Kumar <kuabhs@chromium.org>
Date:   Fri, 5 Feb 2021 13:51:49 -0800
Message-ID: <CACTWRwt0F24rkueS9Ydq6gY3M-oouKGpaL3rhWngQ7cTP0xHMA@mail.gmail.com>
Subject: Re: [PATCH 2/3] mac80211: Add support to trigger sta disconnect on
 hardware restart
To:     Youghandhar Chintala <youghand@codeaurora.org>
Cc:     Felix Fietkau <nbd@nbd.name>,
        Johannes Berg <johannes@sipsolutions.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Douglas Anderson <dianders@chromium.org>,
        Brian Norris <briannorris@chromium.org>,
        Rakesh Pillai <pillair@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Since using DELBA frame to APs to re-establish BA session has a
dependency on APs and also some APs may not honour the DELBA frame. I
am fine with having the disconnect/reconnect solution. The change
looks good to me.

Reviewed-by: Abhishek Kumar <kuabhs@chromium.org>

Thanks
Abhishek

On Thu, Jan 28, 2021 at 12:08 AM <youghand@codeaurora.org> wrote:
>
> On 2020-12-15 23:10, Felix Fietkau wrote:
> > On 2020-12-15 18:23, Youghandhar Chintala wrote:
> >> Currently in case of target hardware restart, we just reconfig and
> >> re-enable the security keys and enable the network queues to start
> >> data traffic back from where it was interrupted.
> >>
> >> Many ath10k wifi chipsets have sequence numbers for the data
> >> packets assigned by firmware and the mac sequence number will
> >> restart from zero after target hardware restart leading to mismatch
> >> in the sequence number expected by the remote peer vs the sequence
> >> number of the frame sent by the target firmware.
> >>
> >> This mismatch in sequence number will cause out-of-order packets
> >> on the remote peer and all the frames sent by the device are dropped
> >> until we reach the sequence number which was sent before we restarted
> >> the target hardware
> >>
> >> In order to fix this, we trigger a sta disconnect, for the targets
> >> which expose this corresponding wiphy flag, in case of target hw
> >> restart. After this there will be a fresh connection and thereby
> >> avoiding the dropping of frames by remote peer.
> >>
> >> The right fix would be to pull the entire data path into the host
> >> which is not feasible or would need lots of complex changes and
> >> will still be inefficient.
> > How about simply tracking which tids have aggregation enabled and send
> > DELBA frames for those after the restart?
> > It would mean less disruption for affected stations and less ugly hacks
> > in the stack for unreliable hardware.
> >
> > - Felix
>
> Hi Felix,
>
> We did try to send an ADDBA frame to the AP once the SSR happened. The
> AP ack=E2=80=99ed the frame and the new BA session with renewed sequence =
number
> was established. But still, the AP did not respond to the ping requests
> with the new sequence number. It did not respond until one of the two
> happened.
> 1.      The sequence number was more than the sequence number that DUT ha=
d
> used before SSR happened
> 2.      DUT disconnected and then reconnected.
> The other option is to send a DELBA frame to the AP and make the AP also
> force to establish the BA session from its side. This we feel can have
> some interoperability issues as some of the AP=E2=80=99s may not honour t=
he
> DELBA frame and will continue to use the earlier BA session that it had
> established. Given that re-negotiating the BA session is prone to IOT
> issues, we feel that it would be good to go with the
> Disconnect/Reconnect solution which is foolproof and will work in all
> scenarios.
>
> Regards,
> Youghandhar
