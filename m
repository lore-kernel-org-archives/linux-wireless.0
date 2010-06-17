Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:42377 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1756869Ab0FQHun (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Jun 2010 03:50:43 -0400
From: Sebastian Smolorz <Sebastian.Smolorz@gmx.de>
To: Kalle Valo <kvalo@adurom.com>
Subject: Re: [RFC] Changes in mac80211 to make at76c50x-usb working again
Date: Thu, 17 Jun 2010 09:51:24 +0200
Cc: Johannes Berg <johannes@sipsolutions.net>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Marcel Holtmann <marcel@holtmann.org>
References: <201006151416.36686.Sebastian.Smolorz@gmx.de> <201006160946.54197.Sebastian.Smolorz@gmx.de> <87typ2fa2j.fsf@purkki.valot.fi>
In-Reply-To: <87typ2fa2j.fsf@purkki.valot.fi>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Message-Id: <201006170951.25067.Sebastian.Smolorz@gmx.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Kalle Valo wrote:
> Sebastian Smolorz <Sebastian.Smolorz@gmx.de> writes:
> > Kalle Valo wrote:
> >> I debugged this a long time ago. The problem is that firmware's
> >> CMD_JOIN only works if bssid is correct one. I remember trying
> >> ff:ff:ff:ff:ff:ff, but that didn't work for some reason. The join
> >> command needs to be sent before association, otherwise transmission
> >> won't work at all. And if I use a random bssid the firmware will
> >> filter the replies. But I tested this a long time ago, I might
> >> remember something wrong.
> >>
> >> I was thinking a hack which would get bssid from association frames
> >> and then send CMD_JOIN, before the association frame.
> >
> > Could you elaborate a little bit on this?
> 
> Basically my idea is this (all in tx path):
> 
> 1. if tx frame is an association frame, get bssid from the frame
> 2. if bssid == priv->bssid, goto step 6
> 3. store tx frame, don't transmit it yet
> 4. send CMD_JOIN with new bssid
> 5. wait for command completion
> 6. priv->bssid = bssid
> 7. transmit tx frame
> 8. done
> 
> Ugly as hell, but one option to get the driver working again.
> 
> > How do we proceed to make the driver working again? Do you want to work
> > on this issue?
> 
> Sorry, currently I only have time to review patches and send comments.
> If you have the time, it would be great to if you could fix the driver
> finally.

OK, I will write a patch.

-- 
Sebastian
