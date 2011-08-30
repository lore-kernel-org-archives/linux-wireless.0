Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:18110 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753658Ab1H3Oob (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Aug 2011 10:44:31 -0400
Cc: <linux-wireless@vger.kernel.org>,
	Edward Lu <shaol@qca.qualcomm.com>
Date: Tue, 30 Aug 2011 17:44:13 +0300
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Subject: Re: [PATCH 11/20] ath6kl: Support channel set request for startscan
 command
Message-ID: <20110830144413.GF8163@jouni.qca.qualcomm.com> (sfid-20110830_164443_914948_77D4AC60)
References: <1314620641-24257-1-git-send-email-jouni@qca.qualcomm.com>
 <1314620641-24257-12-git-send-email-jouni@qca.qualcomm.com>
 <4E5CAE7A.8000809@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4E5CAE7A.8000809@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 30, 2011 at 12:33:46PM +0300, Kalle Valo wrote:
> On 08/29/2011 03:23 PM, Jouni Malinen wrote:
> > @@ -785,14 +787,33 @@ static int ath6kl_cfg80211_scan(struct wiphy *wiphy, struct net_device *ndev,
> > +		n_channels = (request->n_channels > 127) ?
> > +				127 : request->n_channels;
> 
> min()

It looks kind of silly to have 127U here, but I can do that if it is the
preferred way, i.e., min(127U, request->n_channels). min(127,
request->n_channels) complains because of the strict type-checking in
the macro (request->n_channels is u32).

> > +		channels = kzalloc(n_channels * sizeof(u16), GFP_KERNEL);
> > +		if (channels == NULL) {
> > +			ath6kl_err("failed to set scan channels, "
> > +				   "scan all channels");
> 
> ath6kl_warn() would be more approriate here as the driver can still
> continue.

OK.

> >  	if (ath6kl_wmi_startscan_cmd(ar->wmi, WMI_LONG_SCAN, 0,
> > -				     false, 0, 0, 0, NULL) != 0) {
> > +				     false, 0, 0, n_channels, channels) != 0) {
> >  		ath6kl_err("wmi_startscan_cmd failed\n");
> >  		ret = -EIO;
> 
> Again I would prefer to return the error code from the wmi call.

OK.

> > -	if (num_chan)
> > -		memcpy(sc->ch_list, ch_list, num_chan * sizeof(u16));
> > +	if (num_chan) {
> > +		for (i = 0; i < num_chan; i++)
> > +			sc->ch_list[i] = cpu_to_le16(ch_list[i]);
> > +	}
> 
> if (num_chan) is not needed, the for loop is enough.

OK.

-- 
Jouni Malinen                                            PGP id EFC895FA
