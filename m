Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from p3plsmtpa01-03.prod.phx3.secureserver.net ([72.167.82.83]:53311
	"HELO p3plsmtpa01-03.prod.phx3.secureserver.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751032Ab1AROyV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Jan 2011 09:54:21 -0500
Message-ID: <1F9D19D1999A4D7885D0A4DD7BEBCEE8@ChuckPC>
From: "Chuck Crisler" <ccrisler@vgocom.com>
To: "Chuck Crisler" <ccrisler@vgocom.com>,
	"Johannes Berg" <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
References: <D323CFEF4DEC4E18AFF56742F78C16B6@ChuckPC> <1295347932.3563.13.camel@jlt3.sipsolutions.net> <BB274B92115347F9A8E250DEF0C2B732@ChuckPC>
In-Reply-To: <BB274B92115347F9A8E250DEF0C2B732@ChuckPC>
Subject: Re: intermittent eap authentication failure
Date: Tue, 18 Jan 2011 09:54:10 -0500
MIME-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="utf-8";
	reply-type=response
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I will have to reply later about why it is associating. I will have to add a 
printk to my driver but I currently have 2 tests running and don't want to 
stop either.
It looks like it might be called by ieee80211_sta_work() in mlme.c because 
it might still be in the IEEE80211_STA_MLME_ASSOCIATE state. I will confirm 
that.

Chuck
----- Original Message ----- 
From: "Chuck Crisler" <ccrisler@vgocom.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Cc: <linux-wireless@vger.kernel.org>
Sent: Tuesday, January 18, 2011 9:33 AM
Subject: Re: intermittent eap authentication failure


> It is the MAC80211 code. I am looking to find the exact code that 
> re-associates. We are running an old kernel (2.6.31.6) but can't update 
> right now.
>
> Our app is a mobile video conferencing system (a robot). It is imperative 
> that my connection to the network always be good. When you get  a session 
> timeout from the AP there isn't any reason to do a scan. The MAC driver 
> can send the association request and then notify the supplicant when it 
> receives the assosication response. The supplicant can then handle the 
> higher layer authentication. With the minor supplicant change that I 
> included earler this works with all authentication schemes. However, I 
> have removed the 2 lines that dealt with setting the EAP authentication to 
> NULL. I think that they were causing the EAP problems. The result is that 
> now I re-connect after a session timeout withint 0.75 seconds.
>
> Another problem that I found is that sometimes (not often) the Cisco WLC 
> was sending us a second deauthentication while we were still 
> 'disconnected'. The MAC driver dutifully sent that to the supplicant which 
> was busy trying to re-authenticate, again causing a mess. Now, I have 
> changed the MAC driver to drop that second deauth message if we aren't 
> connected. It works a lot better.
>
> The response that Daniel Halperin made to Larry Finger concerning the 
> reason code 4 (inactivity) isn't correct. That may be the intent but Cisco 
> sends that reason code more often. I have received it withint 3 seconds of 
> receiving an association response. Again, not often but it does happen. I 
> am currently working to understand why the Cisco WLC does this and have 
> extensive logging enabled on my WLC. Unfortuantely, all of the failures 
> are occurring after the WLC times out my putty session!
>
> More to come.
>
> ----- Original Message ----- 
> From: "Johannes Berg" <johannes@sipsolutions.net>
> To: "Chuck Crisler" <ccrisler@vgocom.com>
> Cc: <linux-wireless@vger.kernel.org>
> Sent: Tuesday, January 18, 2011 5:52 AM
> Subject: Re: intermittent eap authentication failure
>
>
>> Chuck,
>>
>>> Sometime ago I found a conflict between the supplicant and the MAC80211 
>>> code
>>> dealing with Cisco session timeouts. When we were 'deauthenticated', the 
>>> MAC
>>> code notified the supplicant AND re-associated with the AP.
>>
>> That doesn't seem right, mac80211 will never re-associate by itself.
>>
>>> We modified the driver so that if it received a
>>> de-auth with reason code 1 (undefined?), it would *NOT* notify the
>>> supplicant but would re-associate, then notify the supplicant of the new
>>> association.
>>
>> What's that driver you're talking about? A mac80211 driver that
>> reassociates by itself doesn't seem right at all.
>>
>> johannes
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" 
>> in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" 
> in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 

