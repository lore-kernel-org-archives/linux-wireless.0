Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ot0-f195.google.com ([74.125.82.195]:32798 "EHLO
        mail-ot0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S966069AbeAOPYm (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 15 Jan 2018 10:24:42 -0500
Received: by mail-ot0-f195.google.com with SMTP id x15so10933392ote.0
        for <linux-wireless@vger.kernel.org>; Mon, 15 Jan 2018 07:24:41 -0800 (PST)
Subject: Re: [RFC v2 3/5] mac80211: Send control port frames over nl80211
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
References: <20180110170938.2341-1-denkenz@gmail.com>
 <20180110170938.2341-4-denkenz@gmail.com>
 <1516021789.410.28.camel@sipsolutions.net>
From: Denis Kenzior <denkenz@gmail.com>
Message-ID: <a7b47de8-ad2c-2b73-1e71-d70c47281845@gmail.com> (sfid-20180115_162446_055028_6069C848)
Date: Mon, 15 Jan 2018 09:24:39 -0600
MIME-Version: 1.0
In-Reply-To: <1516021789.410.28.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

On 01/15/2018 07:09 AM, Johannes Berg wrote:
> On Wed, 2018-01-10 at 11:09 -0600, Denis Kenzior wrote:
> 
>> Pre-authentication type frames (protocol: 0x88c7) are also forwarded
>> over nl80211.
> 
> Interesting - maybe userspace should be able to configure a(n) (list
> of) ethertype(s)?
> 

I'm not so sure.  Preauthentication is different from EAPoL frames and 
most of the special-case checks for control_port_ethertype inside 
mac80211 do not apply to it.  I think it might be safer to carry it as a 
special case to the special case :P

>> Signed-off-by: Denis Kenzior <denkenz@gmail.com>
>> ---
>>   net/mac80211/cfg.c         |  2 ++
>>   net/mac80211/ieee80211_i.h |  1 +
>>   net/mac80211/mlme.c        |  2 ++
>>   net/mac80211/rx.c          | 31 ++++++++++++++++++++++++++++---
>>   4 files changed, 33 insertions(+), 3 deletions(-)
>>
>> diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
>> index 46028e12e216..f53bfb27295f 100644
>> --- a/net/mac80211/cfg.c
>> +++ b/net/mac80211/cfg.c
>> @@ -925,6 +925,7 @@ static int ieee80211_start_ap(struct wiphy *wiphy, struct net_device *dev,
>>   	 */
>>   	sdata->control_port_protocol = params->crypto.control_port_ethertype;
>>   	sdata->control_port_no_encrypt = params->crypto.control_port_no_encrypt;
>> +	sdata->control_port_over_nl80211 = false;
> 
> It's probably better to reset this at interface type switching, if it's
> not done anyway (we zero a lot of memory there, but not sure precisely
> what)
> 
> Otherwise we'll surely forget this in some place like mesh or OCB ...
> 
> Initially it must be false (0) anyway.
> 

Where do I look?  Right now I'm mostly following the precedent of other 
control_port_* stuff.

Regards,
-Denis
