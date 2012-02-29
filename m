Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42552 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299Ab2B2T0I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Feb 2012 14:26:08 -0500
Subject: Re: [PATCH] mac80211: Filter duplicate IE ids
From: Johannes Berg <johannes@sipsolutions.net>
To: Paul Stewart <pstew@chromium.org>
Cc: linux-wireless@vger.kernel.org,
	Sam Leffler <sleffler@chromium.org>,
	Eliad Peller <eliad@wizery.com>
In-Reply-To: <20120229185846.9183D20476@glenhelen.mtv.corp.google.com> (sfid-20120229_195918_830584_A003F6E0)
References: <CAMcMvsj2XMFarr1+fqdSv88ZLrXLquK7wgF8LsTYDBfvHFwgrA@mail.gmail.com>
	 <20120225012039.4E62720353@glenhelen.mtv.corp.google.com>
	 <CAB3XZEcp3F1ZV1MpnBrdF3uL1dpgP1zFCUB+VYFAzEMU1Zzw8A@mail.gmail.com>
	 <CAMcMvsitdrMqMUti=b-cEM6KypGH=SWPhJWnr7xY0sc7_KWOvw@mail.gmail.com>
	 <20120229185846.9183D20476@glenhelen.mtv.corp.google.com>
	 (sfid-20120229_195918_830584_A003F6E0)
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 29 Feb 2012 20:26:05 +0100
Message-ID: <1330543565.13717.8.camel@jlt3.sipsolutions.net> (sfid-20120229_202612_998783_F629C93E)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-02-23 at 17:59 -0800, Paul Stewart wrote:
> mac80211 is lenient with respect to reception of corrupted beacons.
> Even if the frame is corrupted as a whole, the available IE elements
> are still passed back and accepted, sometimes replacing legitimate
> data.  It is unknown to what extent this "feature" is made use of,
> but it is clear that in some cases, this is detrimental.  One such
> case is reported in http://crosbug.com/26832 where an AP corrupts
> its beacons but not its probe responses.
> 
> One approach would be to completely reject frames with invaid data
> (for example, if the last tag extends beyond the end of the enclosing
> PDU).  The enclosed approach is much more conservative: we simply
> prevent later IEs from overwriting the state from previous ones.
> This approach hopes that there might be some salient data in the
> IE stream before the corruption, and seeks to at least prevent that
> data from being overwritten.  This approach will fix the case above.
> 
> Further, we flag element structures that contain data we think might
> be corrupted, so that as we fill the mac80211 BSS structure, we try
> not to replace data from an un-corrupted probe response with that
> of a corrupted beacon, for example.
> 
> Short of any statistics gathering in the various forms of AP breakage,
> it's not possible to ascertain the side effects of more stringent
> discarding of data.

Acked-by: Johannes Berg <johannes@sipsolutions.net>


