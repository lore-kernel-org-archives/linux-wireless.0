Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ra.tuxdriver.com ([70.61.120.52]:2144 "EHLO ra.tuxdriver.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758764AbYBUQdY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Feb 2008 11:33:24 -0500
Date: Thu, 21 Feb 2008 11:20:44 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Jussi Kivilinna <jussi.kivilinna@mbnet.fi>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] rndis_wlan: fix sparse warnings
Message-ID: <20080221162044.GE3094@tuxdriver.com> (sfid-20080221_163345_594977_5B9CCD4A)
References: <1203504466.17534.16.camel@johannes.berg> <20080220202015.GC3825@tuxdriver.com> <1203586157.17534.125.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1203586157.17534.125.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 21, 2008 at 10:29:17AM +0100, Johannes Berg wrote:
> 
> > > --- everything.orig/drivers/net/wireless/rndis_wlan.c	2008-02-20 11:43:22.000000000 +0100
> > > +++ everything/drivers/net/wireless/rndis_wlan.c	2008-02-20 11:45:35.000000000 +0100
> > > @@ -228,9 +228,9 @@ struct NDIS_WLAN_BSSID_EX {
> > >  	struct NDIS_802_11_SSID Ssid;
> > >  	__le32 Privacy;
> > >  	__le32 Rssi;
> > > -	enum NDIS_802_11_NETWORK_TYPE NetworkTypeInUse;
> > > +	__le32 NetworkTypeInUse;
> > >  	struct NDIS_802_11_CONFIGURATION Configuration;
> > > -	enum NDIS_802_11_NETWORK_INFRASTRUCTURE InfrastructureMode;
> > > +	__le32 InfrastructureMode;
> > >  	u8 SupportedRates[NDIS_802_11_LENGTH_RATES_EX];
> > >  	__le32 IELength;
> > >  	u8 IEs[0];
> > 
> > This suggests that the values in the enum need to be explicitly
> > defined, does it not?
> 
> Yeah, well, it is probably understood that those values are from
> hardware. We don't always explicitly define them even when they are
> defined elsewhere since afaik C guarantees starting at 0 and increasing
> order.

Ah, nevermind...I see that the enum values are being converted to/from
cpu-endian before use.

Thanks,

John
-- 
John W. Linville
linville@tuxdriver.com
