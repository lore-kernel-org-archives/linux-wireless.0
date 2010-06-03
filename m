Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from kroah.org ([198.145.64.141]:46465 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755452Ab0FCWm3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Jun 2010 18:42:29 -0400
Date: Thu, 3 Jun 2010 15:17:51 -0700
From: Greg KH <greg@kroah.com>
To: Vivek Natarajan <vnatarajan@Atheros.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	stable@kernel.org, Ranga Rao Ravuri <ranga.ravuri@Atheros.com>
Subject: Re: [stable] [PATCH 2/2] ath9k: Avoid corrupt frames being
 forwarded to mac80211.
Message-ID: <20100603221751.GB22595@kroah.com>
References: <1272353738-17084-1-git-send-email-vnatarajan@atheros.com>
 <1272353738-17084-2-git-send-email-vnatarajan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1272353738-17084-2-git-send-email-vnatarajan@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Apr 27, 2010 at 01:05:38PM +0530, Vivek Natarajan wrote:
> If bit 29 is set, MAC H/W can attempt to decrypt the received aggregate
> with WEP or TKIP, eventhough the received frame may be a CRC failed
> corrupted frame. If this bit is set, H/W obeys key type in keycache.
> If it is not set and if the key type in keycache is neither open nor
> AES, H/W forces key type to be open.  But bit 29 should be set to 1
> for AsyncFIFO feature to encrypt/decrypt the aggregate with WEP or TKIP. 
> 
> Cc: stable@kernel.org
> Reported-by: Johan Hovold <johan.hovold@lundinova.se>
> Signed-off-by: Vivek Natarajan <vnatarajan@atheros.com>
> Signed-off-by: Ranga Rao Ravuri <ranga.ravuri@atheros.com>
> ---
>  drivers/net/wireless/ath/ath9k/ar5008_initvals.h |    2 +-
>  drivers/net/wireless/ath/ath9k/ar9002_initvals.h |    8 ++++----

This is now upstream in Linus's tree, but does not apply to the .32,
.32, or .34 kernel trees due to the file movements in this area.  I
tried to apply this by hand, but didn't get it correct.

Can someone please send me a properly backported version of this patch
to apply to the -stable tree?

thanks,

greg k-h
