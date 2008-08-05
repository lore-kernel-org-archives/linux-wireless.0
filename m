Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:49968 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751778AbYHEVPr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Aug 2008 17:15:47 -0400
Subject: Re: [PATCH 01/19] orinoco: Add ESSID specific scanning for Agere fw
From: Pavel Roskin <proski@gnu.org>
To: Dan Williams <dcbw@redhat.com>
Cc: kilroyd@googlemail.com, linux-wireless@vger.kernel.org,
	orinoco-devel@lists.sourceforge.net,
	David Kilroy <kilroyd@gmail.com>,
	Jean Tourrilhes <jt@hpl.hp.com>
In-Reply-To: <1217864060.3139.10.camel@localhost.localdomain>
References: <1217672073-7094-1-git-send-email-kilroyd@gmail.com>
	 <1217672073-7094-2-git-send-email-kilroyd@gmail.com>
	 <1217825304.10989.20.camel@dv>
	 <1217864060.3139.10.camel@localhost.localdomain>
Content-Type: text/plain
Date: Tue, 05 Aug 2008 17:15:44 -0400
Message-Id: <1217970944.2908.11.camel@dv> (sfid-20080805_231554_081400_AFFA5E67)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-08-04 at 11:34 -0400, Dan Williams wrote:

> Maybe the wireless-tools breakage you're experiencing is causing this to
> fail on x86-64?  Are you using 64-bit wireless-tools and a 64-bit
> kernel, or 32-bit wireless tools with a 64-bit kernel?

I'm using 64-bit kernel with 64-bit userspace.

If I use 32-bit kernel with 32-bit userspace, essid filtering works, but
only to a degree.  Old scan results are cached somewhere, so if I scan
with essid and then without essid, I get filtered results.  Likewise, If
I don't use filtering the first time, but use it the second time, I get
unfiltered results.

I cannot imagine how this bug could have evaded even most basic testing.

I would prefer that we don't merge unreliable functionality.  It's not
needed for WPA support.  And it don't look like and improvement in its
present form.

-- 
Regards,
Pavel Roskin
