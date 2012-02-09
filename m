Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mms2.broadcom.com ([216.31.210.18]:3664 "EHLO mms2.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758330Ab2BIUVy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Feb 2012 15:21:54 -0500
Message-ID: <4F342AD6.8000205@broadcom.com> (sfid-20120209_212223_193741_F48FCB13)
Date: Thu, 9 Feb 2012 21:21:42 +0100
From: "Arend van Spriel" <arend@broadcom.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>
cc: "Felix Fietkau" <nbd@openwrt.org>, "Pavel Roskin" <proski@gnu.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"johannes@sipsolutions.net" <johannes@sipsolutions.net>
Subject: Re: [PATCH] mac80211: do not call rate control .tx_status
 before .rate_init
References: <1328725031-35464-1-git-send-email-nbd@openwrt.org>
 <20120208192536.GB2929@tuxdriver.com> <4F32CF18.4010300@openwrt.org>
 <20120208194453.GC2929@tuxdriver.com> <20120208180152.082cff4e@mj>
 <4F3318A7.5030809@openwrt.org> <20120209201411.GB29948@tuxdriver.com>
In-Reply-To: <20120209201411.GB29948@tuxdriver.com>
Content-Type: text/plain;
 charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/09/2012 09:14 PM, John W. Linville wrote:
> On Thu, Feb 09, 2012 at 01:51:51AM +0100, Felix Fietkau wrote:
>> On 2012-02-09 12:01 AM, Pavel Roskin wrote:
>>> On Wed, 8 Feb 2012 14:44:54 -0500
>>> "John W. Linville" <linville@tuxdriver.com> wrote:
>>>
>>>> On Wed, Feb 08, 2012 at 08:38:00PM +0100, Felix Fietkau wrote:
>>>>> On 2012-02-08 8:25 PM, John W. Linville wrote:
>>>>>> On Wed, Feb 08, 2012 at 07:17:11PM +0100, Felix Fietkau wrote:
>>>>>>> Most rate control implementations assume .get_rate
>>>>>>> and .tx_status are only called once the per-station data has
>>>>>>> been fully initialized. minstrel_ht crashes if this assumption
>>>>>>> is violated.
>>>>>>>
>>>>>>> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
>>>>>>> Tested-by: Arend van Spriel <arend@broadcom.com>
>>>>>>> ---
>>>>>>>  net/mac80211/rate.h |    2 +-
>>>>>>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>>>>>>
>>>>>>> diff --git a/net/mac80211/rate.h b/net/mac80211/rate.h
>>>>>>> index 5fc3135..fbb1efd 100644
>>>>>>> --- a/net/mac80211/rate.h
>>>>>>> +++ b/net/mac80211/rate.h
>>>>>>> @@ -37,7 +37,7 @@ static inline void
>>>>>>> rate_control_tx_status(struct ieee80211_local *local, struct
>>>>>>> ieee80211_sta *ista = &sta->sta; void *priv_sta =
>>>>>>> sta->rate_ctrl_priv; 
>>>>>>> -	if (!ref)
>>>>>>> +	if (!ref || !test_sta_flag(sta, WLAN_STA_RATE_CONTROL))
>>>>>>>  		return;
>>>>>>>  
>>>>>>>  	ref->ops->tx_status(ref->priv, sband, ista, priv_sta,
>>>>>>> skb);
>>>>>>
>>>>>> Any reason not to apply this for 3.3?  Or stable?
>>>>> I think 3.3 doesn't have that sta flag, the issue was probably
>>>>> introduced with the 3.4 changes.
>>>>> I don't remember something like this appearing in earlier versions.
>>>>
>>>> Cool, thanks.
>>>
>>> I believe 3.3 is affected.  At least it looks like the Fedora bug 768639
>>> (https://bugzilla.redhat.com/show_bug.cgi?id=768639) is caused by
>>> calling .tx_status at a wrong time.  Fedora kernels use
>>> compat-wireless-3.3.  I'm going to test the bleeding edge
>>> compat-wireless with the patch by Felix to see if it fixes things.
>>>
>>> The lack of the WLAN_STA_RATE_CONTROL flag doesn't mean that the old
>>> behavior was correct.  The flag was introduced to correct that behavior.
>>>
>>> The oldest report is dated 2011-12-17 and it's about Linux 3.2.0-rc5
>>> with compat-wireless-2011-12-01.
>> Only .get_rate and .tx_status are affected, wireless-testing commit
>> e1936e9407138b483e6d1332dd944afec8131f30 adds one of the checks, and my
>> commit adds the other. Maybe John could merge those two to 3.3.
> 
> At least one of them will cause some merge issues.  Can someone try
> the attached patches to verify that they actually fix a real problem
> in 3.3? 
> 
> Thanks!
> 
> John

Hi John,

This patch fixes NULL deref issue I found and bisected in
wireless-testing earlier this week (see [1]). I don't think gives a
problem with 3.3 at the moment.

Gr. AvS

[1] http://www.spinics.net/lists/linux-wireless/msg84575.html




