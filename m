Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:53953 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750786AbZCBSGZ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Mar 2009 13:06:25 -0500
Subject: Re: [PATCH 2/6] iwl3945: synchronize timestamp with uCode
From: reinette chatre <reinette.chatre@intel.com>
To: Sujith <m.sujith@gmail.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>,
	"Kolekar, Abhijeet" <abhijeet.kolekar@intel.com>
In-Reply-To: <18856.39984.142504.861070@gargle.gargle.HOWL>
References: <1235780484-27979-1-git-send-email-reinette.chatre@intel.com>
	 <1235780484-27979-2-git-send-email-reinette.chatre@intel.com>
	 <1235780484-27979-3-git-send-email-reinette.chatre@intel.com>
	 <18856.39984.142504.861070@gargle.gargle.HOWL>
Content-Type: text/plain
Date: Mon, 02 Mar 2009 10:11:06 -0800
Message-Id: <1236017466.18288.96.camel@rc-desk> (sfid-20090302_190628_219013_273511D3)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2009-02-27 at 18:06 -0800, Sujith wrote:
> Reinette Chatre wrote:
> > From: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
> > 
> > In IBSS, TSF maintains local clock counters at each station. Network
> > Synchronization follows a completely distributed scheme where beacon frames
> > are generated. Each station maintain its own TSF timestamp, extracted from
> > beacon timestamps they recieved. Following patch synchronize this beacon timestamp
> > with uCode.
> > 
> > Signed-off-by: Abhijeet Kolekar <abhijeet.kolekar@intel.com>
> > Signed-off-by: Reinette Chatre <reinette.chatre@intel.com>
> > ---
> >  drivers/net/wireless/iwlwifi/iwl3945-base.c |    3 +++
> >  1 files changed, 3 insertions(+), 0 deletions(-)
> > 
> > diff --git a/drivers/net/wireless/iwlwifi/iwl3945-base.c b/drivers/net/wireless/iwlwifi/iwl3945-base.c
> > index 6dcc577..443c00e 100644
> > --- a/drivers/net/wireless/iwlwifi/iwl3945-base.c
> > +++ b/drivers/net/wireless/iwlwifi/iwl3945-base.c
> > @@ -4305,6 +4305,7 @@ static int iwl3945_mac_beacon_update(struct ieee80211_hw *hw, struct sk_buff *sk
> >  {
> >  	struct iwl_priv *priv = hw->priv;
> >  	unsigned long flags;
> > +	__le64 timestamp;
> >  
> >  	IWL_DEBUG_MAC80211(priv, "enter\n");
> >  
> > @@ -4326,6 +4327,8 @@ static int iwl3945_mac_beacon_update(struct ieee80211_hw *hw, struct sk_buff *sk
> >  	priv->ibss_beacon = skb;
> >  
> >  	priv->assoc_id = 0;
> > +	timestamp = ((struct ieee80211_mgmt *)skb->data)->u.beacon.timestamp;
> > +	priv->timestamp = le64_to_cpu(timestamp);
> >  
> 
> This won't work, since the timestamp in the beacon isn't being updated in mac80211.
> See the 'IBSS Issues' thread. I attached a quick patch there.

Thanks for spotting this. There is thus not a problem with this specific
patch ... just the information it depends on, which you now fixed. Are
you going to send your fix for inclusion ?

Reinette

