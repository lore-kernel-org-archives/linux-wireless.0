Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:59694 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932860Ab3FRQeA (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Jun 2013 12:34:00 -0400
Message-ID: <51C08BF3.7050706@candelatech.com> (sfid-20130618_183431_733383_5DDA27D2)
Date: Tue, 18 Jun 2013 09:33:55 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [RFC 2/2] mac80211:  Fix bss ref leak.
References: <1371504746-8476-1-git-send-email-greearb@candelatech.com>  <1371504746-8476-2-git-send-email-greearb@candelatech.com>  (sfid-20130617_233256_432869_08F1495E) <1371569205.8318.47.camel@jlt4.sipsolutions.net>
In-Reply-To: <1371569205.8318.47.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 06/18/2013 08:26 AM, Johannes Berg wrote:
> On Mon, 2013-06-17 at 14:32 -0700, greearb@candelatech.com wrote:
>
>>   static void ieee80211_destroy_assoc_data(struct ieee80211_sub_if_data *sdata,
>> -					 bool assoc)
>> +					 bool assoc, bool put_bss)
>
> Do we _really_ need another argument? Shouldn't it always be put in the
> non-assoc case anyway, at least if non-NULL?

I don't think so.  Check out the ieee80211_rx_mgmt_assoc_resp method.

  	if (status_code != WLAN_STATUS_SUCCESS) {
		sdata_info(sdata, "%pM denied association (code=%d)\n",
			   mgmt->sa, status_code);
		ieee80211_destroy_assoc_data(sdata, false, false);

This passes in false as 'assoc', but we should not free bss here because
it is being passed back to the calling method, and the return
code of RX_MGMT_CFG80211_RX_ASSOC means bss should eventually
be consumed by the cfg80211 logic.

Of course, this is all 'as far as I can tell'.

I sort of like the second boolean because it forces the caller to
think about whether bss should be freed or not...

Thanks,
Ben


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

