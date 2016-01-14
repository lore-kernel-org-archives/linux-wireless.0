Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:33474 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754101AbcANLMR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 14 Jan 2016 06:12:17 -0500
Message-ID: <1452769934.2444.16.camel@sipsolutions.net> (sfid-20160114_121231_656945_DCDB4C93)
Subject: Re: [RFC V2 2/3] nl80211: add bss selection attribute to CONNECT
 command
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Date: Thu, 14 Jan 2016 12:12:14 +0100
In-Reply-To: <1452769832.2444.14.camel@sipsolutions.net> (sfid-20160114_121044_346336_2FC9C7ED)
References: <1452678583-20086-1-git-send-email-arend@broadcom.com>
	 <1452678583-20086-3-git-send-email-arend@broadcom.com>
	 <1452769832.2444.14.camel@sipsolutions.net>
	 (sfid-20160114_121044_346336_2FC9C7ED)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2016-01-14 at 12:10 +0100, Johannes Berg wrote:

> Perhaps a good way of documenting this would be to say each primitive
> has a priority? E.g.
> 
>     Primitives with a lower document priority are executed first
> while
>     selecting a BSS:
> 
>     RSSI (priority 100)
>     BAND_PREF (priority 1)
>     RSSI_ADJUST (priority 1) [since it's mutually exclusive with
>     BAND_PREF]
> 

I do wonder though what should happen if you just specify *only*
BAND_PREF, for example, or only RSSI_ADJUST. The latter doesn't even
make sense without then going to RSSI as the next level, and BAND_PREF
only can't really pick a single AP (just throw out ones that aren't on
the right band)

johannes
