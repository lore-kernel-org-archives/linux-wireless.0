Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:18854 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753271AbcGSNZi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 Jul 2016 09:25:38 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [v2,1/3] ath6kl: Fix WLAN tethering authentication problem.
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <20160704110719.7694-2-plemagourou@aldebaran.com>
To: Pierre Le Magourou <lemagoup@gmail.com>
CC: <ath6kl@lists.infradead.org>, <linux-wireless@vger.kernel.org>,
	<jmassot@aldebaran.com>,
	Pierre Le Magourou <plemagourou@aldebaran.com>
Message-ID: <06867d9bc8ea4576a185988928d8b0ec@euamsexm01a.eu.qualcomm.com> (sfid-20160719_152547_674547_9F927BC2)
Date: Tue, 19 Jul 2016 15:25:31 +0200
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Pierre Le Magourou <lemagoup@gmail.com> wrote:
> From: Pierre Le Magourou <plemagourou@aldebaran.com>
> 
> When enabling WLAN tethering, a new AP is visible and a STA could
> connect to it. When the STA tries to authenticate to the newly created
> AP, the WPA authentication mechanism is stuck in the 1/4 msg of 4-Way
> Handshake.
> 
> In ath6kl_rx(), the ath6kl_find_sta() function is looking for the
> h_source field of the Ethernet frame header received by the STA. The
> datap pointer that points to the Ethernet frame header is incorrect,
> and was pointing at the wrong offset in the buffer.
> 
> This commit adds a pad_before_data_start offset to set the datap pointer
> to the Ethernet frame header. datap->h_source parameter is now really
> pointing to the source ethernet address and the authentication process
> can continue.
> 
> Signed-off-by: Pierre Le Magourou <plemagourou@aldebaran.com>

Thanks, 3 patches applied to ath-next branch of ath.git:

270df8f80d67 ath6kl: Fix WLAN tethering authentication problem.
f3651bae5644 ath6kl: Fix wrong regulatory domain disconnection.
76b817f6c9a9 ath6kl: Unset IFF_LOWER_UP flag on AP mode leave.

-- 
Sent by pwcli
https://patchwork.kernel.org/patch/9212263/

