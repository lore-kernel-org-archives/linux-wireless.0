Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f52.google.com ([209.85.214.52]:52780 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752793Ab3BRPH1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 18 Feb 2013 10:07:27 -0500
Received: by mail-bk0-f52.google.com with SMTP id jk13so2526861bkc.25
        for <linux-wireless@vger.kernel.org>; Mon, 18 Feb 2013 07:07:26 -0800 (PST)
Message-ID: <512243AB.6000801@cozybit.com> (sfid-20130218_160732_583126_595E9E56)
Date: Mon, 18 Feb 2013 16:07:23 +0100
From: Marco Porsch <marco@cozybit.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: mcgrof@qca.qualcomm.com, jouni@qca.qualcomm.com,
	vthiagar@qca.qualcomm.com, senthilb@qca.qualcomm.com,
	linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	ath9k-devel@lists.ath9k.org
Subject: Re: [PATCH 1/3] mac80211: move mesh sync beacon handler into neighbour_update
References: <1360928446-543-1-git-send-email-marco@cozybit.com>   	 (sfid-20130215_124056_325990_55BC105E) <1360930499.15040.7.camel@jlt4.sipsolutions.net>    <3fance.mi9hwg.2rw1te-qmf@mx.google.com>    (sfid-20130215_134116_713607_1FD8E99F) <1360932381.15040.11.camel@jlt4.sipsolutions.net>   <511E38B2.40900@cozybit.com>  (sfid-20130215_143133_867871_FDF7438A) <1360935431.15040.14.camel@jlt4.sipsolutions.net>  <511E3CB7.4040207@cozybit.com> (sfid-20130215_144844_328347_5B0B2D91) <1360936708.15040.18.camel@jlt4.sipsolutions.net>
In-Reply-To: <1360936708.15040.18.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On 02/15/2013 02:58 PM, Johannes Berg wrote:
> On Fri, 2013-02-15 at 14:48 +0100, Marco Porsch wrote:
>
>>> I'm talking about this API:
>>>
>>> mesh_neighbour_update:
>>> ...
>>> 	tsf = drv_get_tsf()
>>> ...
>>> 	sync_ops->rx_bcn(..., tsf)
>>>
>>>
>>> mesh_sync_offset_rx_bcn(..., t_r):
>>> 	...
>>> 	if (have_better_timestamp)
>>> 		t_r = get_better_timestamp()
>>>
>>>
>>> You can hardly claim that's an intuitive API.
>>
>> Hm, alright. Just saying that ieee80211_mps_sta_tbtt_update still uses
>> the unchanged TSF value. But hey :)
>
> Well, that function doesn't exist in this patch...
>
>> What would be more favourable then?
>
> I guess you can tell I'm not in a good mood today. I think any use of
> get_tsf() for operation is a complete waste of time, there's no way you
> can get the timings correct. You could be preempted, and suddenly sleep
> for a few tens or hundreds milliseconds, so none of this makes any
> sense... To properly do it you have to do calculations in relative times
> and let the device apply them.

I don't get your last sentence here. Maybe you can elaborate?

Concerning timestamp vs. TSF usage; wow - I tested it when using the 
timestamp value for TBTT scheduling. Works fine. Works even better than 
TSF as it slightly reduces the measured wakeup overhead.

Hm, I was sure the TSF as in *now* would be more appropriate than the 
TSF at receipt time... But either way, if it works better and is less 
ugly, it is a win-win =)

I'll send an updated patch with the more intuitive API.
