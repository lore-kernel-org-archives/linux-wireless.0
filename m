Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:40031 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751021AbaAVJPJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 22 Jan 2014 04:15:09 -0500
Message-ID: <1390382106.4334.18.camel@jlt4.sipsolutions.net> (sfid-20140122_101514_820877_FCC3226B)
Subject: Re: [PATCH 3/3] cfg80211: implement multi-interface CSA
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 22 Jan 2014 10:15:06 +0100
In-Reply-To: <CA+BoTQnL5WKMb1TN7ZtDziRQ8=A8F0qq0r6jDOWCZJDCsV5cQA@mail.gmail.com> (sfid-20140122_100954_022427_5EC58ED4)
References: <1390226968-18928-1-git-send-email-michal.kazior@tieto.com>
	 <1390226968-18928-4-git-send-email-michal.kazior@tieto.com>
	 <1390319550.6199.59.camel@jlt4.sipsolutions.net>
	 <CA+BoTQ=sWMSN5NveRf0aw98mMYWks2eXKWzZvk4NZgGLOctuQQ@mail.gmail.com>
	 <1390380813.4334.5.camel@jlt4.sipsolutions.net>
	 <CA+BoTQnL5WKMb1TN7ZtDziRQ8=A8F0qq0r6jDOWCZJDCsV5cQA@mail.gmail.com>
	 (sfid-20140122_100954_022427_5EC58ED4)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-01-22 at 10:09 +0100, Michal Kazior wrote:
> On 22 January 2014 09:53, Johannes Berg <johannes@sipsolutions.net> wrote:
> > On Wed, 2014-01-22 at 07:36 +0100, Michal Kazior wrote:
> >
> >> >> +     if (!attrs[NL80211_ATTR_IFINDEX])
> >> >> +             return -EINVAL;

> >> 1: the old one, which has ifindex in the root
> >> 2: the new one, which has wiphy in the root, and an array of (1)
> >> within CH_SWITCH_IFACES (and each entry has ifindex at its root)
> >
> > Yeah I think I confused the two. This is handling case 1 only, right?
> 
> No. It handles both cases.

In general. I phrased it badly - by "this" I was referring only to the
two lines above.

> > But you have to check the ifindex manually since for case 2 you can only
> > require the pre_doit() to give you the wiphy.
> 
> In case 2 ifindex is not available in the attribute root. Can you
> require pre_doit() to check ifindex if it's possible for ifindex to be
> missing (case 2)?

No, the way you're doing it is exactly right, I just got confused.

johannes

