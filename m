Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 64.mail-out.ovh.net ([91.121.185.65]:47429 "HELO
	64.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933294Ab0BPUej (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 16 Feb 2010 15:34:39 -0500
Message-ID: <4B7B0159.7030408@free.fr>
Date: Tue, 16 Feb 2010 21:34:33 +0100
From: Benoit PAPILLAULT <benoit.papillault@free.fr>
MIME-Version: 1.0
To: Jouni Malinen <j@w1.fi>
CC: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/2] mac80211: Ignore replay for IBSS interfaces
References: <1266190346-2247-1-git-send-email-benoit.papillault@free.fr> <1266225762.3758.1.camel@jlt3.sipsolutions.net> <4B79CD81.3090300@free.fr> <20100216074602.GA19876@jm.kir.nu>
In-Reply-To: <20100216074602.GA19876@jm.kir.nu>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Jouni Malinen a écrit :
> On Mon, Feb 15, 2010 at 11:41:05PM +0100, Benoit PAPILLAULT wrote:
>   
>> Right. This patch disable replay protection. RSN is indeed the
>> correct solution, but it's out of reach for me (no time, no skills).
>> As such, I thought that WPA-NONE could be useful in the interim.
>>     
>
> I do not think it is acceptable to introduce anything that disables
> replay protection.
>   
I know but WPA-NONE is what is implemented in some commercial products...
>   
>> Jouni : I would appreciate your input here. What's the status of
>> IBSS RSN? How much time/skills would be required to implement it?
>>     
>
> The key management side (4-way handshakes) should all be in place now
> and the main missing part is in being able to configure all the GTKs
> (one per peer) and use the GTKs properly (i.e., match the key per addr2
> when addr1 is broadcast/multicast). A good initial step would be to
> hardcode mac80211 to use software encryption and extend that to support
> multiple GTKs. Once that is working, we can see whether some of the
> drivers would be able to do CCMP in hardware for such key configuration.
>
>   
Ah. That's very good news! So wpa_supplicant is already OK and the only 
changes needed is in mac80211 then? and it's related to the GTK use? 
Could you point to me to a sample wpa_supplicant configuration file so I 
can try that out.

Thanks for the information.

Regards,
Benoit

