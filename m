Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:10227 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753520Ab2IJPMh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 10 Sep 2012 11:12:37 -0400
Message-ID: <504E035B.7050106@qca.qualcomm.com> (sfid-20120910_171240_802190_DAC02532)
Date: Mon, 10 Sep 2012 20:42:27 +0530
From: Pandiyarajan <c_ppitch@qca.qualcomm.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linville@tuxdriver.com>, <linux-wireless@vger.kernel.org>
Subject: Re: [RFC] cfg80211/nl80211: Notify connection request failure in
 AP mode
References: <1347274408-11949-1-git-send-email-c_ppitch@qca.qualcomm.com> <1347276502.4272.22.camel@jlt4.sipsolutions.net>
In-Reply-To: <1347276502.4272.22.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

On Monday 10 September 2012 04:58 PM, Johannes Berg wrote:
> On Mon, 2012-09-10 at 16:23 +0530, Pandiyarajan Pitchaimuthu wrote:
>> In AP mode, when a station requests connection to an AP and if the
>> request is failed for particular reason, userspace is notified about the
>> failure through NL80211_CMD_CONN_FAILED command. Reason for the failure
>> is sent through the attribute NL80211_ATTR_CONN_FAILED_REASON.
> Why would userspace care?
It would be useful to inform the userspace that the driver/firmware's
limitation of maintaining the maximum number of connected clients is 
reached.
Without this the user may not be clear about why another client cannot 
be added.

Also, further enhancements/decisions can be made based on this event.

>> +/* AP mode - sta's connection request failed reasons */
>> +enum nl80211_connect_failed_reason {
>> +	NL80211_CONN_FAIL_MAX_CLIENTS		= 1,
>> +	NL80211_CONN_FAIL_BLOCKED_CLIENT	= 2,
>> +};
> Why number explicitly?
Thanks. Will change it to have the default value.
>> + * Whenever a station tries to connect to an AP and if the station
>> + * could not connect to the AP for some reason, this function is called.
> It's not really "for some reason", it's "because the AP rejected it for
> some reason"... You're not handling other cases anyway.
>
> johannes
>
Sure. Will change the comment.

Pandiyarajan.P
