Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from iron02.fraunhofer.de ([153.96.1.56]:5465 "EHLO
        iron02.fraunhofer.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1039116AbdDUMuz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 21 Apr 2017 08:50:55 -0400
Subject: Re: [v2,1/3] ath9k: Support channels in licensed bands
To: Simon Wunderlich <sw@simonwunderlich.de>,
        ath10k@lists.infradead.org
Cc: Ben Greear <greearb@candelatech.com>,
        Steve deRosier <derosier@gmail.com>,
        Julian Calaby <julian.calaby@gmail.com>,
        linux-wireless@vger.kernel.org, ath9k-devel@qca.qualcomm.com,
        Kalle Valo <kvalo@codeaurora.org>
References: <20170323133048.30062-2-sw@simonwunderlich.de>
 <CALLGbRK2d1wZpfLnXu_UDWxVPA9LvejFyEFpzMub56uLH0+DTw@mail.gmail.com>
 <d4acedac-e28c-4c1c-d112-40557d52f3a2@candelatech.com>
 <1811221.G4Vz0DPyQ8@prime>
From: Mathias Kretschmer <mathias.kretschmer@fit.fraunhofer.de>
Message-ID: <12133a0e-b030-5b21-8de1-3bf7334d47df@fit.fraunhofer.de> (sfid-20170421_145058_974363_2F121124)
Date: Fri, 21 Apr 2017 14:40:51 +0200
MIME-Version: 1.0
In-Reply-To: <1811221.G4Vz0DPyQ8@prime>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi all,

as one of the parties who triggered this patch to be included into the 
main line kernel, we do support Simon's or Ben's point of view.

Safeguards against accidental misuse are in place. Various patches are 
(have been) already in the open, so if someone wants to be evil, it 
can't be prevented.

Also, these patches do not make up new channels out of the blue, they 
merely enable channels which are allowed in certain countries under 
specific regulations. To me it seems to be the task of the distribution 
manager (or manufacturer) to ensure that only hardware/kernel features 
are made available that are legal in the given jurisdiction.

The default behavior is to disable those extra channels. If you are 
building, i.e. First Responder solutions, you need to ensure that those 
guys use the systems incl. the frequency spectrum accordingly.

To be pragmatic and to avoid out-of-tree code maintenance, my vote would 
be for integration into mainline.

Best regards,

Mathias




Hence, for

On 21-Apr-17 13:29, Simon Wunderlich wrote:
> Hi,
> 
> On Tuesday, April 18, 2017 10:09:59 AM CEST Ben Greear wrote:
>> [...]
>>>      In my personal view, we have quite a few obstacles which I consider
>>>      "enough", but would be interesting to hear others opinions ...
>>>
>>> I'll throw in my 2-cents. This patch is treading on very dangerous ground.
>>> I can't speak to other regulatory environments, but at least the FCC is
>>> cracking down on even the possibility that anyone can operate a WiFi
>>> device outside the regulatory bounds.
>> These patches make it slightly easier to use the licensed bands, but no one
>> can accidentally use them due to the regdb and other constaints in these
>> patches.
>>
>> So, I don't think these patches offer any fundamental new vulnerability
>> that should concern the FCC.
>>
>> After all, someone who really wants to do evil can find and apply the
>> patches without undue effort, and it could easily be that those applying
>> the patches would then make it even easier to abuse the new channels due to
>> laziness or poor coding choices.
> 
> I'm with Ben on this one. I also have followed the FCC actions in the past few
> years, and I've also been involved into that [1,2,3]. There are mailing lists
> on the topic if you want to get involved. I agree that the topic is important,
> but I would prefer to not have this patch serving as battleground. :)
> 
> The patches proposed here, as Ben says, at least put proper warnings and
> obstacles which users have to knowingly overcome (or read). It's probably
> safer than keeping the driver as is and having people apply random patches
> from the internet which they don't understand or hack the code themselves.
> Frankly, it's not that hard to enable those channels.
> 
> As we have seen by the number of questions and people trying to bring this
> patch in (Ben and Julian), there is quite some interest for supporting those
> bands. I've also got a few requests from companies to have it supported
> (Fraunhofer is one of those).
> 
> Cheers,
>        Simon
> 
> 
> [1] https://www.reddit.com/r/wireless/comments/3irr5b/
> openwrt_vs_fcc_forced_firmware_lockdown/
> [2] http://hackaday.com/2016/02/26/fcc-locks-down-router-firmware/
> [3] https://libreplanet.org/wiki/Save_WiFi
> 
