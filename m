Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga06.intel.com ([134.134.136.21]:52166 "EHLO
	orsmga101.jf.intel.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1762448AbXFDTcg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 Jun 2007 15:32:36 -0400
Message-ID: <46644D8F.2010400@linux.intel.com>
Date: Mon, 04 Jun 2007 10:36:15 -0700
From: James Ketrenos <jketreno@linux.intel.com>
MIME-Version: 1.0
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: Jiri Benc <jbenc@suse.cz>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: Add module parameter for setting initial rate  in rc80211_simple
References: <4661bc4f.88st9yXgySnzwVtb%Larry.Finger@lwfinger.net>
In-Reply-To: <4661bc4f.88st9yXgySnzwVtb%Larry.Finger@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger wrote:
> The initial rate for STA's using rc80211_simple is set to the last
> rate in the rate table. This is too fast for the bcm43xx-mac80211
> driver. 
>
> To correct this situation without affecting any other driver,
> an initial_rate parameter is added to the rc80211_simple module. This
> parameter is set to 10 times the desired initial rate. If the parameter
> is zero or not set, the original behavior is kept. If the parameter
> does not match a valid rate, the first rate in the table will be set.

Initial rate selection should be based on the RSSI of the last frame(s) received from the target network.  One way to do that would be for the driver to map a minimum RSSI value to each rate.  If the RSSI for the target network is greater than the value listed, that rate could be used for initial selection.  The ieee80211_rate with the highest 'rate', which is in the supported rates mask and with a min_rssi <= the AP's reported RSSI, is selected.

The mechanism by which the magic values for min_rssi are determined for each rate is more observational than scientific--and is vendor specific.  You can pick a set of values, but different hardware and environments will yield different levels of success / failure.  Some hardware can be very lenient if it has automatic hardware retry.  Other hardware will need to be very conservative (since, as you point out, the first few frames Tx/Rx'd are important)

James

> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
