Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:2980 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755320Ab2GJM32 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jul 2012 08:29:28 -0400
Message-ID: <4FFC201F.2010507@broadcom.com> (sfid-20120710_142932_415650_93BF9599)
Date: Tue, 10 Jul 2012 14:29:19 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Thomas Huehn" <thomas@net.t-labs.tu-berlin.de>
cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	nbd@openwrt.org, brcm80211-dev-list@broadcom.com,
	pieterpg@broadcom.com, gregkh@suse.de, frankyl@broadcom.com,
	rvossen@broadcom.com, brudley@broadcom.com
Subject: Re: [PATCH v4] brcmsmac: restructure info->control.sta handling
 as it is goning to be removed soon.
References: <1341921697-62091-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
In-Reply-To: <1341921697-62091-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/10/2012 02:01 PM, Thomas Huehn wrote:
> brcmsmac uses info->control.sta while doing ampdu aggregation. This patch
> changes the usage of the structure info->control.sta, as it is going to be
> removed soon from struct ieee80211_tx_info. This patch is a pre-requisit in
> order to add transmission power control (TPC) to the mac80211 subsystem.
> 
> Suggested-by: Felix Fietkau <nbd@openwrt.org>
Acked-by: Arend van Spriel <arend@broadcom.com>
> Signed-off-by: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
> ---
> sta pointer is not used in brcms_c_sendampdu(), sta removed. thx to A.v.Spriel
> remove sta declaration from ampdu.c as well. thx to A.v.Spriel
> ---
>  drivers/net/wireless/brcm80211/brcmsmac/ampdu.c       | 11 ++++-------
>  drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c |  2 ++
>  drivers/net/wireless/brcm80211/brcmsmac/main.c        |  2 +-
>  3 files changed, 7 insertions(+), 8 deletions(-)


