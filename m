Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:44807 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752522AbcAFOha (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jan 2016 09:37:30 -0500
Message-ID: <1452091048.2541.19.camel@sipsolutions.net> (sfid-20160106_153738_743716_A17AAEA1)
Subject: Re: [RFC 1/2] nl80211: add extended feature for BSS selection
 support
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Wed, 06 Jan 2016 15:37:28 +0100
In-Reply-To: <1452090998.2541.18.camel@sipsolutions.net> (sfid-20160106_153644_478475_2DBF2BBE)
References: <1450959550-19655-1-git-send-email-arend@broadcom.com>
	 <1450959550-19655-2-git-send-email-arend@broadcom.com>
	 <1451985926.12357.16.camel@sipsolutions.net>
	 <568B91D6.6080404@broadcom.com>
	 <1452011509.12357.51.camel@sipsolutions.net>
	 <568CE980.5050005@broadcom.com> <1452090998.2541.18.camel@sipsolutions.net>
	 (sfid-20160106_153644_478475_2DBF2BBE)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2016-01-06 at 15:36 +0100, Johannes Berg wrote:

> Right. So realistically, writing this a bit more verbosely, you have
> 
> 1) rssi_preference, band_preference(band)
> 2) rssi_adjust(band, delta), rssi_preference
> 
> and perhaps
> 
> 3) rssi_preference
> 
> as the default?
> 
> As for 1), you said it was "band, rssi" but it seems you really meant
> the other way around since before you said "band" was a tie-breaker.
> 
> 
> Perhaps then, the API should just expose the two "primitives"
>  * band_preference(band)
>  * rssi_adjust(band, delta)?
> 

Which would basically map to cases (1) and (2) then.

johannes
