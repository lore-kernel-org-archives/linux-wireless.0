Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:59048 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753042Ab2JEXPV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 5 Oct 2012 19:15:21 -0400
Message-ID: <506F69FF.5090701@openwrt.org> (sfid-20121006_011526_327939_25B88549)
Date: Sat, 06 Oct 2012 01:15:11 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, johannes@sipsolutions.net,
	mcgrof@qca.qualcomm.com
Subject: Re: [PATCH 3.7 1/2] cfg80211: fix antenna gain handling
References: <1349286707-64433-1-git-send-email-nbd@openwrt.org> <20121005202220.GA1929@tuxdriver.com> <506F4AFE.2090301@broadcom.com>
In-Reply-To: <506F4AFE.2090301@broadcom.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2012-10-05 11:02 PM, Arend van Spriel wrote:
> On 10/05/2012 10:22 PM, John W. Linville wrote:
>> Anyone object?  I suspect that Johannes may be a little more
>> busy/distracted than usual for the next few days/weeks...
>>
>> John
>>
>> On Wed, Oct 03, 2012 at 07:51:46PM +0200, Felix Fietkau wrote:
>>> When not intersecting, orig->chan_mag is initialized to zero. Because of
>>> that, the regulatory antenna gain limit never gets set.
>>>
>>> Signed-off-by: Felix Fietkau <nbd@openwrt.org>
>>> Cc: stable@vger.kernel.org
>>> ---
>>>   net/wireless/reg.c |    3 +--
>>>   1 file changed, 1 insertion(+), 2 deletions(-)
>>>
>>> diff --git a/net/wireless/reg.c b/net/wireless/reg.c
>>> index 3b8cbbc..1a16f19 100644
>>> --- a/net/wireless/reg.c
>>> +++ b/net/wireless/reg.c
>>> @@ -915,8 +915,7 @@ static void handle_channel(struct wiphy *wiphy,
>>>
>>>   	chan->beacon_found = false;
>>>   	chan->flags = flags | bw_flags | map_regdom_flags(reg_rule->flags);
>>> -	chan->max_antenna_gain = min(chan->orig_mag,
>>> -		(int) MBI_TO_DBI(power_rule->max_antenna_gain));
> 
> Just reading the commit message, I would think it better to initialize 
> chan->orig_mag to INT_MAX. Just my 0.02$
I'm not sure it's useful for the driver to be able to add initial max
antenna gain restrictions that way (which IMHO is the only point to
using chan->orig_mag).
I think it's better (and more predictable) to just stick to the power
rules from the regulatory information.

- Felix
