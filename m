Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail138c0.megamailservers.com ([69.49.121.248]:48077 "EHLO
	mail138c0.megamailservers.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932108Ab2EKUGQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 11 May 2012 16:06:16 -0400
Message-ID: <4FAD2B8D.8090104@microhardcorp.com> (sfid-20120511_220620_211450_F02F6481)
Date: Fri, 11 May 2012 09:09:01 -0600
From: Bin Zeng <bzeng@microhardcorp.com>
MIME-Version: 1.0
To: Thomas Pedersen <thomas@cozybit.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: MESH only works at 54Mbps link rate or below?
References: <4FAC2B98.6040100@microhardcorp.com> <CAG6hwVPanDNoWCK-dA2V3gpz8cJhQ-5oJZLXng0rrUXQngPPww@mail.gmail.com>
In-Reply-To: <CAG6hwVPanDNoWCK-dA2V3gpz8cJhQ-5oJZLXng0rrUXQngPPww@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thomas,

Yes, I did like that.
iw phy phy0 interface add mesh0 type mp mesh_id mymesh
iw dev mesh0 set channel 48 HT20
ifconfig mesh0 up

However, if I use iw to set bitrate, something like that "iw mesh0 set 
bitrates legacy-5 54 mcs-5 15". Then use "iw dev mesh0 station dump" to 
check bitrate. It seems like only show 54Mbps or below bitrates. HT mcs 
rate can not be controlled?


Any help appreciate.

Thanks,

Bin





On 05/10/2012 06:20 PM, Thomas Pedersen wrote:
> Hey Bin,
>
> On Thu, May 10, 2012 at 1:56 PM, Bin Zeng<bzeng@microhardcorp.com>  wrote:
>> Hi
>>
>> I created a MESH network by using 802.11n supported cards, however, MESH
>> only works at 54Mbps link rate or below.
>>
>> Can anyone tell me how to active the 802.11n ht mode in mesh?
> Just set the channel type to HT, something like:
>
> iw wlan0 set channel 1 HT20
>
> Before joining the mesh.
>
> Thomas
>
>

