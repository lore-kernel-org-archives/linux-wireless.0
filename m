Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mgw-sa02.nokia.com ([147.243.1.48]:19716 "EHLO
	mgw-sa02.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208Ab0HKLwP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Aug 2010 07:52:15 -0400
Subject: Re: [PATCH 3/5] mac80211: remove unused status flag checks
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: ext Johannes Berg <johannes@sipsolutions.net>
Cc: John Linville <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <20100810074700.385206959@sipsolutions.net>
References: <20100810074637.034583799@sipsolutions.net>
	 <20100810074700.385206959@sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 11 Aug 2010 14:51:35 +0300
Message-ID: <1281527495.6475.160.camel@wimaxnb.nmp.nokia.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-08-10 at 09:46 +0200, ext Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> The decryption code verifies whether or not
> a given frame was decrypted and verified by
> hardware. This is unnecessary, as the crypto
> RX handler already does it long before the
> decryption code is even invoked, so remove
> that code to avoid confusion.
> 
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> ---
>  net/mac80211/wpa.c |   26 ++++++--------------------
>  1 file changed, 6 insertions(+), 20 deletions(-)
> 

This patch for some reason seems to break wl1271 WPA - association
succeeds but encrypted data transfer fails.

I still don't know why, but I'm looking into it.

-Juuso

