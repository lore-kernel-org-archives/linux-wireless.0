Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yw0-f46.google.com ([209.85.213.46]:64099 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752667Ab1LOIoR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 15 Dec 2011 03:44:17 -0500
Received: by yhr47 with SMTP id 47so2022022yhr.19
        for <linux-wireless@vger.kernel.org>; Thu, 15 Dec 2011 00:44:16 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1323937198.3337.0.camel@jlt3.sipsolutions.net>
References: <1323871851-4808-1-git-send-email-helmut.schaa@googlemail.com>
	<1323936138-11357-1-git-send-email-helmut.schaa@googlemail.com>
	<1323937198.3337.0.camel@jlt3.sipsolutions.net>
Date: Thu, 15 Dec 2011 09:44:16 +0100
Message-ID: <CAGXE3d-MzD+FUCC00=A1EsUakDXGtA5F5OULqP1HvsoD53Spzg@mail.gmail.com> (sfid-20111215_094420_622037_8ABBFB40)
Subject: Re: [PATCHv2] mac80211: Use appropriate TID for sending BAR, ADDBA
 and DELBA frames
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	adrian@freebsd.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 15, 2011 at 9:19 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Thu, 2011-12-15 at 09:02 +0100, Helmut Schaa wrote:
>
>> Changes in v2: Make ieee80211_tx_skb an inline function.
>
>> +++ b/net/mac80211/tx.c
>
>> @@ -2719,3 +2718,10 @@ void ieee80211_tx_skb(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb)
>>       ieee80211_xmit(sdata, skb);
>>       local_bh_enable();
>>  }
>> +
>> +void inline ieee80211_tx_skb(struct ieee80211_sub_if_data *sdata, struct sk_buff *skb)
>> +{
>> +     /* Send all internal mgmt frames on VO. Accordingly set TID to 7. */
>> +     ieee80211_tx_skb_tid(sdata, skb, 7);
>> +}
>
> Err, well, you should define inlines in a header file ... This inline
> statement probably made no difference at all, except for potentially
> causing a prototype mismatch compiler warning :)

Ehm, too early in the morning I guess :)
