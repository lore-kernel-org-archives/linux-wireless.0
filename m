Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f176.google.com ([209.85.212.176]:36788 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752049AbbJFPPF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 6 Oct 2015 11:15:05 -0400
Received: by wicgb1 with SMTP id gb1so170266273wic.1
        for <linux-wireless@vger.kernel.org>; Tue, 06 Oct 2015 08:15:03 -0700 (PDT)
Date: Tue, 6 Oct 2015 16:14:59 +0100
From: Mike Rapoport <mike.rapoport@gmail.com>
To: Tony Cho <tony.cho@atmel.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
	rachel.kim@atmel.com, chris.park@atmel.com, austin.shin@atmel.com,
	linux-wireless@vger.kernel.org, johnny.kim@atmel.com,
	Nicolas.FERRE@atmel.com, adel.noureldin@atmel.com,
	leo.kim@atmel.com, adham.abozaeid@atmel.com
Subject: Re: [PATCH 02/10] staging: wilc1000: remove typedef from tenuWIDtype
Message-ID: <20151006151459.GA25750@zed.theccd.local> (sfid-20151006_171510_224785_303BBC20)
References: <1444124541-5663-1-git-send-email-tony.cho@atmel.com>
 <1444124541-5663-2-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1444124541-5663-2-git-send-email-tony.cho@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Oct 06, 2015 at 06:42:13PM +0900, Tony Cho wrote:
> From: Leo Kim <leo.kim@atmel.com>
> 
> This patch remove typedef from the enum tenuWIDtype
> and rename it to WID_TYPE.
> 
> Signed-off-by: Leo Kim <leo.kim@atmel.com>
> Signed-off-by: Tony Cho <tony.cho@atmel.com>
> ---
>  drivers/staging/wilc1000/coreconfigurator.h | 2 +-
>  drivers/staging/wilc1000/host_interface.h   | 2 +-
>  drivers/staging/wilc1000/wilc_wlan_if.h     | 5 ++---
>  3 files changed, 4 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/staging/wilc1000/coreconfigurator.h b/drivers/staging/wilc1000/coreconfigurator.h
> index 306efc9..02faf58 100644

[ snip ]

> diff --git a/drivers/staging/wilc1000/wilc_wlan_if.h b/drivers/staging/wilc1000/wilc_wlan_if.h
> index 8fec64d..be972af 100644
> --- a/drivers/staging/wilc1000/wilc_wlan_if.h
> +++ b/drivers/staging/wilc1000/wilc_wlan_if.h
> @@ -315,7 +315,7 @@ typedef enum {
>  	SW_TRIGGER_ABORT,
>  } TX_ABORT_OPTION_T;
>  
> -typedef enum {
> +enum WID_TYPE {

The enum name should be lowecase, i.e. 'enum wid_type'. 

>  	WID_CHAR		= 0,
>  	WID_SHORT		= 1,
>  	WID_INT			= 2,
> @@ -326,8 +326,7 @@ typedef enum {
>  	WID_ADR			= 7,
>  	WID_UNDEF		= 8,
>  	WID_TYPE_FORCE_32BIT	= 0xFFFFFFFF
> -
> -} WID_TYPE_T, tenuWIDtype;
> +};
>  
>  typedef enum {
>  	WID_NIL				= 0xffff,
> -- 
> 1.9.1

--
Sincerely yours,
Mike.
