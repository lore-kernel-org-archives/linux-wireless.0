Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:52537 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752930Ab3AaQCU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jan 2013 11:02:20 -0500
Date: Thu, 31 Jan 2013 10:02:15 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Arend van Spriel <arend@broadcom.com>,
	Stanislaw Gruszka <sgruszka@redhat.com>
Subject: Re: [PATCH 0/7] Improvements to software scanning
Message-ID: <20130131160215.GB28799@thinkpad-t410> (sfid-20130131_170224_886284_94256BAC)
References: <1359503255-18270-1-git-send-email-seth.forshee@canonical.com>
 <1359644664.8415.68.camel@jlt4.sipsolutions.net>
 <1359644916.8415.69.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1359644916.8415.69.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 31, 2013 at 04:08:36PM +0100, Johannes Berg wrote:
> On Thu, 2013-01-31 at 16:04 +0100, Johannes Berg wrote:
> > On Tue, 2013-01-29 at 17:47 -0600, Seth Forshee wrote:
> > 
> > > Johannes: I have a couple of comments/questions for you related to these
> > > patches.
> > > 
> > > First, in the patches I've added an offchan_tx_ok argument to the tx
> > > operations, but this seems a little awkward to me since it has to be
> > > propogated down through a fairly deep call stack. The alternative idea
> > > that occurred to me is to use a tx control flag, but that seems to be
> > > pretty crowded. Any thoughts?
> > 
> > Maybe you can bypass by using a flag in struct ieee80211_tx_data, so
> > only the first few functions in the call chain need the argument?
> > Otherwise, I guess adding a flag should be OK. I know it's crowded, but
> > if we really run out I guess we could move all the internal flags etc.
> > wholesale ...
> 
> Ok no that was wrong ... we can't do that because many flags need to
> survive queueing.

An ieee80211_tx_data flag would work for this case, though it doesn't
quite have the effect I was hoping for since it really only gets rid of
the argument internal to tx.c. I avoided most of the pain by leaving
ieee80211_tx_skb() unmodified, but it all still seems a bit ugly.

If you're okay with the way I've got things now I'll just stick with it.
I hate to gobble up valuable real estate in the tx control flags just to
satisfy my sense of aesthetics ;-)

Seth

