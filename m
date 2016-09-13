Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:53270 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752654AbcIMK7k (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 13 Sep 2016 06:59:40 -0400
From: "Valo, Kalle" <kvalo@qca.qualcomm.com>
To: Simon Wunderlich <sw@simonwunderlich.de>
CC: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "openwrt-devel@lists.openwrt.org" <openwrt-devel@lists.openwrt.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: ath10k mesh + ap + encryption?
Date: Tue, 13 Sep 2016 10:59:31 +0000
Message-ID: <87h99kjca5.fsf@kamboji.qca.qualcomm.com> (sfid-20160913_125944_333942_0A29EEBB)
References: <2661831.slnB0LOeVt@prime>
In-Reply-To: <2661831.slnB0LOeVt@prime> (Simon Wunderlich's message of "Tue,
        13 Sep 2016 10:00:23 +0200")
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Simon Wunderlich <sw@simonwunderlich.de> writes:

> we have done some experiments last week on ath10k, trying to run mesh=20
> (802.11s) and access point at the same time, both encrypted.=20
>
> We have tested a recent LEDE (reboot-1519-g42f559e) but with=20
> firmware-5.bin_10.2.4.70.42-2 and the included wpa_supplicant, which gave=
 us a=20
> working encrypted 802.11s network. However, starting an AP at the same ti=
me=20
> didn't work (AP doesn't beacon). This wasn't a problem when 802.11s was=20
> running unencrypted.
>
> We also tested version 10.2.4.97 (from codeaurora), which is now default =
in=20
> LEDE. However, this version apparently doesn't support 11s mesh at all=20
> (WMI_SERVICE_MESH_11S is disabled in the service map, but cfg/mac80211=20
> advertises support).
>
> So here are my questions:
>
>  * Did anyone succesfully run AP and mesh, both encrypted at the same tim=
e?
>  * Do you have any pointers how we could fix this? Could it be fixable in=
 the=20
> driver (i.e. not in firmware)?
>  * Does anyone have an idea if 11s will be supported in future versions? =
I=20
> didn't find any changelogs, but having 11s mode no longer in the service =
map=20
> does not make me optimistic.

Why is LEDE using 10.2.4.97? It seems to be a quite old release and I
have no knowledge if anyone even tests that firmware branch with ath10k.
I recommend to only use firmware releases from ath10k-firmware.git as we
use those internally with ath10k. In any case, don't make any
assumptions about future from that firmware branch as it's so old.

--=20
Kalle Valo=
