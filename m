Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:3742 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754480AbYETCQE (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 May 2008 22:16:04 -0400
Subject: Re: iwlwifi injection bug
From: Zhu Yi <yi.zhu@intel.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Andy Green <andy@warmcat.com>
In-Reply-To: <1210945631.6381.11.camel@johannes.berg>
References: <1210945631.6381.11.camel@johannes.berg>
Content-Type: text/plain
Date: Tue, 20 May 2008 10:15:28 +0800
Message-Id: <1211249729.2532.59.camel@debian.sh.intel.com> (sfid-20080520_041609_855823_957E07AE)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2008-05-16 at 15:47 +0200, Johannes Berg wrote:
> I don't know why you want to disallow sending frames when in monitor
> mode (especially since reportedly it works), but this is not a good
> way
> to go about it:
> 
> static int iwl4965_mac_tx(struct ieee80211_hw *hw, struct sk_buff
> *skb)
> {
>         struct iwl_priv *priv = hw->priv;
> 
>         IWL_DEBUG_MAC80211("enter\n");
> 
>         if (priv->iw_mode == IEEE80211_IF_TYPE_MNTR) {
>                 IWL_DEBUG_MAC80211("leave - monitor\n");
>                 return -1;
>         }
> 
> You see, this will cause mac80211 to resubmit the frame and most
> likely will totally mess up queue handling and various other things.

The monitor mode the driver is using currently is purely a "sniffer". We
will look into other promiscuous mode supported by the firmware to see
if we can enable that.

Thanks,
-yi

