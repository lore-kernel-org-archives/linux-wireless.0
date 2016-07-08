Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:62165 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754903AbcGHM7e convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jul 2016 08:59:34 -0400
From: "Manoharan, Rajkumar" <rmanohar@qti.qualcomm.com>
To: Krishna Chaitanya <chaitanya.mgit@gmail.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	ath10k <ath10k@lists.infradead.org>
Subject: Re: ath10k + iw set bitrates is causing FW crash
Date: Fri, 8 Jul 2016 12:59:26 +0000
Message-ID: <1467982766213.21223@qti.qualcomm.com> (sfid-20160708_150002_473926_7B1C8270)
References: <CABPxzYLwye1t1Ycjr3nO5C18vc7OqS9dbbQ1yJ7B-YN+Bkx_PA@mail.gmail.com>
 <CABPxzYL5DHU7ZE1X1AibygBUz0TJEnNLLTp5_hDivmBBkjnVtg@mail.gmail.com>
 <1467972560885.99812@qti.qualcomm.com>,<CABPxzY+8Y-FHUFALGueN1hQwgjJHNpeyy_BRkrM4osguxJZS0Q@mail.gmail.com>
In-Reply-To: <CABPxzY+8Y-FHUFALGueN1hQwgjJHNpeyy_BRkrM4osguxJZS0Q@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I think security failures are due to peer unmap & map upon reassoc. Can you please try below change?

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 5e1cc8f4c43c..f7f04bb46fc8 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -5745,8 +5745,9 @@ static void ath10k_sta_rc_update_wk(struct work_struct *wk)
                                    sta->addr, smps, err);
        }

-       if (changed & IEEE80211_RC_SUPP_RATES_CHANGED ||
-           changed & IEEE80211_RC_NSS_CHANGED) {
+       if ((changed & IEEE80211_RC_SUPP_RATES_CHANGED ||
+           changed & IEEE80211_RC_NSS_CHANGED) &&
+           (arvif->vif->type == NL80211_IFTYPE_ADHOC)) {
                ath10k_dbg(ar, ATH10K_DBG_MAC, "mac update sta %pM supp rates/nss\n",
                           sta->addr);

-Rajkumar
________________________________________
From: Krishna Chaitanya <chaitanya.mgit@gmail.com>
Sent: Friday, July 8, 2016 5:26 PM
To: Manoharan, Rajkumar
Cc: linux-wireless; ath10k
Subject: Re: ath10k + iw set bitrates is causing FW crash

On Fri, Jul 8, 2016 at 3:39 PM, Manoharan, Rajkumar
<rmanohar@qti.qualcomm.com> wrote:
>>> I am using ath10k driver with qca988x hw2.0 and trying to limit it to use
>>> VHT MCS0-7 (iw set bitrates vht-mcs-5 2:0-7).
>>>
>>> But the command it causing a FW crash, if it disable HW_HAS_RATE_CONTROL
>>> no crash is observed but it still uses MCS9.
>>>
>>> tree: wireless-drivers-next: commit#535633a5ba4ea2504fa6c33176633becf0e59339
>>>
>>> 1) If i disable HW_RATE_CONTROL, will ath10k honor
>>> the mac80211 rates?
>>>
>>
> Thanks for reporting the issue. Could you please try with below change?
>
> diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
> index 5e1cc8f4c43c..cfa7e01a6103 100644
> --- a/drivers/net/wireless/ath/ath10k/mac.c
> +++ b/drivers/net/wireless/ath/ath10k/mac.c
> @@ -2812,6 +2812,9 @@ static int ath10k_station_assoc(struct ath10k *ar,
>                 return ret;
>         }
>
> +       if (vif->type != NL80211_IFTYPE_ADHOC)
> +               peer_arg.peer_reassoc = reassoc;
> +
>         ret = ath10k_wmi_peer_assoc(ar, &peer_arg);
>         if (ret) {
>                 ath10k_warn(ar, "failed to run peer assoc for STA %pM vdev %i: %d\n",

Thanks Raj, with this fix the rates are 0-7, if i disable then i am
seeing 0-9, so its
working.

But i am seeing a weird issues, the moment i give bitrates command,
ath10k no longer does encryption, link is a WPA2-PSK: AES. Even after
interface up/down
it doesn't work.
