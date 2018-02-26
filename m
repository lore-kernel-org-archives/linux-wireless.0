Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:44074 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752336AbeBZKlj (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 26 Feb 2018 05:41:39 -0500
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Mon, 26 Feb 2018 16:11:38 +0530
From: periyasa@codeaurora.org
To: Adrian Chadd <adrian@freebsd.org>
Cc: ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        adrian.chadd@gmail.com
Subject: Re: [PATCH] Revert "ath10k: send (re)assoc peer command when NSS
 changed"
In-Reply-To: <CAJ-Vmo=xxG_Jp=uC-Cx96R0YzO8O0tOVe2G6Nyx8ceWopiwvXQ@mail.gmail.com>
References: <1519625792-12010-1-git-send-email-periyasa@codeaurora.org>
 <CAJ-Vmo=xxG_Jp=uC-Cx96R0YzO8O0tOVe2G6Nyx8ceWopiwvXQ@mail.gmail.com>
Message-ID: <559965cc9735f6616957f9ee84a17e52@codeaurora.org> (sfid-20180226_114147_449152_1CCF7F6F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2018-02-26 14:15, Adrian Chadd wrote:
> hi!
> 
> On 25 February 2018 at 22:16, Karthikeyan Periyasamy
> <periyasa@codeaurora.org> wrote:
>> This reverts commit 55884c045d31a29cf69db8332d1064a1b61dd159.
>> 
>> When Ath10k is in AP mode and an unassociated STA sends a VHT action 
>> frame
>> (Operating Mode Notification for the NSS change) periodically to AP 
>> this causes
>> ath10k to call ath10k_station_assoc() which sends WMI_PEER_ASSOC_CMDID 
>> during
>> NSS update. Over the time (with a certain client it can happen within 
>> 15 mins
>> when there are over 500 of these VHT action frames) continuous calls 
>> of
>> WMI_PEER_ASSOC_CMDID cause firmware to assert due to resource exhaust.
>> 
>> To my knowledge setting WMI_PEER_NSS peer param itself enough to 
>> handle NSS
>> updates and no need to call ath10k_station_assoc(). So revert the 
>> original
>> commit from 2014 as it's unclear why the change was really needed.
>> Now the firmware assert doesn't happen anymore.
>> 
>> Issue observed in QCA9984 platform with firmware 
>> version:10.4-3.5.3-00053.
>> This Change tested in QCA9984 with firmware version: 10.4-3.5.3-00053 
>> and
>> QCA988x platform with firmware version: 10.2.4-1.0-00036.
> 
> Did you test this on any of the other major firmware variants? I
> wonder if it snuck in because of some firmware quirk in something way
> before dakota/cascade and 10.4 were a thing.
> 
> Eg, Peregrine? Rome? Maybe even earlier Beeliner, just to double check?
> 
Yes. I tested this on peregrine, Beeliner, Dakota and Cascade. This code 
was introduced before Rome.

Thanks,
Karthikeyan.
