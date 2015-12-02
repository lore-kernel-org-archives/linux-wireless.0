Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.w1.fi ([212.71.239.96]:38951 "EHLO
	li674-96.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757399AbbLBPMt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Dec 2015 10:12:49 -0500
Date: Wed, 2 Dec 2015 17:12:45 +0200
From: Jouni Malinen <j@w1.fi>
To: Arend van Spriel <arend@broadcom.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Hante Meuleman <meuleman@broadcom.com>,
	Dan Williams <dcbw@redhat.com>
Subject: Re: [PATCH 08/11] brcmfmac: Make 5G join preference configurable.
Message-ID: <20151202151245.GA25870@w1.fi> (sfid-20151202_161252_943332_5278E398)
References: <1448447567-12189-1-git-send-email-arend@broadcom.com>
 <1448447567-12189-9-git-send-email-arend@broadcom.com>
 <87si3nkb2l.fsf@kamboji.qca.qualcomm.com>
 <565D5B77.7050501@broadcom.com>
 <87d1uqijnz.fsf@kamboji.qca.qualcomm.com>
 <20151201110827.GA4362@w1.fi>
 <565EF307.90002@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <565EF307.90002@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 02, 2015 at 02:32:55PM +0100, Arend van Spriel wrote:
> On 12/01/2015 12:08 PM, Jouni Malinen wrote:
> >I would like to see this as a new attribute to NL80211_CMD_CONNECT to
> >provide parameters for offloaded (driver and/or firmware) BSS selection
> >and roaming. If there is a driver that uses roaming offload with
> >NL80211_CMD_ASSOCIATE, the same attribute could be used there (but I'm
> >not sure how exact such offloading would work in practice since I'd
> >expect both authentication and (re)association to be offloaded).
> 
> Sounds reasonable. Just would like to explore the use-case a bit
> more. Looking at tools like NetworkManager and android network list,
> the user is always presented with just SSID listed once. For
> NetworkManager details can be configured for a connection and the
> bss selection parameters could be one of those. What level of detail
> would be needed there. Not saying we can not have more detail in the
> nl80211 API.

As far as wpa_supplicant is concerned, I'm thinking of having a "global
parameter" as the default and option to have per-network override. For
most end user GUI things, I'm not sure there would be much to expose
(i.e., seems reasonable to prefer 5 GHz nowadays by default). For an
advanced UI, there could be an option to toggle this type of information
on/off or even give more details like how many dB to prefer.

> So does the driver need to advertise support for bss selection
> parameters or can it simply ignore the parameters. Assuming the
> latter for now.

I thought about this a bit and did not ask for such advertisement since
I didn't see how wpa_supplicant would behave any differently based on
the knowledge.. That said, if someone does think of exposing this in an
UI to a real end user, it would be convenient to have means for
determining whether the parameter is really supported. However, I'm not
sure vendors would provide the exact same set of configuration
parameters for this type of preferences for offloaded roaming, so coming
up with a generic and detailed advertisement can be a bit difficult.
Yes/no advertisement of something along the lines of preference for 5
GHz might be easier to handle.

-- 
Jouni Malinen                                            PGP id EFC895FA
