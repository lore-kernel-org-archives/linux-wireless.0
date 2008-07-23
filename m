Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:60697 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753302AbYGWRPv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 23 Jul 2008 13:15:51 -0400
Date: Wed, 23 Jul 2008 13:15:50 -0400
From: Christoph Hellwig <hch@infradead.org>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: ath9k: some more yummy patches
Message-ID: <20080723171550.GA693@infradead.org> (sfid-20080723_191554_950777_86CC7200)
References: <43e72e890807230913v10198fbcqeecfe770490aef65@mail.gmail.com> <20080723162956.GA8742@infradead.org> <43e72e890807230943u1d39d70eo1b95ee4a38b9bcd8@mail.gmail.com> <20080723164640.GA24445@infradead.org> <43e72e890807230957p5140446dqd156aaa72d584893@mail.gmail.com> <20080723170004.GA8266@infradead.org> <43e72e890807231001y13568b36j18d3ac0f97714994@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <43e72e890807231001y13568b36j18d3ac0f97714994@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 23, 2008 at 10:01:37AM -0700, Luis R. Rodriguez wrote:
> On Wed, Jul 23, 2008 at 10:00 AM, Christoph Hellwig <hch@infradead.org> wrote:
> > On Wed, Jul 23, 2008 at 09:57:31AM -0700, Luis R. Rodriguez wrote:
> >> I take it we made it too late for .27?
> >
> > Well, we decided to put driver in anytime in the process, so if the
> > driver is cleaned up enough in the next month or so it should be able
> > to make it.
> 
> Great! We are committed so let me know if you find other critical
> areas of cleanups you'd like to see.

Let's start with some easy ones that might not be critical by itself
but help making the driver look like a normal Linux driver:

 - replace enum hal_bool with the normal bool type
 - replace A_MAX usage with the normal max/max_t macros
 - just use ASSERT instead of assert
 - think about doing the same for KASSERT
 - kill memzero
 - kill get_dma_mem_context and copy_dma_mem_context
 - replace the various debug message print helpers with standard
   Linux infrastructure
