Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.184]:44952 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751915AbZCQOyL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Mar 2009 10:54:11 -0400
Received: by nf-out-0910.google.com with SMTP id d21so11236nfb.21
        for <linux-wireless@vger.kernel.org>; Tue, 17 Mar 2009 07:54:08 -0700 (PDT)
Message-ID: <49BFB988.8040209@gmail.com> (sfid-20090317_155414_696418_8F1E9239)
Date: Tue, 17 Mar 2009 10:54:00 -0400
From: Richard Farina <sidhayn@gmail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Re: [RFC] fix wireless-regdb enforcement oddities
References: <49BEE56C.9050202@gmail.com> <20090317090922.GA2721@jm.kir.nu>
In-Reply-To: <20090317090922.GA2721@jm.kir.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jouni Malinen wrote:
> On Mon, Mar 16, 2009 at 07:49:00PM -0400, Richard Farina wrote:
>
>   
>> For the sake of sanity, I think that the way rules from wireless-regdb  
>> are enforced needs to be changed. An example:
>>
>> country US:
>>        (5170 - 5250 @ 40), (3, 17)
>>        (5250 - 5330 @ 40), (3, 20), DFS
>>
>> In this case, you will see that I have removed all of the rules that I  
>> do not intend to cite to lower the complexity of the ruleset.
>>
>> Take for example, channel 48, center frequency 5240.  A standard 20 mhz  
>> mode will work as expected, as well as HT40-, however HT40+ cannot be  
>> set because it would need to cross the rule boundary.  Each line of a  
>> regulatory domain section is enforced by itself.  Channel 52 has a  
>> similiar problem where 20 and HT40+ work but HT40- will not.
>>     
>
> Channel 48 with HT40+ would not work regardless of the regulatory rules;
> (48,52) is not one of the allowed HT40 channel pairs. You can use
> (36,40), (44,48), (52,56), and (60,64), but not (40,44), (48,52),
> (56,60). This is not really a regulatory limit but restriction stated in
> IEEE 802.11n Annex J. And same applies to channel 52 with HT40-.
>
> There may be some other examples where the processing of the ruleset
> could be improved, but this particular example does not look like
> something that would benefit much from a change here.
>
>   
>> As this specific example includes frequencies in the DFS range, you can  
>> obviously see why no one has noticed this failing before.  The obviously  
>> expected result is that if two rules abut and a channel is requested  
>> that stradles them, it should take the most restrictive mix between the  
>> two.  For instance, if I set channel 48 in HT40+ mode (and we have DFS  
>> support) the rule would be enforced as (3, 17), DFS; while HT40- would  
>> be enforced as the standard (3, 17).
>>     
>
> If the channel pair (48,52) were allowed by IEEE 802.11n and we
> supported DFS, yes, I would agree with this. However, neither of those
> are the case at the moment (and I don't see the former changing in the
> future either).
>
>   

Okay, so my example isn't good enough because that specific setup is not 
allowed, maybe some later time we can discuss the fact that the rules 
really are not enforced as a whole and not argue the semantics of my 
specific examples.  My eventual goal is to have 1-10,000 in the allowed 
rules with a NOTX flag for all the frequencies which are monitor 
only...but I suppose for now I'll just use that ugly overlapping 
regdomain hack until it starts to bite me. I'm sure overlapping two 
rules by 20 mhz couldn't possibly confuse things...

If I have no choice but to write funny rules then so be it, but at least 
if I could understand how this is interpreted?

        (2402 - 2472 @ 40), (3, 20)
        (2457 - 2482 @ 20), (3, 20), PASSIVE-SCAN, NO-IBSS


What rules are applied if I set channel 11 in 10 Mhz mode? Considering 
support for using 10 mhz channels is being worked on I'm just kinda 
curious.  I'm also not 100% sure on the rules but since the way 
wireless-regdb/crda currently enforces things will allow you to set 
20mhz channels in a 40mhz rule I'm also going to assume that it will 
allow 10 and 5 mhz channels to be set too (@40 appears to mean "40 or 
less" as far as I understand it).

thanks,
Rick
