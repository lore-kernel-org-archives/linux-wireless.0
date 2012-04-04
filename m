Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:28648 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932570Ab2DDUAM (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 4 Apr 2012 16:00:12 -0400
Date: Wed, 4 Apr 2012 13:00:09 -0700
From: "Pedersen, Thomas" <c_tpeder@qca.qualcomm.com>
To: Joe Perches <joe@perches.com>
CC: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Subject: Re: [PATCH 2/2] ath6kl: handle concurrent AP-STA channel switches
Message-ID: <20120404200008.GA19758@pista> (sfid-20120404_220017_635291_235661FC)
References: <1333565817-18816-1-git-send-email-c_tpeder@qca.qualcomm.com>
 <1333565817-18816-2-git-send-email-c_tpeder@qca.qualcomm.com>
 <1333566178.16978.29.camel@joe2Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1333566178.16978.29.camel@joe2Laptop>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Joe,

On Wed, Apr 04, 2012 at 12:02:58PM -0700, Joe Perches wrote:
> On Wed, 2012-04-04 at 11:56 -0700, Thomas Pedersen wrote:
> > If an ath6kl AP vif is beaconing on one channel, and a STA vif
> > associates on a different channel, a WMI_DISCONNECT event will be sent
> > to the AP vif. Make the AP vif follow the STA interface, and notify
> > userspace.
> 
> trivia:
> 
> > diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
> []
> > @@ -1015,6 +1015,19 @@ out:
> >  	vif->scan_req = NULL;
> >  }
> >  
> > +void ath6kl_cfg80211_ch_switch_notify(struct ath6kl_vif *vif, int channel,
> > +				      enum wmi_phy_mode mode)
> > +{
> > +	enum nl80211_channel_type type;
> > +
> > +	ath6kl_dbg(ATH6KL_DBG_WLAN_CFG, "channel switch notify nw_type %d"
> > +		   "freq %d mode %d", vif->nw_type, channel, mode);
> 
> Please coalesce formats.
> If you had, you'd've seen a problem with this format.
> Add a newline "\n" terminator to it too.

I'm not sure what you mean by "coalesce formats". The freq / channel
semantic mismatch? I'll change that and add a newline as well.

Thanks for looking.
Thomas
