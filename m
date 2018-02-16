Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wr0-f176.google.com ([209.85.128.176]:43368 "EHLO
        mail-wr0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933125AbeBPKza (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 16 Feb 2018 05:55:30 -0500
Received: by mail-wr0-f176.google.com with SMTP id b52so2444747wrd.10
        for <linux-wireless@vger.kernel.org>; Fri, 16 Feb 2018 02:55:29 -0800 (PST)
From: Sven Eckelmann <sven.eckelmann@openmesh.com>
To: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
Cc: ath10k@lists.infradead.org, mohammed@codeaurora.org,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 2/2] ath10k: fix CCK h/w rates for QCA99X0 and newer chipsets
Date: Fri, 16 Feb 2018 11:55:26 +0100
Message-ID: <1934280.TgFv3YZ0ZR@bentobox> (sfid-20180216_115534_534894_FB0502D1)
In-Reply-To: <1464852235-13110-2-git-send-email-mohammed@qca.qualcomm.com>
References: <1464852235-13110-1-git-send-email-mohammed@qca.qualcomm.com> <1464852235-13110-2-git-send-email-mohammed@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="nextPart2072417.djJGnljY5C"; micalg="pgp-sha512"; protocol="application/pgp-signature"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--nextPart2072417.djJGnljY5C
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"

On Donnerstag, 2. Juni 2016 12:53:55 CET Mohammed Shafi Shajakhan wrote:
> From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>
> 
> CCK hardware table mapping from QCA99X0 onwards got revised.
> The CCK hardware rate values are in a proper order wrt. to
> rate and preamble as below
> 
> ATH10K_HW_RATE_REV2_CCK_LP_1M = 1,
> ATH10K_HW_RATE_REV2_CCK_LP_2M = 2,
> ATH10K_HW_RATE_REV2_CCK_LP_5_5M = 3,
> ATH10K_HW_RATE_REV2_CCK_LP_11M = 4,
> ATH10K_HW_RATE_REV2_CCK_SP_2M = 5,
> ATH10K_HW_RATE_REV2_CCK_SP_5_5M = 6,
> ATH10K_HW_RATE_REV2_CCK_SP_11M = 7,
> 
> This results in reporting of rx frames (with CCK rates)
> totally wrong for QCA99X0, QCA4019. Fix this by having
> separate CCK rate table for these chipsets with rev2 suffix
> and registering the correct rate mapping to mac80211 based on
> the new hw_param (introduced) 'cck_rate_map_rev2' which shall
> be true for any newchipsets from QCA99X0 onwards

I just tested it here with QCA4019 + 10.4-3.2.1-00050 for beacons. The 
calculated HW code for 1.0 MBit/s would be 0x41 (rate_code) according to this 
new mapping. But when I set it with 

    	ret = ath10k_wmi_vdev_set_param(ar, arvif->vdev_id,
    					ar->wmi.vdev_param->mcast_data_rate,
    					rate_code);

then it sends beacons with 5.5Mbit/s and not with 1.0Mbit/s.

Btw. the rate_code was calculated using:

    		if (ath10k_mac_bitrate_is_cck(sband->bitrates[i].bitrate))
    			preamble = WMI_RATE_PREAMBLE_CCK;
    		else
    			preamble = WMI_RATE_PREAMBLE_OFDM;
    
    		rate_code = ATH10K_HW_RATECODE(hw_value, 0, preamble);

It works fine when using the old mapping (0x43).

This made me rather curious and I've connected a client to the AP which was 
only able to send at 1.0 Mbit/s - this actually resulted in the correctly 
reported rates at in the rx field.

Does this mean that the rates are now inconsistent because the QCA fw doesn't 
provide a consistent interface for hw rates or did I miss anything?

Kind regards,
	Sven
--nextPart2072417.djJGnljY5C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part.
Content-Transfer-Encoding: 7Bit

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEEF10rh2Elc9zjMuACXYcKB8Eme0YFAlqGuJ4ACgkQXYcKB8Em
e0aEuhAAl7DE96Z10IGK7OiZJ5jd7nURAaGqVuZ9Ip5Pc9bn2Ilh1ZqKi5mOUydL
B37+skEIrmS/8aOknBy5dJuWSttX5qHEKEmRjko1ayN82PPgB3e4EupbQ0wso9KE
Ajhs2CL43IQgCTW87tSbtbC38PX7Y8tCcIckxvvKbeNBbDwZNyHbry9eGElWaUrh
XMMI21dgjpFk/YxyC0g0SGoUH4fvbTzmLN+ppiyqsobbS7BIASRvV5iLneiIjJeD
QX0+cKTe52I+AsW1p7tLzRrTsc2n9mNFwpS7wQ+lFwmfOTXMDXZGIThHb38yI+4B
WTa+vxM89oTw/p+j5YHRCVIK8m69TXMtFUSzUUV7zEgrPAEWCkk5fIuTLU091Nu2
04D2BjOao/1pQW7I2/QHHoYjsw0QWMFIgXM1XnftaObVWoT+uV98w5qLwKaDxJdy
xY568H+9ZkodAgreP8tB1WazsicwHNg0B6yaVgTrPDm199peOGp5P2euZGn6QXeO
tkyjAbczE9nuA3uXgjHtwEXOJ5F8bIby9eswz3X5l6/hLXNWqBwvSTFyvGgCQHQL
q4f9Inx3uqCXIvdYag4hamT5JlvQ7YFAK1WsRDKftyVTnMu8h2ZUXyeWBeTfWLb0
bUaGZSmfxLSxgvQmpEXhwfX8wa0ItqjFSKqApUzeVovbujSJvjA=
=WfZW
-----END PGP SIGNATURE-----

--nextPart2072417.djJGnljY5C--
