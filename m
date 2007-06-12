Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from styx.suse.cz ([82.119.242.94]:45750 "EHLO mail.suse.cz"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751974AbXFLLgL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Jun 2007 07:36:11 -0400
Date: Tue, 12 Jun 2007 13:36:08 +0200
From: Jiri Benc <jbenc@suse.cz>
To: Zhu Yi <yi.zhu@intel.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: [PATCH 2/6] mac80211: remove global tsinfo debugfs variables
Message-ID: <20070612133608.5f6e9b60@logostar.upir.cz>
In-Reply-To: <1181530652.3042.27.camel@debian.sh.intel.com>
References: <20070608170342.GA17253@mail.intel.com>
	<1181331767.6533.98.camel@johannes.berg>
	<1181530652.3042.27.camel@debian.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 11 Jun 2007 10:57:32 +0800, Zhu Yi wrote:
> > Actually, now
> > that I understand it, don't you think it'd be easier to understand if
> > you had two write-only (!) files
> >  * dls/teardown
> >  * dls/request
> > and writing a mac address to each one would trigger the operation for
> > that mac address?

I like this idea. It should be also used for send_addts and similar - would
be better than the "write anything here to trigger the event" concept.

> > That way, you have it atomically and no problem with
> > two processes stomping each other (since now you write the mac address
> > and then the operation). That would be much closer to the nl80211
> > interface where I'd probably just have two commands NL80211_REQUEST_DLS
> > and NL80211_TEARDOWN_DLS that both take an ATTR_MAC_ADDRESS (in addition
> > to the virtual interface).
> > 
> > Same for tspec, even though I haven't seen where it's used, why not have
> > a single file that accepts the whole tspec information element that
> > userspace has pieced together,
> 
> When I sent the patch the first time which used sysfs, the comment was
> one value per file (Is this still true for debugfs?). So I split them
> up. The drawback for all values in one file is the user has to remember
> all the values and their orders.

Johannes probably meant a binary blob prepared by user space. That still
complies to the one value per file rule.

> The DLS is easier because it only has one parameter (peer mac address)
> now. I programed it the same way as tspec. So when we find to need more
> parameters for DLS setup, we can add another debugfs file for the new
> parameter instead of combining multiple parameters in one file.
> 
> I'd agree I didn't pay a lot of attentions to the debugfs interface
> design since I thought it was used for occasional debug only. Please
> tell me what which do you prefer: one value per file or multiple values
> per file so that we can do one shot parameter passing? So I don't need
> to switch them back and forth.

Depends on how long you want to keep this debugfs interface. If it's just a
few months matter and it's never going to hit vanilla, it's probably not
worth the effort to rewrite it.

Thanks,

 Jiri

-- 
Jiri Benc
SUSE Labs
