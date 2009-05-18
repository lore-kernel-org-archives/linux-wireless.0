Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:11743 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752339AbZERUhQ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 May 2009 16:37:16 -0400
Subject: Re: [PATCH] cfg80211: allow wext to remove keys that don't exist
From: Pavel Roskin <proski@gnu.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>, Jouni Malinen <j@w1.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>,
	Samuel Ortiz <samuel@sortiz.org>
In-Reply-To: <1242677200.29049.13.camel@johannes.local>
References: <1242669396.29049.2.camel@johannes.local>
	 <1242677076.30019.5.camel@mj>  <1242677200.29049.13.camel@johannes.local>
Content-Type: text/plain
Date: Mon, 18 May 2009 16:37:17 -0400
Message-Id: <1242679037.30019.12.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2009-05-18 at 22:06 +0200, Johannes Berg wrote:
> On Mon, 2009-05-18 at 16:04 -0400, Pavel Roskin wrote:
> > On Mon, 2009-05-18 at 19:56 +0200, Johannes Berg wrote:
> > > Some applications using wireless extensions expect to be able to
> > > remove a key that doesn't exist. One example is wpa_supplicant
> > > which doesn't actually change behaviour when running into an
> > > error while trying to do that, but it prints an error message
> > > which users interpret as wpa_supplicant having problems.
> > 
> > It sounds like you are working around a userspace problem in the kernel.
> 
> More a "user problem" rather than "userspace problem"...

Let's give users a break.  They cannot know which error messages are
important and which are not.  Users' attention should not be attracted
to trivial things such as failure to remove something that never
existed.

> > > The safe thing to do is not change the behaviour of wireless
> > > extensions any more, so when the driver reports -ENOENT let
> > > the wext bridge code return success to userspace. To guarantee
> > > this, also document that drivers should return -ENOENT when the
> > > key doesn't exist.
> > 
> > You patch is changing the behavior or wireless extensions.  It would be
> > much more reasonable for wpa_supplicant not to remove non-existent keys
> > or (if it's unsafe or non-practical for some reason) not to report
> > -ENOENT to the user.
> 
> Umm, no... my previous patch changed the behaviour and this restores it.

OK, that makes me more sympathetic to the patch, at least if the change
did not get exposed in any released kernel.

-- 
Regards,
Pavel Roskin
