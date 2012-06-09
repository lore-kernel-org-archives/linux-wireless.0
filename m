Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:11355 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752875Ab2FIWD1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Jun 2012 18:03:27 -0400
Date: Sat, 9 Jun 2012 15:03:12 -0700
From: "Pedersen, Thomas" <c_tpeder@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: Re: [RFC 2/2] mac80211: support rssi threshold scan
Message-ID: <20120609220310.GA3185@pista> (sfid-20120610_000330_631829_DCA37571)
References: <1339036996-6199-1-git-send-email-c_tpeder@qca.qualcomm.com>
 <1339036996-6199-2-git-send-email-c_tpeder@qca.qualcomm.com>
 <1339229392.4539.8.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1339229392.4539.8.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Jun 09, 2012 at 10:09:52AM +0200, Johannes Berg wrote:
> On Wed, 2012-06-06 at 19:43 -0700, Thomas Pedersen wrote:
> 
> > +	if (sdata->local->scan_req->rssi &&
> > +	    rx_status->signal < sdata->local->scan_req->rssi)
> > +		return RX_DROP_MONITOR;
> 
> I believe that should be RX_CONTINUE

Thanks. Since this is considered a performance optimization, it makes
little sense to even implement it in mac80211?

Thomas
