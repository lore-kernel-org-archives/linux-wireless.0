Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:52517 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1757033Ab2ENSI3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 May 2012 14:08:29 -0400
Message-ID: <1337018906.29436.27.camel@joe2Laptop> (sfid-20120514_200831_954511_19BAA71C)
Subject: Re: [PATCH v2] ath6kl: enable enhanced bmiss detection
From: Joe Perches <joe@perches.com>
To: "Pedersen, Thomas" <c_tpeder@qca.qualcomm.com>
Cc: kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org,
	ath6kl-devel@qualcomm.com
Date: Mon, 14 May 2012 11:08:26 -0700
In-Reply-To: <20120514180339.GA4030@pista>
References: <1337017652-3962-1-git-send-email-c_tpeder@qca.qualcomm.com>
	 <1337018219.29436.24.camel@joe2Laptop> <20120514180339.GA4030@pista>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-05-14 at 11:03 -0700, Pedersen, Thomas wrote:
> On Mon, May 14, 2012 at 10:56:59AM -0700, Joe Perches wrote:
> > On Mon, 2012-05-14 at 10:47 -0700, Thomas Pedersen wrote:
> > > Enable enhanced bmiss detection if the firmware supports it. This
> > > feature is only enabled on some firmwares since it comes with a power
> > > cost.
> > []
> > > diff --git a/drivers/net/wireless/ath/ath6kl/cfg80211.c b/drivers/net/wireless/ath/ath6kl/cfg80211.c
> > []
> > > @@ -2614,6 +2619,30 @@ static int ath6kl_set_channel(struct wiphy *wiphy, struct net_device *dev,
> > >  	return 0;
> > >  }
> > >  
> > > +void ath6kl_cfg80211_sta_bmiss_enhance(struct ath6kl_vif *vif, bool enable)
[]
> > Why 2 messages when 1 message might do?
> > 
> > 	err = ath6kl_wmi_sta_bmiss_enhance_cmd(vif->ar->wmi,
> > 					       vif->fw_vif_idx, enable);
> > 	ath6kl_dbg(ATH6KL_DBG_WLAN_CFG,
> > 		   "%s enhanced fw bmiss detection: %s\n",
> > 		   enable ? "enable" : "disable",
> > 		   err ? "OK" : "failed");
> 
> OK that seems nicer. Should we still print the error code, or maybe it
> doesn't really matter?

Hi Thomas.

That's up to you.  I don't know the code at all.

btw: the err ?: output is badly reversed in my example.


