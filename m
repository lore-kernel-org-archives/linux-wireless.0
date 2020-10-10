Return-Path: <SRS0=cbTT=DR=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3C1CC43467
	for <linux-wireless@archiver.kernel.org>; Sat, 10 Oct 2020 22:52:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA66520829
	for <linux-wireless@archiver.kernel.org>; Sat, 10 Oct 2020 22:52:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602370375;
	bh=Wm+2t5Tn8HAfRb+NiT1DGYzcTM4re5k/zB2Fox6sQ0Q=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:List-ID:From;
	b=fyOsfjqL2TQSf5gXakuMvh4ETtfQpy4LagUdovgsQ1qaZu9k8hJRwqIU440TV/zRU
	 7lGCukRS9Z03yIWey8UDV/kU6HirntHO1Uh64iXsNxE7OIvK7KeAvZctDUQx61TY6L
	 ZdOJSqSoe4ypNLakJ4CNs+HmjgXJcCOSIAz9OF/s=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387932AbgJJWwx (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 10 Oct 2020 18:52:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:54888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732187AbgJJTmt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 10 Oct 2020 15:42:49 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 146F22227F;
        Sat, 10 Oct 2020 15:14:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602342873;
        bh=Wm+2t5Tn8HAfRb+NiT1DGYzcTM4re5k/zB2Fox6sQ0Q=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jGQcodPHlLmCZfKRkUuKRLDJOZBM5RKr1mBTJm64M/HtmdiglIKVDToo4Z1Z5fUzw
         qxH43hZq5SIJ4ytU+fO/QFVNKwcEhnWDpODXgdSBwpimM/dg7iZck5h52Z61hnwFTo
         LYtS4npwciM6z7mTBCOArmovHmlpQo1acSGihoWU=
Date:   Sat, 10 Oct 2020 08:14:31 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Dmitry Vyukov <dvyukov@google.com>
Cc:     Aleksandr Nogikh <a.nogikh@gmail.com>,
        David Miller <davem@davemloft.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        Eric Dumazet <edumazet@google.com>,
        Andrey Konovalov <andreyknvl@google.com>,
        Marco Elver <elver@google.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Aleksandr Nogikh <nogikh@google.com>
Subject: Re: [PATCH 1/2] net: store KCOV remote handle in sk_buff
Message-ID: <20201010081431.1f2d9d0d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CACT4Y+ZF_umjBpyJiCb8YPQOOSofG-M9h0CB=xn3bCgK=Kr=9w@mail.gmail.com>
References: <20201007101726.3149375-1-a.nogikh@gmail.com>
        <20201007101726.3149375-2-a.nogikh@gmail.com>
        <20201009161558.57792e1a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CACT4Y+ZF_umjBpyJiCb8YPQOOSofG-M9h0CB=xn3bCgK=Kr=9w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sat, 10 Oct 2020 09:54:57 +0200 Dmitry Vyukov wrote:
> On Sat, Oct 10, 2020 at 1:16 AM Jakub Kicinski <kuba@kernel.org> wrote:
> > On Wed,  7 Oct 2020 10:17:25 +0000 Aleksandr Nogikh wrote:  
> > > From: Aleksandr Nogikh <nogikh@google.com>
> > >
> > > Remote KCOV coverage collection enables coverage-guided fuzzing of the
> > > code that is not reachable during normal system call execution. It is
> > > especially helpful for fuzzing networking subsystems, where it is
> > > common to perform packet handling in separate work queues even for the
> > > packets that originated directly from the user space.
> > >
> > > Enable coverage-guided frame injection by adding a kcov_handle
> > > parameter to sk_buff structure. Initialization in __alloc_skb ensures
> > > that no socket buffer that was generated during a system call will be
> > > missed.
> > >
> > > Code that is of interest and that performs packet processing should be
> > > annotated with kcov_remote_start()/kcov_remote_stop().
> > >
> > > An alternative approach is to determine kcov_handle solely on the
> > > basis of the device/interface that received the specific socket
> > > buffer. However, in this case it would be impossible to distinguish
> > > between packets that originated from normal background network
> > > processes and those that were intentionally injected from the user
> > > space.
> > >
> > > Signed-off-by: Aleksandr Nogikh <nogikh@google.com>  
> >
> > Could you use skb_extensions for this?  
> 
> Why? If for space, this is already under a non-production ifdef.

I understand, but the skb_ext infra is there for uncommon use cases
like this one. Any particular reason you don't want to use it? 
The slight LoC increase?

Is there any precedent for adding the kcov field to other performance
critical structures?
