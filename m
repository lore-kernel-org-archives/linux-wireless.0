Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from yx-out-2324.google.com ([74.125.44.28]:34429 "EHLO
	yx-out-2324.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754250AbYLBO3W (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Dec 2008 09:29:22 -0500
Received: by yx-out-2324.google.com with SMTP id 8so1193681yxm.1
        for <linux-wireless@vger.kernel.org>; Tue, 02 Dec 2008 06:29:20 -0800 (PST)
Message-ID: <1ba2fa240812020629s4aef06dar48354fd3223c6bc@mail.gmail.com> (sfid-20081202_152928_066837_2E96E63E)
Date: Tue, 2 Dec 2008 16:29:20 +0200
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Vivek Natarajan" <vivek.natraj@gmail.com>
Subject: Re: [RFC] mac80211: Enhancements to dynamic power save.
Cc: "Kalle Valo" <kalle.valo@nokia.com>,
	"Johannes Berg" <johannes@sipsolutions.net>,
	"Vivek Natarajan" <vnatarajan@atheros.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <8e92b4100812020458l29d96527g71bf9f5fb9a5993@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20081202011754.GA9382@myhost.users.atheros.com>
	 <1228133121.3478.27.camel@johannes.berg> <873ah76fax.fsf@nokia.com>
	 <1ba2fa240812010900t4781aca2uc33bc26bc1ef161@mail.gmail.com>
	 <8e92b4100812020458l29d96527g71bf9f5fb9a5993@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Dec 2, 2008 at 2:58 PM, Vivek Natarajan <vivek.natraj@gmail.com> wrote:
> Tomas Winkler <tomasw@gmail.com> wrote:
>> On Mon, Dec 1, 2008 at 6:17 PM, Kalle Valo <kalle.valo@nokia.com> wrote:
>>> Johannes Berg <johannes@sipsolutions.net> writes:
>>>
>>>> On Mon, 2008-12-01 at 17:17 -0800, Vivek Natarajan wrote:
>>>>> This patch is based on Kalle's initial RFC patches on dynamic power save.
>>>>> Since ath9k/ath5k,stlc45xx and b43 need the driver to send the null
>>>>> frame, it is appropriate to do it from mac80211.
>>>>> This patch enables mac80211 to send a null frame and also to
>>>>> check for tim in the beacon if power save is enabled.
>>>>
>>>> One thing I forgot, do we need a special iwlwifi flag to turn this off?
>>>> Or can iwlwifi be programmed to let the host handle this (*), which
>>>> might be beneficial for interoperability and uniformity purposes?
>>>
>>> Having the null frame handling in firmware is faster and we might get
>>> some power savings from that. But is the saving observable, that's an
>>> another question :)
>>
>> This patch is not much relevant in actual saving , since this is the
>> waking up part, you are powering the whole nic up anyway.
>
>  I agree but with PM bit on-off, this is what one can do to reduce some power
>  consumption although not significant. If more significant savings is needed,
>  we may need to implement PS-POLL or the APSD mechanism. But this
>  is a good start to power save in mac80211.

I was more referring to Kalle comment whether more power is saved when
host or firmware sends the null packet,
then to actual implementation of PM.
PM be done through either toggling PM bit or PS-POLL.  I'm not sure
which one is better. In PS-POLL the station has more timing control
but there is additional overhead since for each packet PS-POLL frame
has to be issued.
Simplified explanation to APSD would be this as APSD  is fine grained
PM per AC category,  if I'm not confusing with something else :)

>
>> The firmware handling of power save is more relevant in going to sleep
>> phase and sustaining where decision about sending the null frame is
>> faster then from host. The NIC is powered down in stages up to state
>> where only slow clock is ticking so this is rather time sensitive
>
> AFAIK, only iwlwifi has this firmware support and we need mac80211's
> support in this for ath9k/ath5k,stlc45xx and b43. I believe a powerful
> 2GHz host processor can manage these timings as a Windows driver
> for these vendor cards seems to support power save without firmware support.

I think I think what you meant is that only iwlwifi issues null
packets from the firmware but I believe that all other NICs supports
PM in HW/firmware a.k.a shutting down some parts of the HW.
So to be good also to all NICs null packet shell not be sent for PM
for iwlwifi driver.  In good case it's just redundant in worst it can
screw up the PM state machine. I suggest to add flag that indicates
whether null packet is required or not.


Thanks
Tomas
