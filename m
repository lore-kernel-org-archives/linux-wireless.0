Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:62049 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750725Ab1ECPS1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 3 May 2011 11:18:27 -0400
Received: by wya21 with SMTP id 21so143207wya.19
        for <linux-wireless@vger.kernel.org>; Tue, 03 May 2011 08:18:26 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1304432929.3720.4.camel@jlt3.sipsolutions.net>
References: <570950.1322951304422032629.JavaMail.defaultUser@defaultHost>
	<BANLkTim3-ve4BD6wghA=F-asEqJmcDip6Q@mail.gmail.com>
	<7DDF37406E10F0438561DBB78326DF3902F35339F2@SC-VEXCH1.marvell.com>
	<1304432929.3720.4.camel@jlt3.sipsolutions.net>
Date: Tue, 3 May 2011 20:48:26 +0530
Message-ID: <BANLkTinZp_EW=Jfyv_S4g9kqqd8atVb8Eg@mail.gmail.com> (sfid-20110503_171830_710787_28803950)
Subject: Re: WARNING: at net/mac80211/wep.c:101 ieee80211_wep_add_iv+0x52/0x150
 [mac80211]()
From: Mohammed Shafi <shafi.wireless@gmail.com>
To: Johannes Berg <johannes@sipsolutions.net>,
	Yogesh Powar <yogeshp@marvell.com>
Cc: "rossi.f@inwind.it" <rossi.f@inwind.it>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, May 3, 2011 at 7:58 PM, Johannes Berg <johannes@sipsolutions.net> wrote:
> On Tue, 2011-05-03 at 07:25 -0700, Yogesh Powar wrote:
>> >so may will this help? I don't know whether its a correct and with a
>> >quick test the warning gets fixed.
>> That should solve our problem with following explanation.
>>
>> The devices that require IV generation in software need tailroom reservation
>> for ICVs used in TKIP or WEP encryptions.
>>
>> Currently, decision to skip the tailroom reservation in the tx
>> path was taken only on whether driver wants MMIC to be generated
>> in software or not. Following patch appends IV generation check for such
>> decisions.
>>
>> diff --git a/net/mac80211/key.c b/net/mac80211/key.c
>> index ca3c626..f3c4deb 100644
>> --- a/net/mac80211/key.c
>> +++ b/net/mac80211/key.c
>> @@ -102,7 +102,9 @@ static int ieee80211_key_enable_hw_accel(struct ieee80211_key *key)
>>       if (!ret) {
>>               key->flags |= KEY_FLAG_UPLOADED_TO_HARDWARE;
>>
>> -             if (!(key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_MMIC))
>> +             if (!((key->conf.flags & IEEE80211_KEY_FLAG_GENERATE_MMIC) ||
>> +                             (key->conf.flags &
>> +                                     IEEE80211_KEY_FLAG_GENERATE_IV)))
>>                       key->local->crypto_tx_tailroom_needed_cnt--;
>
> Can we have a bit nicer code style? :)
>
> Also, need to submit a proper patch with S-o-b etc, and reported-by
> rossi.

Can please send the patch, with some more testing.


>
> johannes
>
>
