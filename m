Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 128-177-27-249.ip.openhosting.com ([128.177.27.249]:58542 "EHLO
	jmalinen.user.openhosting.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751280AbYLRHFV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Dec 2008 02:05:21 -0500
Date: Thu, 18 Dec 2008 09:05:08 +0200
From: Jouni Malinen <j@w1.fi>
To: Sujith <m.sujith@gmail.com>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	mcgrof@gmail.com, jouni.malinen@atheros.com
Subject: Re: [RFC] Handle Channel Switch Announcement
Message-ID: <20081218070508.GA15803@jm.kir.nu> (sfid-20081218_080525_800504_59F879BD)
References: <18761.4838.509784.281821@localhost.localdomain> <20081217162017.GA28712@jm.kir.nu> <18761.43079.702658.733757@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <18761.43079.702658.733757@localhost.localdomain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 18, 2008 at 07:02:55AM +0530, Sujith wrote:

> But after receiving a CSA on the current frequency, and having moved to the new
> advertised frequency, can the STA send out probe requests in the earlier frequency ?
> (In case of a scan run or something)

As far as IEEE 802.11 standard is concerned, yes, that would be allowed.
There are not even explicit limits on doing that (if it is a broadcast
probe request, not unicast to the current BSS) before the channel move.
The only thing that the STA has to do immediately (if mode=1) is to
cease to send anything to the current BSS before the channel switch.
When receiving the CSA, the STA needs to decide whether it wants to
follow the AP or not. If not, it could start scanning immediately for
another AP.. The standard even has a following statement about channel
switch: "It should also be stressed that the channel switch process is
distinct from the regulatory requirement to cease transmission on a
particular channel in the presence of radar."

However, the STA must discontinue operation on the channel if it detects
a radar operating in the channel or learns this from another STA. The
regulatory rules on how quickly this must be done (and how much airtime
may be used after the radar has been detected) may be quire strict, so
doing an active scan on the previous channel immediately after having
received a CSA may not be that good of an idea. Then again, channels
that require radar detection should not really allow active scanning on
them in the first place. In that way it would be enough for the non-AP
STA to just stop using the current BSS because any other AP on the same
channel should stop Beaconing, too, when a radar is detected and as
such, the non-AP STA should not end up using the channel anymore.

-- 
Jouni Malinen                                            PGP id EFC895FA
