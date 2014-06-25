Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:52228 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756886AbaFYPz6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jun 2014 11:55:58 -0400
Message-ID: <1403711732.4140.14.camel@jlt4.sipsolutions.net> (sfid-20140625_175601_619179_50E69997)
Subject: Re: [RFC 3/3] brcmfmac: update band and regulatory info before
 wiphy_register()
From: Johannes Berg <johannes@sipsolutions.net>
To: Arend van Spriel <arend@broadcom.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Wed, 25 Jun 2014 17:55:32 +0200
In-Reply-To: <53A9B152.5050503@broadcom.com>
References: <1402996581-10764-1-git-send-email-arend@broadcom.com>
		 <1402996581-10764-4-git-send-email-arend@broadcom.com>
	 <1403516273.4418.11.camel@jlt4.sipsolutions.net>
	 <53A9B152.5050503@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-06-24 at 19:11 +0200, Arend van Spriel wrote:

> >> +	if (wiphy_is_40mhz_24ghz_disabled(wiphy) == false) {
> >> +		err = brcmf_enable_bw40_2g(ifp);
> >> +		if (!err)
> >> +			err = brcmf_fil_iovar_int_set(ifp, "obss_coex",
> >> +						      BRCMF_OBSS_COEX_AUTO);
> >> +	}
> >
> > This seems to have an effect only on the device, so why not do it after
> > wiphy_register()?
> 
> It does affect channels list in brcmf_update_wiphybands().

Ah, ok, I guess I missed that.

> Digging further in this code, I found that the brcmf_update_wiphybands() 
> queries the device to get the actual list of channels, which 
> subsequently is determined by the 40MHz setting in the 2G band. Not so 
> much for the channel itself as for the flags. If that is all done after 
> wiphy_apply_custom_regulatory() it does not show up when doing 'iw phy 
> info'. And according to the documentation that call needs to be done 
> before wiphy_register().
> 
> In the current code the wiphy_apply_custom_regulatory() is called twice 
> (before and after wiphy_register()) which seems to do the trick, but in 
> that it might be exploiting unintended behaviour. Hence the attempt to 
> change the order of things.

Ok :)

johannes

