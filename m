Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yk0-f176.google.com ([209.85.160.176]:49404 "EHLO
	mail-yk0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753052AbaFLPPr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Jun 2014 11:15:47 -0400
Received: by mail-yk0-f176.google.com with SMTP id 131so1070930ykp.7
        for <linux-wireless@vger.kernel.org>; Thu, 12 Jun 2014 08:15:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <5399929D.5010304@globaledgesoft.com>
References: <539030ED.4020006@globaledgesoft.com> <CAHNKnsTUKMxmDK7H=5ndf2zyCX3BChx+Kr70TRVdXxZzj1YFtQ@mail.gmail.com>
 <5399929D.5010304@globaledgesoft.com>
From: Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date: Thu, 12 Jun 2014 19:15:26 +0400
Message-ID: <CAHNKnsQTexCNWi-2n8JMJNMk7+vNfogaf9wTA_w5EXw0+0zRCw@mail.gmail.com> (sfid-20140612_171555_059834_6B9677FC)
Subject: Re: Physical carrier sensing (CCA)
To: Gaurav Kumar Chauhan <ck.gaurav@globaledgesoft.com>
Cc: ath9k-devel <ath9k-devel@lists.ath9k.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

2014-06-12 15:44 GMT+04:00 Gaurav Kumar Chauhan <ck.gaurav@globaledgesoft.com>:
>> On Tuesday 10 June 2014 02:18 PM, Sergey Ryazanov wrote:
>>> 2014-06-05 12:57 GMT+04:00 Gaurav Kumar Chauhan
>>> <ck.gaurav@globaledgesoft.com>:
>>>
>>> I am working on measuring channel load which requires knowledge of carrier
>>> sensing.
>>>
>>> I am comfortable with virtual carrier sensing but not with physical carrier
>>> sensing.
>>> I tried to google it but didn't get more than basics. I want to know about
>>> physical carrier
>>> sensing in detail and where code for physical sensing is present.
>>>
>>> Is it in driver or in firmware?
>>> I am using atheros pci-express card and ath9k driver.
>>
>> Physical and virtual carrier sensing are both realized in hardware at
>> least in AR9xxx chips. Chip provides some knobs to control both of
>> them (on/off, setup levels, etc.) and allows retrieve some statistics
>> (see channel survey code of ath9k driver for example).
>>
>
> Hi Sergey,
>
> Thanks for replying. Your information really helped me a lot.
>
> In ath9k/main.c there is one function called ath9k_get_survey() which inter
> calls ath_update_survey_stats() function.
> In ath_update_survey_stats() , struct survey_info members a getting
> initialized.
>
> One of the member is channel_time_busy: amount of time the primary channel
> was sensed busy.
> I want to confirm if this member holds the channel busy time value returned
> by physical carrier sensing mechanism.
>

AR9xxx measure four values and export them via appropriate registers:
- Tx time
- Rx time
- Channel busy time
- Total measurement period time

And I don't know is Tx/Rx time accounted by the busy time counter or
not. Seems that busy time counter considers whole busy time, but you
need to investigate this by yourself or ask somebody who know.

And please don't mail me privately.

-- 
BR,
Sergey
