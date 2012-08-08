Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:33882 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754763Ab2HHOMZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Aug 2012 10:12:25 -0400
Date: Wed, 8 Aug 2012 17:12:14 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: luoy@marvell.com
Cc: linux-wireless@vger.kernel.org
Subject: re: mwifiex: add AES_CMAC support in key_material cmd
Message-ID: <20120808141213.GA28142@elgon.mountain> (sfid-20120808_161229_196629_E95D014B)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Ying Luo,

The patch b877f4cf5af8: "mwifiex: add AES_CMAC support in 
key_material cmd" from Aug 3, 2012, leads to the following warning:
drivers/net/wireless/mwifiex/sta_cmd.c:692 
mwifiex_cmd_802_11_key_material()
	 error: memcpy() 'param->key' too small (16 vs 32)

   656          } else if (enc_key->key_len == WLAN_KEY_LEN_TKIP) {
                           ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

We assume a 32 byte key_len here.

   657                  dev_dbg(priv->adapter->dev, "cmd: WPA_TKIP\n");
   658                  key_material->key_param_set.key_type_id =
   659                                                  cpu_to_le16(KEY_TYPE_ID_TKIP);
   660                  key_material->key_param_set.key_info =
   661                                                  cpu_to_le16(KEY_ENABLED);

[snip]

   686                  if (le16_to_cpu(key_material->key_param_set.key_type_id) ==
   687                                                          KEY_TYPE_ID_AES_CMAC) {
   688                          struct mwifiex_cmac_param *param =
   689                                          (void *)key_material->key_param_set.key;
   690  
   691                          memcpy(param->ipn, enc_key->pn, IGTK_PN_LEN);
   692                          memcpy(param->key, enc_key->key_material,
                                       ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
   693                                 enc_key->key_len);
                                       ^^^^^^^^^^^^^^^^
"param->key" only has space for 16 bytes.

   694  

regards,
dan carpenter

