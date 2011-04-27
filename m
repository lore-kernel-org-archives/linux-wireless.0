Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38277 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754846Ab1D0Iq7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 27 Apr 2011 04:46:59 -0400
Received: by iyb14 with SMTP id 14so1181992iyb.19
        for <linux-wireless@vger.kernel.org>; Wed, 27 Apr 2011 01:46:58 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1303884983.2336.46.camel@cumari>
References: <1303849642-9014-1-git-send-email-arik@wizery.com>
	<BANLkTim45NHT3o2mB7Ofb9KvqBDrGjJcaw@mail.gmail.com>
	<BANLkTikMMMck78MhFuFNqc+CrUBGpG+TxQ@mail.gmail.com>
	<1303884983.2336.46.camel@cumari>
Date: Wed, 27 Apr 2011 10:46:58 +0200
Message-ID: <BANLkTi=WSfA+2-PvH3TPUW+j+y5g0f7ZMQ@mail.gmail.com> (sfid-20110427_104705_479854_227139F0)
Subject: Re: [PATCH] mac80211: report MIC failure for truncated packets in AP mode
From: Christian Lamparter <chunkeey@googlemail.com>
To: Luciano Coelho <coelho@ti.com>
Cc: Arik Nemtsov <arik@wizery.com>, linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 27, 2011 at 8:16 AM, Luciano Coelho <coelho@ti.com> wrote:
> On Wed, 2011-04-27 at 01:03 +0300, Arik Nemtsov wrote:
>> On Tue, Apr 26, 2011 at 23:55, Christian Lamparter
>> <chunkeey@googlemail.com> wrote:
>> > On Tue, Apr 26, 2011 at 10:27 PM, Arik Nemtsov <arik@wizery.com> wrote:
>> >> MIC failure notifications for packets too short to contain a key index
>> >> are currently ignored in AP-mode.

>> > wait! Since you seem able to trigger MIC events frequently, could you
>> > please test if the following patch:
>> >
>> > <http://www.spinics.net/lists/linux-wireless/msg67571.html>
>> >
>> > <a little more info:http://www.spinics.net/lists/linux-wireless/msg67461.html>
>> >
>> > would help in your case as well?
>> >
>>
>> I seem to have missed this thread entirely :)
>> The patch you mentioned does indeed help. I tested in STA and AP mode.
>>
>> This bit is important for wl12xx:
>>
>> +       /*
>> +        * No way to verify the MIC if the hardware stripped it or
>> +        * the IV with the key index. In this case we have solely rely
>> +        * on the driver to set RX_FLAG_MMIC_ERROR in the event of a
>> +        * MIC failure report.
>> +        */
>> +       if (status->flag & (RX_FLAG_MMIC_STRIPPED | RX_FLAG_IV_STRIPPED)) {
>> +               if (status->flag & RX_FLAG_MMIC_ERROR)
>> +                       goto mic_fail;
>>
>> This prevents us from getting to the problematic check that I tried to
>> remove with my patch.
>>
>> Just for the record - generating a MIC failure is pretty easy. I'm
>> using the (very cool) mac80211 debugfs feature that allows simulating
>> a MIC failure (see ieee80211_if_parse_tkip_mic_test()).
>> It works well with a rt2x00 based card and the latest compat. I'm
>> simulating it from AP as well as STA.
>>
>> To summarize - either patch will work for us.
>
> Great! If this can be solved in a generic way in mac80211, I'd prefer if
> that one is used.
>
> Christian, are you planning to submit this patch again any time soon? If
> not, we could include the wl12xx patch for now and revert it later when
> the proper fix in mac80211 is applied.
Well, I didn't know about the if_parse_tkip_mic_test() and tried to get
aircrack-ng's tkip attack working, this was such a waste of time...

And yes I plan to resubmit the patch [Friday?!], because carl9170
(and to some degree ath9k) have similar problems with spurious
MIC failures.

Thanks,
   Chr
