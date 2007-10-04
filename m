Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:35781
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756064AbXJDOry (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Oct 2007 10:47:54 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Daniel Drake <dsd@gentoo.org>
Subject: Re: [PATCH] zd1211rw-mac80211: More complete configure_filter implementation
Date: Thu, 4 Oct 2007 16:44:44 +0200
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	kune@deine-taler.de
References: <20071004113509.E5FF29D502B@zog.reactivated.net>
In-Reply-To: <20071004113509.E5FF29D502B@zog.reactivated.net>
MIME-Version: 1.0
Message-Id: <200710041644.45038.mb@bu3sch.de> (sfid-20071004_154801_048419_79B7A18E)
Content-Type: text/plain;
  charset="iso-8859-15"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thursday 04 October 2007 13:35:09 Daniel Drake wrote:
> @@ -206,6 +212,11 @@ static inline struct zd_mac *zd_usb_to_mac(struct zd_usb *usb)
>  	return zd_chip_to_mac(zd_usb_to_chip(usb));
>  }
>  
> +static inline u8 *zd_mac_get_perm_addr(struct zd_mac *mac)
> +{
> +	return mac->hw->wiphy->perm_addr;
> +}
> +
>  #define zd_mac_dev(mac) (zd_chip_dev(&(mac)->chip))
>  
>  struct ieee80211_hw *zd_mac_alloc_hw(struct usb_interface *intf);

We talked about these obfuscator- (a.k.a. helper-) functions on IRC... ;)

-- 
Greetings Michael.
