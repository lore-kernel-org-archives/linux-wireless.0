Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ig0-f180.google.com ([209.85.213.180]:37033 "EHLO
	mail-ig0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850AbbC0Od5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Mar 2015 10:33:57 -0400
Received: by igcxg11 with SMTP id xg11so21516367igc.0
        for <linux-wireless@vger.kernel.org>; Fri, 27 Mar 2015 07:33:56 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1426849379-7562-7-git-send-email-marek.puzyniak@tieto.com>
References: <1426849379-7562-1-git-send-email-marek.puzyniak@tieto.com>
	<1426849379-7562-7-git-send-email-marek.puzyniak@tieto.com>
Date: Fri, 27 Mar 2015 10:33:56 -0400
Message-ID: <CADnKcVhg8ZVD8Nn7pqjtCUWWOiO_8Zp7-U0zaMh4FKL-pj3bLg@mail.gmail.com> (sfid-20150327_153400_579884_D9925B14)
Subject: Re: [PATCH v4 6/6] ath10k: introduce basic tdls functionality
From: Marek Puzyniak <marek.puzyniak@tieto.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
Cc: Marek Puzyniak <marek.puzyniak@tieto.com>,
	Michal Kazior <michal.kazior@tieto.com>,
	Marek Kwaczynski <marek.kwaczynski@tieto.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Kalle,

On 20 March 2015 at 07:02, Marek Puzyniak <marek.puzyniak@tieto.com> wrote:
> This patch introduces tdls without tdls peer uapsd
> and tdls channel switching.
> Transmitting tdls data frames works only for ethernet
> type frames, that's why data addressed to tdls sta
> is in ethernet format.
>
> This patch depends on:
> mac80211: initialize rate control earlier for tdls station
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>
> Signed-off-by: Marek Kwaczynski <marek.kwaczynski@tieto.com>
> Signed-off-by: Marek Puzyniak <marek.puzyniak@tieto.com>
> ---
[...]

> +static int ath10_mac_tdls_vifs_count(struct ieee80211_hw *hw)
[...]
> +               num_tdls_vifs = ath10_mac_tdls_vifs_count(hw);
[...]

I found typo in my patch. This can be fixed by

diff --git a/drivers/net/wireless/ath/ath10k/mac.c
b/drivers/net/wireless/ath/ath10k/mac.c
index 4e2be87..5eb6c98 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -4613,7 +4613,7 @@ static void ath10k_mac_tdls_vifs_count_iter(void
*data, u8 *mac,
                (*num_tdls_vifs)++;
 }

-static int ath10_mac_tdls_vifs_count(struct ieee80211_hw *hw)
+static int ath10k_mac_tdls_vifs_count(struct ieee80211_hw *hw)
 {
        int num_tdls_vifs = 0;

@@ -4704,7 +4704,7 @@ static int ath10k_sta_state(struct ieee80211_hw *hw,
                        goto exit;

                num_tdls_stations = ath10k_mac_tdls_vif_stations_count(hw, vif);
-               num_tdls_vifs = ath10_mac_tdls_vifs_count(hw);
+               num_tdls_vifs = ath10k_mac_tdls_vifs_count(hw);

                if (num_tdls_vifs >= ar->max_num_tdls_vdevs &&
                    num_tdls_stations == 0) {


Should I resend this patch or whole patch-set, or maybe it can be
handled in another way.

Marek
