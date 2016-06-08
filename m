Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:50299 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752067AbcFHPw4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Jun 2016 11:52:56 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Date: Wed, 08 Jun 2016 21:22:55 +0530
From: Rajkumar Manoharan <rmanohar@codeaurora.org>
To: Mike Lothian <mike@fireburn.co.uk>
Cc: Ben Greear <greearb@candelatech.com>,
	"Manoharan, Rajkumar" <rmanohar@qti.qualcomm.com>,
	"Valo, Kalle" <kvalo@qca.qualcomm.com>, ath10k@lists.infradead.org,
	linux-wireless@vger.kernel.org
Subject: Re: Bug 119151 - [regression] ath10k no longer authenitcates and
 freezes system
In-Reply-To: <CAHbf0-GT0y1pEs-ToxbPAf+aRo7TNAyV_Emies_rjL27R1fk2A@mail.gmail.com>
References: <8760trzoiw.fsf@kamboji.qca.qualcomm.com>
 <871t4fzn1x.fsf@kamboji.qca.qualcomm.com> <57504F05.3040200@candelatech.com>
 <1464887026467.72937@qti.qualcomm.com> <57506BA1.2090303@candelatech.com>
 <CAHbf0-GT0y1pEs-ToxbPAf+aRo7TNAyV_Emies_rjL27R1fk2A@mail.gmail.com>
Message-ID: <c36f442934605c492525af72fa04ada9@codeaurora.org> (sfid-20160608_175259_907744_32D57D6C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2016-06-02 23:03, Mike Lothian wrote:
> I've just tried those two changes, the machine now locks up before X
> has even started
> 
Mike,

Sorry for the delay. Found root cause for dead lock. Can you please give 
a try with below change?

diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c 
b/drivers/net/wireless/ath/ath10k/htt_rx.c
index 3b35c7ab5680..80e645302b54 100644
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c
@@ -1905,7 +1905,6 @@ static void ath10k_htt_rx_in_ord_ind(struct ath10k 
*ar, struct sk_buff *skb)
                         return;
                 }
         }
-       ath10k_htt_rx_msdu_buff_replenish(htt);
  }


-Rajkumar
