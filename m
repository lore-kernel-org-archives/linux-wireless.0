Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fig.raritan.com ([24.38.102.197]:3301 "EHLO fig.raritan.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751232AbaKFKwV (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Nov 2014 05:52:21 -0500
From: Ronald Wahl <ronald.wahl@raritan.com>
To: linux-wireless@vger.kernel.org
Cc: Christian Lamparter <chunkeey@googlemail.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Ard Biesheuvel <ard.biesheuvel@linaro.org>,
	Ronald Wahl <ronald.wahl@raritan.com>
Subject: [PATCH v2] mac80211: Fix regression that triggers a kernel BUG with CCMP
Date: Thu,  6 Nov 2014 11:52:13 +0100
Message-Id: <1415271133-6588-1-git-send-email-ronald.wahl@raritan.com> (sfid-20141106_115225_313179_65BBB65C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Commit 7ec7c4a9a686c608315739ab6a2b0527a240883c (mac80211: port CCMP to
cryptoapi's CCM driver) introduced a regression when decrypting empty
packets (data_len == 0). This will lead to backtraces like:

(scatterwalk_start) from [<c01312f4>] (scatterwalk_map_and_copy+0x2c/0xa8)
(scatterwalk_map_and_copy) from [<c013a5a0>] (crypto_ccm_decrypt+0x7c/0x25c)
(crypto_ccm_decrypt) from [<c032886c>] (ieee80211_aes_ccm_decrypt+0x160/0x170)
(ieee80211_aes_ccm_decrypt) from [<c031c628>] (ieee80211_crypto_ccmp_decrypt+0x1ac/0x238)
(ieee80211_crypto_ccmp_decrypt) from [<c032ef28>] (ieee80211_rx_handlers+0x870/0x1d24)
(ieee80211_rx_handlers) from [<c0330c7c>] (ieee80211_prepare_and_rx_handle+0x8a0/0x91c)
(ieee80211_prepare_and_rx_handle) from [<c0331260>] (ieee80211_rx+0x568/0x730)
(ieee80211_rx) from [<c01d3054>] (__carl9170_rx+0x94c/0xa20)
(__carl9170_rx) from [<c01d3324>] (carl9170_rx_stream+0x1fc/0x320)
(carl9170_rx_stream) from [<c01cbccc>] (carl9170_usb_tasklet+0x80/0xc8)
(carl9170_usb_tasklet) from [<c00199dc>] (tasklet_hi_action+0x88/0xcc)
(tasklet_hi_action) from [<c00193c8>] (__do_softirq+0xcc/0x200)
(__do_softirq) from [<c0019734>] (irq_exit+0x80/0xe0)
(irq_exit) from [<c0009c10>] (handle_IRQ+0x64/0x80)
(handle_IRQ) from [<c000c3a0>] (__irq_svc+0x40/0x4c)
(__irq_svc) from [<c0009d44>] (arch_cpu_idle+0x2c/0x34)

Such packets can appear for example when using the carl9170 wireless driver
because hardware sometimes generates garbage when the internal FIFO overruns.

This patch adds an additional length check.

Cc: stable@vger.kernel.org
Fixes: 7ec7c4a9a686 ("mac80211: port CCMP to cryptoapi's CCM driver")
Signed-off-by: Ronald Wahl <ronald.wahl@raritan.com>
---
v1 -> v2:
    - return negative error value

 net/mac80211/aes_ccm.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/mac80211/aes_ccm.c b/net/mac80211/aes_ccm.c
index ec24378..09d9caa 100644
--- a/net/mac80211/aes_ccm.c
+++ b/net/mac80211/aes_ccm.c
@@ -53,6 +53,9 @@ int ieee80211_aes_ccm_decrypt(struct crypto_aead *tfm, u8 *b_0, u8 *aad,
 		__aligned(__alignof__(struct aead_request));
 	struct aead_request *aead_req = (void *) aead_req_data;
 
+	if (data_len == 0)
+		return -EINVAL;
+
 	memset(aead_req, 0, sizeof(aead_req_data));
 
 	sg_init_one(&pt, data, data_len);
-- 
1.9.3

