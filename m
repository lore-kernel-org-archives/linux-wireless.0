Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pl0-f52.google.com ([209.85.160.52]:46734 "EHLO
        mail-pl0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753187AbeBTQwz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 20 Feb 2018 11:52:55 -0500
Received: by mail-pl0-f52.google.com with SMTP id x19so7716581plr.13
        for <linux-wireless@vger.kernel.org>; Tue, 20 Feb 2018 08:52:55 -0800 (PST)
Subject: Re: [RFC v4 3/6] nl80211: Implement TX of control port frames
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
References: <20180201010420.6102-1-denkenz@gmail.com>
 <20180201010420.6102-4-denkenz@gmail.com>
 <1519044297.16723.4.camel@sipsolutions.net>
From: Denis Kenzior <denkenz@gmail.com>
Message-ID: <da21b7e8-dd53-4bf3-ca9a-b933cddb3212@gmail.com> (sfid-20180220_175303_677218_F90ADA8A)
Date: Tue, 20 Feb 2018 10:52:52 -0600
MIME-Version: 1.0
In-Reply-To: <1519044297.16723.4.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

On 02/19/2018 06:44 AM, Johannes Berg wrote:
> On Wed, 2018-01-31 at 19:04 -0600, Denis Kenzior wrote:
>>
>> +	switch (wdev->iftype) {
>> +	case NL80211_IFTYPE_STATION:
>> +		if (wdev->current_bss)
>> +			break;
>> +		err = -ENOTCONN;
>> +		goto out;
>> +	default:
>> +		err = -EOPNOTSUPP;
>> +		goto out;
>> +	}
>>
> Why restrict this to client mode? At the very least, P2P_CLIENT really
> should be listed there, but I'm not sure why not also support it in
> IBSS, and AP/P2P_GO/AP_VLAN modes?
> 
> We could do this in a separate patch, but then we have to define
> different flags for the modes which seems somewhat pointless.

I've no means of testing the other modes at this time.  So I'm not sure 
what to tell you.  I can respin with IFTYPE_P2P_CLIENT in the 
switch/case (or you can amend and do so).

Regards,
-Denis
