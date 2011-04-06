Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:41438 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753325Ab1DFQYX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 6 Apr 2011 12:24:23 -0400
Message-ID: <4D9C93B0.5050806@openwrt.org>
Date: Wed, 06 Apr 2011 18:24:16 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Rajkumar Manoharan <rmanoharan@atheros.com>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org
Subject: Re: [PATCH v3] ath9k_hw: Fix instable target power control b/w CCK/OFDM
References: <1302106372-4622-1-git-send-email-rmanoharan@atheros.com>
In-Reply-To: <1302106372-4622-1-git-send-email-rmanoharan@atheros.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-04-06 6:12 PM, Rajkumar Manoharan wrote:
> The problem is that when the attenuation is increased,
> the rate will start to drop from MCS7 ->  MCS6, and finally
> will see MCS1 ->  CCK_11Mbps. When the rate is changed b/w
> CCK and OFDM, it will use register desired_scale to calculate
> how much tx gain need to change.
>
> The output power with the same tx gain for CCK and OFDM modulated
> signals are different. This difference is constant for AR9280
> but not AR9285/AR9271. It has different PA architecture
> a constant. So it should be calibrated against this PA
> characteristic.
>
> The driver has to read the calibrated values from EEPROM and set
> the tx power registers accordingly.
>
> Cc: Felix Fietkau<nbd@openwrt.org>
> Signed-off-by: Rajkumar Manoharan<rmanoharan@atheros.com>
Acked-by: Felix Fietkau <nbd@openwrt.org>

Thanks,

- Felix
