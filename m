Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:52912 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755033Ab3E1UFc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 28 May 2013 16:05:32 -0400
Message-ID: <51A50E00.5030704@hauke-m.de> (sfid-20130528_220535_513449_9A9FAF65)
Date: Tue, 28 May 2013 22:05:20 +0200
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: Arend van Spriel <arend@broadcom.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	brcm80211-dev-list@broadcom.com
Subject: Re: REGRESSION: v3.10-rc1: [PATCH 04/15] brcmsmac: remove brcms_bss_cfg->associated
References: <1364085963-25940-1-git-send-email-hauke@hauke-m.de> <1364085963-25940-5-git-send-email-hauke@hauke-m.de> <5197DC4F.7030503@broadcom.com> <51988B8F.7010205@broadcom.com> <5198A879.6000406@hauke-m.de>
In-Reply-To: <5198A879.6000406@hauke-m.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/19/2013 12:24 PM, Hauke Mehrtens wrote:
> On 05/19/2013 10:21 AM, Arend van Spriel wrote:
>> On 05/18/2013 09:53 PM, Arend van Spriel wrote:
>>> On 03/24/2013 01:45 AM, Hauke Mehrtens wrote:
>>>> Replaced the usage with pub->associated.
>>>>
>>>> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
>>>> ---
>>>>   drivers/net/wireless/brcm80211/brcmsmac/main.c |   12 +++---------
>>>>   drivers/net/wireless/brcm80211/brcmsmac/main.h |    2 --
>>>>   2 files changed, 3 insertions(+), 11 deletions(-)
>>>
>>> Hi Hauke,
>>>
>>> I had a problem with bcm43224 in STA mode and bisecting it shows this
>>> change as culprit. On laptop I installed kernel with brcmsmac compiled
>>> as module. It comes up and associates during boot, but after logging in
>>> there is no connectivity. Triggering reassoc gives connectivity for some
>>> time, but after a while (1-2 min) it stops.
>>>
>>> I am looking into it. Given the function name below (brcms_c_ps_allowed)
>>> it may be power-save related. I will keep you informed.
>>>
>>> Gr. AvS
>>>
>>>> diff --git a/drivers/net/wireless/brcm80211/brcmsmac/main.c
>>>> b/drivers/net/wireless/brcm80211/brcmsmac/main.c
>>>> index 90e6c0d..810b7e2 100644
>>>> --- a/drivers/net/wireless/brcm80211/brcmsmac/main.c
>>>> +++ b/drivers/net/wireless/brcm80211/brcmsmac/main.c
>>>> @@ -3049,8 +3049,6 @@ static void brcms_b_antsel_set(struct
>>>> brcms_hardware *wlc_hw, u32 antsel_avail)
>>>>    */
>>>>   static bool brcms_c_ps_allowed(struct brcms_c_info *wlc)
>>>>   {
>>>> -    struct brcms_bss_cfg *cfg = wlc->bsscfg;
>>>> -
>>>>       /* disallow PS when one of the following global conditions
>>>> meets */
>>>>       if (!wlc->pub->associated)
>>>>           return false;
>>>> @@ -3059,9 +3057,6 @@ static bool brcms_c_ps_allowed(struct
>>>> brcms_c_info *wlc)
>>>>       if (wlc->filter_flags & FIF_PROMISC_IN_BSS)
>>>>           return false;
>>>>
>>>> -    if (cfg->associated)
>>>> -        return false;
>>>> -
>>
>> wlc->pub->associated and wlc->bsscfg->associated have the same value,
>> which I guess was your motivation to remove it from struct
>> brcms_bss_cfg. So before this patch the function brcms_c_ps_allowed()
>> always returned false. As power-save is a unsupported feature for
>> brcmsmac that was fine, but the removal below changed that behaviour.
> 
> The change in the behavior was not intended. I removed
> wlc->bsscfg->associated because it always had the same value as
> wlc->pub->associated. I must have missed that one the if conditions was
> negated. When multi bssid support will be added to brcmsmac this
> complete handling has to be reworked.
> 
>> As power-save is not supported this function can be changed to simply
>> return false for now. I will send out a patch for that.
> 
> Thanks for making such a patch.

What is the status of the patch? Is there more needed than returning
false in brcms_c_ps_allowed()?
There is also a bugzilla report at [0] and I added patch a [1], feel
free to use it.

Hauke

[0]: https://bugzilla.kernel.org/show_bug.cgi?id=58471
[1]: https://bugzilla.kernel.org/attachment.cgi?id=102741
