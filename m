Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f41.google.com ([209.85.219.41]:62221 "EHLO
	mail-oa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757209AbaCTJj5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Mar 2014 05:39:57 -0400
Received: by mail-oa0-f41.google.com with SMTP id j17so616882oag.0
        for <linux-wireless@vger.kernel.org>; Thu, 20 Mar 2014 02:39:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1395238934.4142.22.camel@jlt4.sipsolutions.net>
References: <1393327628-1078-1-git-send-email-michal.kazior@tieto.com>
	<1393330040.4170.0.camel@jlt4.sipsolutions.net>
	<1393330210.4170.1.camel@jlt4.sipsolutions.net>
	<CA+BoTQnvSxOCxV4UwUmi2_if8NQWWJCht=urAewBZAiEJdHpZA@mail.gmail.com>
	<1395238934.4142.22.camel@jlt4.sipsolutions.net>
Date: Thu, 20 Mar 2014 10:39:57 +0100
Message-ID: <CA+BoTQm_w4qk98pYbJ4Fz5NL-zTq7eCkAepOYGtd=LGVCLTU9A@mail.gmail.com> (sfid-20140320_104009_747359_960EB737)
Subject: Re: [PATCH] mac80211: don't downgrade VHT20 to HT20
From: Michal Kazior <michal.kazior@tieto.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 19 March 2014 15:22, Johannes Berg <johannes@sipsolutions.net> wrote:
> Sorry for the delay. Somehow I thought this was addressed, but I'm
> confused.
>
> I think we all agree that the spec says:
>
>> > A VHT STA shall set the Supported Channel Width Set subfield in its HT
>> > Capabilities element HT Capabilities Info field to 1, indicating that
>> > both 20 MHz operation and 40 MHz operation are supported.
>
> and that the station should therefore set the 20_40 capability bit in
> the association response?

Correct.


>> The spec also defines VHT BSS operating channel width is derived from
>> HT Operation Element: STA Channel Width field (Table 10-19) and 20 MHz
>> is not forbidden for AP/mesh. hostapd seems to go in line with this
>> and allows VHT20 and VHT40.
>
> Yes but how is that related to the *capability* bit? You're talking
> about the HT/VHT operation information.

Good point.

Hostapd sets *both* HT Capability and HT Information IEs to "only
20Mhz" for VHT20. I can see Cisco EA6500 do the same thing too.


>> Without my patch (i.e. with the 20/40 check left intact):
>>
>> * If a station connects to VHT20 BSS, hostapd tries to add a VHT20
>> station, but mac80211 downgrades it to HT20,
>> * If mac80211 station connects to a VHT20 BSS it gets downgraded to HT20 too.
>>
>> This means mac80211 is unable to setup VHT20 pairing properly even
>> though VHT20 BSS is defined in the spec.
>>
>> My take is 10.39.1 means VHT STA AssocReq must contain
>> IEEE80211_HT_CAP_SUP_WIDTH_20_40.
>> I suppose AP (hostapd) should deny STA association in that case.
>
> So are you saying the station isn't setting 20_40 capability? Or is
> something else unsetting the bit in case it's a 20MHz network?

In case of AP mode you get ht_capa/vht_capa from userspace (i.e.
hostapd). This would again imply hostapd does it wrong or is it
perhaps the interface describing HT/VHT state is insufficient? Should
mac80211 treat HT Capab and HT Info separately? Should they be passed
and processed separately?


Michał
