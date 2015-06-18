Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:38316 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751228AbbFRETX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 18 Jun 2015 00:19:23 -0400
Date: Wed, 17 Jun 2015 21:19:21 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Sunghoon Cho <ywhsbliss@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
	johnny.kim@atmel.com, chris.park@atmel.com, Rachel.kim@atmel.com,
	dean.lee@atmel.com
Subject: Re: [PATCH 1/5] staging: wilc1000: change commenting styles.
Message-ID: <20150618041921.GA10663@kroah.com> (sfid-20150618_061926_777700_6E8F027D)
References: <eed9181385a22bfe580dbe1a0cca17d9bb694209.1434526056.git.ywhsbliss@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <eed9181385a22bfe580dbe1a0cca17d9bb694209.1434526056.git.ywhsbliss@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 17, 2015 at 04:28:51PM +0900, Sunghoon Cho wrote:
> This patch changes commenting style to Linux preferred C89 style.
> 
> Signed-off-by: Sunghoon Cho <ywhsbliss@gmail.com>
> ---
>  drivers/staging/wilc1000/wilc_wlan_if.h | 721 ++++++++++++++++++--------------
>  1 file changed, 397 insertions(+), 324 deletions(-)
> 
> diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc1000/wilc_wlan_if.h
> index ea0ec41..c7143cd 100644
> --- a/drivers/staging/wilc1000/wilc_wlan_if.h
> +++ b/drivers/staging/wilc1000/wilc_wlan_if.h
> @@ -1,17 +1,13 @@
> -/* ////////////////////////////////////////////////////////////////////////// */
> -/*  */
> -/* Copyright (c) Atmel Corporation.  All rights reserved. */
> -/*  */
> -/* Module Name:  wilc_wlan_if.h */
> -/*  */
> -/*  */
> -/* ///////////////////////////////////////////////////////////////////////// */
> +/*
> + * Copyright (c) Atmel Corporation. All rights reserved.
> + * Module Name:  wilc_wlan_if.h
> + */
>  
>  
>  #ifndef WILC_WLAN_IF_H
>  #define WILC_WLAN_IF_H
>  
> -/*bug 3887: [AP] Allow Management frames to be passed to the host*/
> +/* bug 3887: [AP] Allow Management frames to be passed to the host */
>  #define WILC_AP_EXTERNAL_MLME
>  #define WILC_P2P
>  #define TCP_ENHANCEMENTS
> @@ -24,11 +20,7 @@
>  #include "linux_wlan_common.h"
>  
>  
> -/********************************************
> - *
> - *      Debug Flags
> - *
> - ********************************************/
> +/* Debug Flags */
>  
>  #define N_INIT		0x00000001
>  #define N_ERR		0x00000002
> @@ -36,31 +28,19 @@
>  #define N_INTR		0x00000008
>  #define N_RXQ		0x00000010
>  
> -/********************************************
> - *
> - *      Host Interface Defines
> - *
> - ********************************************/
> +/* Host Interface Defines */
>  
>  #define HIF_SDIO           (0)
>  #define HIF_SPI            (1 << 0)
>  #define HIF_SDIO_GPIO_IRQ  (1 << 2)
>  
>  
> -/********************************************
> - *
> - *      Tx/Rx Buffer Size Defines
> - *
> - ********************************************/
> +/* Tx/Rx Buffer Size Defines */
>  
>  #define CE_TX_BUFFER_SIZE (64 * 1024)
>  #define CE_RX_BUFFER_SIZE (384 * 1024)
>  
> -/********************************************
> - *
> - *      Wlan Interface Defines
> - *
> - ********************************************/
> +/* Wlan Interface Defines */
>  
>  typedef struct {
>  	uint32_t read_write: 1;
> @@ -97,7 +77,7 @@ typedef struct {
>  	void (*os_enter_cs)(void *);
>  	void (*os_leave_cs)(void *);
>  
> -	/*Added by Amr - BugID_4720*/
> +	/* Added by Amr - BugID_4720 */
>  	void (*os_spin_lock)(void *, unsigned long *);
>  	void (*os_spin_unlock)(void *, unsigned long *);
>  
> @@ -146,7 +126,7 @@ typedef struct {
>  	uint32_t tx_buffer_size;
>  	void *txq_critical_section;
>  
> -	/*Added by Amr - BugID_4720*/
> +	/* Added by Amr - BugID_4720 */
>  	void *txq_add_to_head_critical_section;
>  	void *txq_spin_lock;
>  
> @@ -218,7 +198,7 @@ typedef struct {
>  	int (*wlan_cfg_set)(int, uint32_t, uint8_t *, uint32_t, int, uint32_t);
>  	int (*wlan_cfg_get)(int, uint32_t, int, uint32_t);
>  	int (*wlan_cfg_get_value)(uint32_t, uint8_t *, uint32_t);
> -	/*Bug3959: transmitting mgmt frames received from host*/
> +	/* Bug3959: transmitting mgmt frames received from host */
>  	#if defined(WILC_AP_EXTERNAL_MLME) || defined(WILC_P2P)
>  	int (*wlan_add_mgmt_to_tx_que)(void *, uint8_t *, uint32_t, wilc_tx_complete_func_t);
>  
> @@ -229,11 +209,7 @@ typedef struct {
>  	#endif
>  } wilc_wlan_oup_t;
>  
> -/********************************************
> - *
> - *      Wlan Configuration ID
> - *
> - ********************************************/
> +/* Wlan Configuration ID */
>  
>  #define MAX_SSID_LEN            33
>  #define MAX_RATES_SUPPORTED     12
> @@ -283,15 +259,15 @@ typedef enum {
>  } G_OPERATING_MODE_T;
>  
>  typedef enum {
> -	G_SHORT_PREAMBLE = 0,   /* Short Preamble          */
> -	G_LONG_PREAMBLE  = 1,           /* Long Preamble           */
> -	G_AUTO_PREAMBLE  = 2,           /* Auto Preamble Selection */
> +	G_SHORT_PREAMBLE = 0,	/* Short Preamble */
> +	G_LONG_PREAMBLE  = 1,	/* Long Preamble */
> +	G_AUTO_PREAMBLE  = 2,	/* Auto Preamble Selection */
>  } G_PREAMBLE_T;
>  
>  #define MAC_CONNECTED    1
>  #define MAC_DISCONNECTED 0
>  
> -/*bug3819: */
> +/* bug3819: */
>  #define SCAN_DONE		TRUE
>  typedef enum {
>  	PASSIVE_SCAN = 0,
> @@ -328,10 +304,10 @@ typedef enum {
>  	WEP_104 = 0x7,
>  	WPA_AES = 0x29,
>  	WPA_TKIP = 0x49,
> -	WPA_AES_TKIP = 0x69,            /* Aes or Tkip */
> +	WPA_AES_TKIP = 0x69,	/* Aes or Tkip */

You are changing the indentation, not // into /* style here.

You do this in other places, just changing alignment, not the C99
comment style.

Please fix up into multiple patches, each one only doing one thing.

thanks,

greg k-h
