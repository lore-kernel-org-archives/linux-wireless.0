Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:40597 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751810AbYL2TV2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Dec 2008 14:21:28 -0500
Date: Mon, 29 Dec 2008 21:21:16 +0200
From: Jouni Malinen <j@w1.fi>
To: Pavel Roskin <proski@gnu.org>
Cc: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Michael Buesch <mb@bu3sch.de>,
	Luis Rodriguez <Luis.Rodriguez@atheros.com>,
	Dan E <trg_info@mailhaven.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: Hostapd doesn't like crda
Message-ID: <20081229192116.GA20493@jm.kir.nu> (sfid-20081229_202132_974194_0EFFDC38)
References: <200812272208.20153.mb@bu3sch.de> <200812291128.00512.mb@bu3sch.de> <20081229155613.GR5944@tesla> <200812291704.28163.mb@bu3sch.de> <20081229161828.GT5944@tesla> <1230575256.22537.3.camel@dv>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1230575256.22537.3.camel@dv>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 29, 2008 at 01:27:36PM -0500, Pavel Roskin wrote:
> On Mon, 2008-12-29 at 08:18 -0800, Luis R. Rodriguez wrote:
> > > I think this wouldn't be hackish, but do we actually _know_ when crda has finished
> > > uploading regulatory information? Does it do it all in one step?
> > 
> > It would go in through another nl80211 command, NL80211_CMD_SET_REG. nl80211 eventually
> > calls set_regdom() and this will set it, so if all goes well we can remove the timer
> > at the end if its active (other means can call CRDA like for 802.11d or the wireless core
> > upon initialization).
> 
> Can we have a command to _get_ regulatory settings?  I think it would be
> useful.  Then hostapd could wait until the correct settings are active.
> If it doesn't happen after some time, hostapd should exit with an error.
> 
> It would be even better if hostapd could wait for an event notifying of
> the regulatory settings change.

While I could make hostapd poll for the change (either with get or by
waiting in a local loop waiting for the event; both are about equally
horrible hacks), I would really prefer this to be done by blocking the
response message in the kernel rather than requiring all user space apps
(or scripts, for that matter) from having to do this. This is just
likely to result in silly "sleep 1" everywhere and hoping that it is
always long enough wait..

I might even be tempted to just push that out from hostapd and leave it
to be a somebody else's problem (that silly shell script with sleep 1)
if the needed mechanism would mean that restarting hostapd takes extra
time). A command for querying the current country would get rid of the
extra penalty on restarts, so I would probably prefer it if these two
options were the only available choices.

Either way, the main problems I see here is to figure out when exactly
the CRDA processing has been completed and to make sure that userspace
apps will somehow know when that happened (i.e., get country better not
return the new country code before all CRDA parameters have been
configured and available for the following set_freq command).

-- 
Jouni Malinen                                            PGP id EFC895FA
