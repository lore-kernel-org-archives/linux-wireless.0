Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44229 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752627Ab3ABM56 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Jan 2013 07:57:58 -0500
Message-ID: <1357131499.9839.19.camel@jlt4.sipsolutions.net> (sfid-20130102_135805_248791_7B5EFC7E)
Subject: Re: [PATCH] nl80211: allow ad-hoc to set WMM parameters from outside
From: Johannes Berg <johannes@sipsolutions.net>
To: Adrian Chadd <adrian@freebsd.org>
Cc: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	mathias.kretschmer@fokus.fraunhofer.de,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Date: Wed, 02 Jan 2013 13:58:19 +0100
In-Reply-To: <CAJ-Vmok_UDVykup4xHCigrBbzErOhUQOZMATJ+=qkBFOHQS+Bg@mail.gmail.com> (sfid-20130102_004632_190205_ACBF40E1)
References: <1354042232-32428-1-git-send-email-siwu@hrz.tu-chemnitz.de>
	 <1354042232-32428-2-git-send-email-siwu@hrz.tu-chemnitz.de>
	 <1354111295.9345.25.camel@jlt4.sipsolutions.net>
	 <20121130134311.GA19037@pandem0nium>
	 <1356707102.9922.26.camel@jlt4.sipsolutions.net>
	 <20121230233304.GB16767@pandem0nium>
	 <CAJ-Vmok_UDVykup4xHCigrBbzErOhUQOZMATJ+=qkBFOHQS+Bg@mail.gmail.com>
	 (sfid-20130102_004632_190205_ACBF40E1)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-01-01 at 15:46 -0800, Adrian Chadd wrote:
> I've been looking at WME parameter handling for FreeBSD's net80211
> stack (with and without 802.11n support.)
> 
> Yes, the problem is figuring out what the actual BSS configuration
> _should_ be. You could potentially hear a variety of different WMM
> parameters from a variety of different nodes in the BSS (depending
> upon how buggy their WMM IE handling in adhoc mode is, I guess) so you
> can't just simply update the WMM parameters based on what you hear
> from peers.
> 
> What I have thus far:
> 
> * When creating a BSS, used the stored values;
> * When joining a BSS, use the configuration from the BSS node you've
> initially decided to "join" against, and hope they're actually
> "correct";
> * When doing a BSS merge, use the configuration from the BSS node that
> you're joining to;
> * If a different BSS configuration is heard from the node you joined
> against, update your local configuration;
> * .. and set a timer that enforces you don't change your configuration
> for another 'n' ms (for n > 1000?) even if the joined/merged BSS ID
> changes its config.
> 
> STA mode operation has the STA listening to changes in the BSS. It
> only hears these frames from the active AP so you don't have churn if
> you hear different WMM IEs from different APs (in the same SSID.)
> adhoc is slightly crazier there.
> 
> My only concern is having oscillating BSS updates propagate across the
> network in a rather silly looking fashion. Hence the BGP 'route
> dampening' style timer to try and ensure that doesn't occur.
> 
> It'd be nice if we could come up with a unified way of doing this and
> have it interoperate between FreeBSD/Linux (and any other vendor
> adhoc+wmm implementations out there.)

Makes sense to me, but I'm not really into IBSS.

Overall, that speaks for having the parameters given as part of the
"IBSS join" command rather than being updated on the fly though.

johannes

