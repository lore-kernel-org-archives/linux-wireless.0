Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:42861 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754391Ab0LOWAF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 15 Dec 2010 17:00:05 -0500
Date: Wed, 15 Dec 2010 16:56:11 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Jouni Malinen <j@w1.fi>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] nl80211: Add notification for dropped Deauth/Disassoc
Message-ID: <20101215215610.GH2377@tuxdriver.com>
References: <20101213220048.GA24752@jm.kir.nu>
 <20101214084133.GA28466@jm.kir.nu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20101214084133.GA28466@jm.kir.nu>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 14, 2010 at 10:41:33AM +0200, Jouni Malinen wrote:
> Add a new notification to indicate that a received, unprotected
> Deauthentication or Disassociation frame was dropped due to
> management frame protection being in use. This notification is
> needed to allow user space (e.g., wpa_supplicant) to implement
> SA Query procedure to recover from association state mismatch
> between an AP and STA.
> 
> This is needed to avoid getting stuck in non-working state when MFP
> (IEEE 802.11w) is used and a protected Deauthentication or
> Disassociation frame is dropped for any reason. After that, the
> station would silently discard any unprotected Deauthentication or
> Disassociation frame that could be indicating that the AP does not
> have association for the STA (when the Reason Code would be 6 or 7).
> IEEE Std 802.11w-2009, 11.13 describes this recovery mechanism.
> 
> Signed-off-by: Jouni Malinen <j@w1.fi>
> 
> ---
>  include/linux/nl80211.h |   10 ++++++++++
>  net/mac80211/rx.c       |   22 ++++++++++++++++++++--
>  net/wireless/mlme.c     |   22 ++++++++++++++++++++++
>  net/wireless/nl80211.c  |   16 ++++++++++++++++
>  net/wireless/nl80211.h  |    6 ++++++
>  5 files changed, 74 insertions(+), 2 deletions(-)


> --- wireless-testing.orig/net/wireless/mlme.c	2010-12-13 23:35:46.000000000 -0800
> +++ wireless-testing/net/wireless/mlme.c	2010-12-14 10:23:56.000000000 -0800
> @@ -263,6 +263,28 @@ void cfg80211_send_disassoc(struct net_d
>  }
>  EXPORT_SYMBOL(cfg80211_send_disassoc);
>  
> +void cfg80211_send_unprot_deauth(struct net_device *dev, const u8 *buf,
> +				 size_t len)
> +{
> +	struct wireless_dev *wdev = dev->ieee80211_ptr;
> +	struct wiphy *wiphy = wdev->wiphy;
> +	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
> +
> +	nl80211_send_unprot_deauth(rdev, dev, buf, len, GFP_ATOMIC);
> +}
> +EXPORT_SYMBOL(cfg80211_send_unprot_deauth);
> +
> +void cfg80211_send_unprot_disassoc(struct net_device *dev, const u8 *buf,
> +				   size_t len)
> +{
> +	struct wireless_dev *wdev = dev->ieee80211_ptr;
> +	struct wiphy *wiphy = wdev->wiphy;
> +	struct cfg80211_registered_device *rdev = wiphy_to_dev(wiphy);
> +
> +	nl80211_send_unprot_disassoc(rdev, dev, buf, len, GFP_ATOMIC);
> +}
> +EXPORT_SYMBOL(cfg80211_send_unprot_disassoc);
> +
>  static void __cfg80211_auth_remove(struct wireless_dev *wdev, const u8 *addr)
>  {
>  	int i;

Need cfg80211.h bits for these, no?

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
