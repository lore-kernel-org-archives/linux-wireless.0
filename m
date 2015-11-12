Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:51025 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753702AbbKLID0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Nov 2015 03:03:26 -0500
Message-ID: <1447315403.2131.1.camel@sipsolutions.net> (sfid-20151112_090329_361351_E3D0CC11)
Subject: Re: [RFC v3 6/8] kconfig: introduce "count"
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Jason Baron <jbaron@akamai.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Steven Rostedt <rostedt@goodmis.org>,
	Michal Marek <mmarek@suse.com>
Date: Thu, 12 Nov 2015 09:03:23 +0100
In-Reply-To: <1447315173.2131.0.camel@sipsolutions.net> (sfid-20151112_085940_975706_EC9F10A3)
References: <1447280120-16010-1-git-send-email-johannes@sipsolutions.net>
	 <1447280120-16010-7-git-send-email-johannes@sipsolutions.net>
	 (sfid-20151111_231543_296720_F6DDE04A) <1447315173.2131.0.camel@sipsolutions.net>
	 (sfid-20151112_085940_975706_EC9F10A3)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2015-11-12 at 08:59 +0100, Johannes Berg wrote:
> On Wed, 2015-11-11 at 23:15 +0100, Johannes Berg wrote:
> >  
> > +static unsigned long long count_or_symbols(struct expr *e)
> > +{
> > +	switch (e->type) {
> > +	case E_SYMBOL:
> > +		return 1;
> 
> Oh, this is obviously bogus - I need to count the *enabled* symbols.
> 

-               return 1;
+               sym_calc_value(e->left.sym);
+               return e->left.sym->curr.tri != no;

works properly.

johannes
