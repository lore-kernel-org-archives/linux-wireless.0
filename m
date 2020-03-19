Return-Path: <SRS0=6X60=5E=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6D13C4332D
	for <linux-wireless@archiver.kernel.org>; Thu, 19 Mar 2020 08:41:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8E8F62072D
	for <linux-wireless@archiver.kernel.org>; Thu, 19 Mar 2020 08:41:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1584607282;
	bh=Ax69JWe2mAO3MiZ3t8XP/HcweZkT7pxlhXJ1svHjTis=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=duYA/TTX7XZJbLUyp0c/u6p0p4AdJIWijkc2/FvEKgn0EsK8l+RzdX8KI6JHDwic1
	 0fBjOcXun1e1x6lS1ykS9SKwCFmZXrjF1l5dTqSR62NT2dSWA9th722qt6hC04JuQ0
	 h+x9Mfxd6kEJnRHRTcieMpeOTNK6OK6yg1KhzZsc=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726976AbgCSIlS (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Thu, 19 Mar 2020 04:41:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:56280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725895AbgCSIlS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 19 Mar 2020 04:41:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 237512072C;
        Thu, 19 Mar 2020 08:41:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584607277;
        bh=Ax69JWe2mAO3MiZ3t8XP/HcweZkT7pxlhXJ1svHjTis=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NZqqpZ2jqJGbiLh1O9e+6Zp6HeAL9Yj2e7wjAbOpeJv419lkji1jaJB7nHjmMhGzm
         7GPB5mhSV879Jnm+FzyKpqgQIUxX3FrelEzxKQJHyPfzrXshDpuEU831YrsdrjaF5K
         ZKnx/byPP6ThnVhPThevhoLaMVz4u7vaQJ77K2II=
Date:   Thu, 19 Mar 2020 09:41:15 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Will Deacon <will@kernel.org>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Joel Fernandes <joel@joelfernandes.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Felipe Balbi <balbi@kernel.org>, linux-usb@vger.kernel.org,
        Logan Gunthorpe <logang@deltatee.com>,
        Kurt Schwemmer <kurt.schwemmer@microsemi.com>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Arnd Bergmann <arnd@arndb.de>, linuxppc-dev@lists.ozlabs.org
Subject: Re: [patch V2 03/15] usb: gadget: Use completion interface instead
 of open coding it
Message-ID: <20200319084115.GB3492783@kroah.com>
References: <20200318204302.693307984@linutronix.de>
 <20200318204407.700914073@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200318204407.700914073@linutronix.de>
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Wed, Mar 18, 2020 at 09:43:05PM +0100, Thomas Gleixner wrote:
> ep_io() uses a completion on stack and open codes the waiting with:
> 
>   wait_event_interruptible (done.wait, done.done);
> and
>   wait_event (done.wait, done.done);
> 
> This waits in non-exclusive mode for complete(), but there is no reason to
> do so because the completion can only be waited for by the task itself and
> complete() wakes exactly one exlusive waiter.
> 
> Replace the open coded implementation with the corresponding
> wait_for_completion*() functions.
> 
> No functional change.
> 
> Reported-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
> Cc: Felipe Balbi <balbi@kernel.org>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Cc: linux-usb@vger.kernel.org
> ---
> V2: New patch to avoid the conversion to swait interfaces later
> ---

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
