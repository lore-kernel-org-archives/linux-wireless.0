Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp1.irobot.com ([206.83.81.187]:24034 "EHLO smtp1.irobot.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932504AbZKXRRX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Nov 2009 12:17:23 -0500
Message-ID: <4B0C1527.60305@irobot.com>
Date: Tue, 24 Nov 2009 09:17:27 -0800
From: Adam Wozniak <awozniak@irobot.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: Derek Smithies <derek@indranet.co.nz>,
	Christian Lamparter <chunkeey@googlemail.com>,
	linux-wireless@vger.kernel.org, Felix Fietkau <nbd@openwrt.org>
Subject: Re: [PATCH 2/2] mac80211: minstrel try all rates
References: <4AF0D54D.4090303@irobot.com>	 <alpine.DEB.2.00.0911111508391.6214@kauri.acheron.indranet.co.nz>	 <4AFC655A.5020706@irobot.com> <200911122103.27455.chunkeey@googlemail.com>	 <4AFC8E4F.5090307@irobot.com>  <4AFC8F0D.5020700@irobot.com>	 <1258097352.3899.75.camel@johannes.local>  <4AFDDF19.8060202@irobot.com>	 <1258191039.6167.40.camel@johannes.local>  <4B018B26.2070008@irobot.com>	 <1258392453.32159.28.camel@johannes.local> <4B0192A6.9050808@irobot.com>	 <alpine.DEB.2.00.0911170938380.3829@kauri.acheron.indranet.co.nz>	 <4B01D4A5.7060204@irobot.com>	 <alpine.DEB.2.00.0911171156210.3829@kauri.acheron.indranet.co.nz>	 <4B01E298.3030602@irobot.com>	 <alpine.DEB.2.00.0911171314470.3829@kauri.acheron.indranet.co.nz>	 <1258443484.1375.8.camel@johannes.local> <4B02DFE3.9040602@irobot.com>	 <4B0AEEE3.2050808@irobot.com> <1259018866.7094.189.camel@johannes.local>	 <4B0B2F6E.7050907@irobot.com> <1259025067.7094.208.camel@johannes.local>
In-Reply-To: <1259025067.7094.208.camel@johannes.local>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> I really don't like this patch anyhow though, it's at best a hackish
> workaround around an issue that should just be fixed instead.
>
> Will take another look at the other patch tomorrow.
>   
I concur 2/2 is a hack.  I'm not an 802.11 ad-hoc expert, and I haven't 
been allocated time to pursue the issue any more deeply than this.  It 
is still not clear to me how the list of usable rates is supposed to be 
determined when the IBSS is composed of stations with heterogeneous rate 
capabilities, beaconing is stochastically distributed, and not all nodes 
can hear all beacons, much less what is wrong with the way the current 
code is doing it.

I do not believe 1/2 was a hack.  It really was possible to get to the 
end of that function and use that variable without it being assigned the 
correct value.  Also, it is important to reinitialize the rate control 
layer when the list of usable rates changes.

I would certainly be in favor of a better patch that resolves all the 
issues.

--Adam Wozniak
