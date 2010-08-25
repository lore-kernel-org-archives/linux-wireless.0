Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37726 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751124Ab0HYISh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Aug 2010 04:18:37 -0400
Subject: Re: Marshaling issues w/ compat-wireless-2010-08-19
From: Johannes Berg <johannes@sipsolutions.net>
To: Philip Prindeville <philipp_subx@redfish-solutions.com>
Cc: linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>
In-Reply-To: <1282723861.3685.4.camel@jlt3.sipsolutions.net>
References: <4C746F74.70401@redfish-solutions.com>
	 <1282723861.3685.4.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 25 Aug 2010 10:20:12 +0200
Message-ID: <1282724412.3685.5.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2010-08-25 at 10:11 +0200, Johannes Berg wrote:

> > authentication: STA=f8:1e:df:1e:c2:23 auth_alg=35510 auth_transaction=79 status_code=21688 wep=1
> > Unsupported authentication algorithm (35510)
> > 
> > 
> > I'm wondering if some messages that are passed up to user-space via
> > netlink from the driver might have changed their schema, i.e. adding
> > new fields in the middle of a structure or moving fields around within
> > a structure.
> 
> Looks more like a crypto problem to me, as this should be the encrypted
> challenge in your shared key handshake. IOW, it looks like the frame
> isn't getting decrypted by mac80211 for some reason.

Works fine here in hwsim, so likely to be either a driver problem (hw
decrypts frame, but driver doesn't tell us so), something that has been
fixed between then and now, or a compat specific problem.

johannes

