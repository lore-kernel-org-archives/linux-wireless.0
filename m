Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.233]:63494 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753286AbYLLWnz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Dec 2008 17:43:55 -0500
Received: by rv-out-0506.google.com with SMTP id k40so1582408rvb.1
        for <linux-wireless@vger.kernel.org>; Fri, 12 Dec 2008 14:43:54 -0800 (PST)
Message-ID: <69e28c910812121443h1fae52e6uc88749d7e9baf529@mail.gmail.com> (sfid-20081212_234359_636889_CF4487A0)
Date: Fri, 12 Dec 2008 23:43:54 +0100
From: "=?ISO-8859-1?Q?Stefanik_G=E1bor?=" <netrolller.3d@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: [RFC 2/3] mac80211: Make use of the new F_TX_NOACK and F_TX_NOSEQ Radiotap TX flags
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <1229121558.3565.6.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <69e28c910812121432n6e84de41s94a887110051a1dd@mail.gmail.com>
	 <1229121558.3565.6.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Dec 12, 2008 at 11:39 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Fri, 2008-12-12 at 23:32 +0100, Stefanik G=E1bor wrote:
>> Honor the 2 new flags in the "TX Flags" Radiotap field, introduced i=
n
>> the previous commit.
>>
>> Signed-off-by: G=E1bor Stefanik <netrolller.3d@gmail.com>
>>
>> ---
>>
>> Patch also available as an attachment in case Gmail decides to damag=
e it.
>>
>> diff --git a/net/mac80211/ieee80211_i.h b/net/mac80211/ieee80211_i.h
>> index 155a204..141099a 100644
>> --- a/net/mac80211/ieee80211_i.h
>> +++ b/net/mac80211/ieee80211_i.h
>> @@ -143,6 +143,8 @@ typedef unsigned __bitwise__ ieee80211_tx_result=
;
>>  #define IEEE80211_TX_FRAGMENTED              BIT(0)
>>  #define IEEE80211_TX_UNICAST         BIT(1)
>>  #define IEEE80211_TX_PS_BUFFERED     BIT(2)
>> +#define IEEE80211_TX_MON_NO_SEQ              BIT(3)
>> +#define IEEE80211_TX_MON_NO_ACK              BIT(4)
>
> You don't need that, you can directly modify info.
>
> johannes
>

I tried, but for some reason setting IEEE80211_TX_CTL_NO_ACK directly
in __ieee80211_parse_tx_radiotap resulted in an oops upon unloading
the driver module.

Note that IEEE80211_TX_MON_NO_ACK is not equivalent to
!(IEEE80211_TX_CTL_ASSIGN_SEQ), as it also disables mac80211's built
in sequence numbering.

--=20
Vista: [V]iruses, [I]ntruders, [S]pyware, [T]rojans and [A]dware. :-)
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
