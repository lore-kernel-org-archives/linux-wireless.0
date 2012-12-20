Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [64.78.22.98] ([64.78.22.98]:38813 "EHLO
	mail022-1.exch022.serverdata.net" rhost-flags-FAIL-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751326Ab2LTKji (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Dec 2012 05:39:38 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Date: Thu, 20 Dec 2012 02:39:17 -0800
From: vivekanandah@posedge.com
To: Johannes Berg <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Subject: Re: Re: adding =?UTF-8?Q?ba=5Fpolicy=20member=20in=20drv=5Fampdu?=
 =?UTF-8?Q?=5Faction=20op=20-=20request=20information?=
In-Reply-To: <1355407319.9463.4.camel@jlt4.sipsolutions.net>
References: <53a9b58ee917248d8fa617dd1bbcde83@posedge.com>
 <1355407319.9463.4.camel@jlt4.sipsolutions.net>
Message-ID: <ccd9b999d335370ce1508dae369e0951@posedge.com> (sfid-20121220_113945_028523_28669005)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

hi johannes,

sorry for the delayed response. i was off from work for a few days.

is'nt the station's capability and the AP capability intersected during 
association? i always thought that the comment was mis-represented.

i did a small test and i see that the stations capability is actually 
the subset of AP capabilities that both support.
if that is the case, then we do not have to check for the capability 
independently there! do i miss something in my understanding?

also, if what i have stated above is correct, then yes, i feel delayed 
block ack as a feature might need to be implemented on mac80211 and then 
check for the same.

thanks and regards
Vivek


On Thu, 13 Dec 2012 15:01:59 +0100, Johannes Berg wrote:
> Hi Vivek,
>
>> if you are referring to the addba-request to transmit a ADDBA with
>> delayed block ack, yes, i accept what you have stated. but, then we
>> would need to support delayed block ack on the TX.
>>
>> for my query, i was thinking more with respect to the receive side 
>> of
>> an AP.
>
> Ah, ok.
>
>> if, let us say a particular station is capable of delayed block ack
>> which might not be a linux station(presently it seems, linux box 
>> will
>> only pursue immediate block ack), then on receive of a block ack
>> request, the lower layer can just send an ack if the policy is known 
>> to
>> be delayed block ack.
>
> Right now, a mac80211-based station should probably never even 
> advertise
> that it is delayed-BA capable since it won't correctly be handled.
> Therefore, any other station must not ask for a delayed-BA session in
> its AddBA request. And in fact, ieee80211_process_addba_request() 
> drops
> frames that ask for delayed BA.
>
> So I guess what you're really saying is that you want to implement
> delayed BA and address the todo item in
> ieee80211_process_addba_request() that says:
>
>         /* XXX: check own ht delayed BA capability?? */
>
> i.e. add a check here for our own capability and add a new parameter 
> to
> let the driver know...
>
> Overall that seems reasonable.
>
> johannes

