Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53736 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751327Ab2IGRwo (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Sep 2012 13:52:44 -0400
Message-ID: <1347040390.4256.39.camel@jlt4.sipsolutions.net> (sfid-20120907_195247_677476_90AF00B1)
Subject: Re: [PATCH] mac80211: add key flag for management keys
From: Johannes Berg <johannes@sipsolutions.net>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 07 Sep 2012 19:53:10 +0200
In-Reply-To: <201209071937.09316.chunkeey@googlemail.com> (sfid-20120907_193717_461401_8B53311F)
References: <1347038794-29039-1-git-send-email-johannes@sipsolutions.net>
	 <201209071937.09316.chunkeey@googlemail.com>
	 (sfid-20120907_193717_461401_8B53311F)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-09-07 at 19:37 +0200, Christian Lamparter wrote:

> > +	case NL80211_IFTYPE_WDS:
> > +	case NL80211_IFTYPE_MONITOR:
> > +	case NL80211_IFTYPE_P2P_DEVICE:
> > +	case NL80211_IFTYPE_UNSPECIFIED:
> > +	case NUM_NL80211_IFTYPES:
> > +	case NL80211_IFTYPE_P2P_CLIENT:
> > +	case NL80211_IFTYPE_P2P_GO:
> > +		/* shouldn't happen */
> > +		WARN_ON(1);
> > +		break;
> > +	}
> > +
> Is there a reason not to use default: ? 

I like the compiler warning, when we add a new iftype it'll tell use we
need to modify this code :-)

johannes

