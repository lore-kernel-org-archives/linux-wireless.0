Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:55720 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754269Ab1LGI7j (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 7 Dec 2011 03:59:39 -0500
Date: Wed, 7 Dec 2011 11:59:23 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Wey-Yi Guy <wey-yi.w.guy@intel.com>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless@vger.kernel.org
Subject: [smatch stuff] question about iwlagn_rx_calib_result()
Message-ID: <20111207085923.GA15304@elgon.mountain> (sfid-20111207_095943_156880_EC0FBF3D)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Smatch complains about iwlagn_rx_calib_result() it would be bad for
"len" to be negative.

drivers/net/wireless/iwlwifi/iwl-ucode.c

   299  int iwlagn_rx_calib_result(struct iwl_priv *priv,
   300                              struct iwl_rx_mem_buffer *rxb,
   301                              struct iwl_device_cmd *cmd)
   302  {
   303          struct iwl_rx_packet *pkt = rxb_addr(rxb);
   304          struct iwl_calib_hdr *hdr = (struct iwl_calib_hdr *)pkt->u.raw;
   305          int len = le32_to_cpu(pkt->len_n_flags) & FH_RSCSR_FRAME_SIZE_MSK;
   306  
   307          /* reduce the size of the length field itself */
   308          len -= 4;
                ^^^^^^^^
Where does this 4 come from?  I've tried to determine what the minimum
size of "le32_to_cpu(pkt->len_n_flags) & FH_RSCSR_FRAME_SIZE_MSK" is but
I got lost.  Can it ever be less than 4?

   309  
   310          if (iwl_calib_set(priv, hdr, len))
   311                  IWL_ERR(priv, "Failed to record calibration data %d\n",
   312                          hdr->op_code);
   313  
   314          return 0;
   315  }

regards,
dan carpenter
