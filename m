Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:44111 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754125Ab2ACVvV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Jan 2012 16:51:21 -0500
Received: by eekc4 with SMTP id c4so16236349eek.19
        for <linux-wireless@vger.kernel.org>; Tue, 03 Jan 2012 13:51:20 -0800 (PST)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Andreas Hartmann <andihartmann@01019freenet.de>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@openwrt.org>
Subject: Re: Re: Compat-wireless-3.2-rc6-3 is broken for rt2860 device
Date: Tue, 03 Jan 2012 22:51:11 +0100
Message-ID: <2766356.70ylY68Gqi@helmutmobil.site> (sfid-20120103_225124_703874_CABD1F67)
In-Reply-To: <4EFF71F8.6070208@01019freenet.de>
References: <4EFF12D9.3010602@01019freenet.de> <4EFF71F8.6070208@01019freenet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Andreas,

Am Samstag, 31. Dezember 2011, 21:35:04 schrieb Andreas Hartmann:
> Andreas Hartmann schrieb:
> > Hello,
> > 
> > I tested compat-wireless-3.2-rc6-3 with kernel 3.1 and a rt2860 device
> > running in AP mode (80211.n - 40 MHz). During
> > 
> > netperf -t TCP_STREAM -H ap
> > 
> > the data stream mostly stalls (-> the device receives data) after a few
> > seconds and never comes up any more. The connection is completely death.
> > I have to restart wpa_supplicant to get it working again.
> > 
> > 
> > 
> > I tried to isolate the problem the following way:
> > 
> > 1. Running compat-wireless-3.2-rc6-3 with the rt2x00 level from
> > compat-wireless-3.1.1-1. The problem didn't gone.
> > 
> > 2. Running compat-wireless-3.1.1-1 with the rt2x00 based changes in
> > compat-wireless-3.2-rc6-3. I can't see the problem any more.
> > 
> > 
> > That's why I think, that the problem must be outside the rt2x00 changes.
> > But there are many changes outside :-).
> 
> 
> Removing this patch
> 
> mac80211: retry sending failed BAR frames later instead of tearing down
> aggr (http://www.spinics.net/lists/linux-wireless/msg76379.html) makes
> it working again.
> 
> Device is: RaLink RT2800 802.11n PCI

What's the client device connected to the rt2x00 AP? Mind to send a
802.11 capture wen this stall happens?

Thanks and a happy new year,
Helmut
