Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from na3sys009aog131.obsmtp.com ([74.125.149.247]:39861 "EHLO
	na3sys009aog131.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750724Ab2HIBqP convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Aug 2012 21:46:15 -0400
From: Bing Zhao <bzhao@marvell.com>
To: Dan Carpenter <dan.carpenter@oracle.com>,
	Ying Luo <luoy@marvell.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Wed, 8 Aug 2012 18:45:36 -0700
Subject: RE: mwifiex: add AES_CMAC support in key_material cmd
Message-ID: <477F20668A386D41ADCC57781B1F7043083AF35FF2@SC-VEXCH1.marvell.com> (sfid-20120809_034622_413406_2695EAEE)
References: <20120808141213.GA28142@elgon.mountain>
In-Reply-To: <20120808141213.GA28142@elgon.mountain>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dan,

Thanks for reporting this warning.

> The patch b877f4cf5af8: "mwifiex: add AES_CMAC support in
> key_material cmd" from Aug 3, 2012, leads to the following warning:
> drivers/net/wireless/mwifiex/sta_cmd.c:692
> mwifiex_cmd_802_11_key_material()
> 	 error: memcpy() 'param->key' too small (16 vs 32)

I pulled latest 'smatch' code (top commit 130ba3ad) but it cannot detect this error though.

> 
>    656          } else if (enc_key->key_len == WLAN_KEY_LEN_TKIP) {
>                            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> 
> We assume a 32 byte key_len here.

For TKIP, yes, key_len has been set to 32.

> 
>    657                  dev_dbg(priv->adapter->dev, "cmd: WPA_TKIP\n");
>    658                  key_material->key_param_set.key_type_id =
>    659                                                  cpu_to_le16(KEY_TYPE_ID_TKIP);
>    660                  key_material->key_param_set.key_info =
>    661                                                  cpu_to_le16(KEY_ENABLED);
> 
> [snip]
> 
>    686                  if (le16_to_cpu(key_material->key_param_set.key_type_id) ==
>    687                                                          KEY_TYPE_ID_AES_CMAC) {
>    688                          struct mwifiex_cmac_param *param =
>    689                                          (void *)key_material->key_param_set.key;
>    690
>    691                          memcpy(param->ipn, enc_key->pn, IGTK_PN_LEN);
>    692                          memcpy(param->key, enc_key->key_material,
>                                        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>    693                                 enc_key->key_len);
>                                        ^^^^^^^^^^^^^^^^
> "param->key" only has space for 16 bytes.

For AES_CMAC, here key_len should have been set to 16, but compiler doesn't know that.

The following change should fix the warning. (I will send a formal patch shortly.)

diff --git a/drivers/net/wireless/mwifiex/sta_cmd.c b/drivers/net/wireless/mwifiex/
--- a/drivers/net/wireless/mwifiex/sta_cmd.c
+++ b/drivers/net/wireless/mwifiex/sta_cmd.c
@@ -690,7 +690,7 @@ mwifiex_cmd_802_11_key_material(struct mwifiex_private *priv,

                        memcpy(param->ipn, enc_key->pn, IGTK_PN_LEN);
                        memcpy(param->key, enc_key->key_material,
-                              enc_key->key_len);
+                              WLAN_KEY_LEN_AES_CMAC);

                        key_param_len = sizeof(struct mwifiex_cmac_param);
                        key_material->key_param_set.key_len =

Thanks,
Bing
