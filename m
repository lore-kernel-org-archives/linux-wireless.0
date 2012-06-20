Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:40502 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752626Ab2FTAhm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jun 2012 20:37:42 -0400
Received: by lbbgm6 with SMTP id gm6so6501679lbb.19
        for <linux-wireless@vger.kernel.org>; Tue, 19 Jun 2012 17:37:41 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1340120850-9155-6-git-send-email-mohammed@qca.qualcomm.com>
References: <1340120850-9155-1-git-send-email-mohammed@qca.qualcomm.com> <1340120850-9155-6-git-send-email-mohammed@qca.qualcomm.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Wed, 20 Jun 2012 10:37:20 +1000
Message-ID: <CAGRGNgUhCvTVaCd7KxuvP5ZUNED2vN7yFHdL27Jp+sg183KobQ@mail.gmail.com> (sfid-20120620_023745_982507_5D73EA2F)
Subject: Re: [PATCH 05/10] ath9k: advertise supported WoW flags to upper layer
To: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, ath9k-devel@lists.ath9k.org,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>,
	Sujith Manoharan <c_manoha@qca.qualcomm.com>,
	vadivel@qca.qualcomm.com, rhu@qca.qualcomm.com,
	aeolus@qca.qualcomm.com,
	Senthil Balasubramanian <senthilb@qca.qualcomm.com>,
	"Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Mohammed,

On Wed, Jun 20, 2012 at 1:47 AM, Mohammed Shafi Shajakhan
<mohammed@qca.qualcomm.com> wrote:
> From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
>
> currently the code supports WoW triggers due to
> *magic packet
> *user defined patterns
> *deauth and disassoc patterns
> *disconnect - beacon miss, last beacon received timeout,
> no ack for keeep alive frames.
>
> we need to support other WoW offload features in the
> near future. also a minor cleanup.
>
> Cc: Senthil Balasubramanian <senthilb@qca.qualcomm.com>
> Cc: Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
> Cc: vadivel@qca.qualcomm.com
> Tested-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
> Signed-off-by: Luis R. Rodriguez <mcgrof@qca.qualcomm.com>
> Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
> ---
>  drivers/net/wireless/ath/ath9k/init.c |   20 ++++++++++++++++++--
>  1 files changed, 18 insertions(+), 2 deletions(-)
>
> diff --git a/drivers/net/wireless/ath/ath9k/init.c b/drivers/net/wireless/ath/ath9k/init.c
> index 9dfce1a..d08824f 100644
> --- a/drivers/net/wireless/ath/ath9k/init.c
> +++ b/drivers/net/wireless/ath/ath9k/init.c
> @@ -688,8 +688,8 @@ void ath9k_set_hw_capab(struct ath_softc *sc, struct ieee80211_hw *hw)
>                IEEE80211_HW_SPECTRUM_MGMT |
>                IEEE80211_HW_REPORTS_TX_ACK_STATUS;
>
> -       if (sc->sc_ah->caps.hw_caps & ATH9K_HW_CAP_HT)
> -                hw->flags |= IEEE80211_HW_AMPDU_AGGREGATION;
> +       if (ah->caps.hw_caps & ATH9K_HW_CAP_HT)
> +               hw->flags |= IEEE80211_HW_AMPDU_AGGREGATION;

This doesn't look like it belongs with the rest of the patch.

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
