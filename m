Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f187.google.com ([209.85.210.187]:55282 "EHLO
	mail-yx0-f187.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755999AbZKWBeE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Nov 2009 20:34:04 -0500
Received: by yxe17 with SMTP id 17so4332022yxe.33
        for <linux-wireless@vger.kernel.org>; Sun, 22 Nov 2009 17:34:11 -0800 (PST)
Message-ID: <4B09E691.8020205@lwfinger.net>
Date: Sun, 22 Nov 2009 19:34:09 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Michael Buesch <mb@bu3sch.de>
CC: "John W. Linville" <linville@tuxdriver.com>,
	bcm43xx-dev@lists.berlios.de,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] b43: Rewrite DMA Tx status handling sanity checks
References: <200911192224.29491.mb@bu3sch.de>
In-Reply-To: <200911192224.29491.mb@bu3sch.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/19/2009 03:24 PM, Michael Buesch wrote:
> This rewrites the error handling policies in the TX status handler.
> It tries to be error-tolerant as in "try hard to not crash the machine".
> It won't recover from errors (that are bugs in the firmware or driver),
> because that's impossible. However, it will return a more or less useful
> error message and bail out. It also tries hard to use rate-limited messages
> to not flood the syslog in case of a failure.
> 
> Signed-off-by: Michael Buesch <mb@bu3sch.de>
> 
> ---

Tested and ACKed by Larry Finger. Not only does this improve the error handling
for b43, but it also appears to fix the skb == NULL error that I experienced
with the open-source firmware.

John - please push this into wireless-testing. It should also go to 2.6.32, but
it is likely too large for the current stage. At least Cc it to stable.

Larry
