Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:45809 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760425AbZBRWsg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 18 Feb 2009 17:48:36 -0500
Date: Wed, 18 Feb 2009 17:48:33 -0500
From: "Luis R. Rodriguez" <mcgrof@bombadil.infradead.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"Luis R. Rodriguez" <mcgrof@gmail.com>,
	wireless <linux-wireless@vger.kernel.org>,
	John Linville <linville@tuxdriver.com>
Subject: Re: ieee80211_regdom module parameter for cfg80211
Message-ID: <20090218224833.GB28733@bombadil.infradead.org> (sfid-20090218_234923_858639_6CE347D2)
References: <499C7DC0.4040608@lwfinger.net> <1234992712.4023.60.camel@johannes.local> <20090218220531.GD4246@tesla> <499C8DD2.7000800@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <499C8DD2.7000800@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 18, 2009 at 04:38:10PM -0600, Larry Finger wrote:
> Luis R. Rodriguez wrote:
> > On Wed, Feb 18, 2009 at 01:31:52PM -0800, Johannes Berg wrote:
> >> On Wed, 2009-02-18 at 15:29 -0600, Larry Finger wrote:
> >>> On at least one forum, I have seen the recommendation that a user set their
> >>> regulatory domain by creating the file /etc/modprobe.d/cfg80211 with the
> >>> contents "ieee80211_regdom=US".
> >>>
> >>> That works as long as CONFIG_WIRELESS_OLD_REGULATORY is set in their .config,
> >>> but will fail if it is not.
> >>>
> >>> Should the module_param statement be moved outside the ifdef
> >>> CONFIG_WIRELESS_OLD...? Setting the module parameter that way might not make any
> >>> sense, but it surely shouldn't kill wireless.
> >> I actually see no reason to not just /honour/ it by calling crda with
> >> its parameter if CONFIG_WIRELESS_OLD_REGULATORY isn't set.
> > 
> > The idea was that things we want to get rid of will go in OLD_REG. Static regdoms
> > for US, JP and EU fall into that and so does the module parameter. I believe
> > it is silly to keep the module parameter around as we already have userspace
> > APIs to let users set this.
> 
> I guess we leave it the way it is. At least the only people that will get caught
> are those that upgrade their distro.

Yeah, if they disable OLD_REG -- but I am curious which distributions are using this
themselves as well. Would you happen to know ? Or are you mostly seeing just users
doing that themselves?

> A clean install should redo the /etc/...
> tree and do away with such modifications.

Sure, I'd like to see us avoid upgrade issues but I'd also like to phase out
module parameters for which we have created equivalent userspace APIs. I suspect
this is a reasonable case.

  Luis
