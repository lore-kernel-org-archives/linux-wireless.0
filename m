Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:31468 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751148Ab1GGApq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Jul 2011 20:45:46 -0400
Message-ID: <4E1501B7.80303@gnu.org> (sfid-20110707_024549_444289_26A28C2D)
Date: Wed, 06 Jul 2011 20:45:43 -0400
From: Pavel Roskin <proski@gnu.org>
MIME-Version: 1.0
To: Henry Ptasinski <henryp@broadcom.com>
CC: linville@tuxdriver.com, gregkh@suse.de,
	devel@linuxdriverproject.org, linux-wireless@vger.kernel.org,
	Brett Rudley <brudley@broadcom.com>,
	Arend Van Spriel <arend@broadcom.com>,
	Roland Vossen <rvossen@broadcom.com>,
	Zhenhui Lin <frankyl@broadcom.com>
Subject: Re: [RFC] Move brcm80211 to mainline
References: <20110707002034.GA17885@broadcom.com>
In-Reply-To: <20110707002034.GA17885@broadcom.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/06/2011 08:20 PM, Henry Ptasinski wrote:
> With the latest series of cleanup patches merged in by Greg KH, I'd like to now
> propose moving brcm80211 out of staging and into mainline.
>
> Since brcm80211 in staging-next has about ~250 patches that areen't in
> wireless-testing yet, I've put together a patch to add a copy of the current
> sources from staging-next into wireless-testing:drivers/net/wireless/brcm80211.
>
> The patch is somewhat large, so I've posted the patch at:
>
> 	http://linuxwireless.org/en/users/Drivers/brcm80211?action=AttachFile&do=get&target=0001-wireless-testing-add-brcm80211.patch
>
> Only the necessary Kconfig and Makefile adjustments have been made (the sources
> are unchanged from what's currently in staging-next).

The change to Kconfig seems to be wrong.  It would be better to respect 
CONFIG_WLAN in drivers/net/wireless/Kconfig, like all other drivers do. 
  Then drivers/net/wireless/brcm80211/Kconfig should be cleaned up to 
remove unneeded dependencies on CONFIG_WLAN.

-- 
Regards,
Pavel Roskin
