Return-Path: <SRS0=4Kz6=5J=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D19BCC4332B
	for <linux-wireless@archiver.kernel.org>; Tue, 24 Mar 2020 08:15:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A9CA720842
	for <linux-wireless@archiver.kernel.org>; Tue, 24 Mar 2020 08:15:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1585037750;
	bh=95HDZEYr73gkVtFgHb5F5HQmWSnntZ5l5/JwKg88mxM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=lWj0yLTllWfYo+7LNqDJ7pSZmUoqXbcHW6XXHGcY+/uBqaavR7Ty9MY8TRcOWp5L2
	 8d8kV5ev5AFTIJ0UDqFPbRRTitQqaFM+BAnOoM5C0UfVGFGiCKrVx/41NhjXVErm8w
	 eIwEFvBDJSCKBBOcEImqQAU968zQeQ3ykeMstl4Y=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727159AbgCXIPr (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Tue, 24 Mar 2020 04:15:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:36458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725922AbgCXIPr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 24 Mar 2020 04:15:47 -0400
Received: from willie-the-truck (236.31.169.217.in-addr.arpa [217.169.31.236])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6C8562080C;
        Tue, 24 Mar 2020 08:15:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585037746;
        bh=95HDZEYr73gkVtFgHb5F5HQmWSnntZ5l5/JwKg88mxM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xwfUgmUW53dw91LyETvme5Ib+IkARacfJ/JGnvaqYPF7KvGq9wcyRwgOSVkigeg6u
         6gNg54OWfTL/gN8MKPjHsVbYCUIxndvuuLvaC/p9N+EC0u8/B9gnt/rPjt7yX+VOVg
         gYylIFtZ5mAQ2ZpK5nN5CxQyo23RsvgrW3gWI45M=
Date:   Tue, 24 Mar 2020 08:15:39 +0000
From:   Will Deacon <will@kernel.org>
To:     Joel Fernandes <joel@joelfernandes.org>
Cc:     Kalle Valo <kvalo@codeaurora.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>,
        "Paul E . McKenney" <paulmck@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Logan Gunthorpe <logang@deltatee.com>,
        Kurt Schwemmer <kurt.schwemmer@microsemi.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        "linux-pci@vger.kernel.org Felipe Balbi" <balbi@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        Oleg Nesterov <oleg@redhat.com>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Arnd Bergmann <arnd@arndb.de>, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH] Documentation: Clarify better about the rwsem non-owner
 release issue
Message-ID: <20200324081538.GA8696@willie-the-truck>
References: <20200322021938.175736-1-joel@joelfernandes.org>
 <87a748khlo.fsf@kamboji.qca.qualcomm.com>
 <20200323182349.GA203600@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200323182349.GA203600@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Mon, Mar 23, 2020 at 02:23:49PM -0400, Joel Fernandes wrote:
> On Sun, Mar 22, 2020 at 08:51:15AM +0200, Kalle Valo wrote:
> > "Joel Fernandes (Google)" <joel@joelfernandes.org> writes:
> > 
> > > Reword and clarify better about the rwsem non-owner release issue.
> > >
> > > Link: https://lore.kernel.org/linux-pci/20200321212144.GA6475@google.com/
> > >
> > > Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
> > 
> > There's something wrong with your linux-pci and linux-usb addresses:
> > 
> > 	"linux-pci@vger.kernel.org Felipe Balbi" <balbi@kernel.org>,
> > 
> > 
> > 	"linux-usb@vger.kernel.org Kalle Valo" <kvalo@codeaurora.org>,
> 
> Not sure. It appears fine in the archive.

Hmm, I don't think it does. Here's the copy from LKML:

https://lore.kernel.org/lkml/20200322021938.175736-1-joel@joelfernandes.org/

Which works because it's in the To: correctly. But both linux-pci and
linux-usb were *not* CC'd:

"linux-usb@vger.kernel.org Kalle Valo" <kvalo@codeaurora.org>
"linux-pci@vger.kernel.org Felipe Balbi" <balbi@kernel.org>

and searching for the message in the linux-pci archives doesn't find it:

https://lore.kernel.org/linux-pci/?q=Reword+and+clarify+better+about+the+rwsem+non-owner+release+issue

So it looks like there is an issue with your mail setup.

Will
