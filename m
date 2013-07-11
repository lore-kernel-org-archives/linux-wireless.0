Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from webmail.solarflare.com ([12.187.104.25]:11543 "EHLO
	webmail.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756178Ab3GKRRO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jul 2013 13:17:14 -0400
Message-ID: <1373563030.2085.14.camel@bwh-desktop.uk.level5networks.com> (sfid-20130711_191722_990111_CCDB20D5)
Subject: Re: [RFC]: vlan priority handling in WMM
From: Ben Hutchings <bhutchings@solarflare.com>
To: Cedric Debarge <cedric.debarge@acksys.fr>
CC: <netdev@vger.kernel.org>, <linux-wireless@vger.kernel.org>
Date: Thu, 11 Jul 2013 18:17:10 +0100
In-Reply-To: <773DB8A82AB6A046AE0195C68612A319015E05AD@sbs2003.acksys.local>
References: <773DB8A82AB6A046AE0195C68612A319015E05AD@sbs2003.acksys.local>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-07-11 at 09:45 +0200, Cedric Debarge wrote:
> Dear mailing list,
> 
> I would like to manage the VLAN priority in Wireless QOS (WMM).
> 
> I get the VLAN tag from skb->vlan_tci and I extract the VLAN priority. 
> 
> How I should handle the priority value 0. 
> 	- Handle this value as no priority request, In this case the frame will 
> 		sent with the DSCP priority or default (Best effort)
>         - Handle this value as a lowest priority, in this case I Map it to the WMM.
[...]

IEEE 802.1q refers to the definition in 802.1d:

> The user_priority parameter is the priority requested by the
> originating service user. The value of this parameter is in the range
> 0 through 7.
> 
> NOTE—The default user_priority value is 0. Values 1 through 7 form an
> ordered sequence of user_priorities, with 1 being the lowest value and
> 7 the highest. See 7.7.3 and Annex G (informative) for further
> explanation of the use of user_priority values.

So a value of 0 should be treated as no priority request, same as for an
untagged frame.

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

