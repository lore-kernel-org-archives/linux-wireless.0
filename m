Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.184]:26811 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762043AbZB1CHY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Feb 2009 21:07:24 -0500
Received: by ti-out-0910.google.com with SMTP id d10so1766878tib.23
        for <linux-wireless@vger.kernel.org>; Fri, 27 Feb 2009 18:07:20 -0800 (PST)
From: Sujith <m.sujith@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Message-ID: <18856.39984.142504.861070@gargle.gargle.HOWL> (sfid-20090228_030732_259424_9779D683)
Date: Sat, 28 Feb 2009 07:36:40 +0530
To: Reinette Chatre <reinette.chatre@intel.com>
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Abhijeet Kolekar <abhijeet.kolekar@intel.com>
Subject: [PATCH 2/6] iwl3945: synchronize timestamp with uCode
In-Reply-To: <1235780484-27979-3-git-send-email-reinette.chatre@intel.com>
References: <1235780484-27979-1-git-send-email-reinette.chatre@intel.com>
	<1235780484-27979-2-git-send-email-reinette.chatre@intel.com>
	<1235780484-27979-3-git-send-email-reinette.chatre@intel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Reinette Chatre wrote:
> From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
> 
> In IBSS, TSF maintains local clock counters at each station. Network
> Synchronization follows a completely distributed scheme where beacon frames
> are generated. Each station maintain its own TSF timestamp, extracted from
> beacon timestamps they recieved. Following patch synchronize this beacon timestamp
> with uCode.
> 
> Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
> Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> ---
>  drivers/net/wireless/iwlwifi/iwl3945-base.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
> index 6dcc577..443c00e 100644
> --- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
> +++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
> @@ -4305,6 +4305,7 @@ static int iwl3945_mac_beacon_update(struct ieee80211_hw *hw, struct sk_buff *sk
>  {
>  	struct iwl_priv *priv = hw->priv;
>  	unsigned long flags;
> +	__le64 timestamp;
>  
>  	IWL_DEBUG_MAC80211(priv, "enter\n");
>  
> @@ -4326,6 +4327,8 @@ static int iwl3945_mac_beacon_update(struct ieee80211_hw *hw, struct sk_buff *sk
>  	priv->ibss_beacon = skb;
>  
>  	priv->assoc_id = 0;
> +	timestamp = ((struct ieee80211_mgmt *)skb->data)->u.beacon.timestamp;
> +	priv->timestamp = le64_to_cpu(timestamp);
>  

This won't work, since the timestamp in the beacon isn't being updated in mac80211.
See the 'IBSS Issues' thread. I attached a quick patch there.

Sujith
