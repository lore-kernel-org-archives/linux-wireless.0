Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:34044 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755649Ab2B2UrB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Feb 2012 15:47:01 -0500
Date: Wed, 29 Feb 2012 15:35:15 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] carl9170: fix breakage from "mac80211: handle
 non-bufferable MMPDUs correctly"
Message-ID: <20120229203515.GE13733@tuxdriver.com> (sfid-20120229_214705_668166_351E2883)
References: <1330546305-26773-1-git-send-email-linville@tuxdriver.com>
 <1330546923.13717.9.camel@jlt3.sipsolutions.net>
 <201202292127.18915.chunkeey@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201202292127.18915.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 29, 2012 at 09:27:18PM +0100, Christian Lamparter wrote:
> On Wednesday, February 29, 2012 09:22:03 PM Johannes Berg wrote:
> > On Wed, 2012-02-29 at 15:11 -0500, John W. Linville wrote:
> > > That commit intended for 3.4 renamed IEEE80211_TX_CTL_POLL_RESPONSE as
> > > IEEE80211_TX_CTL_NO_PS_BUFFER.  Meanwhile, "carl9170: fix frame delivery
> > > if sta is in powersave mode" added a reference to
> > > IEEE80211_TX_CTL_POLL_RESPONSE in the fixes stream for 3.3.  This simple
> > > patch fixes that merge boo-boo.
> > 
> > Thanks, sorry about the overlap.
> Err?! I wrote and posted an updated patch on saturday.
> 
> [PATCH -wt] carl9170: fix frame delivery if sta is in powersave mode
> http://www.spinics.net/lists/linux-wireless/msg85556.html

Indeed, you did.  I think the net effect is the same, right?

I generally prefer to merge a single fix patch and account for any
conflicts in a merge.  This one slipped through because of the lack
of direct merge breakage.  Anyway, it all seems fine now.

Thanks,

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
