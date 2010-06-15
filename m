Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:53599 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754715Ab0FONgv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Jun 2010 09:36:51 -0400
Subject: Re: [RFC] Changes in mac80211 to make at76c50x-usb working again
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Sebastian Smolorz <Sebastian.Smolorz@gmx.de>, kalle.valo@iki.fi,
	linux-wireless@vger.kernel.org,
	Marcel Holtmann <marcel@holtmann.org>
In-Reply-To: <20100615132619.GB12885@tuxdriver.com>
References: <201006151416.36686.Sebastian.Smolorz@gmx.de>
	 <20100615132619.GB12885@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 15 Jun 2010 15:36:46 +0200
Message-ID: <1276609006.3648.233.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-06-15 at 09:26 -0400, John W. Linville wrote:
> On Tue, Jun 15, 2010 at 02:16:36PM +0200, Sebastian Smolorz wrote:
> > Hi,
> > 
> > the at76c50x-usb driver fails to authenticate with an AP. 

We need more information on how it fails.

> > The last working 
> > major kernel version was 2.6.30. I investigated the problem and found out 
> > that the driver needs to send a join command (CMD_JOIN) prior to the actual 
> > authentication process. For the join command, the driver needs to know the 
> > bssid of the AP. The problem is now that the mac80211 layer does not inform 
> > the driver about the bssid prior to the authentication. So we have a 
> > chicken-and-egg dilemma.



>     [1] http://thread.gmane.org/gmane.linux.kernel.wireless.general/32598
>     [2] http://www.intellinuxwireless.org/bugzilla/show_bug.cgi?id=1995
>     
>     Cc: Marcel Holtmann <marcel@holtmann.org>
>     Signed-off-by: Johannes Berg <johannes@sipsolutions.net>
>     Signed-off-by: John W. Linville <linville@tuxdriver.com>
> 
> It would be best to avoid reintroducing the bug mentioned in that
> commit.  Perhaps ensuring that iwlwifi's sta_notify is correct would
> be worthwhile?

mac80211's sta_notify was since fixed.

> What other issues might be introduced from setting a non-zero BSSID
> when not associated?  Will that limit scan results for any devices?
> Trigger a premature auth or assoc?  Etc?

I still think this is the wrong thing to do though.

What if you want to implement fast roaming? In that case, you still have
to authenticate to one AP while associated with another, etc.

johannes

