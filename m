Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:39098 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025AbaALIkt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 12 Jan 2014 03:40:49 -0500
Message-ID: <1389516039.5242.1.camel@jlt4.sipsolutions.net> (sfid-20140112_094123_647890_26809280)
Subject: Re: [PATCH 2/3] b43: Fix oops if firmware is not available
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Hutchings <ben@decadent.org.uk>
Cc: Larry Finger <Larry.Finger@lwfinger.net>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	Stable <stable@vger.kernel.org>
Date: Sun, 12 Jan 2014 09:40:39 +0100
In-Reply-To: <1389500647.3720.51.camel@deadeye.wl.decadent.org.uk> (sfid-20140112_052455_040829_49454E3C)
References: <1389469714-13040-1-git-send-email-Larry.Finger@lwfinger.net>
	 <1389469714-13040-3-git-send-email-Larry.Finger@lwfinger.net>
	 <1389497251.3720.40.camel@deadeye.wl.decadent.org.uk>
	 <52D21226.4070306@lwfinger.net>
	 <1389500647.3720.51.camel@deadeye.wl.decadent.org.uk>
	 (sfid-20140112_052455_040829_49454E3C)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2014-01-12 at 04:24 +0000, Ben Hutchings wrote:

> You could switch back to synchronous firmware loading soon, as it's not
> going to support a usermode helper any more.
> 
> But until then, the proper fix for this is going to be to cancel the
> waiter earlier in teardown.

I don't think we found a way when we looked at this, and instead made
the module unload wait for the request_firmware callback to come back
(see all users of the request_firmware_complete struct member in
iwlwifi/iwl-drv.c)

johannes

