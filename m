Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout4.w1.samsung.com ([210.118.77.14]:29965 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752641Ab3LCGrU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 Dec 2013 01:47:20 -0500
Received: from eucpsbgm1.samsung.com (unknown [203.254.199.244])
 by mailout4.w1.samsung.com
 (Oracle Communications Messaging Server 7u4-24.01(7.0.4.24.0) 64bit (built Nov
 17 2011)) with ESMTP id <0MX700FQDXIUQE00@mailout4.w1.samsung.com> for
 linux-wireless@vger.kernel.org; Tue, 03 Dec 2013 06:47:18 +0000 (GMT)
Message-id: <529D7E75.2010702@samsung.com> (sfid-20131203_074735_455083_CC72162A)
Date: Tue, 03 Dec 2013 10:47:17 +0400
From: Alexey Perevalov <a.perevalov@samsung.com>
MIME-version: 1.0
To: Dan Williams <dcbw@redhat.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: question about generalized way for RSSI notification
References: <52989CB9.3060108@samsung.com>
 <1385997324.1969.9.camel@dcbw.foobar.com>
In-reply-to: <1385997324.1969.9.camel@dcbw.foobar.com>
Content-type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dan,

Thank you very much, already existing netlink interface is really what 
we need.
And beacon frame it's better place to send notification about RSSI.


On 12/02/2013 07:15 PM, Dan Williams wrote:
> On Fri, 2013-11-29 at 17:55 +0400, Alexey Perevalov wrote:
>> Dear wireless subsystem maintainers,
>>
>> I have a question regarding RSSI notification to the user space.
>> Right now this information available in /proc/net/wireless.
>> That generalized method is not depending on driver implementation,
>> driver just need to provide wireless statistics.
>>
>> I found 2 places in kernel which report about RSSI to user space eventually.
>> First place, it's wlan_rndis driver base implementation
>> ./drivers/net/wireless/rndis_wlan.c.
>> The second place, it's mac80211 driver - beacon frame handling.
> Do you mean ieee80211_rx_mgmt_beacon()?
Yes I meant IEEE80211_STYPE_BEACON handling which use already existing 
netlink infrastructure.

>> Unfortunately wireless driver we're using isn't rndis based and isn't
>> mac80211 based.
>> We don't want to depends on driver code.
> There's another possibility: use cfg80211 for the driver's configuration
> interface.  cfg80211 is actually just some utility code that implements
> the nl80211 API (which replaces the old WEXT configuration API).  Any
> driver can use cfg80211, not just ones based on the mac80211 software
> stack.  In fact, a number of the older "fullmac" drivers (libertas,
> orinico) have been ported to use the cfg80211 API for all configuration
> handling.
>
>> What community think in this situation, is it possible to add notifier
>> with following responsibility:
>>       send netlink notification in case of signal level changed according
>> to predefined by user threshold?
> Look at net/wireless/nl80211.c; these are the entry points when
> userspace is configuring the driver with nl80211 commands.  Userspace
> would set up CQM thresholds with the NL80211_CMD_SET_CQM command, which
> then gets passed to your driver.  Your driver could then set up a timer
> or level triggers based on the userspace parameters, and then call
> cfg80211_cqm_rssi_notify() as appropriate to send the notification to
> userspace.
>
> Dan
>
>> Technically it will looks like rndis_wlan approach - timer function with
>> predefined frequency.
>>
>> This functionality is needed to reduce user space daemon activity which
>> provides information to GUI wifi indicator.
>> Also such approach could decrease time reaction on signal level changes.
>> Currently, some OSes has 1 second interval,
>> another one has 3 seconds for checking RSSI.
>>


-- 
Best regards,
Alexey Perevalov
