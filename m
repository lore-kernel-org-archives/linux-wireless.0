Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:18824 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753053AbdFPIuY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Jun 2017 04:50:24 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Sven Eckelmann <sven.eckelmann@openmesh.com>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        Ben Greear <greearb@candelatech.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2 2/3] ath10k: Configure rxnss_override for 10.4
 firmware.
Date: Fri, 16 Jun 2017 08:50:13 +0000
Message-ID: <87o9toz58b.fsf@kamboji.qca.qualcomm.com> (sfid-20170616_105043_751640_A5A48853)
References: <20170609110750.14950-1-sven.eckelmann@openmesh.com>
        <20170609110750.14950-2-sven.eckelmann@openmesh.com>
In-Reply-To: <20170609110750.14950-2-sven.eckelmann@openmesh.com> (Sven
        Eckelmann's message of "Fri, 9 Jun 2017 13:07:49 +0200")
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sven Eckelmann <sven.eckelmann@openmesh.com> writes:

> From: Ben Greear <greearb@candelatech.com>
>
> QCA9984 hardware can do 4x4 at 80Mhz, but only 2x2 at 160Mhz.
>
> First, report this to user-space by setting the max-tx-speed
> and max-rx-speed vht capabilities.
>
> Second, if the peer rx-speed is configured, and if we
> are in 160 or 80+80 mode, and the peer rx-speed matches
> the max speed for 2x2 or 1x1 at 160Mhz (long guard interval),
> then use that info to set the peer_bw_rxnss_override appropriately.
>
> Without this, a 9984 firmware will not use 2x2 ratesets when
> transmitting to peer (it will be stuck at 1x1), because
> the firmware would not have configured the rxnss_override.
>
> This could use some testing....

Sven, I assume you have tested this so I removed the last sentence.

> @@ -4408,6 +4422,23 @@ static struct ieee80211_sta_vht_cap ath10k_create_=
vht_cap(struct ath10k *ar)
>  	vht_cap.vht_mcs.rx_mcs_map =3D cpu_to_le16(mcs_map);
>  	vht_cap.vht_mcs.tx_mcs_map =3D cpu_to_le16(mcs_map);
> =20
> +	/* If we are supporting 160Mhz or 80+80, then the NIC may be able to do
> +	 * a restricted NSS for 160 or 80+80 vs what it can do for 80Mhz.  Give
> +	 * user-space a clue if that is the case.
> +	 */
> +	if (vht_cap.cap & IEEE80211_VHT_CAP_SUPP_CHAN_WIDTH_MASK) {
> +		switch (ar->dev_id) {
> +		case QCA9984_1_0_DEVICE_ID:
> +			/* Can do only 2x2 VHT160 or 80+80.
> +			 * 1560Mbps is 4x4 80Mhz or 2x2 160Mhz,
> +			 * long-guard-interval
> +			 */
> +			vht_cap.vht_mcs.rx_highest =3D 1560;
> +			vht_cap.vht_mcs.tx_highest =3D 1560;
> +			break;
> +		}
> +	}

We have hw_params for stuff like this so I changed this and the
following patch to use that. Please review:

https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git/commit/?h=3Dp=
ending&id=3D81f55f2a3e1837287a52de6577ca89a2c7393456

https://git.kernel.org/pub/scm/linux/kernel/git/kvalo/ath.git/commit/?h=3Dp=
ending&id=3D09ce674529472c8deca41fbb28bad59e03330321

--=20
Kalle Valo=
