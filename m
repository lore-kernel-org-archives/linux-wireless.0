Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:59735 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750889AbZEZNrL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 May 2009 09:47:11 -0400
Subject: Re: Ralink Status
From: Dan Williams <dcbw@redhat.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Galen P Zink <galen@zinkconsulting.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20090526075700.GB3321@tuxdriver.com>
References: <C7F37A4E-95C1-4E89-9FE4-340F73900683@zinkconsulting.com>
	 <20090526075700.GB3321@tuxdriver.com>
Content-Type: text/plain
Date: Tue, 26 May 2009 09:46:41 -0400
Message-Id: <1243345601.2575.15.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2009-05-26 at 09:57 +0200, John W. Linville wrote:
> On Mon, May 25, 2009 at 04:27:52PM -0700, Galen P Zink wrote:
> > Ralink has released open source drivers for their 2800-series cards. I  
> > presume they are GPL, given how closely they're tied to the kernel. Is  
> > there any reasons these aren't coming into the linux tree?
> 
> You must be new... :-)
> 
> Those drivers are not properly integrated with existing kernel
> infrastructure.  The rt2x00 team is working on support for that
> hardware, using those drivers as a reference where appropriate.

As a follow-up, the largest reason these drivers are not imported
directly is that they do not use the standard Linux 802.11 stack
(mac80211), and having more than one 802.11 stack creates confusion,
bugs, and duplication of effort.  The rt2x00 team's driver (which is
accepted in the Linux kernel) does use the mac80211 stack, and thus is
preferred.

Dan


