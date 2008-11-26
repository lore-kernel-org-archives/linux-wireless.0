Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.168]:9456 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751668AbYKZDKJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 25 Nov 2008 22:10:09 -0500
Received: by ug-out-1314.google.com with SMTP id 39so1284684ugf.37
        for <linux-wireless@vger.kernel.org>; Tue, 25 Nov 2008 19:10:07 -0800 (PST)
Message-ID: <492CBE0F.1000500@gmail.com> (sfid-20081126_041015_173666_D68A0577)
Date: Tue, 25 Nov 2008 22:10:07 -0500
From: Richard Farina <sidhayn@gmail.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
CC: Pavel Roskin <proski@gnu.org>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>,
	John Linville <linville@tuxdriver.com>,
	wireless <linux-wireless@vger.kernel.org>,
	Michael Green <Michael.Green@Atheros.com>
Subject: Re: wireless-regdb: flaw in general functionality
References: <492B2B74.7040404@gmail.com> <20081124231204.GN6245@tesla> <1227568883.28878.15.camel@dv> <43e72e890811241526o1ea6ecf7ge05a2319d6ff3641@mail.gmail.com> <492B623E.5030202@gmail.com> <1227580299.32415.2.camel@dv> <20081126001942.GN5950@tesla> <1227659754.2556.11.camel@dv> <20081126010218.GP5950@tesla>
In-Reply-To: <20081126010218.GP5950@tesla>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez wrote:
> On Tue, Nov 25, 2008 at 04:35:54PM -0800, Pavel Roskin wrote:
>   
>> On Tue, 2008-11-25 at 16:19 -0800, Luis R. Rodriguez wrote:
>>
>>     
>>> This is documented here:
>>>
>>> http://wireless.kernel.org/en/developers/Regulatory#Changingthedatabasefileformat
>>>       
>> I mean, I don't know how painful it can be.  Perhaps it's better to
>> anticipate some requirements earlier than to change them later.
>>     
>
> Its painful to add anything new. To understand this better it helps to
> understand why some flags were added in the first place to regulatory rules.
> The short and sweet answer is DFS. And the general rule of thumb goes like this:
>
> When in a DFS freq, if you don't support DFS in your mode of operation,
> then you cannot TX.
>
> So if you don't support DFS in IBSS, you get NO-IBSS. If your AP doesn't
> support DFS then you can't use DFS channels. If you don't support DFS
> then you better not use active scanning on a STA, hence the passive scan
> flag (I guess this should be renamed to NO-ACTIVE-SCAN to be more
> consistent).
>
> The NO-HT20 is historical, we're not aware of countries disallowing
> this. No-HT40 is also a bit historical as it seems the countries which
> do not allow this will soon allow for it.
>
> The NO-OFDM and NO-CCK flag is unused and purely historical.
>
> So before adding a flag I think its *really* good to think about it
> thrice and see if there is a need of it, otherwise the answer should
> usually be that its not a good idea to add it.
>
> If anything we can consolidate flags or remove flags, that would be nicer
> if possible.
>
>   
>> I think
>> both "don't transmit" and "don't transmit unless permitted by the AP"
>> could be useful in some jurisdictions.
>>     
>
> Don't transmit is implicit, CRDA just "allows", so the flags we have now
> are all negative for special considerations on "allowing", such as NO
> IBSS, etc.
>
>   
This is simply not the case.  Implicit is don't tune the radio, this 
prevents both transmission and reception which needlessly limits useful 
features of a device for no regulatory reason.  This is why we are 
discussing it.

A flag of "no-transmit" is likely accurate in most regulatory domains 
and would allow driver developers to enable more advanced usage of the 
devices (if they choose).  I grant, most users really have no reason for 
this and that is an acceptable reason for someone to refuse to take the 
time to code it.  If someone is willing to take the time to add the 
flag, it should not be turned down as it is both accurate and proper to 
support receive only frequencies.

thanks,
Rick Farina
>   Luis
>
>   

