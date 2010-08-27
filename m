Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.nokia.com ([192.100.122.230]:49813 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752531Ab0H0LTg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Aug 2010 07:19:36 -0400
Subject: Re: [PATCH 4/4] mac80211: allow changing port control protocol
From: Juuso Oikarinen <juuso.oikarinen@nokia.com>
To: ext Johannes Berg <johannes@sipsolutions.net>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1282907610.4377.4.camel@jlt3.sipsolutions.net>
References: <1282907259-30825-1-git-send-email-juuso.oikarinen@nokia.com>
	 <1282907259-30825-5-git-send-email-juuso.oikarinen@nokia.com>
	 <1282907610.4377.4.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 27 Aug 2010 14:18:51 +0300
Message-ID: <1282907931.9258.229.camel@wimaxnb.nmp.nokia.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-08-27 at 13:13 +0200, ext Johannes Berg wrote:
> On Fri, 2010-08-27 at 14:07 +0300, Juuso Oikarinen wrote:
> 
> > @@ -855,6 +855,8 @@ static void ieee80211_setup_sdata(struct ieee80211_sub_if_data *sdata,
> >  	sdata->dev->netdev_ops = &ieee80211_dataif_ops;
> >  	sdata->wdev.iftype = type;
> >  
> > +	sdata->control_port_protocol = cpu_to_be16(ETH_P_PAE);
> > +
> 
> I believe we may also need to set control_port_no_encrypt to false here,
> or we'll run into issues with interface type switching after it had been
> true?

Sounds valid. I'll send v2 still.

-Juuso

> johannes
> 


