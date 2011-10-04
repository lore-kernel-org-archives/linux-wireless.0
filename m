Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.neratec.ch ([80.75.119.105]:38991 "EHLO mail.neratec.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754194Ab1JDORj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Oct 2011 10:17:39 -0400
Message-ID: <4E8B157F.2080203@neratec.com> (sfid-20111004_161742_433341_2E9DF477)
Date: Tue, 04 Oct 2011 16:17:35 +0200
From: Zefir Kurtisi <zefir.kurtisi@neratec.com>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@googlemail.com>
CC: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	kgiori@qca.qualcomm.com, nbd@openwrt.org
Subject: Re: [RFC 5/6] ath9k: enable DFS pulse detection
References: <1317637758-11907-1-git-send-email-zefir.kurtisi@neratec.com> <201110032124.53937.chunkeey@googlemail.com> <CAB=NE6XBkisvFmj6F7wS6i8XV7WEsM6bQ5zsXFWXm9XM8z0pwA@mail.gmail.com> <201110041538.12885.chunkeey@googlemail.com>
In-Reply-To: <201110041538.12885.chunkeey@googlemail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10/04/2011 03:38 PM, Christian Lamparter wrote:
> On Monday, October 03, 2011 09:31:12 PM Luis R. Rodriguez wrote:
>> On Mon, Oct 3, 2011 at 12:24 PM, Christian Lamparter
>> <chunkeey@googlemail.com> wrote:
>>> On Monday, October 03, 2011 08:27:39 PM Luis R. Rodriguez wrote:
>>>> On Mon, Oct 3, 2011 at 3:29 AM, Zefir Kurtisi <zefir.kurtisi@neratec.com> wrote:
>>>>>
>>>>> Signed-off-by: Zefir Kurtisi <zefir.kurtisi@neratec.com>
>>>>> ---
>>>>>  drivers/net/wireless/ath/ath9k/main.c |   12 ++++++++++++
>>>>>  1 files changed, 12 insertions(+), 0 deletions(-)
>>>>>
>>>>> diff --git a/drivers/net/wireless/ath/ath9k/main.c b/drivers/net/wireless/ath/ath9k/main.c
>>>>> index e8aeb98..5defebe 100644
>>>>> --- a/drivers/net/wireless/ath/ath9k/main.c
>>>>> +++ b/drivers/net/wireless/ath/ath9k/main.c
>>>>> @@ -344,6 +344,18 @@ static int ath_reset_internal(struct ath_softc *sc, struct ath9k_channel *hchan,
>>>>>                        "Unable to reset channel, reset status %d\n", r);
>>>>>                goto out;
>>>>>        }
>>>>> +#ifdef CONFIG_ATH9K_DFS
>>>>
>>>> Please spare the #ifdef and just call something within dfs.c, then
>>>> dfs.h would wrap it to nothing if DFS is disabled.
>>> Why would anyone want to disable DFS driver support?
>>> I would say: drop the ifdefs altogether since DFS
>>> is and will be "required".
>>
>> Because DFS requires to be properly tested before being enabled.
> Testing if a driver detects a pulse is "trivial" compared to the
> stuff mac80211/cfg80211 and hostapd will have to do to make a
> channel-change as smooth as possible. I think if there's a DFS
> "OFF" switch, it should be in hostapd and I hope more people
> agree on this one.  
> 
Yes on both. Work on the management part of the DFS module has just been started by TI guys. When this is in, hostapd will be able to query the driver's DFS detection capabilities and leave DFS channels disabled for those devices with no (or insufficient) support (like it is generally done today for DFS channels).

The proper way for a driver's OFF switch would then be to just announce missing DFS capabilities.

>> You may also want to simply disable DFS if you do not want to
>> deal with the regulatory test implications of having it enabled.
> AFAIK you can't "simply" disable the DFS requirement: hostapd
> (hw_features.c), [cfg80211] (checks if tx on secondary channel
> is possible) and mac80211 (tx.c) all have checks. Indeed, the
> easiest way is to modify crda's database. So there's no need
> for an extra compile-time option.
> 
There might be a demand for conditional compiling in addition to DFS capabilities announcements to reduce memory footprint, since (especially) pattern matching algorithms will increase it significantly.

> Regards,
> 	Chr

Zefir
