Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f194.google.com ([209.85.220.194]:35016 "EHLO
	mail-qk0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751993AbcF2I4g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Jun 2016 04:56:36 -0400
Received: by mail-qk0-f194.google.com with SMTP id b136so8446294qkg.2
        for <linux-wireless@vger.kernel.org>; Wed, 29 Jun 2016 01:56:35 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CABPxzYJYGiCHGh2drjDq73JL9_FUWy-Bhb3zqORNz=wBy2Tzuw@mail.gmail.com>
References: <1467021206-2702-1-git-send-email-chaitanya.mgit@gmail.com>
 <CACYmx9O-xnLLUWgVFBWnY2L2ArsHW_+voOA+xeTBMqOK9mAPLg@mail.gmail.com>
 <CABPxzYLQyBsDD+HK=eS7qBXtrAdxwOajC3-xyYhKP8Bf_HExww@mail.gmail.com> <CABPxzYJYGiCHGh2drjDq73JL9_FUWy-Bhb3zqORNz=wBy2Tzuw@mail.gmail.com>
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Date: Wed, 29 Jun 2016 14:26:15 +0530
Message-ID: <CABPxzYKk2ofEzfSTJHx8fZhNYHhAiipSk+zhQbQ+QvFFJYe+uQ@mail.gmail.com> (sfid-20160629_105646_975045_B9FBDFEF)
Subject: Re: [PATCH] mac80211: minstrel: Enable STBC and LDPC for VHT Rates
To: Karl Beldan <karl.beldan@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Felix Fietkau <nbd@nbd.name>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 29, 2016 at 1:52 PM, Krishna Chaitanya
<chaitanya.mgit@gmail.com> wrote:
> On Wed, Jun 29, 2016 at 1:50 PM, Krishna Chaitanya
> <chaitanya.mgit@gmail.com> wrote:
>> On Wed, Jun 29, 2016 at 1:41 PM, Karl Beldan <karl.beldan@gmail.com> wrote:
>>> On Mon, Jun 27, 2016 at 9:53 AM, Chaitanya TK <chaitanya.mgit@gmail.com>
>>> wrote:
>>>>
>>>> From: Chaitanya T K <chaitanya.mgit@gmail.com>
>>>>
>>>> If peer support reception of STBC and LDPC, enable them for better
>>>> performance.
>>>>
>>>> Signed-off-by: Chaitanya TK <chaitanya.mgit@gmail.com>
>>>> ---
>>>>  include/linux/ieee80211.h          |    1 +
>>>>  net/mac80211/rc80211_minstrel_ht.c |   25 +++++++++++++++++--------
>>>>  2 files changed, 18 insertions(+), 8 deletions(-)
>>>>
>>>> diff --git a/include/linux/ieee80211.h b/include/linux/ieee80211.h
>>>> index b118744..4d01130 100644
>>>> --- a/include/linux/ieee80211.h
>>>> +++ b/include/linux/ieee80211.h
>>>> @@ -1550,6 +1550,7 @@ struct ieee80211_vht_operation {
>>>>  #define IEEE80211_VHT_CAP_RXSTBC_3                             0x00000300
>>>>  #define IEEE80211_VHT_CAP_RXSTBC_4                             0x00000400
>>>>  #define IEEE80211_VHT_CAP_RXSTBC_MASK                          0x00000700
>>>> +#define IEEE80211_VHT_CAP_RXSTBC_SHIFT                         8
>>>>  #define IEEE80211_VHT_CAP_SU_BEAMFORMER_CAPABLE
>>>> 0x00000800
>>>>  #define IEEE80211_VHT_CAP_SU_BEAMFORMEE_CAPABLE
>>>> 0x00001000
>>>>  #define IEEE80211_VHT_CAP_BEAMFORMEE_STS_SHIFT                  13
>>>> diff --git a/net/mac80211/rc80211_minstrel_ht.c
>>>> b/net/mac80211/rc80211_minstrel_ht.c
>>>> index 30fbabf..e2fcdea 100644
>>>> --- a/net/mac80211/rc80211_minstrel_ht.c
>>>> +++ b/net/mac80211/rc80211_minstrel_ht.c
>>>> @@ -1166,13 +1166,14 @@ minstrel_ht_update_caps(void *priv, struct
>>>> ieee80211_supported_band *sband,
>>>>         struct minstrel_ht_sta_priv *msp = priv_sta;
>>>>         struct minstrel_ht_sta *mi = &msp->ht;
>>>>         struct ieee80211_mcs_info *mcs = &sta->ht_cap.mcs;
>>>> -       u16 sta_cap = sta->ht_cap.cap;
>>>> +       u16 ht_cap = sta->ht_cap.cap;
>>>>         struct ieee80211_sta_vht_cap *vht_cap = &sta->vht_cap;
>>>>         int use_vht;
>>>>         int n_supported = 0;
>>>>         int ack_dur;
>>>>         int stbc;
>>>>         int i;
>>>> +       bool ldpc;
>>>>
>>>>         /* fall back to the old minstrel for legacy stations */
>>>>         if (!sta->ht_cap.ht_supported)
>>>> @@ -1210,16 +1211,24 @@ minstrel_ht_update_caps(void *priv, struct
>>>> ieee80211_supported_band *sband,
>>>>         }
>>>>         mi->sample_tries = 4;
>>>>
>>>> -       /* TODO tx_flags for vht - ATM the RC API is not fine-grained
>>>> enough */
>>>>         if (!use_vht) {
>>>> -               stbc = (sta_cap & IEEE80211_HT_CAP_RX_STBC) >>
>>>> +               stbc = (ht_cap & IEEE80211_HT_CAP_RX_STBC) >>
>>>>                         IEEE80211_HT_CAP_RX_STBC_SHIFT;
>>>> -               mi->tx_flags |= stbc << IEEE80211_TX_CTL_STBC_SHIFT;
>>>>
>>>> -               if (sta_cap & IEEE80211_HT_CAP_LDPC_CODING)
>>>> -                       mi->tx_flags |= IEEE80211_TX_CTL_LDPC;
>>>> +               if (ht_cap & IEEE80211_HT_CAP_LDPC_CODING)
>>>> +                       ldpc = true;
>>>> +       } else {
>>>> +               stbc = (vht_cap->cap & IEEE80211_VHT_CAP_RXSTBC_MASK) >>
>>>> +                       IEEE80211_VHT_CAP_RXSTBC_SHIFT;
>>>> +
>>>> +               if (vht_cap->cap & IEEE80211_VHT_CAP_RXLDPC)
>>>> +                       ldpc = true;
>>>>         }
>>>>
>>>> +       mi->tx_flags |= stbc << IEEE80211_TX_CTL_STBC_SHIFT;
>>>> +       if (ldpc)
>>>> +               mi->tx_flags |= IEEE80211_TX_CTL_LDPC;
>>>> +
>>>
>>>
>>> Here you are using ldpc uninitialized.
> yeah, will fix it.
Johannes,

How do you want to proceed? Do you want to
revert this patch and shall i send another patch?
