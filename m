Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54186 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056Ab1IXKju (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Sep 2011 06:39:50 -0400
Subject: Re: [PATCH 14/20] staging: brcm80211: remove dongle firmware
 related debug code
From: Johannes Berg <johannes@sipsolutions.net>
To: Franky Lin <frankyl@broadcom.com>
Cc: gregkh@suse.de, devel@linuxdriverproject.org,
	linux-wireless@vger.kernel.org
In-Reply-To: <1316830148-28661-15-git-send-email-frankyl@broadcom.com> (sfid-20110924_041001_582824_018BAB77)
References: <1316830148-28661-1-git-send-email-frankyl@broadcom.com>
	 <1316830148-28661-15-git-send-email-frankyl@broadcom.com>
	 (sfid-20110924_041001_582824_018BAB77)
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 24 Sep 2011 12:39:45 +0200
Message-ID: <1316860785.3952.6.camel@jlt3.sipsolutions.net> (sfid-20110924_123953_439695_399D22F0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-09-23 at 19:09 -0700, Franky Lin wrote:
> From: Arend van Spriel <arend@broadcom.com>
> 
> When the device dies the driver could extract cpu registers on
> the device to analyze the trap handling on the dongle. As the
> firmware with this driver is stable this code does not belong
> in the brcmfmac driver.
> 
> Reported-by: Johannes Berg <johannes@sipsolutions.net>

FWIW, when I said this looked strange I might have thought that it was
actually accessing the *host* registers. I don't remember exactly what I
said. If this is debug code for the dongle, then maybe it makes sense to
keep it, maybe optionally. I don't think you'll want to support a
separate driver just for debug. You could even use nl80211 testmode to
export it to userspace for your tools.

johannes

