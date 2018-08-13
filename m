Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-io0-f194.google.com ([209.85.223.194]:41790 "EHLO
        mail-io0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728443AbeHMNhD (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 13 Aug 2018 09:37:03 -0400
Received: by mail-io0-f194.google.com with SMTP id q4-v6so14357665iob.8
        for <linux-wireless@vger.kernel.org>; Mon, 13 Aug 2018 03:55:19 -0700 (PDT)
MIME-Version: 1.0
References: <20180812145207.11395-1-kristian.evensen@gmail.com>
 <871sb3zc3v.fsf@kamboji.qca.qualcomm.com> <5B708025.4090906@broadcom.com>
In-Reply-To: <5B708025.4090906@broadcom.com>
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
Date: Mon, 13 Aug 2018 12:55:03 +0200
Message-ID: <CAJ0CqmVZNAnHwnU4YqRRv7R8DyHi2MiFJr1bvQDPVszUU5Ez3g@mail.gmail.com> (sfid-20180813_125522_526262_83FE5B47)
Subject: Re: [PATCH] mt76: Enable NL80211_EXT_FEATURE_CQM_RSSI_LIST
To: arend.vanspriel@broadcom.com
Cc: Kalle Valo <kvalo@codeaurora.org>, kristian.evensen@gmail.com,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> On 8/12/2018 8:14 PM, Kalle Valo wrote:
> > Kristian Evensen <kristian.evensen@gmail.com> writes:
> >
> >> Enable the use of CQM with mt76-devices.
> >>
> >> Signed-off-by: Kristian Evensen <kristian.evensen@gmail.com>
> >> ---
> >>   drivers/net/wireless/mediatek/mt76/mac80211.c | 2 ++
> >>   1 file changed, 2 insertions(+)
> >>
> >> diff --git a/drivers/net/wireless/mediatek/mt76/mac80211.c b/drivers/net/wireless/mediatek/mt76/mac80211.c
> >> index 029d54bc..3eb328ff 100644
> >> --- a/drivers/net/wireless/mediatek/mt76/mac80211.c
> >> +++ b/drivers/net/wireless/mediatek/mt76/mac80211.c
> >> @@ -305,6 +305,8 @@ int mt76_register_device(struct mt76_dev *dev, bool vht,
> >>
> >>      wiphy->features |= NL80211_FEATURE_ACTIVE_MONITOR;
> >>
> >> +    wiphy_ext_feature_set(wiphy, NL80211_EXT_FEATURE_CQM_RSSI_LIST);
> >
> > So have you tested this and with what devices? For example, does it work
> > with recently added USB devices?
>
> I was looking into this as it looks suspicious to me. From reading the
> description of this ext_feature flag it seems this is an extention of CQM:
>
> """
>   * @NL80211_EXT_FEATURE_CQM_RSSI_LIST: With this driver the
>   *     %NL80211_ATTR_CQM_RSSI_THOLD attribute accepts a list of zero or more
>   *     RSSI threshold values to monitor rather than exactly one threshold.
> """
>
> Also looking at mt76x2_bss_info_changed() it does not handle
> BSS_CHANGED_CQM so I doubt it has support for it (yet). The driver does
> not use IEEE80211_VIF_SUPPORTS_CQM_RSSI which is a requirement for it.
>
> Regards,
> Arend
>

According to my understanding (please correct me if I am wrong)
BSS_CHANGED_CQM is only needed if CQM_RSSI is handled
by the driver/fw, while if it is not set mac80211 will take care of that
in ieee80211_handle_beacon_sig routine.
I am AFK at the moment, I will test that patch when I am back from vacations.

Regards,
Lorenzo

>
> https://elixir.bootlin.com/linux/latest/source/drivers/net/wireless/mediatek/mt76/mt76x2_main.c#L223
>
