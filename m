Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from 27.mail-out.ovh.net ([91.121.30.210]:46807 "HELO
	27.mail-out.ovh.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758625Ab0BXX4o (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 24 Feb 2010 18:56:44 -0500
Message-ID: <4B85BCB8.1000006@free.fr>
Date: Thu, 25 Feb 2010 00:56:40 +0100
From: Benoit PAPILLAULT <benoit.papillault@free.fr>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
CC: Bruno Randolf <br1@einfach.org>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: fix rates setup on IBSS merge
References: <20100223095113.25360.75291.stgit@void> <43e72e891002231128w45c357a6v157dc4f7ddf3bbae@mail.gmail.com>
In-Reply-To: <43e72e891002231128w45c357a6v157dc4f7ddf3bbae@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Luis R. Rodriguez a écrit :
> On Tue, Feb 23, 2010 at 1:51 AM, Bruno Randolf <br1@einfach.org> wrote:
>   
>> when an IBSS merge happened, the supported rates for the newly added station
>> were left empty, causing the rate control module to be initialized with only
>> the basic rates.
>>
>> also the section of the ibss code which deals with updating supported rates for
>> an already existing station fails to inform the rate control module about the
>> new rates. as i don't know how to fix this (minstrel does not have an update
>> function), i have just added a comment for now.
>>
>> Signed-off-by: Bruno Randolf <br1@einfach.org>
>>     
>
> This seems like a stable fix, if it applies can you please resend with a
>
> Cc: stable@kernel.org
>
> on the commit log entry right below your own SOB.
>
>   Luis
>   
Hi Bruno,

I think the root cause is that IBSS neighbor entries are added whenever 
we received any packet from a neighbor. However, the supported rates are 
only available in the beacon/probe responses. I think one fix is to only 
add IBSS neighbors on beacon/probe response reception (and moreover, 
beacon/probe responses contains the timestamp that is needed for IBSS 
merge).

Basically, I removed the call to ieee80211_ibss_add_sta in 
net/mac80211/rx.c.

Can you try that and tell me about the result?

In fact, I did this change to have HT rates in IBSS mode (but I'm still 
missing some stuff).

Regards,
Benoit
