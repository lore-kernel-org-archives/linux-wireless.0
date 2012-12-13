Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail022-1.exch022.serverdata.net ([64.78.22.98]:37561 "EHLO
	mail022-1.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753481Ab2LMKSW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Dec 2012 05:18:22 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Thu, 13 Dec 2012 15:48:21 +0530
From: vivekanandah@posedge.com
To: <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Subject: Re: Re: adding =?UTF-8?Q?ba=5Fpolicy=20member=20in=20drv=5Fampdu?=
 =?UTF-8?Q?=5Faction=20op=20-=20request=20information?=
Message-ID: <53a9b58ee917248d8fa617dd1bbcde83@posedge.com> (sfid-20121213_111825_443355_70DA9F23)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi johannes,

kindly find my thoughts below:

if you are referring to the addba-request to transmit a ADDBA with 
delayed block ack, yes, i accept what you have stated. but, then we 
would need to support delayed block ack on the TX.

for my query, i was thinking more with respect to the receive side of 
an AP.

if, let us say a particular station is capable of delayed block ack 
which might not be a linux station(presently it seems, linux box will 
only pursue immediate block ack), then on receive of a block ack 
request, the lower layer can just send an ack if the policy is known to 
be delayed block ack.

It can later decide to send out the actual block ack response in the 
next TXOP. i felt this could be independent of actual support of delayed 
block ack on the TX side. this also provides the entire block ack info 
to the lower layers.

looking forward to your inputs
thanks and regards
Vivek



> -------- Original Message --------
>
> SUBJECT:
> Re: adding ba_policy member in drv_ampdu_action op - request
> information
>
> DATE:
> Wed, 12 Dec 2012 15:17:58 +0100
>
> FROM:
> Johannes Berg  [1]
>
> TO:
> vivekanandah@posedge.com [2]
>
> CC:
> linux-wireless@vger.kernel.org [3]
>
> On Wed, 2012-12-12 at 12:10 +0530, vivekanandah@posedge.com [4]
> wrote:
>> Hi,
>>
>> presently in code, the block ack policy is not sent by mac80211 to
> the
>> lower level driver via the ampdu_action callback.
>>
>> The mac80211 while transmitting a block ack (ADDBA)request,
> hardcodes
>> the block ack methodology to immediate block ack.
>>
>> on the receive side, the delayed block ack bit is checked
> along-with
>> the capability of the receiver station to support delayed block
> ack.
>> even if the station supports delayed block ack, mac80211 does not
> send
>> the ba_policy down to the driver.
>>
>> should ba_policy be sent to the driver so that lower level drivers
> can
>> take a call as to send block ack response in a delayed manner at
> its
>> convenience?
>
> Well, if you wanted to support it, you'd first have to change the
> negotiation to actually ask for it, no?
>
> johannes
>
> --
> To unsubscribe from this list: send the line "unsubscribe
> linux-wireless" in
> the body of a message to majordomo@vger.kernel.org [5]
> More majordomo info at http://vger.kernel.org/majordomo-info.html [6]
>
>
>
> Links:
> ------
> [1] mailto:johannes@sipsolutions.net
> [2] mailto:vivekanandah@posedge.com
> [3] mailto:linux-wireless@vger.kernel.org
> [4] mailto:vivekanandah@posedge.com
> [5] mailto:majordomo@vger.kernel.org
> [6] http://vger.kernel.org/majordomo-info.html

