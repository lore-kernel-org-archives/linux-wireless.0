Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:49475 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757431AbaKUJDc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 21 Nov 2014 04:03:32 -0500
Received: by mail-wg0-f47.google.com with SMTP id n12so5945610wgh.34
        for <linux-wireless@vger.kernel.org>; Fri, 21 Nov 2014 01:03:30 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1416492382-18058-1-git-send-email-sujith@msujith.org>
References: <1416492382-18058-1-git-send-email-sujith@msujith.org>
Date: Fri, 21 Nov 2014 10:03:30 +0100
Message-ID: <CA+BoTQnyf0tvg8ngLqsoux-A9-3J46cDuJdd-V=kS24wWS4Y1A@mail.gmail.com> (sfid-20141121_100339_161520_01FC11E4)
Subject: Re: [RFC] ath10k: Fix shared WEP
From: Michal Kazior <michal.kazior@tieto.com>
To: Sujith Manoharan <sujith@msujith.org>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 20 November 2014 15:06, Sujith Manoharan <sujith@msujith.org> wrote:
> From: Sujith Manoharan <c_manoha@qca.qualcomm.com>
>
> When static keys are used in shared WEP, when a
> station is associated, message 3 is sent with an
> encrypted payload. But, for subsequent
> authentications that are triggered without a
> deauth, the auth frame is decrypted by the HW. To
> handle this, check if the WEP keys have already
> been set for the peer and if so, mark the
> frame as decrypted.

IOW This fixes a corner case when station reconnects but ath10k AP for
some reason didn't notice it (e.g. station went out of range and came
back before AP inactivity timer kicked in), right? Or is there another
scenario? It might be a good idea to include this in the commit log.


[...]
> diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
> index 1245ac8..e8fee46 100644
> --- a/drivers/net/wireless/ath/ath10k/mac.c
> +++ b/drivers/net/wireless/ath/ath10k/mac.c
> @@ -179,6 +179,31 @@ static int ath10k_clear_peer_keys(struct ath10k_vif *arvif,
>         return first_errno;
>  }
>
> +bool ath10k_is_peer_wep_key_set(struct ath10k *ar, const u8 *addr,
> +                               u8 keyidx)

Functions in mac.c should have ath10k_mac_ prefix. I'm aware not all
function follow this rule (albeit they should).


> +{
> +       struct ath10k_peer *peer;
> +       int i;
> +
> +       /*
> +        * We don't know which vdev this peer belongs to,
> +        * since WMI doesn't give us that information.
> +        */
> +       spin_lock_bh(&ar->data_lock);
> +       peer = ath10k_peer_find(ar, 0, addr);
> +       spin_unlock_bh(&ar->data_lock);

I don't think the above will work for mBSS, e.g. consider vdev_id=0
being an open network and vdev_id=1 being wep-shared. Maybe it's about
time to introduce ath10k_peer_find_by_addr(struct ath10k *ar, const u8
*)?


> +
> +       if (!peer)
> +               return false;
> +
> +       for (i = 0; i < ARRAY_SIZE(peer->keys); i++) {
> +               if (peer->keys[i] && peer->keys[i]->keyidx == keyidx)
> +                       return true;
> +       }

Read access to peer->keys should be protected by either data_lock or
conf_mutex. Obviously the latter can't be used because this function
will be called from an atomic context leaving the data_lock. The
entire is_peer_wep_key_set() should require data_lock to be held while
it is called to avoid races.

Oh, and apparently this is buggy anyway because
ath10k_install_peer_wep_keys() is oblivious to this. Oops..


[...]
> diff --git a/drivers/net/wireless/ath/ath10k/wmi.c b/drivers/net/wireless/ath/ath10k/wmi.c
> index c2bc828..8f1186e 100644
> --- a/drivers/net/wireless/ath/ath10k/wmi.c
> +++ b/drivers/net/wireless/ath/ath10k/wmi.c
> @@ -1113,6 +1113,33 @@ static inline u8 get_rate_idx(u32 rate, enum ieee80211_band band)
>         return rate_idx;
>  }
>
> +static void ath10k_check_wep(struct ath10k *ar, struct sk_buff *skb,
> +                            struct ieee80211_rx_status *status)

Function in wmi.c should have ath10k_wmi_ prefix. I also don't like
the name as it doesn't convey what it does in the slightest. Perhaps
ath10k_wmi_mgmt_rx_h_wep_reauth() or ath10k_wmi_handle_wep_reauth()
would be a bit better?


> +{
> +       struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
> +       unsigned int hdrlen;
> +       bool peer_key;
> +       u8 *addr, keyidx;
> +
> +       if (ieee80211_is_auth(hdr->frame_control) &&
> +           ieee80211_has_protected(hdr->frame_control)) {

My preference is to use guards in functions like these, i.e.
  if (!auth || !protected) return;
and then continue with the code without extra indentation.


> +               hdrlen = ieee80211_hdrlen(hdr->frame_control);
> +               if (skb->len < (hdrlen + 4))

It's probably a good idea to use IEEE80211_WEP_IV_LEN instead of literal 4.


> +                       return;
> +
> +               keyidx = skb->data[hdrlen + 3] >> 6;
> +               addr = ieee80211_get_SA(hdr);
> +               peer_key = ath10k_is_peer_wep_key_set(ar, addr, keyidx);
> +
> +               if (peer_key) {

Again, I'd do a guard: `if (!peer_key) return`. But I'm just picky :-P
I leave the final decision up to you or Kalle.


[...]
> @@ -1200,6 +1227,8 @@ static int ath10k_wmi_event_mgmt_rx(struct ath10k *ar, struct sk_buff *skb)
>         hdr = (struct ieee80211_hdr *)skb->data;
>         fc = le16_to_cpu(hdr->frame_control);
>
> +       ath10k_check_wep(ar, skb, status);
> +
>         /* FW delivers WEP Shared Auth frame with Protected Bit set and
>          * encrypted payload. However in case of PMF it delivers decrypted
>          * frames with Protected Bit set. */

This is getting a little messy. Did you consider to somehow unify the
previous wep shared & pmf code with your new fix?


Michał
