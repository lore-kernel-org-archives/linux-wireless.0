Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:20423 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755447Ab2HIHJ3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 9 Aug 2012 03:09:29 -0400
Date: Thu, 9 Aug 2012 10:09:19 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Bing Zhao <bzhao@marvell.com>
Cc: Ying Luo <luoy@marvell.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: mwifiex: add AES_CMAC support in key_material cmd
Message-ID: <20120809070919.GD3734@mwanda> (sfid-20120809_090933_738469_09BAA746)
References: <20120808141213.GA28142@elgon.mountain>
 <477F20668A386D41ADCC57781B1F7043083AF35FF2@SC-VEXCH1.marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <477F20668A386D41ADCC57781B1F7043083AF35FF2@SC-VEXCH1.marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 08, 2012 at 06:45:36PM -0700, Bing Zhao wrote:
> Hi Dan,
> 
> Thanks for reporting this warning.
> 
> > The patch b877f4cf5af8: "mwifiex: add AES_CMAC support in
> > key_material cmd" from Aug 3, 2012, leads to the following warning:
> > drivers/net/wireless/mwifiex/sta_cmd.c:692
> > mwifiex_cmd_802_11_key_material()
> > 	 error: memcpy() 'param->key' too small (16 vs 32)
> 
> I pulled latest 'smatch' code (top commit 130ba3ad) but it cannot detect this error though.
> 

Hm.  It should.  I'm not sure what the problem is.

> > 
> >    656          } else if (enc_key->key_len == WLAN_KEY_LEN_TKIP) {
> >                            ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> > 
> > We assume a 32 byte key_len here.
> 
> For TKIP, yes, key_len has been set to 32.
> 
> > 
> >    657                  dev_dbg(priv->adapter->dev, "cmd: WPA_TKIP\n");
> >    658                  key_material->key_param_set.key_type_id =
> >    659                                                  cpu_to_le16(KEY_TYPE_ID_TKIP);
> >    660                  key_material->key_param_set.key_info =
> >    661                                                  cpu_to_le16(KEY_ENABLED);
> > 
> > [snip]
> > 
> >    686                  if (le16_to_cpu(key_material->key_param_set.key_type_id) ==
> >    687                                                          KEY_TYPE_ID_AES_CMAC) {
> >    688                          struct mwifiex_cmac_param *param =
> >    689                                          (void *)key_material->key_param_set.key;
> >    690
> >    691                          memcpy(param->ipn, enc_key->pn, IGTK_PN_LEN);
> >    692                          memcpy(param->key, enc_key->key_material,
> >                                        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> >    693                                 enc_key->key_len);
> >                                        ^^^^^^^^^^^^^^^^
> > "param->key" only has space for 16 bytes.
> 
> For AES_CMAC, here key_len should have been set to 16, but compiler doesn't know that.
> 
> The following change should fix the warning. (I will send a formal patch shortly.)
> 

It does.  Normally I say that it's not worth silencing false
positives, but this change doesn't make the code less readable so
thanks for that.

regards,
dan carpenter

> diff --git a/drivers/net/wireless/mwifiex/sta_cmd.c b/drivers/net/wireless/mwifiex/
> --- a/drivers/net/wireless/mwifiex/sta_cmd.c
> +++ b/drivers/net/wireless/mwifiex/sta_cmd.c
> @@ -690,7 +690,7 @@ mwifiex_cmd_802_11_key_material(struct mwifiex_private *priv,
> 
>                         memcpy(param->ipn, enc_key->pn, IGTK_PN_LEN);
>                         memcpy(param->key, enc_key->key_material,
> -                              enc_key->key_len);
> +                              WLAN_KEY_LEN_AES_CMAC);
> 
>                         key_param_len = sizeof(struct mwifiex_cmac_param);
>                         key_material->key_param_set.key_len =
> 
> Thanks,
> Bing
