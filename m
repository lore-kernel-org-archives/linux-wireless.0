Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:65213 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759969Ab2FGTSH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 Jun 2012 15:18:07 -0400
Date: Thu, 7 Jun 2012 12:18:03 -0700
From: "Pedersen, Thomas" <c_tpeder@qca.qualcomm.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>, <johannes@sipsolutions.net>,
	<ath6kl-devel@qualcomm.com>
Subject: Re: [RFC 1/2] nl80211: specify RSSI threshold when scanning
Message-ID: <20120607191803.GA4323@pista> (sfid-20120607_211811_207081_17AB7243)
References: <1339036996-6199-1-git-send-email-c_tpeder@qca.qualcomm.com>
 <4FD0570D.50303@qca.qualcomm.com>
 <20120607183820.GA2950@pista>
 <4FD0F8A0.3000704@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4FD0F8A0.3000704@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jun 07, 2012 at 09:53:20PM +0300, Kalle Valo wrote:
> On 06/07/2012 09:38 PM, Pedersen, Thomas wrote:
> >>> +	WIPHY_FLAG_SUPPORTS_RSSI_SCAN		= BIT(22),
> >>> > >  };
> >> > 
> >> > Is this flag really needed? For me this looks like an optimisation more
> >> > than a functional change. If the driver supports this, that's great and
> >> > we can save some power. But if the driver does not support it does it
> >> > really make any difference for the user space? Would user space act
> >> > differently if this feature is not supported by the driver?
> >
> > Well, this allows cfg80211 to return an error if this feature is
> > requested but not supported by the driver / fw.
> 
> But do we want to return an error when the driver doesn't support this?
> I was thinking that driver should just ignore the attribute in that case
> and let user space filter the results.
> 
> Kalle

Sure, we can just let userspace unconditionally filter the results when
we do something like:

iw wlan0 scan rssi -40

Johannes, does this look OK to you?

Thomas
