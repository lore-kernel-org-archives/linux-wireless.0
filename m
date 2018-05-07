Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-eopbgr20043.outbound.protection.outlook.com ([40.107.2.43]:14240
        "EHLO EUR02-VE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752389AbeEGU2W (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 May 2018 16:28:22 -0400
Subject: Re: [PATCH] mesh: don't process mesh channel switch unless csa ie
 provided
To: Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org
References: <1524857196-29399-1-git-send-email-peter.oh@bowerswilkins.com>
 <1525722286.22388.5.camel@sipsolutions.net>
 <81cf6620-d7f6-50f7-23c5-e1ba693f2907@bowerswilkins.com>
 <1525723602.1080.0.camel@sipsolutions.net>
From: Peter Oh <peter.oh@bowerswilkins.com>
Message-ID: <8b2352e3-d551-055e-8d33-4a6a5d76a6a4@bowerswilkins.com> (sfid-20180507_222826_278910_7CCF1FE1)
Date: Mon, 7 May 2018 13:28:08 -0700
MIME-Version: 1.0
In-Reply-To: <1525723602.1080.0.camel@sipsolutions.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 05/07/2018 01:06 PM, Johannes Berg wrote:
> On Mon, 2018-05-07 at 13:04 -0700, Peter Oh wrote:
>> On 05/07/2018 12:44 PM, Johannes Berg wrote:
>>> On Fri, 2018-04-27 at 12:26 -0700, peter.oh@bowerswilkins.com wrote:
>>>> From: Peter Oh <peter.oh@bowerswilkins.com>
>>>>
>>>> There is no meaning to call ieee80211_mesh_process_chnswitch
>>>> without CSA IE provided, since the function will always return error.
>>> I'm not convinced, an extended channel switch element might be present
>>> instead?
>> I expected the comment. Yes, extended channel switch element could be
>> present instead of channel switch element which I missed to take care
>> of. So you can ignore the patch for now and I'll get back with right
>> patch for it.
> Heh. Well, but then why bother at all? I mean, the inner function will
> do the check and fail, and nothing will happen, so why bother?
>
My real concern is that ieee80211_mesh_process_chnswitch function could 
process at certain level of channel switch procedure although mesh 
channel switch parameter element is not given which is mandatory of CSA 
for mesh.
However the reason I didn't use mesh_chansw_params_ie to check is 
because even though it is correct for standard, I'm not sure if it's 
practically right. IMPO, sending CSA means devices (ap or mesh) detected 
radar, so the ultimate goal to achieve is to evacuate the channel 
although there is something missed in frames.

Peter
