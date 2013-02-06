Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from webmail.solarflare.com ([12.187.104.25]:16331 "EHLO
	webmail.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754032Ab3BFAS1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Feb 2013 19:18:27 -0500
Message-ID: <1360109904.2857.36.camel@bwh-desktop.uk.solarflarecom.com> (sfid-20130206_011836_845383_A69D6250)
Subject: Re: [PATCH] rtlwifi: rtl8192cu: Fix NULL dereference BUG when using
 new_id
From: Ben Hutchings <bhutchings@solarflare.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>,
	<netdev@vger.kernel.org>, Stable <stable@vger.kernel.org>
Date: Wed, 6 Feb 2013 00:18:24 +0000
In-Reply-To: <1360108823-5141-1-git-send-email-Larry.Finger@lwfinger.net>
References: <1360108823-5141-1-git-send-email-Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2013-02-05 at 18:00 -0600, Larry Finger wrote:
> When the new_id entry is used for a foreign USB device, rtlwifi BUGS with
> a NULL pointer dereference.
[...]

So set no_dynamic_id in the usb_driver structures.

(But I wonder why USB behaves differently from PCI, which requires that
the dynamic ID's driver_data value (defaulting to 0) matches a value
used in a static ID entry.)

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

