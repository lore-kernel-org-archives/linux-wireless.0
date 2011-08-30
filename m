Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:47160 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753257Ab1H3OSC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Aug 2011 10:18:02 -0400
Date: Tue, 30 Aug 2011 17:16:39 +0300
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 10/20] ath6kl: Use set_appie command to add Probe Request
 IEs
Message-ID: <20110830141639.GD8163@jouni.qca.qualcomm.com> (sfid-20110830_161810_065489_EB39AA23)
References: <1314620641-24257-1-git-send-email-jouni@qca.qualcomm.com>
 <1314620641-24257-11-git-send-email-jouni@qca.qualcomm.com>
 <4E5CACB2.1060304@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4E5CACB2.1060304@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 30, 2011 at 12:26:10PM +0300, Kalle Valo wrote:
> On 08/29/2011 03:23 PM, Jouni Malinen wrote:
> > --- a/drivers/net/wireless/ath/ath6kl/cfg80211.c
> > +++ b/drivers/net/wireless/ath/ath6kl/cfg80211.c
> > @@ -776,6 +776,15 @@ static int ath6kl_cfg80211_scan(struct wiphy *wiphy, struct net_device *ndev,

> > +	if (request->ie) {
> > +		if (ath6kl_wmi_set_appie_cmd(ar->wmi, WMI_FRAME_PROBE_REQ,
> > +					     request->ie, request->ie_len)) {
> > +			ath6kl_err("failed to set Probe Request appie for "
> > +				   "scan");
> > +			return -EIO;
> > +		}
> > +	}
> 
> I would prefer to return the original error code from the wmi call.

I followed the style used in this function with
ath6kl_wmi_startscan_cmd(), but sure, returning the error code from
wmi.c sounds reasonable.

-- 
Jouni Malinen                                            PGP id EFC895FA
