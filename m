Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f41.google.com ([209.85.214.41]:46436 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161179Ab3BONbd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Feb 2013 08:31:33 -0500
Received: by mail-bk0-f41.google.com with SMTP id q16so1535365bkw.14
        for <linux-wireless@vger.kernel.org>; Fri, 15 Feb 2013 05:31:32 -0800 (PST)
Message-ID: <511E38B2.40900@cozybit.com> (sfid-20130215_143140_187393_83B74545)
Date: Fri, 15 Feb 2013 14:31:30 +0100
From: Marco Porsch <marco@cozybit.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: mcgrof@qca.qualcomm.com, jouni@qca.qualcomm.com,
	vthiagar@qca.qualcomm.com, senthilb@qca.qualcomm.com,
	linux-wireless@vger.kernel.org, devel@lists.open80211s.org,
	ath9k-devel@lists.ath9k.org
Subject: Re: [PATCH 1/3] mac80211: move mesh sync beacon handler into neighbour_update
References: <1360928446-543-1-git-send-email-marco@cozybit.com> 	 (sfid-20130215_124056_325990_55BC105E) <1360930499.15040.7.camel@jlt4.sipsolutions.net>  <3fance.mi9hwg.2rw1te-qmf@mx.google.com>  (sfid-20130215_134116_713607_1FD8E99F) <1360932381.15040.11.camel@jlt4.sipsolutions.net>
In-Reply-To: <1360932381.15040.11.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On 02/15/2013 01:46 PM, Johannes Berg wrote:
> On Fri, 2013-02-15 at 12:40 +0000, marco@cozybit.com wrote:
>> Please check again. The comment is split in two and placed on the respective new positions.
>
> Yeah, I see, the API is just total shit. First passing the TSF and then
> calculating it to override? Why not do the calculation outside the API
> always?

The TBTT calculation does intentionally not use the mactime value.

Synchronization uses the time in local TSF units and the exact same time 
point in peers TSF units at the time of sending/receiving (mactime field).
The TBTT calculation uses the time of NOW, i.e. the current TSF after 
possible delays in firmware/driver/rx-handler which may have outdated 
the mactime field.

--Marco
