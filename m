Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:49378 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751856Ab3A3HtE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jan 2013 02:49:04 -0500
Message-ID: <1359532167.8010.0.camel@jlt4.sipsolutions.net> (sfid-20130130_084912_942240_D708CB5F)
Subject: Re: [PATCH 2/2] cfg80211: simplify mesh BSS comparison
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless@vger.kernel.org
Date: Wed, 30 Jan 2013 08:49:27 +0100
In-Reply-To: <20130130014222.GA25214@cable.cozybit.com> (sfid-20130130_024327_399043_37BB70B9)
References: <1359503120-25685-1-git-send-email-johannes@sipsolutions.net>
	 <1359503120-25685-2-git-send-email-johannes@sipsolutions.net>
	 <20130130014222.GA25214@cable.cozybit.com>
	 (sfid-20130130_024327_399043_37BB70B9)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-01-29 at 17:42 -0800, Thomas Pedersen wrote:

> FWIW cfg80211_get_mesh() has no users either.

Oh, I'll kill it too then :-)

> > +	if (WLAN_CAPABILITY_IS_STA_BSS(a->capability))
> > +		ie1 = cfg80211_find_ie(WLAN_EID_MESH_ID,
> > +				       a_ies->data, a_ies->len);
> > +	if (WLAN_CAPABILITY_IS_STA_BSS(a->capability))
> 
> You probably wanted:
> 
> 	if (WLAN_CAPABILITY_IS_STA_BSS(b->capability))

Yup, indeed, thanks.

johannes

