Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp156.iad.emailsrvr.com ([207.97.245.156]:57189 "EHLO
	smtp156.iad.emailsrvr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752511AbXICCJl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Sep 2007 22:09:41 -0400
Message-ID: <46DB6C7B.3020001@gentoo.org>
Date: Sun, 02 Sep 2007 22:07:55 -0400
From: Daniel Drake <dsd@gentoo.org>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [RFC 2/2] mac80211: revamp interface and filter configuration
References: <20070821161845.165557000@sipsolutions.net> <20070821161942.938977000@sipsolutions.net>
In-Reply-To: <20070821161942.938977000@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> +	/*
> +	 * Configure the device's RX filter.
[...]
> +	 * Must be atomic due to running under the tx lock.

This is slightly freaky for zd1211rw and probably other USB drivers. In 
most cases we can't act upon any of those filter flag changes in atomic 
context.

We could defer work like we do for multicast lists, but then the driver 
would be lying in that it would return from configure_filter saying that 
it has honoured some flags without actually having done so (yet).

Will that be a problem? I'm thinking maybe not, since the flags only 
affect RX and we can't determine which frames will be in the air at any 
time. [as opposed to such atomicity problems that relate to TX, we can 
just disable TX until the work has completed]

> +	 * This callback is must be implemented.
> +	 */

Typo.

Daniel
