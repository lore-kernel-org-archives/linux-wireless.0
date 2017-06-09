Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from webmail.newmedia-net.de ([185.84.6.166]:56571 "EHLO
        webmail.newmedia-net.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751534AbdFIOaD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Jun 2017 10:30:03 -0400
Subject: Re: [PATCH v2 1/3] ath10k: Use complete VHT chan width for 160MHz
 workaround
To: Ben Greear <greearb@candelatech.com>,
        Sven Eckelmann <sven.eckelmann@openmesh.com>,
        ath10k@lists.infradead.org
Cc: linux-wireless@vger.kernel.org
References: <20170609110750.14950-1-sven.eckelmann@openmesh.com>
 <c91d2578-d491-c813-cbfb-f742d04f9417@candelatech.com>
From: Sebastian Gottschall <s.gottschall@dd-wrt.com>
Message-ID: <f01b07e5-bc11-68ac-0c37-e0d859ebfb4e@dd-wrt.com> (sfid-20170609_163007_340362_EEFD2267)
Date: Fri, 9 Jun 2017 16:09:01 +0200
MIME-Version: 1.0
In-Reply-To: <c91d2578-d491-c813-cbfb-f742d04f9417@candelatech.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am 09.06.2017 um 15:50 schrieb Ben Greear:
>
>
> On 06/09/2017 04:07 AM, Sven Eckelmann wrote:
>> From: Ben Greear <greearb@candelatech.com>
>>
>> The ath10k firmware doesn't announce its VHT channel width 
>> capabilities in
>> the vht_cap information from the "service ready event" arguments. The
>> driver must therefore check whether the 160MHz short GI bit is set and
>> whether the driver still doesn't set the bits for the 160/80+80 MHz
>> capabilities.
>>
>> The two bits for the channel width are a two bit integer and not two
>> separate bits which cannot be parsed without the knowledge of the other
>> bit. Using IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_160_80PLUS80MHZ (b10..) 
>> as a
>> mask for this task doesn't make any sense. The correct mask for the VHT
>> channel width should be used instead to make this check more readable.
>
> I didn't test them, but a quick review looks good.  Thanks for picking 
> this up!
mmh except that it wont change anything. this patch is a workaround for 
older firmwares. these older firmwares have this flag zeroed
newer firmwares have 80p80 set. thats all. for sure we can now check if 
the mask is 0 or not 0. but it wont change anything at the end
>
> --Ben
>
>

-- 
Mit freundlichen Grüssen / Regards

Sebastian Gottschall / CTO

NewMedia-NET GmbH - DD-WRT
Firmensitz:  Berliner Ring 101, 64625 Bensheim
Registergericht: Amtsgericht Darmstadt, HRB 25473
Geschäftsführer: Peter Steinhäuser, Christian Scheele
http://www.dd-wrt.com
email: s.gottschall@dd-wrt.com
Tel.: +496251-582650 / Fax: +496251-5826565
