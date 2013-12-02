Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55816 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751438Ab3LBPOe (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Dec 2013 10:14:34 -0500
Message-ID: <1385997324.1969.9.camel@dcbw.foobar.com> (sfid-20131202_161437_364773_50EB2B67)
Subject: Re: question about generalized way for RSSI notification
From: Dan Williams <dcbw@redhat.com>
To: Alexey Perevalov <a.perevalov@samsung.com>
Cc: linux-wireless@vger.kernel.org, johannes@sipsolutions.net
Date: Mon, 02 Dec 2013 09:15:24 -0600
In-Reply-To: <52989CB9.3060108@samsung.com>
References: <52989CB9.3060108@samsung.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-11-29 at 17:55 +0400, Alexey Perevalov wrote:
> Dear wireless subsystem maintainers,
> 
> I have a question regarding RSSI notification to the user space.
> Right now this information available in /proc/net/wireless.
> That generalized method is not depending on driver implementation, 
> driver just need to provide wireless statistics.
> 
> I found 2 places in kernel which report about RSSI to user space eventually.
> First place, it's wlan_rndis driver base implementation 
> ./drivers/net/wireless/rndis_wlan.c.
> The second place, it's mac80211 driver - beacon frame handling.

Do you mean ieee80211_rx_mgmt_beacon()?

> Unfortunately wireless driver we're using isn't rndis based and isn't 
> mac80211 based.
> We don't want to depends on driver code.

There's another possibility: use cfg80211 for the driver's configuration
interface.  cfg80211 is actually just some utility code that implements
the nl80211 API (which replaces the old WEXT configuration API).  Any
driver can use cfg80211, not just ones based on the mac80211 software
stack.  In fact, a number of the older "fullmac" drivers (libertas,
orinico) have been ported to use the cfg80211 API for all configuration
handling.

> What community think in this situation, is it possible to add notifier 
> with following responsibility:
>      send netlink notification in case of signal level changed according 
> to predefined by user threshold?

Look at net/wireless/nl80211.c; these are the entry points when
userspace is configuring the driver with nl80211 commands.  Userspace
would set up CQM thresholds with the NL80211_CMD_SET_CQM command, which
then gets passed to your driver.  Your driver could then set up a timer
or level triggers based on the userspace parameters, and then call
cfg80211_cqm_rssi_notify() as appropriate to send the notification to
userspace.

Dan

> Technically it will looks like rndis_wlan approach - timer function with 
> predefined frequency.
> 
> This functionality is needed to reduce user space daemon activity which 
> provides information to GUI wifi indicator.
> Also such approach could decrease time reaction on signal level changes. 
> Currently, some OSes has 1 second interval,
> another one has 3 seconds for checking RSSI.
> 


