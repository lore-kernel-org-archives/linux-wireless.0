Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:36724 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934156AbdADVUD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 4 Jan 2017 16:20:03 -0500
MIME-Version: 1.0
In-Reply-To: <3fc87224-7f08-e365-7bbb-a4b8b5746e4f@broadcom.com>
References: <20170104175832.25996-1-zajec5@gmail.com> <20170104175832.25996-4-zajec5@gmail.com>
 <3fc87224-7f08-e365-7bbb-a4b8b5746e4f@broadcom.com>
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Date: Wed, 4 Jan 2017 22:19:57 +0100
Message-ID: <CACna6rxay9sC+QT2G4AfjWT1ERsNDzFQ620hNhVhr0FRHXJu=w@mail.gmail.com> (sfid-20170104_222011_976745_A36E0AB4)
Subject: Re: [PATCH V6 4/3] brcmfmac: use wiphy_read_of_freq_limits to respect
 extra limits
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Felix Fietkau <nbd@nbd.name>,
        Arend van Spriel <arend@broadcom.com>,
        Arnd Bergmann <arnd@arndb.de>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 4 January 2017 at 21:07, Arend Van Spriel
<arend.vanspriel@broadcom.com> wrote:
> On 4-1-2017 18:58, Rafa=C5=82 Mi=C5=82ecki wrote:
>> From: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
>>
>> There are some devices (e.g. Netgear R8000 home router) with one chipset
>> model used for different radios, some of them limited to subbands. NVRAM
>> entries don't contain any extra info on such limitations and firmware
>> reports full list of channels to us. We need to store extra limitation
>> info in DT to support such devices properly.
>>
>> Now there is a cfg80211 helper for reading such info use it in brcmfmac.
>> This patch adds check for channel being disabled with orig_flags which
>> is how this wiphy helper and wiphy_register work.
>>
>> Signed-off-by: Rafa=C5=82 Mi=C5=82ecki <rafal@milecki.pl>
>> ---
>> This patch should probably go through wireless-driver-next which is why
>> it got weird number 4/3. I'm sending it just as a proof of concept.
>> It was succesfully tested on SmartRG SR400ac with BCM43602.
>>
>> V4: Respect IEEE80211_CHAN_DISABLED in orig_flags
>> V5: Update commit message
>> V6: Call wiphy_read_of_freq_limits after brcmf_setup_wiphybands to make =
it work
>>     with helper setting "flags" instead of "orig_flags".
>> ---
>>  drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c | 9 +++++++=
+-
>>  1 file changed, 8 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c=
 b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
>> index ccae3bb..a008ba5 100644
>> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
>> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
>> @@ -5886,6 +5886,9 @@ static int brcmf_construct_chaninfo(struct brcmf_c=
fg80211_info *cfg,
>>                                                      band->band);
>>               channel[index].hw_value =3D ch.control_ch_num;
>>
>> +             if (channel->orig_flags & IEEE80211_CHAN_DISABLED)
>> +                     continue;
>> +
>
> So to be clear this is still needed for subsequent calls to
> brcmf_setup_wiphybands(). The subsequent calls are done from the
> regulatory notifier. So I think we have an issue with this approach. Say
> the device comes up with US. That would set DISABLED flags for channels
> 12 to 14. With a country update to PL we would want to enable channels
> 12 and 13, right? The orig_flags are copied from the initial flags
> during wiphy_register() so it seems we will skip enabling 12 and 13. I
> think we should remove the check above and call
> wiphy_read_of_freq_limits() as a last step within
> brcmf_setup_wiphybands(). It means it is called every time, but it
> safeguards that the limits in DT are always applied.

I'm not exactly happy with channels management in brcmfmac. Before
calling wiphy_register it already disables channels unavailable for
current country. This results in setting IEEE80211_CHAN_DISABLED in
orig_flags of channels that may become available later, after country
change. Please note it happens even right now, without this patch.
Maybe you can workaround this by ignoring orig_flags in custom
regulatory code, but I'd just prefer to have it nicely handled in the
first place.

This is the next feature I'm going to work on. AFAIU this patch won't
be applied for now (it's for wireless-drivers-next and we first need
to get wiphy_read_of_freq_limits in that tree). By the time that
happens I may have another patchset cleaning brcmfmac ready. And FWIW
this patch wouldn't make things worse *at this point* as we don't
really support country switching for any device yet.

So I hope problem with channels in brcmfmac doesn't mean we need to
postpone patches 1-3.

--=20
Rafa=C5=82
