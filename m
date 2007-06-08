Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:33076 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1758894AbXFHJ7T (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jun 2007 05:59:19 -0400
Date: Fri, 8 Jun 2007 11:59:25 +0200
From: Jiri Benc <jbenc@suse.cz>
To: Zhu Yi <yi.zhu@intel.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Michael Wu <flamingice@sourmilk.net>
Subject: Re: [PATCH 3/3] mac80211: debugfs support for TSM and DLS
Message-ID: <20070608115925.157721ad@griffin.suse.cz>
In-Reply-To: <1181265476.3039.86.camel@debian.sh.intel.com>
References: <20070606082239.GA28667@mail.intel.com>
	<20070607223934.4726e8a7@griffin.suse.cz>
	<1181265476.3039.86.camel@debian.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 08 Jun 2007 09:17:55 +0800, Zhu Yi wrote:
> On Thu, 2007-06-07 at 22:39 +0200, Jiri Benc wrote:
> > A global variable? Common for all devices you have in your computer?
> > That's broken.
> 
> OK, it can be fixed. But it is that broken if you treat it as a debug
> helper and don't use it on mulitple interfaces simultaneously.

It's broken even when it's just a debug code. Please fix it.

> > Triggering an event just by writing anything to the debugfs file
> > doesn't seem like a clean and intelligible way to configure things.

(*)

> > Also, are you aware this is just a _debug_ stuff? Given the fact that
> > you're calling (for example) ieee80211_send_addts from debugfs handler
> > only, it looks like you're misusing it as an user space API.
> 
> If you follow the thread, I will write a user space API with cfg80211.
> This one for debugging only.

Ok, I somehow missed that. I suppose that's fine for wireless-dev then.
Except that I'm still not happy with (*). But that's probably just a
matter of taste and therefore doesn't constitute a real problem in a
debug code.

Thanks,

 Jiri

-- 
Jiri Benc
SUSE Labs
