Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:43618 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751445AbaBTKK4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Feb 2014 05:10:56 -0500
Date: Thu, 20 Feb 2014 12:10:50 +0200
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Sunil Dutt Undekari <usdutt@qti.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <c_ppotte@qti.qualcomm.com>,
	<djindal@qti.qualcomm.com>
Subject: Re: [PATCH] cfg80211: Pass TDLS peer capability information in
 tdls_mgmt
Message-ID: <20140220101050.GA13639@jouni.qca.qualcomm.com> (sfid-20140220_111100_916067_3213785D)
References: <1392890788-5967-1-git-send-email-usdutt@qti.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1392890788-5967-1-git-send-email-usdutt@qti.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 20, 2014 at 03:36:28PM +0530, Sunil Dutt Undekari wrote:
> While framing the TDLS Setup Confirmation frame, the driver needs to
> know if the TDLS peer is VHT/HT/WMM capable and thus shall construct
> the VHT/HT operation / WMM parameter elements accordingly. Supplicant
> determines if the TDLS peer is VHT/HT/WMM capable based on the
> presence of the respective IEs in the received TDLS Setup Response frame.
> 
> The host driver should not need to parse the received TDLS Response
> frame and thus, should be able to rely on the supplicant to indicate
> the capability of the peer through additional flags while transmitting
> the TDLS Setup Confirmation frame through tdls_mgmt operations.
> 
> Signed-off-by: Sunil Dutt Undekari <usdutt@qti.qualcomm.com>
> ---
>  drivers/net/wireless/mwifiex/cfg80211.c |  4 ++--
>  include/net/cfg80211.h                  |  3 ++-
>  include/uapi/linux/nl80211.h            | 21 +++++++++++++++++++++
>  net/wireless/nl80211.c                  |  7 ++++++-
>  net/wireless/rdev-ops.h                 |  9 ++++++---
>  net/wireless/trace.h                    | 12 ++++++++----

This needs to add following:

diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
index 363d19b..bcc65ef 100644
--- a/net/mac80211/cfg.c
+++ b/net/mac80211/cfg.c
@@ -3647,8 +3647,8 @@ ieee80211_prep_tdls_direct(struct wiphy *wiphy, struct net_device *dev,
 
 static int ieee80211_tdls_mgmt(struct wiphy *wiphy, struct net_device *dev,
 			       u8 *peer, u8 action_code, u8 dialog_token,
-			       u16 status_code, const u8 *extra_ies,
-			       size_t extra_ies_len)
+			       u16 status_code, u32 peer_capability,
+			       const u8 *extra_ies, size_t extra_ies_len)
 {
 	struct ieee80211_sub_if_data *sdata = IEEE80211_DEV_TO_SUB_IF(dev);
 	struct ieee80211_local *local = sdata->local;


-- 
Jouni Malinen                                            PGP id EFC895FA
