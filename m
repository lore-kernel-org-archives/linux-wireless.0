Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:65009 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755137AbZLBBTr (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 Dec 2009 20:19:47 -0500
Subject: Re: [PATCH] mac80211: allow disabling 40MHz on 2.4GHz
From: Pavel Roskin <proski@gnu.org>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	John Linville <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <43e72e890912011118w535781a4id4e4572df16267f4@mail.gmail.com>
References: <1259688582.32171.97.camel@johannes.local>
	 <1259691446.4806.12.camel@mj>  <1259692053.32171.98.camel@johannes.local>
	 <43e72e890912011118w535781a4id4e4572df16267f4@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 01 Dec 2009 20:19:14 -0500
Message-Id: <1259716754.11611.6.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2009-12-01 at 11:18 -0800, Luis R. Rodriguez wrote:
> >> That looks like a hack to me.
> >>
> >> Maybe it should be treated like other CRDA flags?  In fact, you can find
> >> this in dbparse.py in the wireless-regdb sources:
> >>
> >>     # hole at bit 9. FIXME: Where is NO-HT40 defined?
> >>     'NO-HT40':          1<<10,
> >>
> >> However, there are no other references to NO-HT40 in the wireless-regdb
> >> or CRDA sources.  I assume it's not implemented.
> >
> > It's not a regulatory requirement, it's a coexistence requirement.
> 
> To extend this text a little more, me and Johannes had reviewed usage
> of a NO-HT40 flag for regulatory purposes a while back. It was used
> mainly on the old Atheros HAL regulatory code and upon a lot of review
> even with our own regulatory folks determined that in fact there was
> no specific rules about disallowing 40 MHz, but that when this was
> disallowed it can be implied by the frequency range not fitting a 40
> MHz channel. This is currently computed dynamically now on cfg80211
> and its results are outputed through the file:
> 
> /sys/kernel/debug/ieee80211/phy0/ht40allow_map

OK, good to know.

Anyway, I think that using module parameters for any configuration
creates a bad precedent.  Disabling HT40 in the 2.4GHz band is a "fine
tuning" compared to other settings.  But there may be many other such
"knobs" (e.g. ACK timeout), and if they all are controlled by mac80211
parameters, it would be a maintenance nightmare.

If module parameters are discourages for the drivers, mac80211 should be
held to the same standard.

-- 
Regards,
Pavel Roskin
