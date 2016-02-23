Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:35509 "EHLO
	mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752204AbcBWK3J (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 23 Feb 2016 05:29:09 -0500
Received: by mail-wm0-f65.google.com with SMTP id g62so21136612wme.2
        for <linux-wireless@vger.kernel.org>; Tue, 23 Feb 2016 02:29:08 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1456222250.2041.8.camel@sipsolutions.net>
References: <1455878585-5525-1-git-send-email-lorenzo.bianconi83@gmail.com>
	<1455878585-5525-3-git-send-email-lorenzo.bianconi83@gmail.com>
	<1456222250.2041.8.camel@sipsolutions.net>
Date: Tue, 23 Feb 2016 11:29:07 +0100
Message-ID: <CAA2SeNLB+oL00Mx1BCccA4eOx6nghLUofruPSepW70VWRS8EQQ@mail.gmail.com> (sfid-20160223_112947_445866_7D163393)
Subject: Re: [PATCH v2 2/2] mac80211: parse VHT info in injected frames
From: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I used the previous commit scheme (mac80211: Parse legacy and HT rate
in injected frames).
I will rewrite the documentation. Should I send v3 or a different patch?

Regards,
Lorenzo

On Tue, Feb 23, 2016 at 11:10 AM, Johannes Berg
<johannes@sipsolutions.net> wrote:
> On Fri, 2016-02-19 at 11:43 +0100, Lorenzo Bianconi wrote:
>> Add VHT radiotap parsing support to ieee80211_parse_tx_radiotap().
>> That capability has been tested using a d-link dir-860l rev b1
>> running
>> OpenWrt trunk and mt76 driver
>>
>> Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi83@gmail.com>
>> ---
>>  Documentation/networking/mac80211-injection.txt | 10 ++++++++
>>  net/mac80211/tx.c                               | 31
>> +++++++++++++++++++++++++
>>  2 files changed, 41 insertions(+)
>>
>> diff --git a/Documentation/networking/mac80211-injection.txt
>> b/Documentation/networking/mac80211-injection.txt
>> index ec8f934..ef57cc0 100644
>> --- a/Documentation/networking/mac80211-injection.txt
>> +++ b/Documentation/networking/mac80211-injection.txt
>> @@ -45,6 +45,16 @@ radiotap headers and used to control injection:
>>     number of retries when either IEEE80211_RADIOTAP_RATE or
>>     IEEE80211_RADIOTAP_MCS was used
>>
>> + * IEEE80211_RADIOTAP_VHT
>> +
>> +   VHT rate for the transmission (only for devices without own rate
>> control).
>> +   Also some flags are parsed
>> +
>> +   IEEE80211_TX_RC_SHORT_GI: use short guard interval
>> +   IEEE80211_TX_RC_40_MHZ_WIDTH: send in HT40 mode
>> +   IEEE80211_TX_RC_80_MHZ_WIDTH: send in HT80 mode
>> +   IEEE80211_TX_RC_160_MHZ_WIDTH: send in HT160 mode
>>
> This makes no sense, those are mac80211 internal flags, should document
> the radiotap flags here, not what they map to internally.
>
> johannes



-- 
UNIX is Sexy: who | grep -i blonde | talk; cd ~; wine; talk; touch;
unzip; touch; strip; gasp; finger; gasp; mount; fsck; more; yes; gasp;
umount; make clean; sleep
