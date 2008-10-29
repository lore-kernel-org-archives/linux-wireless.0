Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:39225 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753017AbYJ2Mxp (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2008 08:53:45 -0400
Date: Wed, 29 Oct 2008 08:52:51 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: David Miller <davem@davemloft.net>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] wireless: clean up sysfs code using %pM
Message-ID: <20081029125251.GC24103@tuxdriver.com> (sfid-20081029_135352_033574_AD794DD2)
References: <1225198854.3598.6.camel@johannes.berg> <20081028.220733.88410572.davem@davemloft.net> <1225281291.5439.4.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1225281291.5439.4.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Oct 29, 2008 at 12:54:51PM +0100, Johannes Berg wrote:
> On Tue, 2008-10-28 at 22:07 -0700, David Miller wrote:
> > From: Johannes Berg <johannes@sipsolutions.net>
> > Date: Tue, 28 Oct 2008 14:00:54 +0100
> > 
> > > Remove converting the MAC address to a string by a direct byte
> > > conversion and use %pM instead, since the code is now boilerplate
> > > use a macro to define the show functions, and also use the shorter
> > > __ATTR_RO macro to define the attributes.
> > > 
> > > Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
> > > ---
> > > John, just FYI, it needs to go through net-next-2.6 since it depends on
> > > %pM. Won't cause conflicts either :)
> > 
> > I'll let John get this one.
> 
> Hmm. That means it won't get into 2.6.29 because John doesn't branch
> from your next tree but rather from Linus's tree, and thus we can't use
> %pM yet. I can resend then, doesn't matter much.

Not quite true -- wireless-testing doesn't branch from net-next-2.6,
but wireless-next-2.6 does.  Often that is a benefit for "just
wireless" development, but sometimes not...

I can push this through wireless-next-2.6 only (i.e. not in
wireless-testing), Dave could take it directly, or it could just wait.
Any preferences?

John
-- 
John W. Linville		Linux should be at the core
linville@tuxdriver.com			of your literate lifestyle.
