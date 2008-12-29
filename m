Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:47032 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751135AbYL2S1k (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Dec 2008 13:27:40 -0500
Subject: Re: Hostapd doesn't like crda
From: Pavel Roskin <proski@gnu.org>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: Michael Buesch <mb@bu3sch.de>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	Dan E <trg_info@mailhaven.com>, Jouni Malinen <j@w1.fi>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20081229161828.GT5944@tesla>
References: <200812272208.20153.mb@bu3sch.de>
	 <200812291128.00512.mb@bu3sch.de> <20081229155613.GR5944@tesla>
	 <200812291704.28163.mb@bu3sch.de>  <20081229161828.GT5944@tesla>
Content-Type: text/plain
Date: Mon, 29 Dec 2008 13:27:36 -0500
Message-Id: <1230575256.22537.3.camel@dv> (sfid-20081229_192743_597498_819BE2B5)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-12-29 at 08:18 -0800, Luis R. Rodriguez wrote:
> > I think this wouldn't be hackish, but do we actually _know_ when crda has finished
> > uploading regulatory information? Does it do it all in one step?
> 
> It would go in through another nl80211 command, NL80211_CMD_SET_REG. nl80211 eventually
> calls set_regdom() and this will set it, so if all goes well we can remove the timer
> at the end if its active (other means can call CRDA like for 802.11d or the wireless core
> upon initialization).

Can we have a command to _get_ regulatory settings?  I think it would be
useful.  Then hostapd could wait until the correct settings are active.
If it doesn't happen after some time, hostapd should exit with an error.

It would be even better if hostapd could wait for an event notifying of
the regulatory settings change.

-- 
Regards,
Pavel Roskin
