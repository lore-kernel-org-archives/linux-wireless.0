Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:38473 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754929Ab1ENWHs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 14 May 2011 18:07:48 -0400
Received: by qwk3 with SMTP id 3so1752554qwk.19
        for <linux-wireless@vger.kernel.org>; Sat, 14 May 2011 15:07:47 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1305133583.17892.3.camel@jlt3.sipsolutions.net>
References: <BANLkTikBEs7aWZR+UovtpwYVPJfZjHEhgw@mail.gmail.com> <1305133583.17892.3.camel@jlt3.sipsolutions.net>
From: Matteo Croce <matteo@openwrt.org>
Date: Sun, 15 May 2011 00:07:07 +0200
Message-ID: <BANLkTinp0Hy3yhfxAEAX9jeKSaYRMddDew@mail.gmail.com> (sfid-20110515_000756_667204_2A2AB8E6)
Subject: Re: [PATCH v2] 802.11n frame injection
To: Johannes Berg <johannes@sipsolutions.net>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2011/5/11 Johannes Berg <johannes@sipsolutions.net>:
> On Fri, 2011-04-22 at 18:34 +0200, Matteo Croce wrote:
>
>> --- a/net/mac80211/status.c   2011-04-22 11:34:08.833135198 +0200
>> +++ b/net/mac80211/status.c   2011-04-22 11:34:54.037135187 +0200
>> @@ -405,6 +405,19 @@
>>           !(info->status.rates[0].flags & IEEE80211_TX_RC_MCS))
>>               rthdr->rate = sband->bitrates[
>>                               info->status.rates[0].idx].bitrate / 5;
>> +     /* HT rates */
>> +     if (info->status.rates[0].flags & IEEE80211_TX_RC_MCS) {
>> +             rthdr->hdr.it_present |= cpu_to_le32(1 << IEEE80211_RADIOTAP_MCS);
>> +             rthdr->rate = 0;
>> +             rthdr->ht_known =       IEEE80211_RADIOTAP_MCS_HAVE_BW |
>> +                                     IEEE80211_RADIOTAP_MCS_HAVE_MCS |
>> +                                     IEEE80211_RADIOTAP_MCS_HAVE_GI;
>> +             rthdr->ht_mcs = info->status.rates[0].idx;
>> +             if (info->status.rates[0].flags & IEEE80211_TX_RC_40_MHZ_WIDTH)
>> +                     rthdr->ht_flag |= IEEE80211_RADIOTAP_MCS_BW_40;
>> +             if (info->status.rates[0].flags & IEEE80211_TX_RC_SHORT_GI)
>> +                     rthdr->ht_flag |= IEEE80211_RADIOTAP_MCS_SGI;
>> +     }
>
> I think you should also split the patch -- this part isn't really only
> injection.
>
> johannes
>
>

After injecting a frame I have a TX feedback, why shouldn't it have
correct MCS informations?

-- 
Matteo Croce
OpenWrt Developer
 _______                     ________        __
|       |.-----.-----.-----.|  |  |  |.----.|  |_
|   -   ||  _  |  -__|     ||  |  |  ||   _||   _|
|_______||   __|_____|__|__||________||__|  |____|
         |__| W I R E L E S S   F R E E D O M
ATTITUDE ADJUSTMENT (bleeding edge) --------------
 * 1/4 oz Vodka      Pour all ingredents into mixing
 * 1/4 oz Gin        tin with ice, strain into glass.
 * 1/4 oz Amaretto
 * 1/4 oz Triple sec
 * 1/4 oz Peach schnapps
 * 1/4 oz Sour mix
 * 1 splash Cranberry juice
-----------------------------------------------------
