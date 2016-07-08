Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:18512 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754251AbcGHKJ3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Jul 2016 06:09:29 -0400
From: "Manoharan, Rajkumar" <rmanohar@qti.qualcomm.com>
To: Krishna Chaitanya <chaitanya.mgit@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	ath10k <ath10k@lists.infradead.org>
Subject: Re: ath10k + iw set bitrates is causing FW crash
Date: Fri, 8 Jul 2016 10:09:21 +0000
Message-ID: <1467972560885.99812@qti.qualcomm.com> (sfid-20160708_120933_470414_4C9CED03)
References: <CABPxzYLwye1t1Ycjr3nO5C18vc7OqS9dbbQ1yJ7B-YN+Bkx_PA@mail.gmail.com>,<CABPxzYL5DHU7ZE1X1AibygBUz0TJEnNLLTp5_hDivmBBkjnVtg@mail.gmail.com>
In-Reply-To: <CABPxzYL5DHU7ZE1X1AibygBUz0TJEnNLLTp5_hDivmBBkjnVtg@mail.gmail.com>
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>> I am using ath10k driver with qca988x hw2.0 and trying to limit it to use
>> VHT MCS0-7 (iw set bitrates vht-mcs-5 2:0-7).
>>
>> But the command it causing a FW crash, if it disable HW_HAS_RATE_CONTROL
>> no crash is observed but it still uses MCS9.
>>
>> tree: wireless-drivers-next: commit#535633a5ba4ea2504fa6c33176633becf0e59339
>>
>> 1) If i disable HW_RATE_CONTROL, will ath10k honor
>> the mac80211 rates?
>>
>
Thanks for reporting the issue. Could you please try with below change?

diff --git a/drivers/net/wireless/ath/ath10k/mac.c b/drivers/net/wireless/ath/ath10k/mac.c
index 5e1cc8f4c43c..cfa7e01a6103 100644
--- a/drivers/net/wireless/ath/ath10k/mac.c
+++ b/drivers/net/wireless/ath/ath10k/mac.c
@@ -2812,6 +2812,9 @@ static int ath10k_station_assoc(struct ath10k *ar,
                return ret;
        }

+       if (vif->type != NL80211_IFTYPE_ADHOC)
+               peer_arg.peer_reassoc = reassoc;
+
        ret = ath10k_wmi_peer_assoc(ar, &peer_arg);
        if (ret) {
                ath10k_warn(ar, "failed to run peer assoc for STA %pM vdev %i: %d\n",
