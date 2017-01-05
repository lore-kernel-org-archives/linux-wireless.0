Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:35212 "EHLO
        mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753442AbdAEJd1 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 5 Jan 2017 04:33:27 -0500
Received: by mail-wm0-f53.google.com with SMTP id a197so427472661wmd.0
        for <linux-wireless@vger.kernel.org>; Thu, 05 Jan 2017 01:31:57 -0800 (PST)
Subject: Re: [PATCH V6 4/3] brcmfmac: use wiphy_read_of_freq_limits to respect
 extra limits
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
References: <20170104175832.25996-1-zajec5@gmail.com>
 <20170104175832.25996-4-zajec5@gmail.com>
 <3fc87224-7f08-e365-7bbb-a4b8b5746e4f@broadcom.com>
 <CACna6rxay9sC+QT2G4AfjWT1ERsNDzFQ620hNhVhr0FRHXJu=w@mail.gmail.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Felix Fietkau <nbd@nbd.name>,
        Arend van Spriel <arend@broadcom.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
From: Arend Van Spriel <arend.vanspriel@broadcom.com>
Message-ID: <e2bbce35-af09-adfa-09ea-e9fcf57b4d09@broadcom.com> (sfid-20170105_103528_703664_8F99C826)
Date: Thu, 5 Jan 2017 10:31:54 +0100
MIME-Version: 1.0
In-Reply-To: <CACna6rxay9sC+QT2G4AfjWT1ERsNDzFQ620hNhVhr0FRHXJu=w@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 4-1-2017 22:19, Rafał Miłecki wrote:
> On 4 January 2017 at 21:07, Arend Van Spriel
> <arend.vanspriel@broadcom.com> wrote:
>> On 4-1-2017 18:58, Rafał Miłecki wrote:
>>> From: Rafał Miłecki <rafal@milecki.pl>
>>>
>>> There are some devices (e.g. Netgear R8000 home router) with one chipset
>>> model used for different radios, some of them limited to subbands. NVRAM
>>> entries don't contain any extra info on such limitations and firmware
>>> reports full list of channels to us. We need to store extra limitation
>>> info in DT to support such devices properly.
>>>
>>> Now there is a cfg80211 helper for reading such info use it in brcmfmac.
>>> This patch adds check for channel being disabled with orig_flags which
>>> is how this wiphy helper and wiphy_register work.
>>>
>>> Signed-off-by: Rafał Miłecki <rafal@milecki.pl>
>>> ---
>>> This patch should probably go through wireless-driver-next which is why
>>> it got weird number 4/3. I'm sending it just as a proof of concept.
>>> It was succesfully tested on SmartRG SR400ac with BCM43602.
>>>
>>> V4: Respect IEEE80211_CHAN_DISABLED in orig_flags
>>> V5: Update commit message
>>> V6: Call wiphy_read_of_freq_limits after brcmf_setup_wiphybands to make it work
>>>     with helper setting "flags" instead of "orig_flags".
>>> ---
>>>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 9 ++++++++-
>>>  1 file changed, 8 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
>>> index ccae3bb..a008ba5 100644
>>> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
>>> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
>>> @@ -5886,6 +5886,9 @@ static int brcmf_construct_chaninfo(struct brcmf_cfg80211_info *cfg,
>>>                                                      band->band);
>>>               channel[index].hw_value = ch.control_ch_num;
>>>
>>> +             if (channel->orig_flags & IEEE80211_CHAN_DISABLED)
>>> +                     continue;
>>> +
>>
>> So to be clear this is still needed for subsequent calls to
>> brcmf_setup_wiphybands(). The subsequent calls are done from the
>> regulatory notifier. So I think we have an issue with this approach. Say
>> the device comes up with US. That would set DISABLED flags for channels
>> 12 to 14. With a country update to PL we would want to enable channels
>> 12 and 13, right? The orig_flags are copied from the initial flags
>> during wiphy_register() so it seems we will skip enabling 12 and 13. I
>> think we should remove the check above and call
>> wiphy_read_of_freq_limits() as a last step within
>> brcmf_setup_wiphybands(). It means it is called every time, but it
>> safeguards that the limits in DT are always applied.
> 
> I'm not exactly happy with channels management in brcmfmac. Before
> calling wiphy_register it already disables channels unavailable for
> current country. This results in setting IEEE80211_CHAN_DISABLED in

What do you mean by current country. There is none that we are aware off
in the driver. So we obtain the channels for the current
country/revision in the firmware and enable those before
wiphy_register(). This all is within the probe/init sequence so I do not
really see an issue. As the wiphy object is not yet registered there is
no user-space awareness

> orig_flags of channels that may become available later, after country
> change. Please note it happens even right now, without this patch.

Nope. As stated earlier the country setting in firmware is not updated
unless you provide a *proper* mapping of user-space country code to
firmware country code/revision. That is the reason, ie. firmware simply
returns the same list of channels as nothing changed from its
perspective. We may actually drop 11d support.

> Maybe you can workaround this by ignoring orig_flags in custom
> regulatory code, but I'd just prefer to have it nicely handled in the
> first place.

Please care to explain your ideas before putting any effort in this
"feature". As the author of the code that makes you unhappy and as
driver maintainer I would like to get a clearer picture of your point of
view. What exactly is the issue that makes you unhappy.

> This is the next feature I'm going to work on. AFAIU this patch won't
> be applied for now (it's for wireless-drivers-next and we first need
> to get wiphy_read_of_freq_limits in that tree). By the time that
> happens I may have another patchset cleaning brcmfmac ready. And FWIW
> this patch wouldn't make things worse *at this point* as we don't
> really support country switching for any device yet.

Now who is *we*? We as Broadcom can, because we know how to map the ISO
3166-1 country code to firmware country code/revision for a specific
firmware release. Firmware uses its own regulatory rules which may
differ from what regdb has. Now I know Intel submitted a mechanism to
export firmware rules to regdb so maybe we should consider switching to
that api if that has been upstreamed. Need to check.

> So I hope problem with channels in brcmfmac doesn't mean we need to
> postpone patches 1-3.

I do not see any reason to postpone.

Regards,
Arend
