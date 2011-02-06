Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pw0-f46.google.com ([209.85.160.46]:58993 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753003Ab1BFQQB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 6 Feb 2011 11:16:01 -0500
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <19790.51491.583675.986658@gargle.gargle.HOWL>
Date: Sun, 6 Feb 2011 21:45:31 +0530
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Sujith <m.sujith@gmail.com>, Martin Schleier <drahemmaps@gmx.net>,
	Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
	<linux-wireless@vger.kernel.org>, <dsd@gentoo.org>,
	<linville@tuxdriver.com>, <kune@deine-taler.de>,
	<linux-usb@vger.kernel.org>, <gregkh@suse.de>
Subject: Re: Override endpoint attributes (was: RE: [PATCH] zd1211rw: change endpoint types of EP_REGS_OUT and EP_INT_IN from interrupt to bulk)
In-Reply-To: <Pine.LNX.4.44L0.1102061037060.20379-100000@netrider.rowland.org>
References: <19790.36590.884287.572619@gargle.gargle.HOWL>
	<Pine.LNX.4.44L0.1102061037060.20379-100000@netrider.rowland.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Alan Stern wrote:
> Why do you want to?  Why does changing the endpoint type from interrupt
> to bulk improve performance?  Yes, the description says that this
> causes CPU usage to go from 10% to below 1%, but _why_ does it do that?
> 
> Maybe the same effect can be achieved simply by changing the interrupt
> interval instead.

Well, when the device is plugged in, the USB core recognizes the endpoints
as interrupt type. Later, in the probe() callback, the FW is uploaded to the
target and it patches the endpoints' type to bulk. Please correct me if am
wrong, but I think this mismatch between the host and the target would be
the cause for the high CPU usage, when the transmission load for that
endpoint is high.

Sujith
