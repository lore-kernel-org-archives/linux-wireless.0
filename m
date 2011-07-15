Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:45735 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751989Ab1GOVAO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Jul 2011 17:00:14 -0400
Received: by gyh3 with SMTP id 3so711188gyh.19
        for <linux-wireless@vger.kernel.org>; Fri, 15 Jul 2011 14:00:13 -0700 (PDT)
Message-ID: <4E20AA5A.6020101@lwfinger.net> (sfid-20110715_230024_895743_803F091E)
Date: Fri, 15 Jul 2011 16:00:10 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Ali Bahar <ali@internetdog.org>
CC: Greg Kroah-Hartman <gregkh@suse.de>, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 1/2] staging: r8712u: Most return-values changed from
 -1 to proper errno macros.
References: <20110703010605.GA3736@internetdog.org> <1310749876-32632-1-git-send-email-ali@internetDog.org> <1310749876-32632-2-git-send-email-ali@internetDog.org>
In-Reply-To: <1310749876-32632-2-git-send-email-ali@internetDog.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 07/15/2011 12:11 PM, Ali Bahar wrote:
> The ioctl handlers were frequently returning -1 upon failure. Most of
> these have now been changed to proper errno macros.
> The few remaining ones have been left untouched because either the
> handler is not called (and so cannot be tested), or the function never
> fails (and so cannot be system-tested), or requires new code to
> distinguish its failures.
>
> Signed-off-by: Ali Bahar<ali@internetDog.org>
> Cc: Larry Finger<Larry.Finger@lwfinger.net>
> ---
>   drivers/staging/rtl8712/rtl871x_ioctl_linux.c |  121 +++++++++++++++++++++----
>   1 files changed, 105 insertions(+), 16 deletions(-)
>
> diff --git a/drivers/staging/rtl8712/rtl871x_ioctl_linux.c b/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
> index 40e6b5c..bb97d8b 100644
> --- a/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
> +++ b/drivers/staging/rtl8712/rtl871x_ioctl_linux.c
> @@ -526,7 +526,7 @@ static int r871x_set_wpa_ie(struct _adapter *padapter, char *pie,
>   		memcpy(buf, pie , ielen);
>   		pos = buf;
>   		if (ielen<  RSN_HEADER_LEN) {
> -			ret  = -1;
> +			ret  = -EINVAL;
>   			goto exit;
>   		}
>   		if (r8712_parse_wpa_ie(buf, ielen,&group_cipher,
> @@ -689,6 +689,11 @@ static const long frequency_list[] = {
>   	5825
>   };
>
> +/*
> + * This function intends to handle the Set Freq command.
> + * Currently, the request comes via the Wireless Extensions' SIOCSIWFREQ ioctl.
> + *
> + */

This comment is not needed. The function name is descriptive and it is clear 
that it is part of WEXT.

>   static int r8711_wx_set_freq(struct net_device *dev,
>   			     struct iw_request_info *info,
>   			     union iwreq_data *wrqu, char *extra)
> @@ -723,6 +728,11 @@ static int r8711_wx_set_freq(struct net_device *dev,
>   	return rc;
>   }
>
> +/*
> + * This function intends to handle the Get Freq command.
> + * Currently, the request comes via the Wireless Extensions' SIOCGIWFREQ ioctl.
> + *
> + */

Ditto.

>   static int r8711_wx_get_freq(struct net_device *dev,
>   			     struct iw_request_info *info,
>   			     union iwreq_data *wrqu, char *extra)
> @@ -736,11 +746,21 @@ static int r8711_wx_get_freq(struct net_device *dev,
>   			       pcur_bss->Configuration.DSConfig-1] * 100000;
>   		wrqu->freq.e = 1;
>   		wrqu->freq.i = pcur_bss->Configuration.DSConfig;
> -	} else
> -		return -1;
> +	} else {
> +		return -ENOLINK;
> +	}
>   	return 0;
>   }
>
> +/*
> + * This function intends to handle the Set Mode command.
> + * Currently, the request comes via the Wireless Extensions' SIOCSIWMODE ioctl.
> + *

The part above is not needed.

> + * Note: Currently (July 2011) the call to
> + * r8712_set_802_11_infrastructure_mode() always returns true. Since we have no
> + * specific failure reason, we return EPERM in lieu of general failure.
> + *
> + */
>   static int r8711_wx_set_mode(struct net_device *dev,
>   			     struct iw_request_info *a,
>   			     union iwreq_data *wrqu, char *b)
> @@ -769,10 +789,15 @@ static int r8711_wx_set_mode(struct net_device *dev,
>   	else
>   		r8712_setopmode_cmd(padapter, Ndis802_11AutoUnknown);
>   	if (!r8712_set_802_11_infrastructure_mode(padapter, networkType))
> -		return -1;
> +		return -EPERM; /* Unknown failure. */
>   	return 0;

As r8712_set_802_11_infrastructure_mode() always returns true. it would be 
better to rewrite it as a void function and completely do away with the test here.

>   }
>
> +/*
> + * This function intends to handle the Get Mode command.
> + * Currently, the request comes via the Wireless Extensions' SIOCGIWMODE ioctl.
> + *
> + */

Another senseless comment.

>   static int r8711_wx_get_mode(struct net_device *dev, struct iw_request_info *a,
>   			     union iwreq_data *wrqu, char *b)
>   {
> @@ -975,6 +1000,16 @@ static int r871x_wx_set_priv(struct net_device *dev,
>    * s2. set_802_11_authentication_mode()
>    * s3. set_802_11_encryption_mode()
>    * s4. set_802_11_bssid()
> + *
> + * This function intends to handle the Set AP command, which specifies the
> + * MAC# of a preferred Access Point.
> + * Currently, the request comes via Wireless Extensions' SIOCSIWAP ioctl.
> + *
> + * For this operation to succeed, there is no need for the interface to be Up.
> + *
> + * Note: Currently (July 2011) r8712_set_802_11_bssid() may fail for one of
> + * several reasons. For now, we let -1 be returned as a catch-all failure
> + * indication, until that function's implementation is updated.
>    */

Ditto.

>   static int r8711_wx_set_wap(struct net_device *dev,
>   			 struct iw_request_info *info,
> @@ -995,7 +1030,7 @@ static int r8711_wx_set_wap(struct net_device *dev,
>   	if (padapter->bup == false)
>   		return -1;
>   	if (check_fwstate(pmlmepriv, _FW_UNDER_SURVEY) == true)
> -		return -1;
> +		return -EBUSY;
>   	if (check_fwstate(pmlmepriv, _FW_UNDER_LINKING) == true)
>   		return ret;
>   	if (temp->sa_family != ARPHRD_ETHER)
> @@ -1014,14 +1049,14 @@ static int r8711_wx_set_wap(struct net_device *dev,
>   		if (!memcmp(dst_bssid, temp->sa_data, ETH_ALEN)) {
>   			if (r8712_set_802_11_infrastructure_mode(padapter,
>   			    pnetwork->network.InfrastructureMode) == false)
> -				ret = -1;
> +				ret = -EPERM; /* Unknown failure. */
>   			break;
>   		}
>   	}
>   	spin_unlock_irqrestore(&queue->lock, irqL);
>   	if (!ret) {
>   		if (!r8712_set_802_11_authentication_mode(padapter, authmode))
> -			ret = -1;
> +			ret = -ENOMEM;
>   		else {
>   			if (!r8712_set_802_11_bssid(padapter, temp->sa_data))
>   				ret = -1;
> @@ -1074,6 +1109,19 @@ static int r871x_wx_set_mlme(struct net_device *dev,
>   	return ret;
>   }
>
> +/**
> + *
> + * This function intends to handle the Set Scan command.
> + * Currently, the request comes via Wireless Extensions' SIOCSIWSCAN ioctl.
> + *
> + * For this operation to succeed, the interface is brought Up beforehand.
> + *
> + * Note: It is not clear what value we ought to return when hw_init_completed
> + * is false. If the firmware could not be found/loaded, which errno should we
> + * return?
> + * The same question arises for bDriverStopped being true.
> + *
> + */

The above comment is too long.

>   static int r8711_wx_set_scan(struct net_device *dev,
>   			struct iw_request_info *a,
>   			union iwreq_data *wrqu, char *extra)
> @@ -1088,7 +1136,7 @@ static int r8711_wx_set_scan(struct net_device *dev,
>   		return -1;
>   	}
>   	if (padapter->bup == false)
> -		return -1;
> +		return -ENETDOWN;
>   	if (padapter->hw_init_completed == false)
>   		return -1;
>   	if ((check_fwstate(pmlmepriv, _FW_UNDER_SURVEY|_FW_UNDER_LINKING)) ||
> @@ -1122,6 +1170,13 @@ static int r8711_wx_set_scan(struct net_device *dev,
>   	return 0;
>   }
>
> +/**
> + *
> + * This function intends to handle the Get Scan command.
> + * Currently, the request comes via Wireless Extensions' SIOCGIWSCAN ioctl.
> + *
> + *
> + */

Comment not needed.

>   static int r8711_wx_get_scan(struct net_device *dev,
>   				struct iw_request_info *a,
>   				union iwreq_data *wrqu, char *extra)
> @@ -1169,6 +1224,16 @@ static int r8711_wx_get_scan(struct net_device *dev,
>    * s2. set_802_11_authenticaion_mode()
>    * s3. set_802_11_encryption_mode()
>    * s4. set_802_11_ssid()
> + *
> + * This function intends to handle the Set ESSID command.
> + * Currently, the request comes via the Wireless Extensions' SIOCSIWESSID ioctl.
> + *
> + * For this operation to succeed, there is no need for the interface to be Up.
> + *
> + * Note: Currently (July 2011) the call to
> + * r8712_set_802_11_infrastructure_mode() always returns true. Since we have no
> + * specific failure reason, we return EPERM in lieu of general failure.
> + *
>    */

Why is the business about r8712_set_802_11_infrastructure_mode() repeated?

>   static int r8711_wx_set_essid(struct net_device *dev,
>   				struct iw_request_info *a,
> @@ -1187,7 +1252,7 @@ static int r8711_wx_set_essid(struct net_device *dev,
>   	if (padapter->bup == false)
>   		return -1;
>   	if (check_fwstate(pmlmepriv, _FW_UNDER_SURVEY))
> -		return -1;
> +		return -EBUSY;
>   	if (check_fwstate(pmlmepriv, _FW_UNDER_LINKING))
>   		return 0;
>   	if (wrqu->essid.length>  IW_ESSID_MAX_SIZE)
> @@ -1215,7 +1280,7 @@ static int r8711_wx_set_essid(struct net_device *dev,
>   				if (!r8712_set_802_11_infrastructure_mode(
>   				     padapter,
>   				     pnetwork->network.InfrastructureMode))
> -					return -1;
> +					return -EPERM; /* Unknown failure. */
>   				break;
>   			}
>   		}
> @@ -1225,6 +1290,12 @@ static int r8711_wx_set_essid(struct net_device *dev,
>   	return -EINPROGRESS;
>   }
>
> +/**
> + *
> + * This function intends to handle the Get ESSID command.
> + * Currently, the request comes via Wireless Extensions' SIOCGIWESSID ioctl.
> + *
> + */

Not needed.

>   static int r8711_wx_get_essid(struct net_device *dev,
>   				struct iw_request_info *a,
>   				union iwreq_data *wrqu, char *extra)
> @@ -1240,10 +1311,16 @@ static int r8711_wx_get_essid(struct net_device *dev,
>   		memcpy(extra, pcur_bss->Ssid.Ssid, len);
>   		wrqu->essid.flags = 1;
>   	} else
> -		ret = -1;
> +		ret = -ENOLINK;
>   	return ret;
>   }
>
> +/**
> + *
> + * This function intends to handle the Set Rate command.
> + * Currently, the request comes via the Wireless Extensions' SIOCSIWRATE ioctl.
> + *
> + */

Ditto.

>   static int r8711_wx_set_rate(struct net_device *dev,
>   				struct iw_request_info *a,
>   				union iwreq_data *wrqu, char *extra)
> @@ -1312,10 +1389,16 @@ set_rate:
>   			datarates[i] = 0xff;
>   	}
>   	if (r8712_setdatarate_cmd(padapter, datarates) != _SUCCESS)
> -		ret = -1;
> +		ret = -ENOMEM;
>   	return ret;
>   }
>
> +/**
> + *
> + * This function intends to handle the Get Rate command.
> + * Currently, the request comes via the Wireless Extensions' SIOCGIWRATE ioctl.
> + *
> + */

Ditto.

>   static int r8711_wx_get_rate(struct net_device *dev,
>   			     struct iw_request_info *info,
>   			     union iwreq_data *wrqu, char *extra)
> @@ -1371,10 +1454,16 @@ static int r8711_wx_get_rate(struct net_device *dev,
>   			wrqu->bitrate.value = max_rate * 500000;
>   		}
>   	} else
> -		return -1;
> +		return -ENOLINK;
>   	return 0;
>   }
>
> +/**
> + *
> + * This function intends to handle the Get RTS Threshold command.
> + * Currently, the request comes via the Wireless Extensions' SIOCGIWRTS ioctl.
> + *
> + */

Yet again.

>   static int r8711_wx_get_rts(struct net_device *dev,
>   				struct iw_request_info *info,
>   				union iwreq_data *wrqu, char *extra)
> @@ -1701,7 +1790,7 @@ static int r871x_wx_set_enc_ext(struct net_device *dev,
>   	param_len = sizeof(struct ieee_param) + pext->key_len;
>   	param = (struct ieee_param *)_malloc(param_len);
>   	if (param == NULL)
> -		return -1;
> +		return -ENOMEM;
>   	memset(param, 0, param_len);
>   	param->cmd = IEEE_CMD_SET_ENCRYPTION;
>   	memset(param->sta_addr, 0xff, ETH_ALEN);
> @@ -1719,7 +1808,7 @@ static int r871x_wx_set_enc_ext(struct net_device *dev,
>   		alg_name = "CCMP";
>   		break;
>   	default:
> -		return -1;
> +		return -EINVAL;
>   	}
>   	strncpy((char *)param->u.crypt.alg, alg_name, IEEE_CRYPT_ALG_NAME_LEN);
>   	if (pext->ext_flags&  IW_ENCODE_EXT_GROUP_KEY)
> @@ -1785,7 +1874,7 @@ static int dummy(struct net_device *dev,
>   		struct iw_request_info *a,
>   		union iwreq_data *wrqu, char *b)
>   {
> -	return -1;
> +	return -ENOSYS;
>   }
>
>   static int r8711_drvext_hdl(struct net_device *dev,

Comments in the Linux kernel are relatively rare. Only things that are not 
immediately obvious should receive special annotation.

Larry
