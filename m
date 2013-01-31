Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55215 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754686Ab3AaPIO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 Jan 2013 10:08:14 -0500
Message-ID: <1359644916.8415.69.camel@jlt4.sipsolutions.net> (sfid-20130131_160817_601769_FA96BD6F)
Subject: Re: [PATCH 0/7] Improvements to software scanning
From: Johannes Berg <johannes@sipsolutions.net>
To: Seth Forshee <seth.forshee@canonical.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	Arend van Spriel <arend@broadcom.com>,
	Stanislaw Gruszka <sgruszka@redhat.com>
Date: Thu, 31 Jan 2013 16:08:36 +0100
In-Reply-To: <1359644664.8415.68.camel@jlt4.sipsolutions.net> (sfid-20130131_160420_711577_28826127)
References: <1359503255-18270-1-git-send-email-seth.forshee@canonical.com>
	 <1359644664.8415.68.camel@jlt4.sipsolutions.net>
	 (sfid-20130131_160420_711577_28826127)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-01-31 at 16:04 +0100, Johannes Berg wrote:
> On Tue, 2013-01-29 at 17:47 -0600, Seth Forshee wrote:
> 
> > Johannes: I have a couple of comments/questions for you related to these
> > patches.
> > 
> > First, in the patches I've added an offchan_tx_ok argument to the tx
> > operations, but this seems a little awkward to me since it has to be
> > propogated down through a fairly deep call stack. The alternative idea
> > that occurred to me is to use a tx control flag, but that seems to be
> > pretty crowded. Any thoughts?
> 
> Maybe you can bypass by using a flag in struct ieee80211_tx_data, so
> only the first few functions in the call chain need the argument?
> Otherwise, I guess adding a flag should be OK. I know it's crowded, but
> if we really run out I guess we could move all the internal flags etc.
> wholesale ...

Ok no that was wrong ... we can't do that because many flags need to
survive queueing.

johannes

