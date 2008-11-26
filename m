Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.224]:29017 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776AbYKZOCn (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Nov 2008 09:02:43 -0500
Received: by rv-out-0506.google.com with SMTP id k40so480180rvb.1
        for <linux-wireless@vger.kernel.org>; Wed, 26 Nov 2008 06:02:42 -0800 (PST)
Message-ID: <dac45060811260602s3c552ed9o6878031096c30892@mail.gmail.com> (sfid-20081126_150247_771385_BA70627E)
Date: Wed, 26 Nov 2008 16:02:42 +0200
From: "Mark Ryden" <markryde@gmail.com>
To: "Johannes Berg" <johannes@sipsolutions.net>
Subject: Re: AP (Master Mode) of wireless drivers
Cc: "Vladimir Koutny" <vlado@work.ksp.sk>,
	"Pavel Roskin" <proski@gnu.org>, linux-wireless@vger.kernel.org
In-Reply-To: <1227707883.4613.105.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <dac45060811250735m6922688fn13c03ebe388d3137@mail.gmail.com>
	 <1227633414.15224.6.camel@dv> <492D0A26.9090801@work.ksp.sk>
	 <1227693793.4613.57.camel@johannes.berg>
	 <dac45060811260547w2c9d7a7dg839792f5c98011d1@mail.gmail.com>
	 <1227707883.4613.105.camel@johannes.berg>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

>> IEEE80211_TX_CTL_SEND_AFTER_DTIM appears only in rt2x00mac.c

>It's also in b43 and p54. I think your grep-fu is weak ;)

Sorry, my grep was indeed wrong. You are right.
Mark


On Wed, Nov 26, 2008 at 3:58 PM, Johannes Berg
<johannes@sipsolutions.net> wrote:
>
>> "For AP mode, it must
>> honour IEEE80211_TX_CTL_SEND_AFTER_DTIM or set
>>               IEEE80211_HW_HOST_BROADCAST_PS_BUFFERING and use the
>> ieee80211_get_buffered_bc() function"
>>
>> see:
>>  http://wireless.kernel.org/en/developers/Documentation/mac80211/API
>
> Yup.
>
>> However, I found out that in wireless-testing, this is the situation:
>>
>>
>> IEEE80211_TX_CTL_SEND_AFTER_DTIM appears only in rt2x00mac.c
>
> It's also in b43 and p54. I think your grep-fu is weak ;)
>
>> There is a call to ieee80211_get_buffered_bc() only in:
>> 1) drivers/net/wireless/ath9k/beacon.c
>> 2) wireless-testing/drivers/net/wireless/libertas_tf/main.c
>>
>> According to this , b43/b43legacy (Broadcom chips), Intel ipw2200,
>
> ipw2200 is a very special case, and it doesn't use mac80211 so that
> constant above won't occur in it anyway. Not sure if anybody has
> recently tried, I'd almost assume it's broken since the project hasn't
> been maintained forever, afaict.
>
> johannes
>
