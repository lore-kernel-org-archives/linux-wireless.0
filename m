Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:48437 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750795AbYCMBlu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 12 Mar 2008 21:41:50 -0400
Subject: Re: [PATCH] libertas: remove some unused commands
From: Dan Williams <dcbw@redhat.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: libertas-dev@lists.infradead.org, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <200803121706.09735.hs4233@mail.mn-solutions.de>
References: <200803121706.09735.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Wed, 12 Mar 2008 21:36:51 -0400
Message-Id: <1205372212.23943.6.camel@localhost.localdomain> (sfid-20080313_014154_348398_2FCF8575)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-03-12 at 17:06 +0100, Holger Schurig wrote:
> Neither CMD_802_11_PAIRWISE_TSC nor CMD_802_11_GROUP_TSC is used or
> documented. It might have something to do with TKIP sequence counters,
> but that's just an educated guess. Remove all occurences of them.
> 
> CMD_CODE_DNLD is also neither used nor documented.
> 
> Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>

Acked-by: Dan Williams <dcbw@redhat.com>

> 
> Index: wireless-testing/drivers/net/wireless/libertas/cmd.c
> ===================================================================
> --- wireless-testing.orig/drivers/net/wireless/libertas/cmd.c	2008-03-12 15:09:19.000000000 +0100
> +++ wireless-testing/drivers/net/wireless/libertas/cmd.c	2008-03-12 15:41:49.000000000 +0100
> @@ -1379,8 +1379,6 @@ int lbs_prepare_and_send_command(struct 
>  	case CMD_802_11_AD_HOC_START:
>  		ret = lbs_cmd_80211_ad_hoc_start(priv, cmdptr, pdata_buf);
>  		break;
> -	case CMD_CODE_DNLD:
> -		break;
>  
>  	case CMD_802_11_RESET:
>  		ret = lbs_cmd_802_11_reset(priv, cmdptr, cmd_action);
> @@ -1440,11 +1438,6 @@ int lbs_prepare_and_send_command(struct 
>  		ret = lbs_cmd_80211_ad_hoc_stop(priv, cmdptr);
>  		break;
>  
> -	case CMD_802_11_PAIRWISE_TSC:
> -		break;
> -	case CMD_802_11_GROUP_TSC:
> -		break;
> -
>  	case CMD_802_11_MAC_ADDRESS:
>  		ret = lbs_cmd_802_11_mac_address(priv, cmdptr, cmd_action);
>  		break;
> Index: wireless-testing/drivers/net/wireless/libertas/host.h
> ===================================================================
> --- wireless-testing.orig/drivers/net/wireless/libertas/host.h	2008-03-12 15:09:19.000000000 +0100
> +++ wireless-testing/drivers/net/wireless/libertas/host.h	2008-03-12 15:41:41.000000000 +0100
> @@ -33,7 +33,6 @@
>  #define CMD_RET_802_11_ASSOCIATE		0x8012
>  
>  /* Command codes */
> -#define CMD_CODE_DNLD				0x0002
>  #define CMD_GET_HW_SPEC				0x0003
>  #define	CMD_EEPROM_UPDATE			0x0004
>  #define CMD_802_11_RESET			0x0005
> @@ -68,8 +67,6 @@
>  #define CMD_802_11_AD_HOC_JOIN			0x002c
>  #define CMD_802_11_QUERY_TKIP_REPLY_CNTRS	0x002e
>  #define CMD_802_11_ENABLE_RSN			0x002f
> -#define CMD_802_11_PAIRWISE_TSC			0x0036
> -#define CMD_802_11_GROUP_TSC			0x0037
>  #define CMD_802_11_SET_AFC			0x003c
>  #define CMD_802_11_GET_AFC			0x003d
>  #define CMD_802_11_AD_HOC_STOP			0x0040

