Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:58702 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752301Ab2ABQB6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jan 2012 11:01:58 -0500
Subject: Re: [PATCH v2 3/3] mac80211: add sta_state callback
From: Johannes Berg <johannes@sipsolutions.net>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <CAB3XZEdXrkG_3caV4TzFrR=3fXk+TSjSLddiyke2npArcWr0pg@mail.gmail.com> (sfid-20120102_160301_804501_B80B5E36)
References: <1325162501-7996-1-git-send-email-eliad@wizery.com>
	 <1325162501-7996-4-git-send-email-eliad@wizery.com>
	 <1325501581.3643.8.camel@jlt3.sipsolutions.net>
	 <CAB3XZEfQ87gAPPAf4TO6LRbFtBh3YBRR5DO-oM=YB_BPczyCUA@mail.gmail.com>
	 <1325515471.3643.15.camel@jlt3.sipsolutions.net>
	 <CAB3XZEdXrkG_3caV4TzFrR=3fXk+TSjSLddiyke2npArcWr0pg@mail.gmail.com>
	 (sfid-20120102_160301_804501_B80B5E36)
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 02 Jan 2012 17:01:56 +0100
Message-ID: <1325520116.3643.16.camel@jlt3.sipsolutions.net> (sfid-20120102_170201_668410_3BEE9C1C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-01-02 at 17:02 +0200, Eliad Peller wrote:
> On Mon, Jan 2, 2012 at 4:44 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> >> if sta_state will be allowed to return an error, instead of adding a
> >> new backward compatibility implementation to mac80211 we can just
> >> change all the current drivers to register for sta_state(), and
> >> operate on auth->assoc and assoc->auth transitions instead of
> >> sta_add/sta_remove.
> >
> > Right, that's the alternative, but it would be easier to add the code in
> > mac80211 I think? And if we add a "NOT_EXIST" state we can completely
> > make sta_add/sta_remove be only there for drivers that don't need more
> > advanced state?
> >
> oh, so sta_/add/remove and sta_state will be 2 different mechanisms?
> now it all looks better.

Yeah I was thinking they would (should?) be.

> i guess implementing it in mac80211 is easier. hopefully, most of the
> drivers will move to the new model and finally we'll be able to delete
> the backward compatibility layer (which is always an annoying thing).

Right.

johannes

