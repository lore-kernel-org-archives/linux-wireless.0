Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f210.google.com ([209.85.219.210]:60190 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750836AbZFTJcM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 20 Jun 2009 05:32:12 -0400
Received: by ewy6 with SMTP id 6so3254387ewy.37
        for <linux-wireless@vger.kernel.org>; Sat, 20 Jun 2009 02:32:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4A3C3423.2060007@bitnet.be>
References: <4A3B5B11.7060103@bitnet.be>
	 <45e8e6c40906191000i2e74e06btee7313c5c30bc6a2@mail.gmail.com>
	 <4A3C3423.2060007@bitnet.be>
Date: Sat, 20 Jun 2009 12:32:14 +0300
Message-ID: <40f31dec0906200232j531d5804g283a3d93401652a@mail.gmail.com>
Subject: Re: current status of 802.11s mesh in ath5k ?
From: Nick Kossifidis <mickflemm@gmail.com>
To: Hans Maes <Hans@bitnet.be>
Cc: Andrey Yurovsky <andrey@cozybit.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2009/6/20 Hans Maes <Hans@bitnet.be>:
> Andrey Yurovsky wrote:
>>
>>  However ath5k will not beacon until you issue a scan due
>> to a bug.  You can bring up an ath5k node like this:
>>
>> # iw phy phy0 interface add mesh type mp mesh_id mymesh
>> # ifconfig mesh up
>> # iwlist mesh scan
>>
>>
>
> So, once the first scan triggers the beaconing, everything should keep
> working ok ?
> Or should I throw together a small script that triggers a scan once every
> 10minutes until this bug is fixed ?
> (In my case the mesh nodes should stay online 24/7 without user interaction)
>>
>> Things seem to work well aside from the scan issue, however I haven't
>> fully verified multi-hop yet.
>
> I have a semi production setup with about 10 mesh nodes, in a building where
> multihop is required due to the extensive use of metal plating and therefore
> 'poor' wireless performance. In a typical scenario I need about 4 to 5 hops
> to reach the nodes at the other end of the building.
>
> The nodes only have a single antenna connected, so I need to change some
> code to disable antenna switching, but I'm not a C expert/module developer
> at all so that might take a while to figure out...

Antenna controls are there, we just don't have a user interface yet
(configfs/debugfs)
Check out  ath5k_hw_set_antenna_mode inside phy.c, available modes are
on enum ath5k_ant_mode inside ath5k.h and we call it on ath5k_config
inside base.c ;-)

> I thought I managed to do it about 2 months ago but broke something since
> the nodes seemed to work perfectly after updating the wireless modules but
> they all went offline 3 to 5 days later and only came back online after
> reverting to the stable 2.6.29 wireless modules.
>
> Anyway, when I get that issue worked out without breaking anything else I'll
> see how the multihop performs and report back in a few days.
>
> Thanks!




-- 
GPG ID: 0xD21DB2DB
As you read this post global entropy rises. Have Fun ;-)
Nick
