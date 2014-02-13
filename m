Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f44.google.com ([209.85.214.44]:49811 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750903AbaBMOrX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Feb 2014 09:47:23 -0500
Received: by mail-bk0-f44.google.com with SMTP id mz12so3103734bkb.31
        for <linux-wireless@vger.kernel.org>; Thu, 13 Feb 2014 06:47:21 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <87eh379jcm.fsf@kamboji.qca.qualcomm.com>
References: <1391673591-8907-1-git-send-email-michal.kazior@tieto.com>
	<87eh379jcm.fsf@kamboji.qca.qualcomm.com>
Date: Thu, 13 Feb 2014 15:47:21 +0100
Message-ID: <CA+BoTQnC3uVQguO8U+nP9Q7mLypZ77hVBaiS-tqxSMBh6Ph4xQ@mail.gmail.com> (sfid-20140213_154725_409131_40F503B2)
Subject: Re: [PATCH] ath10k: fix SMPS support
From: Michal Kazior <michal.kazior@tieto.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 13 February 2014 15:29, Kalle Valo <kvalo@qca.qualcomm.com> wrote:
> Michal Kazior <michal.kazior@tieto.com> writes:
>
>> Firmware ignores SMPS flags in peer assoc command.
>>
>> For SMPS to work it is necessary to set peer
>> parameter after peer assoc command so that tx
>> chainmask is setup properly.
>>
>> This should fix packet loss and improve throughput
>> with stations that have SMPS enabled upon
>> association.
>>
>> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
>
> [...]
>
>> +static const u32 ath10k_smps_map[] = {
>> +     [WLAN_HT_CAP_SM_PS_STATIC] = WMI_PEER_SMPS_STATIC,
>> +     [WLAN_HT_CAP_SM_PS_DYNAMIC] = WMI_PEER_SMPS_DYNAMIC,
>> +     [WLAN_HT_CAP_SM_PS_INVALID] = WMI_PEER_SMPS_PS_NONE,
>> +     [WLAN_HT_CAP_SM_PS_DISABLED] = WMI_PEER_SMPS_PS_NONE,
>> +};
>> +
>> +static int ath10k_setup_peer_smps(struct ath10k *ar, struct ath10k_vif *arvif,
>> +                               const u8 *addr,
>> +                               const struct ieee80211_sta_ht_cap *ht_cap)
>> +{
>> +     int smps;
>> +
>> +     if (!ht_cap->ht_supported)
>> +             return 0;
>> +
>> +     smps = ht_cap->cap & IEEE80211_HT_CAP_SM_PS;
>> +     smps >>= IEEE80211_HT_CAP_SM_PS_SHIFT;
>> +
>> +     if (smps >= ARRAY_SIZE(ath10k_smps_map))
>> +             return -EINVAL;
>> +
>> +     return ath10k_wmi_peer_set_param(ar, arvif->vdev_id, addr,
>> +                                      WMI_PEER_SMPS_STATE,
>> +                                      ath10k_smps_map[smps]);
>> +}
>
> ath10k_smps_map looks overkill (and fragile), wouldn't a switch
> statement be simpler?

The map shouldn't really ever change since it depends on the 11n spec.
I just prefer it this way as it's shorter and easier to grasp. I can
change it to a switch() if you insist.


>> @@ -1370,6 +1385,7 @@ static void ath10k_bss_assoc(struct ieee80211_hw *hw,
>>  {
>>       struct ath10k *ar = hw->priv;
>>       struct ath10k_vif *arvif = ath10k_vif_to_arvif(vif);
>> +     struct ieee80211_sta_ht_cap ht_cap;
>>       struct wmi_peer_assoc_complete_arg peer_arg;
>>       struct ieee80211_sta *ap_sta;
>>       int ret;
>> @@ -1386,6 +1402,8 @@ static void ath10k_bss_assoc(struct ieee80211_hw *hw,
>>               return;
>>       }
>>
>> +     ht_cap = ap_sta->ht_cap;
>
> Why do you copy ht_cap? I can't figure out the reason.

It is used by ath10k_setup_peer_smps() which might sleep as it sends
wmi command. This means we have to leave rcu section and must not
touch ap_sta pointer anymore.


Michał
