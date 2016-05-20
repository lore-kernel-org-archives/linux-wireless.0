Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f68.google.com ([209.85.218.68]:33062 "EHLO
	mail-oi0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933187AbcETKyP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 May 2016 06:54:15 -0400
MIME-Version: 1.0
In-Reply-To: <48f4f8c9-b4a3-66f9-b4a5-640778ac8e79@broadcom.com>
References: <1463655770-22467-1-git-send-email-zajec5@gmail.com>
	<1463655770-22467-2-git-send-email-zajec5@gmail.com>
	<48f4f8c9-b4a3-66f9-b4a5-640778ac8e79@broadcom.com>
Date: Fri, 20 May 2016 12:54:14 +0200
Message-ID: <CACna6rxpZ5=r99yjR4OYqi_mEY0B1yz96m34Wt=u==x2A2r33g@mail.gmail.com> (sfid-20160520_125442_733977_370BD891)
Subject: Re: [PATCH 4.8 2/2] brcmfmac: support get_channel cfg80211 callback
From: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
To: Arend Van Spriel <arend.vanspriel@broadcom.com>
Cc: Kalle Valo <kvalo@codeaurora.org>,
	Brett Rudley <brudley@broadcom.com>,
	Arend van Spriel <arend@broadcom.com>,
	"Franky (Zhenhui) Lin" <frankyl@broadcom.com>,
	Hante Meuleman <meuleman@broadcom.com>,
	Pieter-Paul Giesberts <pieterpg@broadcom.com>,
	"open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER"
	<linux-wireless@vger.kernel.org>,
	"open list:BROADCOM BRCM80211 IEEE802.11n WIRELESS DRIVER"
	<brcm80211-dev-list@broadcom.com>,
	"open list:NETWORKING DRIVERS" <netdev@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 20 May 2016 at 09:42, Arend Van Spriel <arend.vanspriel@broadcom.com> wrote:
> On 19-5-2016 13:02, Rafał Miłecki wrote:
>> This is important for brcmfmac as the firmware may pick different
>> channel than requested. This has been tested with BCM4366B1 (in D-Link
>> DIR-885L).
>
> Can you elaborate? Is this for AP or STA mode?

This happens when using 5 GHz PHY with one AP interface. It seems
firmware respects: band, channel width & control channel location.
However it picks center channel in a more or less random way.

E.g. I configured hostapd to setup AP using 36 control channel with
VHT80 (chanspec 0xe02a). Almost every time I was restarting AP I got
firmware picking different chanspecs, all cases listed below:
0xe03a BND_5G | BW_80 | SB_LL | 58
0xe06a BND_5G | BW_80 | SB_LL | 106
0xe07a BND_5G | BW_80 | SB_LL | 122
0xe09b BND_5G | BW_80 | SB_LL | 155

I'm a bit disappointed seeing this FullMAC firmware doing such tricks
on its own. I would prefer to simply relay on hostapd doing this kind
of channel switching. I saw many times hostapd e.g. respecting my
40/80 MHz channel but switching control one in order to avoid
collisions with another AP's control frames on the same frequency.

On the other hand I never got this problem with BCM43602 using
Broadcom's official firmware, so it's some new feature you enabled
when building brcmfmac4366b-pcie.bin.


>> Signed-off-by: Rafał Miłecki <zajec5@gmail.com>
>> ---
>>  .../broadcom/brcm80211/brcmfmac/cfg80211.c         | 59 ++++++++++++++++++++++
>>  1 file changed, 59 insertions(+)
>>
>> diff --git a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
>> index 597495d..4fb9e3a 100644
>> --- a/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
>> +++ b/drivers/net/wireless/broadcom/brcm80211/brcmfmac/cfg80211.c
>> @@ -4892,6 +4892,64 @@ exit:
>>       return err;
>>  }
>>
>> +static int brcmf_cfg80211_get_channel(struct wiphy *wiphy,
>> +                                   struct wireless_dev *wdev,
>> +                                   struct cfg80211_chan_def *chandef)
>> +{
>> +     struct brcmf_cfg80211_info *cfg = wiphy_to_cfg(wiphy);
>> +     struct net_device *ndev = wdev->netdev;
>> +     struct brcmf_if *ifp = netdev_priv(ndev);
>
> Can this operation be done on a P2P_DEVICE interface, ie. wdev->netdev
> == NULL?

I don't have any experience with P2P, thanks a lot for pointing this to me!


>> +     struct brcmu_chan ch;
>> +     enum nl80211_band band = 0;
>> +     enum nl80211_chan_width width = 0;
>> +     u32 chanspec;
>> +     int freq, err;
>> +
>> +     err = brcmf_fil_iovar_int_get(ifp, "chanspec", &chanspec);
>> +     if (err) {
>> +             brcmf_err("chanspec failed (%d)\n", err);
>> +             return err;
>> +     }
>> +
>> +     ch.chspec = chanspec;
>> +     cfg->d11inf.decchspec(&ch);
>> +
>> +     switch (ch.band) {
>> +     case BRCMU_CHAN_BAND_2G:
>> +             band = NL80211_BAND_2GHZ;
>> +             break;
>> +     case BRCMU_CHAN_BAND_5G:
>> +             band = NL80211_BAND_5GHZ;
>> +             break;
>> +     }
>> +
>> +     switch (ch.bw) {
>> +     case BRCMU_CHAN_BW_80:
>> +             width = NL80211_CHAN_WIDTH_80;
>> +             break;
>> +     case BRCMU_CHAN_BW_40:
>> +             width = NL80211_CHAN_WIDTH_40;
>> +             break;
>> +     case BRCMU_CHAN_BW_20:
>> +             width = NL80211_CHAN_WIDTH_20;
>> +             break;
>> +     case BRCMU_CHAN_BW_80P80:
>> +             width = NL80211_CHAN_WIDTH_80P80;
>> +             break;
>
> Not much sense to support this given that center_freq2 is set to zero below.

OK.
