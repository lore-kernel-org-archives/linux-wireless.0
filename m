Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ey-out-2122.google.com ([74.125.78.26]:57815 "EHLO
	ey-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751646AbZBIQMX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Feb 2009 11:12:23 -0500
Received: by ey-out-2122.google.com with SMTP id 25so521031eya.37
        for <linux-wireless@vger.kernel.org>; Mon, 09 Feb 2009 08:12:21 -0800 (PST)
Message-ID: <499055E5.6070701@gmail.com> (sfid-20090209_171228_088959_A086B432)
Date: Mon, 09 Feb 2009 11:12:21 -0500
From: Richard Farina <sidhayn@gmail.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: "Luis R. Rodriguez" <lrodriguez@atheros.com>,
	Jouni.Malinen@atheros.com, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v6] mac80211: do not TX injected frames when not allowed
References: <1233335309-28099-1-git-send-email-lrodriguez@atheros.com> <1233347900.4070.4.camel@johannes.local>
In-Reply-To: <1233347900.4070.4.camel@johannes.local>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Johannes Berg wrote:
> On Fri, 2009-01-30 at 09:08 -0800, Luis R. Rodriguez wrote:
>   
>> Monitor mode is able to TX by using injected frames. We should
>> not allow injected frames to be sent unless allowed by regulatory
>> rules. Since AP mode uses a monitor interfaces to transmit
>> management frames we have to take care to not break AP mode as
>> well while resolving this. We can deal with this by allowing compliant
>> APs solutions to inform mac80211 if their monitor interface is
>> intended to be used for an AP by setting a cfg80211 flag for the
>> monitor interface. hostapd, for example, currently does its own
>> checks to ensure AP mode is not used on channels which require radar
>> detection. Once such solutions are available it can can add this
>> flag for monitor interfaces.
>>
>> Acked-by: Johannes Berg <johannes@sipsolutions.net>
>> Signed-off-by: Luis R. Rodriguez <lrodriguez@atheros.com>
>>     
Tested-by: Rick Farina <sidhayn@gmail.com>
Nacked-by: Rick Farina <sidhayn@gmail.com>

Luis, when I requested this from you and you cranked out a patch in 30 
seconds what you gave me worked great, unfortunately this patch doesn't 
perform the intended function for me.  If I use this patch and mark, 
say, everything as "PASSIVE-SCAN NO-IBSS" I can still send raw packets 
out of my interface (confirmed by capturing on another card). The 
original patch is as follows:

+       if ((tx->channel->flags & (IEEE80211_CHAN_NO_IBSS |
+           IEEE80211_CHAN_RADAR)))
+               return TX_DROP;

TX_DROP seemed to successfully prevent raw packet transmission on the 
channels marked NO_IBSS.  Can someone please confirm my findings so we 
can get this fixed properly?

Thanks,
Rick Farina

>> ---
>>
>> This v6 leaves the AP flag out and removes the unused sdata..
>>     
>
> Yeah, let's go with this until hostapd is fixed anyway.
>
> johannes
>   

