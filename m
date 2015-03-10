Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f171.google.com ([209.85.212.171]:39913 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752397AbbCJKVP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 10 Mar 2015 06:21:15 -0400
Received: by wiwl15 with SMTP id l15so28780681wiw.4
        for <linux-wireless@vger.kernel.org>; Tue, 10 Mar 2015 03:21:14 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1425905138-9966-4-git-send-email-marek.puzyniak@tieto.com>
References: <1425905138-9966-1-git-send-email-marek.puzyniak@tieto.com>
	<1425905138-9966-4-git-send-email-marek.puzyniak@tieto.com>
Date: Tue, 10 Mar 2015 11:21:14 +0100
Message-ID: <CA+BoTQnhnUwXkfk7ZGJW_sVsvbohYKs-2JxSXwzYz0TScGiSFw@mail.gmail.com> (sfid-20150310_112121_390199_72F04080)
Subject: Re: [PATCH v3 3/3] ath10k: introduce basic tdls functionality
From: Michal Kazior <michal.kazior@tieto.com>
To: Marek Puzyniak <marek.puzyniak@tieto.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Marek Kwaczynski <marek.kwaczynski@tieto.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 9 March 2015 at 13:45, Marek Puzyniak <marek.puzyniak@tieto.com> wrote:
> This patch adds functions to enable/disable tdls
> and to configure tdls peer station for tlv based firmware.
> Tdls peer uapsd and tdls channel switching are not supported.
> Transmitting tdls data frames works only for ethernet
> type frames, that's why data addressed to tdls sta
> is in ethernet format.
>
> Tdls functionality for ath10k requires changes in mac80211
> provided in patch:
> mac80211: initialize rate control earlier for tdls station
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
> Signed-off-by: Marek Kwaczynski <marek.kwaczynski@tieto.com>
> Signed-off-by: Marek Puzyniak <marek.puzyniak@tieto.com>
> ---
[...]

Currently the patch doesn't account for the number of connected TDLS
station properly. This can lead to firmware crash when number of
allowed station peers is exceeded:

> ath10k_pci 0000:04:00.0 mac vdev 0 peer create 68:94:23:c6:1f:33 (new sta) sta 1 / 32 peer 33 / 37
> [...]
> ath10k_pci 0000:04:00.0 firmware crashed! (uuid 4f652378-c66d-43ff-989d-00f376ff11dc)


Function ath10k_mac_{inc,dec}_num_stations() need to be fixed so that
ar->num_stations (the following was *not* tested), e.g.:

--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -4411,14 +4411,14 @@ static void ath10k_sta_rc_update_wk(struct
work_struct *wk)
        mutex_unlock(&ar->conf_mutex);
 }

-static int ath10k_mac_inc_num_stations(struct ath10k_vif *arvif)
+static int ath10k_mac_inc_num_stations(struct ath10k_vif *arvif,
+                                      struct ieee80211_sta *sta)
 {
        struct ath10k *ar = arvif->ar;

        lockdep_assert_held(&ar->conf_mutex);

-       if (arvif->vdev_type != WMI_VDEV_TYPE_AP &&
-           arvif->vdev_type != WMI_VDEV_TYPE_IBSS)
+       if (arvif->vdev_type == WMI_VDEV_TYPE_STA && !sta->tdls)
                return 0;

        if (ar->num_stations >= ar->max_num_stations)
@@ -4435,8 +4435,7 @@ static void ath10k_mac_dec_num_stations(struct
ath10k_vif *arvif)

        lockdep_assert_held(&ar->conf_mutex);

-       if (arvif->vdev_type != WMI_VDEV_TYPE_AP &&
-           arvif->vdev_type != WMI_VDEV_TYPE_IBSS)
+       if (arvif->vdev_type == WMI_VDEV_TYPE_STA && !sta->tdls)
                return;

        ar->num_stations--;


Michał
