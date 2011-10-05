Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:54156 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934801Ab1JEWai convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Oct 2011 18:30:38 -0400
Received: by qadb15 with SMTP id b15so1629041qad.19
        for <linux-wireless@vger.kernel.org>; Wed, 05 Oct 2011 15:30:38 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4E8B157F.2080203@neratec.com>
References: <1317637758-11907-1-git-send-email-zefir.kurtisi@neratec.com>
 <201110032124.53937.chunkeey@googlemail.com> <CAB=NE6XBkisvFmj6F7wS6i8XV7WEsM6bQ5zsXFWXm9XM8z0pwA@mail.gmail.com>
 <201110041538.12885.chunkeey@googlemail.com> <4E8B157F.2080203@neratec.com>
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Date: Wed, 5 Oct 2011 15:30:18 -0700
Message-ID: <CAB=NE6V4jBiGo4Od4SRPiHJembYw9JGAnBed_2w=1Y1k4_Jd_g@mail.gmail.com> (sfid-20111006_003042_519097_C423DBAF)
Subject: Re: [RFC 5/6] ath9k: enable DFS pulse detection
To: Zefir Kurtisi <zefir.kurtisi@neratec.com>
Cc: Christian Lamparter <chunkeey@googlemail.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	kgiori@qca.qualcomm.com, nbd@openwrt.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 4, 2011 at 7:17 AM, Zefir Kurtisi <zefir.kurtisi@neratec.com> wrote:
> On 10/04/2011 03:38 PM, Christian Lamparter wrote:
>> On Monday, October 03, 2011 09:31:12 PM Luis R. Rodriguez wrote:
>>> On Mon, Oct 3, 2011 at 12:24 PM, Christian Lamparter
>>> <chunkeey@googlemail.com> wrote:
>>>> On Monday, October 03, 2011 08:27:39 PM Luis R. Rodriguez wrote:
>>>>> On Mon, Oct 3, 2011 at 3:29 AM, Zefir Kurtisi <zefir.kurtisi@neratec.com> wrote:
>>>>>>
>>>>>> Signed-off-by: Zefir Kurtisi <zefir.kurtisi@neratec.com>
>>>>>> ---
>>>>>>  drivers/net/wireless/ath/ath9k/main.c |   12 ++++++++++++
>>>>>>  1 files changed, 12 insertions(+), 0 deletions(-)
>>>>>>
>>>>>> diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
>>>>>> index e8aeb98..5defebe 100644
>>>>>> --- a/drivers/net/wireless/ath/ath9k/main.c
>>>>>> +++ b/drivers/net/wireless/ath/ath9k/main.c
>>>>>> @@ -344,6 +344,18 @@ static int ath_reset_internal(struct ath_softc *sc, struct ath9k_channel *hchan,
>>>>>>                        "Unable to reset channel, reset status %d\n", r);
>>>>>>                goto out;
>>>>>>        }
>>>>>> +#ifdef CONFIG_ATH9K_DFS
>>>>>
>>>>> Please spare the #ifdef and just call something within dfs.c, then
>>>>> dfs.h would wrap it to nothing if DFS is disabled.
>>>> Why would anyone want to disable DFS driver support?
>>>> I would say: drop the ifdefs altogether since DFS
>>>> is and will be "required".
>>>
>>> Because DFS requires to be properly tested before being enabled.
>> Testing if a driver detects a pulse is "trivial" compared to the
>> stuff mac80211/cfg80211 and hostapd will have to do to make a
>> channel-change as smooth as possible. I think if there's a DFS
>> "OFF" switch, it should be in hostapd and I hope more people
>> agree on this one.
>>
> Yes on both. Work on the management part of the DFS module has just been started by TI guys. When this is in, hostapd will be able to query the driver's DFS detection capabilities and leave DFS channels disabled for those devices with no (or insufficient) support (like it is generally done today for DFS channels).
>
> The proper way for a driver's OFF switch would then be to just announce missing DFS capabilities.

And this is what I meant by leaving a kernel build option available
for each driver to enable/disable DFS. If a vendor does not want to
deal with the question of enabling DFS they can disable it on the
driver front.

>>> You may also want to simply disable DFS if you do not want to
>>> deal with the regulatory test implications of having it enabled.
>> AFAIK you can't "simply" disable the DFS requirement: hostapd
>> (hw_features.c), [cfg80211] (checks if tx on secondary channel
>> is possible) and mac80211 (tx.c) all have checks. Indeed, the
>> easiest way is to modify crda's database. So there's no need
>> for an extra compile-time option.
>>
> There might be a demand for conditional compiling in addition to DFS capabilities announcements to reduce memory footprint, since (especially) pattern matching algorithms will increase it significantly.

I doubt space considerations will be that much given that we don't
even have build options to disable hardware families, at least nbd had
determine already that separating families at build time wouldn't save
us much. Given that -- I suspect using build size as an argument for
introducing a flag here doesn't carry much weight. The argument I'm
using is to simply enable integrators to decide whether or not to have
to deal with testing such features.

 Luis
