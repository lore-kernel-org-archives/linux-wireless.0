Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:45501 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751750AbaEZLyu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 26 May 2014 07:54:50 -0400
Message-ID: <1401105274.4431.9.camel@dubbel> (sfid-20140526_135453_890369_EE078580)
From: Luca Coelho <luca@coelho.fi>
To: Arend van Spriel <arend@broadcom.com>
Cc: Johannes Berg <johannes@sipsolutions.net>, Jouni Malinen <j@w1.fi>,
	"hostap@lists.shmoo.com" <hostap@lists.shmoo.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Mon, 26 May 2014 14:54:34 +0300
In-Reply-To: <536A1FA9.7010404@broadcom.com>
References: <536A1FA9.7010404@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: scheduled scan api
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Arend,

I'm replying to this since I've been "somewhat" involved in the
implementation. ;)

I think it will make more sense if you check the nl80211 doc:


---8<----
 * @NL80211_ATTR_SCHED_SCAN_MATCH: Nested attribute with one or more
 *	sets of attributes to match during scheduled scans.  Only BSSs
 *	that match any of the sets will be reported.  These are
 *	pass-thru filter rules.
 *	For a match to succeed, the BSS must match all attributes of a
 *	set.  Since not every hardware supports matching all types of
 *	attributes, there is no guarantee that the reported BSSs are
 *	fully complying with the match sets and userspace needs to be
 *	able to ignore them by itself.
 *	Thus, the implementation is somewhat hardware-dependent, but
 *	this is only an optimization and the userspace application
 *	needs to handle all the non-filtered results anyway.
 *	If the match attributes don't make sense when combined with
 *	the values passed in @NL80211_ATTR_SCAN_SSIDS (eg. if an SSID
 *	is included in the probe request, but the match attributes
 *	will never let it go through), -EINVAL may be returned.
 *	If ommited, no filtering is done.
---8<----

Especially the second paragraph.  This means that for the SSIDs, a
broadcast SSID means that everything goes through, there is no filtering
of SSIDs.  You can use that for RSSI-only matches with a single RSSI
match attribute (so you don't need to specify an RSSI attribute for
every SSID you need to match).

This is a bit unclear, but it's due to some confusion that was
introduced when the RSSI match attribute was added.

--
Luca.

On Wed, 2014-05-07 at 13:57 +0200, Arend van Spriel wrote:
> Hi Johannes,
> 
> I received a couple of reports from people who got problem with brcmfmac 
> when a scheduled scan is requested, without any ssid specified. 
> Currently, brcmfmac basically rejects the request. So what are valid 
> usage scenarios for scheduled scans with respect to the n_ssid, 
> n_channels, and n_matchsets. In the kernel doc below it says a 
> zero-length ssid means 'no match'. I suppose it means any ssid which 
> signal is above RRSI threshold will match.
> 
> Regards,
> Arend
> ---8<----------------------------------------------------------
> /**
>   * struct cfg80211_match_set - sets of attributes to match
>   *
>   * @ssid: SSID to be matched; may be zero-length for no match (RSSI only)
>   * @rssi_thold: don't report scan results below this threshold (in s32 dBm)
>   */
> _______________________________________________
> HostAP mailing list
> HostAP@lists.shmoo.com
> http://lists.shmoo.com/mailman/listinfo/hostap


