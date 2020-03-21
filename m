Return-Path: <SRS0=bMqq=5G=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A89C8C4332D
	for <linux-wireless@archiver.kernel.org>; Sat, 21 Mar 2020 17:23:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7D9742076F
	for <linux-wireless@archiver.kernel.org>; Sat, 21 Mar 2020 17:23:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1584811393;
	bh=xECwvu3Zm1NEgzqD5GrnBGLFCYYFmNZsamemFqiM8NY=;
	h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:List-ID:
	 From;
	b=VDEW7aOg81Bbr/qNtzOZBDWv3ivzTepKV6mEELti2fpjyY8yVHPF6VQSsJ/wzfoYQ
	 4Ozz0Qe3QSyuw2cAdtOUiKY51t4PPqoZAvg1XnUd5k19Gj8dJKAxKel+wXv69cqzZg
	 Euql1hKVe6Q7H4w8WZ5UloCcBp1psuWzMq648t6M=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727932AbgCURXI (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 21 Mar 2020 13:23:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:50970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727548AbgCURXH (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 21 Mar 2020 13:23:07 -0400
Received: from paulmck-ThinkPad-P72.home (50-39-105-78.bvtn.or.frontiernet.net [50.39.105.78])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8AE9120767;
        Sat, 21 Mar 2020 17:23:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584811386;
        bh=xECwvu3Zm1NEgzqD5GrnBGLFCYYFmNZsamemFqiM8NY=;
        h=Date:From:To:Cc:Subject:Reply-To:References:In-Reply-To:From;
        b=0uZasLyYOOcy2Jn3NQfpB2UAWhjp74rz1TUNHg9BhAjwPgKnZR60zmujqnihmxQ4W
         7foxJjnQ0xMcW011TdKCXLYocZvyg8MDtNv8kWqj8WW3VxI5OcNV2Y2TQfkKR5STHK
         tsXIa2UPcdd8dIM4hV5/+BQQoln4Cxe0PVsX+CFA=
Received: by paulmck-ThinkPad-P72.home (Postfix, from userid 1000)
        id 8D6D435226C1; Sat, 21 Mar 2020 10:23:05 -0700 (PDT)
Date:   Sat, 21 Mar 2020 10:23:05 -0700
From:   "Paul E. McKenney" <paulmck@kernel.org>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Will Deacon <will@kernel.org>,
        Joel Fernandes <joel@joelfernandes.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Logan Gunthorpe <logang@deltatee.com>,
        Kurt Schwemmer <kurt.schwemmer@microsemi.com>,
        Bjorn Helgaas <bhelgaas@google.com>, linux-pci@vger.kernel.org,
        Felipe Balbi <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Arnd Bergmann <arnd@arndb.de>, linuxppc-dev@lists.ozlabs.org
Subject: Re: [patch V2 08/15] Documentation: Add lock ordering and nesting
 documentation
Message-ID: <20200321172305.GW3199@paulmck-ThinkPad-P72>
Reply-To: paulmck@kernel.org
References: <20200320160145.GN3199@paulmck-ThinkPad-P72>
 <87mu8apzxr.fsf@nanos.tec.linutronix.de>
 <20200320210243.GT3199@paulmck-ThinkPad-P72>
 <874kuipsbw.fsf@nanos.tec.linutronix.de>
 <20200321022930.GU3199@paulmck-ThinkPad-P72>
 <875zeyrold.fsf@nanos.tec.linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <875zeyrold.fsf@nanos.tec.linutronix.de>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Sat, Mar 21, 2020 at 11:26:06AM +0100, Thomas Gleixner wrote:
> "Paul E. McKenney" <paulmck@kernel.org> writes:
> > On Fri, Mar 20, 2020 at 11:36:03PM +0100, Thomas Gleixner wrote:
> >> I agree that what I tried to express is hard to parse, but it's at least
> >> halfways correct :)
> >
> > Apologies!  That is what I get for not looking it up in the source.  :-/
> >
> > OK, so I am stupid enough not only to get it wrong, but also to try again:
> >
> >    ... Other types of wakeups would normally unconditionally set the
> >    task state to RUNNING, but that does not work here because the task
> >    must remain blocked until the lock becomes available.  Therefore,
> >    when a non-lock wakeup attempts to awaken a task blocked waiting
> >    for a spinlock, it instead sets the saved state to RUNNING.  Then,
> >    when the lock acquisition completes, the lock wakeup sets the task
> >    state to the saved state, in this case setting it to RUNNING.
> >
> > Is that better?
> 
> Definitely!
> 
> Thanks for all the editorial work!

NP, and glad you like it!

But I felt even more stupid sometime in the middle of the night.  Why on
earth didn't I work in your nice examples?  :-/

I will pull them in later.  Time to go hike!!!

							Thanx, Paul
