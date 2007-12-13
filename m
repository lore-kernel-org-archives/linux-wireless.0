Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from londo.lunn.ch ([80.238.139.98]:35717 "EHLO londo.lunn.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752644AbXLMMu6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2007 07:50:58 -0500
Date: Thu, 13 Dec 2007 13:50:47 +0100
From: Andrew Lunn <andrew@lunn.ch>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Andrew Lunn <andrew@lunn.ch>, flamingice@sourmilk.net,
	linux-wireless@vger.kernel.org, linville@tuxdriver.com
Subject: Re: [PATCH] try 2: mac80211: Fix swapped parameters to
	ieee80211_set_channel()
Message-ID: <20071213125047.GD501@lunn.ch> (sfid-20071213_125104_616105_F22520E7)
References: <20071212153158.GB16947@lunn.ch> <1197481426.6558.138.camel@johannes.berg> <20071212180204.GP31218@lunn.ch> <1197482969.6558.149.camel@johannes.berg> <1197504975.6558.199.camel@johannes.berg> <20071213120904.GB501@lunn.ch> <1197549025.6558.253.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1197549025.6558.253.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 13, 2007 at 01:30:25PM +0100, Johannes Berg wrote:
> 
> > iwconfig wlan0 freq 5240
> 
> man iwconfig(8)
> 
>        freq/channel
>               Set the operating frequency or channel in the  device.  A  value
>               below 1000 indicates a channel number, a value greater than 1000
>               is a frequency in Hz. You may append the suffix k, M or G to the
>               value  (for  example,  "2.46G"  for  2.46 GHz frequency), or add
>               enough ???0???.

Yup, see my last email. 

However this description does not match the implementation. The
implementation is that its a channel if e = 0. My "frequency" is > 1000,  
but it was still interpreted as a channel. Looking at the
implementation of iw_float2freq(), the description should be that a
value less than 1e9 is a channel. 

So there should really be a check in the user space tools which says
that values between 1000 and 1e9 are invalid. This would catch errors
like the one i made for both 2.4GHz and 5GHz.

     Andrew

