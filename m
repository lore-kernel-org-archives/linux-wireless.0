Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52802 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752588Ab2BWSpA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Feb 2012 13:45:00 -0500
Received: by iacb35 with SMTP id b35so1891105iac.19
        for <linux-wireless@vger.kernel.org>; Thu, 23 Feb 2012 10:45:00 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1330004589.3448.12.camel@jlt3.sipsolutions.net>
References: <loom.20120221T000341-610@post.gmane.org>
	<1330004589.3448.12.camel@jlt3.sipsolutions.net>
Date: Thu, 23 Feb 2012 10:45:00 -0800
Message-ID: <CA+yqC4be_Zn48LyRMLCX5bDJt3+Ls5+y4hwb1WZ9gK=9Yd++ZA@mail.gmail.com> (sfid-20120223_194512_681650_F1AD3910)
Subject: Re: [PATCH] mac80211 radiotap injection
From: Sam Leffler <sleffler@google.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Lars Bro <larsbro@gmail.com>, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 23, 2012 at 5:43 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Mon, 2012-02-20 at 23:17 +0000, Lars Bro wrote:
>> Building on the work of Sam Leffler, adding the possibility of setting
>> the tx-power also.
>
> Please read
> http://wireless.kernel.org/en/developers/Documentation/SubmittingPatches, particularly the references at the bottom of the page.
>
> Please also follow the style of the surrounding code.

I tried (for my stuff); it's helpful if you can point out at least one
specific issue.  The code went through checkpatch for example.

>
>> diff --git a/Documentation/networking/mac80211-injection.txt
>> b/Documentation/networking/mac80211-injection.txt
>> index 3a93007..cd3d3ef 100644
>> --- a/Documentation/networking/mac80211-injection.txt
>> +++ b/Documentation/networking/mac80211-injection.txt
>> @@ -23,11 +23,28 @@ radiotap headers and used to control injection:
>>     IEEE80211_RADIOTAP_F_FRAG: frame will be fragmented if longer than the
>>                             current fragmentation threshold.
>>
>> + * IEEE80211_RADIOTAP_RATE
>> +   legacy transmit rate in .5 Mb/s units (u8)
>
> This looks quite strange, for example.

Strange how?  The .5 units are consistent w/ IEEE legacy rate codes.
Not sure how you want to express values like 5.5 to the kernel.

>
>> diff --git a/include/net/mac80211.h b/include/net/mac80211.h
>> index cbff4f9..2821b87 100644
>> --- a/include/net/mac80211.h
>> +++ b/include/net/mac80211.h
>> @@ -378,6 +378,9 @@ struct ieee80211_bss_conf {
>>   * @IEEE80211_TX_CTL_DONTFRAG: Don't fragment this packet even if it
>>   *   would be fragmented by size (this is optional, only used for
>>   *   monitor injection).
>> + * @IEEE80211_TX_CTL_NO_RC: This frame does not require rate control.
>> + *   This flag is used when an injected frame includes a transmit
>> + *   rate (and possibly flags and retry count) in the radiotap header.
>
> Does that really have to be here? This is the last bit we have, and it
> seems this is internal so ... ?

So ... what?  I saw it was the last bit didn't see another way to tag
state in the skb (and the cb looked to be max size so there was no
room to expand it).

>
>>  #define IEEE80211_TX_CTL_STBC_SHIFT          23
>> @@ -555,6 +559,7 @@ struct ieee80211_tx_info {
>>                       struct ieee80211_vif *vif;
>>                       struct ieee80211_key_conf *hw_key;
>>                       struct ieee80211_sta *sta;
>> +                     u8 tx_power;
>
> That's not going to be honoured by a lot of devices.
>
>>
>>       /* process and remove the injection radiotap header */
>> -     if (!ieee80211_parse_tx_radiotap(skb))
>> +     if (!ieee80211_parse_tx_radiotap(skb, local))
>
> that's a very unusual argument order for the mac80211 code
>
> I promise to actually look at the code when you fix all the surrounding
> issues, right now I'm quite busy though so not very keen on looking
> through this.
>
> johannes
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
