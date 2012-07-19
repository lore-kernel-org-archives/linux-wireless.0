Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:35391 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751036Ab2GSVLU (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Jul 2012 17:11:20 -0400
Date: Thu, 19 Jul 2012 17:11:14 -0400
From: Pavel Roskin <proski@gnu.org>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: <ath6kl-devel@qualcomm.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath6kl: fix incorrect use of IEEE80211_NUM_BANDS
Message-ID: <20120719171114.4d904006@mj> (sfid-20120719_231123_683868_9B374E4F)
In-Reply-To: <5007EABC.5050905@qca.qualcomm.com>
References: <20120712091311.9751.60082.stgit@localhost6.localdomain6>
	<20120712134855.53d23fef@mj>
	<5007EABC.5050905@qca.qualcomm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 19 Jul 2012 14:08:44 +0300
Kalle Valo <kvalo@qca.qualcomm.com> wrote:

> Hi Pavel,
> 
> sorry for the late reply, this got accidentally buried inside my todo
> folder.

No problem.

> On 07/12/2012 08:48 PM, Pavel Roskin wrote:
> > On Thu, 12 Jul 2012 12:13:12 +0300
> > Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> > 
> >> +	/* only check 2.4 and 5 GHz bands, skip the rest */
> >> +	for (band = 0; band <= IEEE80211_BAND_5GHZ; band++) {
> > 
> > There is something inelegant here.  The code is mixing an integer
> > and an enum.  I'd rather go with one or those:
> > 
> > two enums:
> > for (band = IEEE80211_BAND_2GHZ; band <= IEEE80211_BAND_5GHZ;
> > band++) {
> 
> I somewhat see your point. But IMHO zero is commonly used when
> iterating over an enum to denote the first value and I don't see how
> IEEE80211_BAND_2GHZ helps here.

It's the lowest band we support.  What if the 900MHz band is added one
day?

> > or two integers:
> > for (band = 0; band <= ATH6KL_NUM_BANDS; band++) {
> 
> ATH6KL_NUM_BANDS is also an enum so I don't see the difference.

Actually, it should NOT be _seen_ as an enum, even if it is defined as
such.  It's a number of bands, not an arbitrary number.

But I don't want to argue further any about it.  Anything short of
having a bitmap of supported bands would be "good enough for now", and
having the bitmap may be hard to justify if only three bands are
recognized.  Things may change if more bands are added (900MHz, 3.7GHz
etc).

-- 
Regards,
Pavel Roskin
