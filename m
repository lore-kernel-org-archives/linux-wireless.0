Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:2770 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017Ab1K3FWW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Nov 2011 00:22:22 -0500
Message-ID: <4ED5BD76.7020204@qca.qualcomm.com> (sfid-20111130_062226_138975_CE71D3F8)
Date: Wed, 30 Nov 2011 10:51:58 +0530
From: Mohammed Shafi Shajakhan <mohammed@qca.qualcomm.com>
MIME-Version: 1.0
To: "John W. Linville" <linville@tuxdriver.com>,
	Vasanthakumar Thiagarajan <vthiagar@qca.qualcomm.com>,
	Jouni Malinen <jouni@qca.qualcomm.com>,
	<ath9k-devel@lists.ath9k.org>, <linux-wireless@vger.kernel.org>,
	Rodriguez Luis <rodrigue@qca.qualcomm.com>,
	Vivek Natarajan <nataraja@qualcomm.com>,
	Balasubramanian senthilkumar <senthilb@qca.qualcomm.com>,
	Rajkumar Manoharan <rmanohar@qca.qualcomm.com>
Subject: Re: [ath9k-devel] [RFC] ath9k: validate for non-zero BSSID
References: <1322576540-13751-1-git-send-email-mohammed@qca.qualcomm.com> <20111130023650.19520.qmail@stuge.se>
In-Reply-To: <20111130023650.19520.qmail@stuge.se>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Peter,

On Wednesday 30 November 2011 08:06 AM, Peter Stuge wrote:
> Mohammed Shafi Shajakhan wrote:
>> before concluding that the recieved beacon is for us, let us make sure
>> that the BSSID is non-zero.
>
> Under what circumstances would the BSSID be zero?
>
>
> //Peter

unassociated state for station.

but I observed this when i tested ad-hoc mode. I just started an ad-hoc 
mode creator and left it for some time with no one joining. i observed 
there are few frames in rx_tasklet of ath9k driver which seem to be 
beacons and their BSSID is '0', as our curbssid is also '0' they seem to 
be wrongly identified as 'my_beacons'. let me also verify it in STA mode 
and find the effect of this before sending it as a PATCH.
let me also check if it has any effect in ath9k_process_rssi and ath_rx_ps.

-- 
thanks,
shafi
