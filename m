Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f42.google.com ([74.125.82.42]:57940 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755112AbaGPMfp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 Jul 2014 08:35:45 -0400
Received: by mail-wg0-f42.google.com with SMTP id l18so807802wgh.1
        for <linux-wireless@vger.kernel.org>; Wed, 16 Jul 2014 05:35:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <53C66422.10702@gmail.com>
References: <1405505855-13741-1-git-send-email-michal.kazior@tieto.com>
	<1405509540-32691-1-git-send-email-michal.kazior@tieto.com>
	<53C66422.10702@gmail.com>
Date: Wed, 16 Jul 2014 14:35:41 +0200
Message-ID: <CA+BoTQn8TYX4vDx=K4P5rE+LBXrrUL2q1E7GsiOpBj82QgRKsw@mail.gmail.com> (sfid-20140716_143549_049995_40250EB1)
Subject: Re: [PATCH v3] ath10k: fix Rx aggregation reordering
From: Michal Kazior <michal.kazior@tieto.com>
To: Varka Bhadram <varkabhadram@gmail.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Denton Gentry <denton.gentry@gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 16 July 2014 13:38, Varka Bhadram <varkabhadram@gmail.com> wrote:
> On 07/16/2014 04:49 PM, Michal Kazior wrote:
>
> (...)
>
>
>> +static void ath10k_htt_rx_addba(struct ath10k *ar, struct htt_resp *resp)
>> +{
>> +       struct htt_rx_addba *ev = &resp->rx_addba;
>> +       struct ath10k_peer *peer;
>> +       struct ath10k_vif *arvif;
>> +       u16 info0, tid, peer_id;
>> +
>> +       info0 = __le32_to_cpu(ev->info0);
>> +       tid = MS(info0, HTT_RX_BA_INFO0_TID);
>> +       peer_id = MS(info0, HTT_RX_BA_INFO0_PEER_ID);
>> +
>> +       ath10k_dbg(ATH10K_DBG_HTT,
>> +                  "htt rx addba tid %hu peer_id %hu size %hhu\n",
>> +                  tid, peer_id, ev->window_size);
>> +
>> +       spin_lock_bh(&ar->data_lock);
>> +       peer = ath10k_peer_find_by_id(ar, peer_id);
>> +       if (!peer) {
>> +               ath10k_warn("received addba event for invalid peer_id:
>> %hu\n",
>> +                           peer_id);
>> +               spin_unlock_bh(&ar->data_lock);
>> +               return;
>> +       }
>
>
> Here my concern in amount of time holding the lock...
>
> spin_lock_bh(&ar->data_lock);
> peer = ath10k_peer_find_by_id(ar, peer_id);
> if (!peer) {
>         spin_unlock_bh(&ar->data_lock);
>
>         ath10k_warn("received addba event for invalid peer_id: %hu\n",
>                     peer_id);
>         return;
> }
>
> No need to of putting the debug message inside the critical region...  :-)

Sounds reasonable in this case as I'm not printing spinlock-protected values.


[...]
>>   +static int ath10k_ampdu_action(struct ieee80211_hw *hw,
>> +                              struct ieee80211_vif *vif,
>> +                              enum ieee80211_ampdu_mlme_action action,
>> +                              struct ieee80211_sta *sta, u16 tid, u16
>> *ssn,
>> +                              u8 buf_size)
>> +{
>> +       struct ath10k_vif *arvif = ath10k_vif_to_arvif(vif);
>> +
>> +       ath10k_dbg(ATH10K_DBG_MAC, "mac ampdu vdev_id %i sta %pM tid %hu
>> action %d\n",
>> +                  arvif->vdev_id, sta->addr, tid, action);
>> +
>> +       switch (action) {
>> +       case IEEE80211_AMPDU_RX_START:
>> +       case IEEE80211_AMPDU_RX_STOP:
>> +               /* HTT AddBa/DelBa events trigger mac80211 Rx BA session
>> +                * creation/removal. Do we need to verify this?
>> +                */
>> +               return 0;
>> +       case IEEE80211_AMPDU_TX_START:
>> +       case IEEE80211_AMPDU_TX_STOP_CONT:
>> +       case IEEE80211_AMPDU_TX_STOP_FLUSH:
>> +       case IEEE80211_AMPDU_TX_STOP_FLUSH_CONT:
>> +       case IEEE80211_AMPDU_TX_OPERATIONAL:
>> +               /* Firmware offloads Tx aggregation entirely so deny
>> mac80211
>> +                * Tx aggregation requests.
>> +                */
>> +               break;
>
>
> Instead of break here we can directly do: return -EOPNOTSUPP;

True.


Thanks for review. I'll wait a bit more before I re-post v4 (although
there's no rush since the patch needs mac80211 patches to be applied
first).


Michał
