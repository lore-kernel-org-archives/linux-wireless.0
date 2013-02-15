Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f41.google.com ([209.85.214.41]:44309 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161639Ab3BONsn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Feb 2013 08:48:43 -0500
Received: by mail-bk0-f41.google.com with SMTP id q16so1542927bkw.14
        for <linux-wireless@vger.kernel.org>; Fri, 15 Feb 2013 05:48:42 -0800 (PST)
Message-ID: <511E3CB7.4040207@cozybit.com> (sfid-20130215_144848_013245_04E096CB)
Date: Fri, 15 Feb 2013 14:48:39 +0100
From: Marco Porsch <marco@cozybit.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: mcgrof@qca.qualcomm.com, jouni@qca.qualcomm.com,
	vthiagar@qca.qualcomm.com, senthilb@qca.qualcomm.com,
	linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	ath9k-devel@lists.ath9k.org
Subject: Re: [PATCH 1/3] mac80211: move mesh sync beacon handler into neighbour_update
References: <1360928446-543-1-git-send-email-marco@cozybit.com>  	 (sfid-20130215_124056_325990_55BC105E) <1360930499.15040.7.camel@jlt4.sipsolutions.net>   <3fance.mi9hwg.2rw1te-qmf@mx.google.com>   (sfid-20130215_134116_713607_1FD8E99F) <1360932381.15040.11.camel@jlt4.sipsolutions.net>  <511E38B2.40900@cozybit.com> (sfid-20130215_143133_867871_FDF7438A) <1360935431.15040.14.camel@jlt4.sipsolutions.net>
In-Reply-To: <1360935431.15040.14.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/15/2013 02:37 PM, Johannes Berg wrote:
> On Fri, 2013-02-15 at 14:31 +0100, Marco Porsch wrote:
>> Hi,
>>
>> On 02/15/2013 01:46 PM, Johannes Berg wrote:
>>> On Fri, 2013-02-15 at 12:40 +0000, marco@cozybit.com wrote:
>>>> Please check again. The comment is split in two and placed on the respective new positions.
>>>
>>> Yeah, I see, the API is just total shit. First passing the TSF and then
>>> calculating it to override? Why not do the calculation outside the API
>>> always?
>>
>> The TBTT calculation does intentionally not use the mactime value.
>>
>> Synchronization uses the time in local TSF units and the exact same time
>> point in peers TSF units at the time of sending/receiving (mactime field).
>> The TBTT calculation uses the time of NOW, i.e. the current TSF after
>> possible delays in firmware/driver/rx-handler which may have outdated
>> the mactime field.
>
> I'm talking about this API:
>
> mesh_neighbour_update:
> ...
> 	tsf = drv_get_tsf()
> ...
> 	sync_ops->rx_bcn(..., tsf)
>
>
> mesh_sync_offset_rx_bcn(..., t_r):
> 	...
> 	if (have_better_timestamp)
> 		t_r = get_better_timestamp()
>
>
> You can hardly claim that's an intuitive API.

Hm, alright. Just saying that ieee80211_mps_sta_tbtt_update still uses 
the unchanged TSF value. But hey :)

What would be more favourable then?

a) second variable in mesh_sync_offset_rx_bcn

mesh_neighbour_update:
...
	tsf = drv_get_tsf()
...
	sync_ops->rx_bcn(..., tsf)

	ieee80211_mps_sta_tbtt_update(..., tsf);


mesh_sync_offset_rx_bcn(..., tsf):
	...
	if (have_better_timestamp)
		t_r = get_better_timestamp()
	else
		t_r = tsf;


b) second variable in mesh_neighbour_update

mesh_neighbour_update:
...
	tsf = drv_get_tsf()
	if (have_better_timestamp)
		t_r = get_better_timestamp()
	else
		t_r = tsf;
...
	sync_ops->rx_bcn(..., t_r)

	ieee80211_mps_sta_tbtt_update(..., tsf);


--Marco

