Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.irobot.com ([206.83.81.187]:16027 "EHLO smtp1.irobot.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758509AbZKJW72 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Nov 2009 17:59:28 -0500
Message-ID: <4AF9F03E.2010405@irobot.com>
Date: Tue, 10 Nov 2009 14:59:10 -0800
From: Adam Wozniak <awozniak@irobot.com>
MIME-Version: 1.0
To: Derek Smithies <derek@indranet.co.nz>
CC: Christian Lamparter <chunkeey@googlemail.com>,
	linux-wireless@vger.kernel.org, nbd@openwrt.org
Subject: Re: compat-wireless and minstrel
References: <4AF0D54D.4090303@irobot.com> <200911041653.33737.chunkeey@googlemail.com> <alpine.DEB.2.00.0911050951000.16407@kauri.acheron.indranet.co.nz>
In-Reply-To: <alpine.DEB.2.00.0911050951000.16407@kauri.acheron.indranet.co.nz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Reading through the 802.11 spec, it appears to me that "Supported rates" 
(and "Extended Supported Rates" when number of rates > 8) is REQUIRED 
for all management frames except authentication, deauthentication, and 
action frames.  (IEEE 802.11-2007, 7.2.3)

Do you know which frames in the mac80211 code are missing this required 
information?  Or was that conjecture?

Looking at mac80211/tx.c ieee80211_beacon_get_tim, it is not clear to me 
how (or if) this rate information is being set for ad-hoc beacons.

Derek Smithies wrote:
> Some management frames don't contain a full report of the rates 
> supported by the sender.
> My view is that node A (in this example) is incorrectly determining 
> that B only supports the 1mb/sec rate. Consequently, node A fills the 
> rate_supported  array with one rate - 1mb/sec.

