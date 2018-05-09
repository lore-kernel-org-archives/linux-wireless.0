Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from esa5.microchip.iphmx.com ([216.71.150.166]:46797 "EHLO
        esa5.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934630AbeEINov (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 9 May 2018 09:44:51 -0400
Subject: Re: [PATCH 03/30] staging: wilc1000: fix line over 80 chars in
 handle_key()
To: Ajay Singh <ajay.kathat@microchip.com>,
        <linux-wireless@vger.kernel.org>
CC: <devel@driverdev.osuosl.org>, <gregkh@linuxfoundation.org>,
        <ganesh.krishna@microchip.com>, <venkateswara.kaja@microchip.com>,
        <aditya.shankar@microchip.com>, <adham.abozaeid@Microchip.com>
References: <1525682614-3824-1-git-send-email-ajay.kathat@microchip.com>
 <1525682614-3824-4-git-send-email-ajay.kathat@microchip.com>
From: Claudiu Beznea <Claudiu.Beznea@microchip.com>
Message-ID: <1c7fbd1f-a655-a96a-5d2c-50cca9087023@microchip.com> (sfid-20180509_154454_029947_8AD36CEF)
Date: Wed, 9 May 2018 16:44:47 +0300
MIME-Version: 1.0
In-Reply-To: <1525682614-3824-4-git-send-email-ajay.kathat@microchip.com>
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>



On 07.05.2018 11:43, Ajay Singh wrote:
> Fix checkpatch reported issue of line over 80 char in handle_key().
> Introduced new functions by spliting existing function to address the
> checkpatch issue.
> 
> Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
> ---
>  drivers/staging/wilc1000/host_interface.c | 59 +++++++++++++++++++------------
>  1 file changed, 37 insertions(+), 22 deletions(-)
> 
> diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
> index 4ba868c..29f9907 100644
> --- a/drivers/staging/wilc1000/host_interface.c
> +++ b/drivers/staging/wilc1000/host_interface.c
> @@ -1498,12 +1498,45 @@ static s32 handle_rcvd_gnrl_async_info(struct wilc_vif *vif,
>  	return result;
>  }
>  
> +static int wilc_pmksa_key_copy(struct wilc_vif *vif, struct key_attr *hif_key)
> +{
> +	int i;
> +	int ret;
> +	struct wid wid;
> +	u8 *key_buf;
> +
> +	key_buf = kmalloc((hif_key->attr.pmkid.numpmkid * PMKSA_KEY_LEN) + 1,
> +			  GFP_KERNEL);
> +	if (!key_buf)
> +		return -ENOMEM;
> +
> +	key_buf[0] = hif_key->attr.pmkid.numpmkid;
> +
> +	for (i = 0; i < hif_key->attr.pmkid.numpmkid; i++) {
> +		memcpy(key_buf + ((PMKSA_KEY_LEN * i) + 1),
> +		       hif_key->attr.pmkid.pmkidlist[i].bssid, ETH_ALEN);
> +		memcpy(key_buf + ((PMKSA_KEY_LEN * i) + ETH_ALEN + 1),
> +		       hif_key->attr.pmkid.pmkidlist[i].pmkid, PMKID_LEN);
> +	}
> +
> +	wid.id = (u16)WID_PMKID_INFO;
> +	wid.type = WID_STR;
> +	wid.val = (s8 *)key_buf;

Is this cast really needed?

> +	wid.size = (hif_key->attr.pmkid.numpmkid * PMKSA_KEY_LEN) + 1;
> +
> +	ret = wilc_send_config_pkt(vif, SET_CFG, &wid, 1,
> +				   wilc_get_vif_idx(vif));
> +
> +	kfree(key_buf);
> +
> +	return ret;
> +}
> +
>  static int handle_key(struct wilc_vif *vif, struct key_attr *hif_key)
>  {
>  	int result = 0;
>  	struct wid wid;
>  	struct wid wid_list[5];
> -	u8 i;
>  	u8 *key_buf;
>  	s8 s8idxarray[1];
>  	struct host_if_drv *hif_drv = vif->hif_drv;
> @@ -1547,7 +1580,8 @@ static int handle_key(struct wilc_vif *vif, struct key_attr *hif_key)
>  						      wilc_get_vif_idx(vif));
>  			kfree(key_buf);
>  		} else if (hif_key->action & ADDKEY) {
> -			key_buf = kmalloc(hif_key->attr.wep.key_len + 2, GFP_KERNEL);
> +			key_buf = kmalloc(hif_key->attr.wep.key_len + 2,
> +					  GFP_KERNEL);
>  			if (!key_buf) {
>  				result = -ENOMEM;
>  				goto out_wep;
> @@ -1715,26 +1749,7 @@ static int handle_key(struct wilc_vif *vif, struct key_attr *hif_key)
>  		break;
>  
>  	case PMKSA:
> -		key_buf = kmalloc((hif_key->attr.pmkid.numpmkid * PMKSA_KEY_LEN) + 1, GFP_KERNEL);
> -		if (!key_buf)
> -			return -ENOMEM;
> -
> -		key_buf[0] = hif_key->attr.pmkid.numpmkid;
> -
> -		for (i = 0; i < hif_key->attr.pmkid.numpmkid; i++) {
> -			memcpy(key_buf + ((PMKSA_KEY_LEN * i) + 1), hif_key->attr.pmkid.pmkidlist[i].bssid, ETH_ALEN);
> -			memcpy(key_buf + ((PMKSA_KEY_LEN * i) + ETH_ALEN + 1), hif_key->attr.pmkid.pmkidlist[i].pmkid, PMKID_LEN);
> -		}
> -
> -		wid.id = (u16)WID_PMKID_INFO;
> -		wid.type = WID_STR;
> -		wid.val = (s8 *)key_buf;
> -		wid.size = (hif_key->attr.pmkid.numpmkid * PMKSA_KEY_LEN) + 1;
> -
> -		result = wilc_send_config_pkt(vif, SET_CFG, &wid, 1,
> -					      wilc_get_vif_idx(vif));
> -
> -		kfree(key_buf);
> +		result = wilc_pmksa_key_copy(vif, hif_key);
>  		break;
>  	}
>  
> 
