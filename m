Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f207.google.com ([209.85.219.207]:62390 "EHLO
	mail-ew0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752931AbZHSTaa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Aug 2009 15:30:30 -0400
Received: by ewy3 with SMTP id 3so2369625ewy.18
        for <linux-wireless@vger.kernel.org>; Wed, 19 Aug 2009 12:30:31 -0700 (PDT)
Message-ID: <4A8C52BD.5070609@gmail.com>
Date: Wed, 19 Aug 2009 20:30:05 +0100
From: Dave <kilroyd@googlemail.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [RFC 5/5] cfg80211: scan before connect if we don't have the
 bss
References: <1250640253-18434-1-git-send-email-kilroyd@googlemail.com>	 <1250640253-18434-6-git-send-email-kilroyd@googlemail.com> <1250668113.16393.25.camel@johannes.local>
In-Reply-To: <1250668113.16393.25.camel@johannes.local>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Wed, 2009-08-19 at 01:04 +0100, David Kilroy wrote:
>> @@ -791,18 +824,55 @@ int __cfg80211_connect(struct cfg80211_registered_device *rdev,
>> +		bss = cfg80211_get_bss(wdev->wiphy, NULL, connect->bssid,
>> +				       connect->ssid, connect->ssid_len,
>> +				       WLAN_CAPABILITY_ESS,
>> +				       WLAN_CAPABILITY_ESS);
> 
> Hmm. What if the bssid isn't set? Then the card might select a different
> BSS than the one we have on the scan list.

That's correct. For the Agere driver that's also true when bssid is set
- we can't specify which AP the firmware connects to.

>> +			/* Failed to clone (or scan), so we can't
>> +			 * delay the connect. Free everything up and
>> +			 * go ahead with the connect */
>> +			if (wdev->conn)
>> +				kfree(wdev->conn->ie);
>> +			kfree(wdev->conn);
>> +			wdev->conn = NULL;
> 
> and that would then run into the warning and the problem anyway? Better
> to just reject with -ENOMEM I think? Also, I really don't think you
> should use wdev->conn anywhere in this code path, because some code
> looks at that to figure out whether or not the cfg80211 SME is used.

I thought that might be the case.

>> +		} else {
>> +			cfg80211_put_bss(bss);
> 
>>  		err = rdev->ops->connect(&rdev->wiphy, dev, connect);
> 
> And it's all racy too -- by the time the driver calls connect_result(),
> the BSS might have expired after it was found here now.

Agreed, but with a 15s expiry period I wouldn't expect this to be a
problem in practice.

> I don't think this is really feasible to implement in cfg80211.

cfg80211 seemed like the appropriate place because it avoids different
(fullmac) drivers having to re-implement this.

> Couldn't
> the driver do a probe to the BSS that the device selected, and report
> that before the connect result?

Yes, that's possible. If we went this way it would make sense to encode
this in the interface by changing the cfg80211_connect_result prototype to:

void cfg80211_connect_result(struct net_device *dev,
                             const struct bss *bss,
			     const u8 *req_ie, size_t req_ie_len,
			     const u8 *resp_ie, size_t resp_ie_len,
			     u16 status, gfp_t gfp);

So on connecting:

 * the driver has to call cfg80211_get_bss() to get the bss pointer.

 * if it is not available, scan/probe to get the information, call
cfg80211_inform_bss(), and then use the returned pointer in the
cfg80211_connect_result call.

This means the driver may have to hold onto the IE info to use after the
scan returns.

Another alternative is for cfg80211_connect_result to trigger the scan
if it doesn't have the bss, and only complete the connect when the scan
returns. I think I like the sound of this best.



Dave.
