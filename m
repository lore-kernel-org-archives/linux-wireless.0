Return-Path: <SRS0=6X60=5E=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D65BC4332B
	for <linux-wireless@archiver.kernel.org>; Thu, 19 Mar 2020 09:22:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6EB8C20773
	for <linux-wireless@archiver.kernel.org>; Thu, 19 Mar 2020 09:22:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727039AbgCSJWR (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 19 Mar 2020 05:22:17 -0400
Received: from mx2.suse.de ([195.135.220.15]:50068 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726968AbgCSJWR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 19 Mar 2020 05:22:17 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 2697EAE59;
        Thu, 19 Mar 2020 09:22:15 +0000 (UTC)
Date:   Thu, 19 Mar 2020 02:21:07 -0700
From:   Davidlohr Bueso <dave@stgolabs.net>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Will Deacon <will@kernel.org>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Joel Fernandes <joel@joelfernandes.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Arnd Bergmann <arnd@arndb.de>, linuxppc-dev@lists.ozlabs.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Logan Gunthorpe <logang@deltatee.com>,
        Kurt Schwemmer <kurt.schwemmer@microsemi.com>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>
Subject: Re: [patch V2 07/15] powerpc/ps3: Convert half completion to rcuwait
Message-ID: <20200319092107.6brm26peh3h2n4sk@linux-p48b>
References: <20200318204302.693307984@linutronix.de>
 <20200318204408.102694393@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200318204408.102694393@linutronix.de>
User-Agent: NeoMutt/20180716
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, 18 Mar 2020, Thomas Gleixner wrote:
>AFAICT the kthread uses TASK_INTERRUPTIBLE to not increase loadavg, kthreads
>cannot receive signals by default and this one doesn't look different. Use
>TASK_IDLE instead.

Hmm it seems in general this needs to be done kernel-wide. This kthread abuse of
TASK_INTERRUPTIBLE seems to be a common thing. There's also the users doing
schedule_timeout_interruptible()...

Thanks,
Davidlohr
