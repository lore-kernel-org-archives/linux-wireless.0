Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:18482 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932642AbcGOLte convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jul 2016 07:49:34 -0400
From: "Nagarajan, Ashok Raj" <arnagara@qti.qualcomm.com>
To: Ben Greear <greearb@candelatech.com>,
	"nbd@nbd.name" <nbd@nbd.name>, Kalle Valo <kvalo@codeaurora.org>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	"michal.kazior@tieto.com" <michal.kazior@tieto.com>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	"A. Benz" <ash.benz@bk.ru>
Subject: Re: ath10k/QCA9980 - Issues introduced in wireless testing 2016-05
Date: Fri, 15 Jul 2016 11:49:09 +0000
Message-ID: <1468583339047.52453@qti.qualcomm.com> (sfid-20160715_134938_090429_55B29232)
References: <ff65514a-47a3-2f32-658c-a2177401aa9a@bk.ru>
 <CA+BoTQmJ+JruxZ9WsG8Dnz=cwNY+e3Dy=g74-brS+0OE_5iu0Q@mail.gmail.com>
 <d836933e-ddbb-d10c-0715-6bce4396fd41@nbd.name>
 <877fdxfd2l.fsf@kamboji.qca.qualcomm.com> <575AB829.10101@candelatech.com>
 <f80db123-9b8a-289d-aed8-12531db13424@nbd.name>,<575ABDA2.9020609@candelatech.com>
In-Reply-To: <575ABDA2.9020609@candelatech.com>
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> On 06/10/2016 05:57 AM, Felix Fietkau wrote:
>>> On 2016-06-10 14:52, Ben Greear wrote:
>>> This looks a lot like the problems I was having.
>>>
>>> Two of these 5 patches recently made it upstream (but may not be in LEDE yet),
>>> but the other patches also were related to memory corruption.
>>>
>>> See my patches posted on 4/1/16:
>>>
>>> https://patchwork.kernel.org/project/ath10k/list/
>>>
>>> I don't know where the 5/5 patch ended up.
>> I had already asked affected users to test with those patches (I have a
>> commit that adds them in my staging tree), but it did not resolve the issue.
>
>Ok, must be something else then.
>
>If you can run on x86 under KASAN it may provide some clues..that is how I eventually
>made progress on the issues I was seeing.  My rebase onto 3.7 has been slow and painful,
>but I should be ready to start testing that sometime soon, maybe I can reproduce something
>there.

Hi Benz,

Could you please check with the following diff if it is solving your issue?

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 6f19fca..c192a41 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -1528,7 +1528,7 @@ static void ath10k_htt_rx_h_filter(struct ath10k *ar,
static int ath10k_htt_rx_handle_amsdu(struct ath10k_htt *htt)
{
        struct ath10k *ar = htt->ar;
-       static struct ieee80211_rx_status rx_status;
+       struct ieee80211_rx_status *rx_status = &htt->rx_status;
        struct sk_buff_head amsdu;
        int ret;
 
@@ -1553,11 +1553,11 @@ static int ath10k_htt_rx_handle_amsdu(struct ath10k_htt *htt)
        }
 
        ath10k_pktlog_rx(ar, &amsdu);
-       ath10k_htt_rx_h_ppdu(ar, &amsdu, &rx_status, 0xffff);
+       ath10k_htt_rx_h_ppdu(ar, &amsdu, rx_status, 0xffff);
        ath10k_htt_rx_h_unchain(ar, &amsdu, ret > 0);
-       ath10k_htt_rx_h_filter(ar, &amsdu, &rx_status);
-       ath10k_htt_rx_h_mpdu(ar, &amsdu, &rx_status);
-       ath10k_htt_rx_h_deliver(ar, &amsdu, &rx_status);
+       ath10k_htt_rx_h_filter(ar, &amsdu, rx_status);
+       ath10k_htt_rx_h_mpdu(ar, &amsdu, rx_status);
+       ath10k_htt_rx_h_deliver(ar, &amsdu, rx_status);

Thanks,
Ashok

>Thanks,
>Ben
