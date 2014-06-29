Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.w1.fi ([212.71.239.96]:50422 "EHLO
	li674-96.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753072AbaF2SIg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 29 Jun 2014 14:08:36 -0400
Date: Sun, 29 Jun 2014 21:08:33 +0300
From: Jouni Malinen <j@w1.fi>
To: Arik Nemtsov <arik@wizery.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 05/10] mac80211: use TDLS initiator in tdls_mgmt
 operations
Message-ID: <20140629180833.GA15371@w1.fi> (sfid-20140629_201001_500276_B8A8796D)
References: <1402496307-32522-1-git-send-email-arik@wizery.com>
 <1402496307-32522-5-git-send-email-arik@wizery.com>
 <20140629104318.GA32230@w1.fi>
 <CA+XVXfeZNbTiMwid4bBX5Ft4Pz-FjDz7jwLkJqsf2FSY8YkvgQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CA+XVXfeZNbTiMwid4bBX5Ft4Pz-FjDz7jwLkJqsf2FSY8YkvgQ@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Jun 29, 2014 at 06:23:01PM +0300, Arik Nemtsov wrote:
> Well I have to say I didn't really consider mac80211 TDLS
> functionality "ready for prime time" when I've discovered this bug.
> It's something pretty basic.
> The breakage of older userspace was semi-deliberate here.

It may have lacked some functionality, but it is being deployed at least
in number of test setups.. Any such breakage of already exposed kernel
functionality needs to really be clearly identified in the commit
message, so that it is obvious to whoever may be reviewing the changes.

> But your logic is sound. If you consider this important, we can fix this.

I'm more concerned about non-mac80211 drivers since there are number of
those with TDLS support in deployed devices. However, ath9k enabled TDLS
support already in 2011 and as far as I know, it was working more or
less fine for single channel use cases since that point in time (even if
some of the teardown operations may have failed based on these new
patches and frames getting delivered through incorrect path, etc.).

While I may not be able to point to any specific deployment of
mac80211-based TDLS implementation, I don't think that it is acceptable
to break functionality that has been enabled for multiple years.. So
yes, I think that these patches will need to be fixed or reverted to
avoid such regressions.

-- 
Jouni Malinen                                            PGP id EFC895FA
