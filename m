Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sabertooth01.qualcomm.com ([65.197.215.72]:21149 "EHLO
	sabertooth01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750756AbbCSNxJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Mar 2015 09:53:09 -0400
From: Kalle Valo <kvalo@qca.qualcomm.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] ath10k: strip qos data bit always
References: <1426080326-14764-1-git-send-email-michal.kazior@tieto.com>
Date: Thu, 19 Mar 2015 15:53:00 +0200
In-Reply-To: <1426080326-14764-1-git-send-email-michal.kazior@tieto.com>
	(Michal Kazior's message of "Wed, 11 Mar 2015 14:25:26 +0100")
Message-ID: <871tkljdqb.fsf@kamboji.qca.qualcomm.com> (sfid-20150319_145314_082582_D2F3219E)
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> writes:

> NativeWifi tx mode expects QoS Data frames to be
> delivered as Data frames with QoS part (e.g. tid)
> being delievered out-of-band in fw tx command.
>
> The QoS bit wasn't stripped before submitting to
> firmware.
>
> Stripping fixes two known problems:
>
>  * qca6174 IOT with some APs, e.g.
>    Cisco AIR-AP 1252 (which would crash after
>    ath10k association). Some ath9k APs would
>    crash as well.
>
>  * sniffing own tx frames via radiotap because,
>    e.g. wireshark was seeing QoS bit set but
>    since QoS Control was stripped in ath10k it
>    would parse beginning of LLC/SNAP
>
>>From debugability point of view this removes the
> ability to distinguish QoS from non-QoS frames
> when sniffing own tx via radiotap. On the other
> hand frames can be now parsed correctly without
> special software modification.
>
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

Thanks, applied.

-- 
Kalle Valo
