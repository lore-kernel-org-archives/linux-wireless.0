Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f170.google.com ([209.85.212.170]:33032 "EHLO
	mail-wi0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753244AbbGIMm3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Jul 2015 08:42:29 -0400
Received: by wiwl6 with SMTP id l6so17578291wiw.0
        for <linux-wireless@vger.kernel.org>; Thu, 09 Jul 2015 05:42:28 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20150707150040.GA1374@w1.fi>
References: <CA+BoTQm==AM3F2Fxq6T_+uY+jq0yXc9JHFT0iwpe2XJrmxkSsg@mail.gmail.com>
	<20150707150040.GA1374@w1.fi>
Date: Thu, 9 Jul 2015 14:42:28 +0200
Message-ID: <CA+BoTQnA4bkx33-cEZGJEbCyGBx=xS7Cy_6iY3JkrGsA8ds_Kg@mail.gmail.com> (sfid-20150709_144249_905085_C31F5916)
Subject: Re: Association race when acting as AP?
From: Michal Kazior <michal.kazior@tieto.com>
To: Michal Kazior <michal.kazior@tieto.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"hostap@lists.shmoo.com" <hostap@lists.shmoo.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 7 July 2015 at 17:00, Jouni Malinen <j@w1.fi> wrote:
> On Thu, Jul 02, 2015 at 10:24:33AM +0200, Michal Kazior wrote:
>> After looking into hostapd code I noticed something strange and I wonder if
>> anyone else is already aware of this problem:
>>
>>  1. AP starts
>>  2. STA->AP auth OTA
>>  3. AP->STA auth OTA
>>  4. STA->AP assoc req OTA
>>  5. AP->STA assoc resp OTA
>>  6. STA sends NullFunc with "STA will go to sleep" bit set
>>  7. AP driver/device sees a frame from with unknown TA/SA and issues Deauth
>> w/ Reason 7
>>    (this Deauth doesn't originate from hostapd; it comes from the device FW
>> in my case)
>
> If there is a driver or firmware design that sends these
> Deauthentication frames on their own, they better be able to handle race
> conditions and enable this functionality at the correct time..

At least one ath10k qca61x4 firmware seems to send Deauth when it gets
a NullFunc from DA which doesn't have an internal peer entry. It
doesn't seem to care whether peer is authenticated or associated
though. Probably having none->auth, auth->assoc state transitions
(instead of a single none->assoc) would be enough - at least for
ath10k today.


> Sure,
> cfg80211 and hostapd may need modifications to make this work better,
> but this needs to be done for things to work properly. There's a good
> reason for hostapd having code to check the internal STA associated
> flag before triggering deauthentication based on EVENT_RX_FROM_UNKNOWN
> events..
>
>> To me this looks like a race in hostapd. The station should be installed to
>> driver _before_ sending Assoc Resp frame, not after. My quick-n-dirty hack
>> seems to help:
>
> Adding a STA entry before sending Association Response frame would be
> fine, but this change would do more: it would claim that STA entry to be
> in associated state. That is not correct from the IEEE 802.11 standard
> view point. On the AP side, a STA becomes associated when an ACK frame
> to the (Re)Association Response frame is received by the AP.

This seems pretty racy inherently. Driver/firmware actually needs to
be aware of this requirement and make sure to avoid reordering Tx ACK
processing and Rx. Since Tx/Rx engines are often (if not always?)
independent of each other I imagine this could be a common problem
across many devices today but perhaps not easily observable due to
narrow time window this could happen in.

Anyway - thank you for your great insight!


Michał
