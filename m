Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms1.broadcom.com ([216.31.210.17]:4825 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753778Ab2GJLBC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Jul 2012 07:01:02 -0400
Message-ID: <4FFC0B61.7080506@broadcom.com> (sfid-20120710_130110_804923_47EFE600)
Date: Tue, 10 Jul 2012 13:00:49 +0200
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "Thomas Huehn" <thomas@net.t-labs.tu-berlin.de>
cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	nbd@openwrt.org, brcm80211-dev-list@broadcom.com,
	pieterpg@broadcom.com, gregkh@suse.de, frankyl@broadcom.com,
	rvossen@broadcom.com, brudley@broadcom.com
Subject: Re: [PATCH v3] brcmsmac: restructure info->control.sta handling
 as it is goning to be removed soon.
References: <1341914697-59039-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
In-Reply-To: <1341914697-59039-1-git-send-email-thomas@net.t-labs.tu-berlin.de>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/10/2012 12:04 PM, Thomas Huehn wrote:
> brcmsmac uses info->control.sta while doing ampdu aggregation. This patch
> changes the usage of the structure info->control.sta, as it is going to be
> removed soon from struct ieee80211_tx_info. This patch is a pre-requisit in
> order to add transmission power control (TPC) to the mac80211 subsystem.
> 
> Suggested-by: Felix Fietkau <nbd@openwrt.org>
> Signed-off-by: Thomas Huehn <thomas@net.t-labs.tu-berlin.de>
> ---
> sta pointer is not used in brcms_c_sendampdu(), sta removed. thx to A.v.Spriel
> ---
>  drivers/net/wireless/brcm80211/brcmsmac/ampdu.c       | 10 ++++------
>  drivers/net/wireless/brcm80211/brcmsmac/mac80211_if.c |  2 ++
>  drivers/net/wireless/brcm80211/brcmsmac/main.c        |  2 +-
>  3 files changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c b/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c
> index 01b190a..77c5f57 100644
> --- a/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c
> +++ b/drivers/net/wireless/brcm80211/brcmsmac/ampdu.c
> @@ -665,8 +665,6 @@ brcms_c_sendampdu(struct ampdu_info *ampdu, struct brcms_txq_info *qi,
>  			u8 plcp0, plcp3, is40, sgi;
>  			struct ieee80211_sta *sta;
>  
> -			sta = tx_info->control.sta;
> -
>  			if (rr) {

Now it probably results in a compiler warning. Declaration can go as well.

Gr. AvS


