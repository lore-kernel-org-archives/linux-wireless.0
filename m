Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:40339 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756137AbZAWAQZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 22 Jan 2009 19:16:25 -0500
Message-ID: <49790C43.5050100@lwfinger.net> (sfid-20090123_011629_406173_1B8775FB)
Date: Thu, 22 Jan 2009 18:16:03 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: wireless <linux-wireless@vger.kernel.org>
CC: =?ISO-8859-1?Q?Mart=EDn_Ernesto_Barreyro?=
	<barreyromartin@gmail.com>, Felix Fietkau <nbd@openwrt.org>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Minstrel rate-setting question
References: <BLU144-W4266C309A1F9CD0F4B5C21B2D90@phx.gbl>	 <496CE438.6020408@lwfinger.net>	 <BLU144-W164FB7B41C703C52AAAF9BB2D90@phx.gbl>	 <496D2772.4060104@lwfinger.net>	 <BLU144-W254C2D7845CD9E851F745DB2D60@phx.gbl>	 <496D3118.7060906@lwfinger.net>	 <BLU144-W40A7F7D25BE3B92EABD5C7B2D60@phx.gbl> <496D665A.90608@lwfinger.net>	 <BLU144-W102912CECD6EE0D07D1BD8B2D50@phx.gbl>	 <4972B1E7.7000005@lwfinger.net>	 <BLU144-W211FE279F46EA07E0D35E0B2D10@phx.gbl>	 <4977612D.7050500@lwfinger.net> <1232664643.4589.5.camel@note-tatin>
In-Reply-To: <1232664643.4589.5.camel@note-tatin>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In the patch I just submitted, I added TX retry info to the driver for RTL8187L devices.
One of the testers of the patch reports that the rate is being adjusted, but that the rate
is overestimated and he has to limit it to 11M. His minstrel statistics and his comments
are as follows:

> rate     throughput  ewma prob   this prob  this succ/attempt   success
> attempts
>      1         0.2       29.8       12.5          1(  8)         51
> 86
>      2         0.4       22.6       14.2          0(  0)          6
> 25
>   P  5.5       2.7       54.2      100.0          0(  0)         41
> 109
>     11         1.9       20.5       12.5          0(  0)          6
> 30
>      6         2.1       38.4       20.0          0(  0)          7
> 24
>      9         2.0       24.8        8.3          0(  0)          6
> 25
>     12         2.4       21.9       12.5          0(  0)          6
> 52
>     18         3.2       19.9       12.5          0(  0)          6
> 44
>     24         4.7       22.2       12.5          0(  0)         15
> 109
>     36         4.4       14.5        9.0          0(  0)        495
> 2036
>  t  48         5.2       13.4       12.5          0(  0)        209
> 1220
> T   54         8.6       19.8       14.2          1(  7)        556
> 4514
> 
> But It still is a little to optimistic. But I supose is the algorithm
> fault. It gets a little laggy and I have to limit the rate to 11Mbps.
> 
> If I do that the conection works perfect.
> 
> But the algorithm is working, maybe its just how it should work.
> What do you think?

The losses for all rates seem to be a little high, and I plan to see if he can change
channels, but I would like an expert's analysis of these data.

Thanks,

Larry

