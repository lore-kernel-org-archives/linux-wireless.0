Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail8.sea5.speakeasy.net ([69.17.117.10]:56640 "EHLO
	mail8.sea5.speakeasy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750818AbXFUNgP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jun 2007 09:36:15 -0400
Date: Thu, 21 Jun 2007 06:35:56 -0700
From: Jouni Malinen <j@w1.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [WIP] mac80211: kill mgmt interface
Message-ID: <20070621133556.GJ5361@jm.kir.nu>
References: <1182418939.10821.8.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1182418939.10821.8.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 21, 2007 at 11:42:19AM +0200, Johannes Berg wrote:

> This patch kills the management interface type now that we can
> see transmitted frames on monitor interfaces.

Has someone tested that this works with programs that use the management
interface (mainly, hostapd and wpa_supplicant)? Is all the needed
functionality available with the alternative solution?

> I renamed the req_tx_status to reliable_tx_mntr and the flag
> constant as well since that's what they now mean. It is always
> set for injected frames so that hostapd can rely on seeing the
> frames it sent.

I'm not sure I follow this explanation fully.. How would hostapd learn
whether the destination address acknowledged a unicast frame?

> There are a few minor remaining problems:
>  * some notifications are now missing
>    (radar, key threshold, michael MIC failure, wep unknown key)
>    [radar, key threshold aren't used anywhere so can probably
>     be left out for now]

I would not remove key threshold notification and we must most certainly
not remove Michal MIC failure before there is a reliable way of doing
the same functionality.

>  * injected frames aren't sent to AC_VO pending on the radiotap
>    definition for access category

This is not good either since management frames should be sent at a high
priority.

> The biggest problem, however, and I'm not sure how to solve it, is
> that hostapd will see either encrypted or unencrypted frames on the
> monitor interface depending on whether hardware encryption is used
> or not. However, hostapd really needs to see eapol frames to do
> whatever it needs to with them. Right now, I don't really have an
> idea except maybe to send these packets to hostapd via nl80211,
> or to introduce some sort of "decrypted soft monitor" iface.

If I've understood correctly (please correct me, if not), this patch is
proposing to remove an interface that works currently and leave the
stack in state that does not work. I can only strongly recommend this
patch not to be applied at this point. It is not a good direction to
start removing working code before there is a good alternative available
and that alternative has actually been tested to provide the needed
functionality.

I don't really see need for getting rid of the management interface, but
if there is consensus on doing that, we would need to have another way
of being able to receive and transmit management frames and data frames
from/to user space in a way that provides at least following
functionality:
- transmit management frames at high priority
- control whether transmitted frames will be encrypted or not
- get callback to report TX status for unicast frames (whether the
  receiver sent control::ack for the frame)
- receive management frames
- receive data frames EAPOL/etc. ethertypes in decrypted form
- delivery of notifications to user space for Michael MIC errors and
  other similar events

-- 
Jouni Malinen                                            PGP id EFC895FA
