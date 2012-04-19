Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35223 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751865Ab2DSN2I (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Apr 2012 09:28:08 -0400
Message-ID: <4F9012E9.1040409@sipsolutions.net> (sfid-20120419_152813_869196_D0613C64)
Date: Thu, 19 Apr 2012 06:28:09 -0700
From: Johannes Berg <johannes@sipsolutions.net>
MIME-Version: 1.0
To: Andrei Emeltchenko <Andrei.Emeltchenko.news@gmail.com>,
	Marcel Holtmann <marcel@holtmann.org>,
	linux-bluetooth@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: [RFCv1] mac80211: Adds Software / Virtual AMP 80211
References: <4F846257.1060807@sipsolutions.net> <1334092668.16897.54.camel@aeonflux> <4F84A422.3030900@sipsolutions.net> <4F84A52A.7050905@sipsolutions.net> <20120411071119.GC17779@aemeltch-MOBL1> <1334714611.3725.34.camel@jlt3.sipsolutions.net> <20120418121551.GE19228@aemeltch-MOBL1> <4F8ED1D0.1070401@sipsolutions.net> <20120418145202.GH19228@aemeltch-MOBL1> <4F8ED913.4040807@sipsolutions.net> <20120419063558.GA16002@aemeltch-MOBL1>
In-Reply-To: <20120419063558.GA16002@aemeltch-MOBL1>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 4/18/2012 11:36 PM, Andrei Emeltchenko wrote:
>>>> No, this is incorrect. If one device wants to connect on one
>>>> channel, the other typically has to use the same channel. If one
>>>> device wants to scan, the other will be affected. Some hardware may
>>>> support switching around between two channels, but might also
>>>> support more than 2 virtual interfaces, so again they won't be
>>>> independent.
>>>
>>> BTW: which devices can switch channels?
>>
>> None today, I'm working on it.
>
> If this is not possible how people setup wireless hotspot using virtual
> interfaces and run wpa_supplicant and hostapd on each separately.
> Like here:
>
> http://linuxalfi.wordpress.com/2011/11/08/connectify-for-linux-with-single-wireless-interface/

Of course it's possible. Are you deliberately misunderstanding me?

You cannot use more than one channel today. We are changing that. To do 
good channel management, rather than hard-coding it in your config, you 
want to run a single wpa_s controlling all interfaces.

johannes
