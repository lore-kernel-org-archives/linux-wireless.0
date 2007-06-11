Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:62873 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751251AbXFKC6b (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 10 Jun 2007 22:58:31 -0400
Subject: Re: [PATCH 2/6] mac80211: remove global tsinfo debugfs variables
From: Zhu Yi <yi.zhu@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <1181331767.6533.98.camel@johannes.berg>
References: <20070608170342.GA17253@mail.intel.com>
	 <1181331767.6533.98.camel@johannes.berg>
Content-Type: text/plain
Date: Mon, 11 Jun 2007 10:57:32 +0800
Message-Id: <1181530652.3042.27.camel@debian.sh.intel.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2007-06-08 at 21:42 +0200, Johannes Berg wrote:
> On Sat, 2007-06-09 at 01:03 +0800, Zhu Yi wrote:
> 
> > --- a/net/mac80211/ieee80211_i.h
> > +++ b/net/mac80211/ieee80211_i.h
> > @@ -21,6 +21,7 @@
> >  #include <linux/workqueue.h>
> >  #include <linux/types.h>
> >  #include <linux/spinlock.h>
> > +//#include <linux/ieee80211.h>
> 
> Is that accidentally in that patch or does that serve a purpose?

This should be removed.

> > +#ifdef CONFIG_MAC80211_DEBUGFS
> > +	struct ieee80211_elem_tspec tspec;
> > +	u8 dls_mac[ETH_ALEN];
> > +#endif
> 
> Not sure I understand this. What's the point of the tspec element here? 
> I just tried to find where it's actually used but couldn't, I guess I'm
> blind.

It is used in the debugfs_netdev.c in the same patch. Search
sdata->u.sta.tspec.

> However, why do we even need a whole bunch of these files? For the QoS
> stuff I can see what you're doing, you have the DLS MAC address in
> debugfs and then a debugfs operations file that calls
> ieee80211_send_dls_req or ieee80211_send_dls_teardown. Actually, now
> that I understand it, don't you think it'd be easier to understand if
> you had two write-only (!) files
>  * dls/teardown
>  * dls/request
> and writing a mac address to each one would trigger the operation for
> that mac address? That way, you have it atomically and no problem with
> two processes stomping each other (since now you write the mac address
> and then the operation). That would be much closer to the nl80211
> interface where I'd probably just have two commands NL80211_REQUEST_DLS
> and NL80211_TEARDOWN_DLS that both take an ATTR_MAC_ADDRESS (in addition
> to the virtual interface).
> 
> Same for tspec, even though I haven't seen where it's used, why not have
> a single file that accepts the whole tspec information element that
> userspace has pieced together,

When I sent the patch the first time which used sysfs, the comment was
one value per file (Is this still true for debugfs?). So I split them
up. The drawback for all values in one file is the user has to remember
all the values and their orders.

The DLS is easier because it only has one parameter (peer mac address)
now. I programed it the same way as tspec. So when we find to need more
parameters for DLS setup, we can add another debugfs file for the new
parameter instead of combining multiple parameters in one file.

I'd agree I didn't pay a lot of attentions to the debugfs interface
design since I thought it was used for occasional debug only. Please
tell me what which do you prefer: one value per file or multiple values
per file so that we can do one shot parameter passing? So I don't need
to switch them back and forth.

>  this is the same thing we're doing with
> the information element for inclusion in the association request (wext's
> GENIE request, which IMHO should be called ASSOC_EXTRA_IE or something,
> nl80211 has it too already). Then, this tspec information element could
> be read in one go and then used in whatever way necessary when it's
> written (after suitable sanity checks on it)
> 
> johannes
