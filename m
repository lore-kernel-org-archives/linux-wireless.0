Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:56430 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751171AbdKNDBV (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 13 Nov 2017 22:01:21 -0500
Received: by mail-wm0-f67.google.com with SMTP id z3so19054333wme.5
        for <linux-wireless@vger.kernel.org>; Mon, 13 Nov 2017 19:01:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAL3ir7J5GwTjgo6U4k_r91uqMV4Nowr10k8-Kd+t8cXfrwKQDQ@mail.gmail.com>
References: <CAL3ir7JHwLpNFRSv0jEED50XeFAWmSz4gXXOs0MpM=VeTGiKnQ@mail.gmail.com>
 <CALLGbRKwcm0ugSKAV1p3rxGseAkp6Zk9RZvKZeTrWFJ_=-pSKg@mail.gmail.com> <CAL3ir7J5GwTjgo6U4k_r91uqMV4Nowr10k8-Kd+t8cXfrwKQDQ@mail.gmail.com>
From: Yuri Shih <yurishih1985@gmail.com>
Date: Tue, 14 Nov 2017 11:01:19 +0800
Message-ID: <CAL5Ybtwn11N4RGsSsCaRtAQ14_i5DXQMnR+XsqYLin_2MYFHCw@mail.gmail.com> (sfid-20171114_040136_166313_9A9ED05E)
Subject: Re: PS-Poll not behaving as expected
To: Daniel Ghansah <smartwires@gmail.com>
Cc: Steve deRosier <derosier@gmail.com>,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Steve,

For our hardware/driver information, they are the following:

Linux FW: Linux LEDE 4.4.87
AP Hardware: Compex WPJ563HV (radio chip QCA9563, driver Ath9k)
5G Radio: WLE1216V5-20 (radio chip QCA9984, driver Ath10k)
Driver: Base Driver is compat-wireless-2017-01-31 (with various
patches installed)

Station: Marvell RD-88W-8897-WIFI-S0 (radio chip 88W8897)
Driver - PCIE8897-15.68.6.p5-M2615485.p3-GPL-(FP68)

Here's also a link to the wireshark sniffer recordings:
https://drive.google.com/open?id=1GGNpMhfZ9Ya7HPrdISTxGLfXIuBgL1PR

Right now we don't have kernel logs since we weren't the ones who did
the test (test lab did them), but I can ask test lab to do the test
and give us the logs.

Thanks.

Sincerely,

Yuri

On Tue, Nov 14, 2017 at 10:45 AM, Daniel Ghansah <smartwires@gmail.com> wrote:
> Hello Steve,
>          Thanks for your prompt response, and sorry for my lack of
> details my colleague Yuri will provide this info shortly Thanks
>
> Regards
> Daniel
>
> On Mon, Nov 13, 2017 at 7:01 PM, Steve deRosier <derosier@gmail.com> wrote:
>> Hi Daniel,
>>
>> On Mon, Nov 13, 2017 at 2:40 PM, Daniel Ghansah <smartwires@gmail.com> wrote:
>>>        Here is the problem we experience:
>>>
>>> When the station (wifi devices) sends a null QoS frame with power save
>>> telling our AP that it is going into power save mode. RIght now, our
>>> problem is that the AP will not stop sending data packets to the
>>> station. Correct behavior is that the AP will buffer data packets and
>>> stop sending any data or null packets (WiFi Alliance allows at most 2
>>> of these packets to be sent by the AP before station sends ps-poll,
>>> exclude retries) until a PS-Poll packet is sent by the station to
>>> collect data. The AP should also respond only 1 packet per PS-Poll
>>> (exclude any retries). Right now, we are also experiencing that the AP
>>> will, at times, send more than 1 data packet to the station per
>>> PS-Poll. The first and second problems may be linked together.
>>>
>>
>> You've given no context with which we can help you. Things like the
>> Linux version, the hardware running on the AP and client, which it is
>> you're trying to report a bug on (the AP or Client), dmesg logs,
>> wireless traces, and so on would all be somewhere between mandatory to
>> helpful information. Trying to give us nothing but your interpretation
>> of what the 802.11 standard says (which most of us know very well)
>> isn't a useful bug report.
>>
>> This might help:
>> https://wireless.wiki.kernel.org/en/users/documentation/reporting_bugs
>>
>> Please try again and send us the information we need to be able to help.
>>
>> Thanks,
>> - Steve
>
>
>
> --
> Regards,
> Daniel Ghansah
