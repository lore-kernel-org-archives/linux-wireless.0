Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 30.mail-out.ovh.net ([213.186.62.213]:39999 "HELO
	30.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752849Ab0AINzw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 9 Jan 2010 08:55:52 -0500
Message-ID: <4B488AE2.70006@free.fr>
Date: Sat, 09 Jan 2010 14:55:46 +0100
From: Benoit PAPILLAULT <benoit.papillault@free.fr>
MIME-Version: 1.0
To: Jouni Malinen <j@w1.fi>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	linville@tuxdriver.com, johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/4] cfg80211: fix 2 GHz subband calculation for country
 IEs
References: <1262903097-2129-1-git-send-email-lrodriguez@atheros.com> <1262903097-2129-3-git-send-email-lrodriguez@atheros.com> <20100108131451.GA18758@jm.kir.nu> <43e72e891001081341j1c24b7c4i6f5bb636d8ccc81b@mail.gmail.com> <20100108232009.GA4840@jm.kir.nu> <43e72e891001081628s47474cadl5473432411162f0f@mail.gmail.com> <20100109084521.GA6190@jm.kir.nu>
In-Reply-To: <20100109084521.GA6190@jm.kir.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jouni Malinen a écrit :
> On Fri, Jan 08, 2010 at 04:28:17PM -0800, Luis R. Rodriguez wrote:
>
>   
>> Heh alright, I'll change this to match the rx'd band first but that
>> change is a bit big for stable so we'll have to deal with how we have
>> it now for stable. I'll submit the changes for wireless-testing. Now
>> last question -- although I haven't seen APs send country IEs for two
>> bands in case we do, how do you want to treat those channels?
>>     
>
> What exactly do you mean with sending two bands? By using the Regulatory
> Extension Identifier? I didn't think we support it.. In general, I would
> not bother doing anything special until someone can show that such an AP
> exist.
>
>   
>> Does hostapd send just one band or two bands on the country IE?
>>     
>
> Only one; it does not support Regulatory Extension Identifier and I
> don't really see any point in advertising more than the current band.
>
>   
I was going to say the same as Jouni : channel number cannot be used to 
determine the frequency band (2.4GHz versus 5GHz). Channel 1 exists both 
in 2.4GHz and 5GHz. For 5GHz, I think the 802.11 specs mentions a 
"Channel starting frequency is defined as dot11ChannelStartingFactor × 
500 kHz or is defined as 5 GHz for systems where 
dot11RegulatoryClassesRequired is false or not defined." (17.3.8.3.2). 
This is based on the RegulatoryClass as defined in Annex J which is 
transmitted in Country IE as Regulatory Extension Identifier.

There are AP that are operating on both bands (either single radio or 
dual radio). We could imagine a scenario where the AP sends a Channel 
Switch Announcement IE asking to switch from a 2.4GHz channel to a 5GHz 
channel. At this point, the STA should be aware of regulatory 
restrictions that may exist in the 5GHz band. In this case, the STA must 
wait for a beacon to show up in the 5GHz band (see 11.1.3.3 Initializing 
a BSS) and we are on the safe side by assuming that it applies on the 
same band.

Regards,
Benoit


