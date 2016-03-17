Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f53.google.com ([74.125.82.53]:36919 "EHLO
	mail-wm0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932832AbcCQLMd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Mar 2016 07:12:33 -0400
Received: by mail-wm0-f53.google.com with SMTP id p65so112002921wmp.0
        for <linux-wireless@vger.kernel.org>; Thu, 17 Mar 2016 04:12:32 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1458211740-6875-1-git-send-email-mohammed@qca.qualcomm.com>
References: <1458211740-6875-1-git-send-email-mohammed@qca.qualcomm.com>
Date: Thu, 17 Mar 2016 12:12:31 +0100
Message-ID: <CA+BoTQkk30nPEKiP-8FA2DcddJ_SL90txgHQeua7GCauR_M2dg@mail.gmail.com> (sfid-20160317_121237_476004_435B66D9)
Subject: Re: [PATCH v2 1/2] ath10k: Add support for ath10k_sta_statistics support
From: Michal Kazior <michal.kazior@tieto.com>
To: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
Cc: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	Kalle Valo <kvalo@qca.qualcomm.com>,
	"kvalo@codeaurora.org" <kvalo@codeaurora.org>,
	mohammed@codeaurora.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 17 March 2016 at 11:48, Mohammed Shafi Shajakhan
<mohammed@qti.qualcomm.com> wrote:
[...]
> +void ath10k_sta_statistics(struct ieee80211_hw *hw, struct ieee80211_vif *vif,
> +                          struct ieee80211_sta *sta,
> +                          struct station_info *sinfo)
> +{
> +       struct ath10k_sta *arsta = (struct ath10k_sta *)sta->drv_priv;
> +       struct ath10k *ar = arsta->arvif->ar;
> +
> +       mutex_lock(&ar->conf_mutex);
> +
> +       if (ar->state != ATH10K_STATE_ON &&
> +           ar->state != ATH10K_STATE_RESTARTED)
> +               goto out;

Do you really need mutex and ar->state check in this function?


Michał
