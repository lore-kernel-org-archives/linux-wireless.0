Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f210.google.com ([209.85.219.210]:60833 "EHLO
	mail-ew0-f210.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989AbZFSRUv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Jun 2009 13:20:51 -0400
Received: by ewy6 with SMTP id 6so2741869ewy.37
        for <linux-wireless@vger.kernel.org>; Fri, 19 Jun 2009 10:20:53 -0700 (PDT)
Message-ID: <4A3BC8EC.6040801@gmail.com>
Date: Fri, 19 Jun 2009 18:20:44 +0100
From: Dave <kilroyd@googlemail.com>
MIME-Version: 1.0
To: Julian Calaby <julian.calaby@gmail.com>
CC: linux-wireless@vger.kernel.org, orinoco-devel@lists.sourceforge.net
Subject: Re: [PATCH 02/23] cfg80211: Advertise ciphers via WE according to
 driver capability
References: <1245363695-8289-1-git-send-email-kilroyd@googlemail.com> 	<1245363695-8289-3-git-send-email-kilroyd@googlemail.com> <646765f40906181638j39d8e8eex8ead9d856b5f2548@mail.gmail.com>
In-Reply-To: <646765f40906181638j39d8e8eex8ead9d856b5f2548@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Julian Calaby wrote:
> On Fri, Jun 19, 2009 at 08:21, David Kilroy<kilroyd@googlemail.com> wrote:
>> Signed-off-by: David Kilroy <kilroyd@googlemail.com>
>> Acked-by: Johannes Berg <johannes@sipsolutions.net>
>> ---
>>  net/wireless/wext-compat.c |   15 +++++++++++++--
>>  1 files changed, 13 insertions(+), 2 deletions(-)
>>
>> diff --git a/net/wireless/wext-compat.c b/net/wireless/wext-compat.c
>> index 9e56f35..7dbe6c6 100644
>> --- a/net/wireless/wext-compat.c
>> +++ b/net/wireless/wext-compat.c
>> @@ -204,8 +204,19 @@ int cfg80211_wext_giwrange(struct net_device *dev,
>>        range->avg_qual.noise = range->max_qual.noise / 2;
>>        range->avg_qual.updated = range->max_qual.updated;
>>
>> -       range->enc_capa = IW_ENC_CAPA_WPA | IW_ENC_CAPA_WPA2 |
>> -                         IW_ENC_CAPA_CIPHER_TKIP | IW_ENC_CAPA_CIPHER_CCMP;
>> +       range->enc_capa = IW_ENC_CAPA_WPA | IW_ENC_CAPA_WPA2;
> 
> Should this should go into the for loop too, like how patch 5 works?

Err... patch 5 moves this line into the for loop. I moved these in
separate patches because:

* Indicating available ciphers based on cipher capability is obviously
correct.
* Indicating WPA/WPA2 based on cipher capability is not obviously
correct - and we might want the drivers to indicate this explicitly.
* The latter patch can be NACK'd without affecting the former, or the
rest of the series (well, apart from patch 22).

As it happens, no-one has objected (yet).

Apologies if I've completely misunderstood you.


Thanks,

Dave.
