Return-Path: <SRS0=Zq5x=5F=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3550C43332
	for <linux-wireless@archiver.kernel.org>; Fri, 20 Mar 2020 09:20:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C22ED20752
	for <linux-wireless@archiver.kernel.org>; Fri, 20 Mar 2020 09:20:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727135AbgCTJUD (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 20 Mar 2020 05:20:03 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:34890 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726527AbgCTJUC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 20 Mar 2020 05:20:02 -0400
Received: from bigeasy by Galois.linutronix.de with local (Exim 4.80)
        (envelope-from <bigeasy@linutronix.de>)
        id 1jFDoh-0000M7-2n; Fri, 20 Mar 2020 10:19:47 +0100
Date:   Fri, 20 Mar 2020 10:19:47 +0100
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Davidlohr Bueso <dave@stgolabs.net>
Cc:     tglx@linutronix.de, arnd@arndb.de, balbi@kernel.org,
        bhelgaas@google.com, davem@davemloft.net,
        gregkh@linuxfoundation.org, joel@joelfernandes.org,
        kurt.schwemmer@microsemi.com, kvalo@codeaurora.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-wireless@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, logang@deltatee.com,
        mingo@kernel.org, mpe@ellerman.id.au, netdev@vger.kernel.org,
        oleg@redhat.com, paulmck@kernel.org, peterz@infradead.org,
        rdunlap@infradead.org, rostedt@goodmis.org,
        torvalds@linux-foundation.org, will@kernel.org,
        Davidlohr Bueso <dbueso@suse.de>
Subject: Re: [PATCH 19/15] sched/swait: Reword some of the main description
Message-ID: <20200320091947.qmj2nsjri3xq6vif@linutronix.de>
References: <20200318204302.693307984@linutronix.de>
 <20200320085527.23861-1-dave@stgolabs.net>
 <20200320085527.23861-4-dave@stgolabs.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200320085527.23861-4-dave@stgolabs.net>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2020-03-20 01:55:27 [-0700], Davidlohr Bueso wrote:
> diff --git a/include/linux/swait.h b/include/linux/swait.h
> index 73e06e9986d4..6e5b5d0e64fd 100644
> --- a/include/linux/swait.h
> +++ b/include/linux/swait.h
> @@ -39,7 +26,7 @@
>   *    sleeper state.
>   *
>   *  - the !exclusive mode; because that leads to O(n) wakeups, everything is
> - *    exclusive.
> + *    exclusive. As such swait_wake_up_one will only ever awake _one_ waiter.
                            swake_up_one()

>   *  - custom wake callback functions; because you cannot give any guarantees
>   *    about random code. This also allows swait to be used in RT, such that

Sebastian
