Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:49707 "EHLO
        wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751631AbcI0NEu (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 27 Sep 2016 09:04:50 -0400
From: "Shajakhan, Mohammed Shafi (Mohammed Shafi)"
        <mohammed@qti.qualcomm.com>
To: "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>
CC: "mohammed@codeaurora.org" <mohammed@codeaurora.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v4] ath10k: Cleanup calling ath10k_htt_rx_h_unchain
Date: Tue, 27 Sep 2016 13:04:44 +0000
Message-ID: <1474981503694.62077@qti.qualcomm.com> (sfid-20160927_150453_887709_D1F14CF4)
References: <1474981300-15945-1-git-send-email-mohammed@qca.qualcomm.com>
In-Reply-To: <1474981300-15945-1-git-send-email-mohammed@qca.qualcomm.com>
Content-Type: text/plain; charset="iso-8859-1"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

apologies please ignore this , wrong patch due to confusing v4 tag=0A=
 =0A=
please review,=0A=
=0A=
[PATCH] ath10k: Cleanup calling ath10k_htt_rx_h_unchain=0A=
=0A=
________________________________________=0A=
From: Shajakhan, Mohammed Shafi (Mohammed Shafi)=0A=
Sent: 27 September 2016 18:31=0A=
To: ath10k@lists.infradead.org=0A=
Cc: mohammed@codeaurora.org; linux-wireless@vger.kernel.org; Shajakhan, Moh=
ammed Shafi (Mohammed Shafi)=0A=
Subject: [PATCH v4] ath10k: Cleanup calling ath10k_htt_rx_h_unchain=0A=
=0A=
From: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>=0A=
=0A=
'ath10k_htt_rx_h_unchain' is need to be called only if the return=0A=
value from 'ath10k_htt_rx_amsdu_pop' is 1('chained msdu's'), this=0A=
change makes it more explicit and avoids doing a skb_peek, fetching=0A=
rx descriptor pointer, checking rx msdu decap format for the case of=0A=
ret =3D 0 (unchained msdus). Found this change during code walk through,=0A=
not sure if this addresses any issue.=0A=
=0A=
Signed-off-by: Mohammed Shafi Shajakhan <mohammed@qti.qualcomm.com>=0A=
---=0A=
 drivers/net/wireless/ath/ath10k/htt_rx.c | 12 ++++++------=0A=
 1 file changed, 6 insertions(+), 6 deletions(-)=0A=
=0A=
diff --git a/drivers/net/wireless/ath/ath10k/htt_rx.c b/drivers/net/wireles=
s/ath/ath10k/htt_rx.c=0A=
index 7ae9349..e51dace 100644=0A=
--- a/drivers/net/wireless/ath/ath10k/htt_rx.c=0A=
+++ b/drivers/net/wireless/ath/ath10k/htt_rx.c=0A=
@@ -1459,8 +1459,7 @@ static int ath10k_unchain_msdu(struct sk_buff_head *a=
msdu)=0A=
 }=0A=
=0A=
 static void ath10k_htt_rx_h_unchain(struct ath10k *ar,=0A=
-                                   struct sk_buff_head *amsdu,=0A=
-                                   bool chained)=0A=
+                                   struct sk_buff_head *amsdu)=0A=
 {=0A=
        struct sk_buff *first;=0A=
        struct htt_rx_desc *rxd;=0A=
@@ -1471,9 +1470,6 @@ static void ath10k_htt_rx_h_unchain(struct ath10k *ar=
,=0A=
        decap =3D MS(__le32_to_cpu(rxd->msdu_start.common.info1),=0A=
                   RX_MSDU_START_INFO1_DECAP_FORMAT);=0A=
=0A=
-       if (!chained)=0A=
-               return;=0A=
-=0A=
        /* FIXME: Current unchaining logic can only handle simple case of r=
aw=0A=
         * msdu chaining. If decapping is other than raw the chaining may b=
e=0A=
         * more complex and this isn't handled by the current code. Don't e=
ven=0A=
@@ -1550,7 +1546,11 @@ static int ath10k_htt_rx_handle_amsdu(struct ath10k_=
htt *htt)=0A=
        }=0A=
=0A=
        ath10k_htt_rx_h_ppdu(ar, &amsdu, rx_status, 0xffff);=0A=
-       ath10k_htt_rx_h_unchain(ar, &amsdu, ret > 0);=0A=
+=0A=
+       /* only for ret =3D 1 indicates chained msdus */=0A=
+       if (ret > 0)=0A=
+               ath10k_htt_rx_h_unchain(ar, &amsdu);=0A=
+=0A=
        ath10k_htt_rx_h_filter(ar, &amsdu, rx_status);=0A=
        ath10k_htt_rx_h_mpdu(ar, &amsdu, rx_status);=0A=
        ath10k_htt_rx_h_deliver(ar, &amsdu, rx_status);=0A=
--=0A=
1.9.1=0A=
=0A=
