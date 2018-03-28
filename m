Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59162 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751207AbeC1Lf7 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 28 Mar 2018 07:35:59 -0400
Date: Wed, 28 Mar 2018 13:35:56 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Ajay Singh <ajay.kathat@microchip.com>
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        venkateswara.kaja@microchip.com, ganesh.krishna@microchip.com,
        adham.abozaeid@Microchip.com, aditya.shankar@microchip.com
Subject: Re: [PATCH v2 1/9] staging: wilc1000: remove unused global variables
 related to p2p
Message-ID: <20180328113556.GA30980@kroah.com> (sfid-20180328_133603_444514_3E28D970)
References: <1522064763-11576-1-git-send-email-ajay.kathat@microchip.com>
 <1522064763-11576-2-git-send-email-ajay.kathat@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1522064763-11576-2-git-send-email-ajay.kathat@microchip.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 26, 2018 at 05:15:55PM +0530, Ajay Singh wrote:
> Cleanup patch to remove the unused global variables defined for p2p.
> 
> Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
> Reviewed-by: Claudiu Beznea <claudiu.beznea@microchip.com>
> ---
>  drivers/staging/wilc1000/host_interface.c | 59 -------------------------------
>  1 file changed, 59 deletions(-)
> 
> diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
> index 5082ede..a13998d 100644
> --- a/drivers/staging/wilc1000/host_interface.c
> +++ b/drivers/staging/wilc1000/host_interface.c
> @@ -254,13 +254,6 @@ static u32 inactive_time;
>  static u8 del_beacon;
>  static u32 clients_count;
>  
> -static u8 *join_req;
> -static u8 *info_element;
> -static u8 mode_11i;
> -static u8 auth_type;
> -static u32 join_req_size;
> -static u32 info_element_size;
> -static struct wilc_vif *join_req_vif;

These are not "globals", just static to this file.  But yeah, global to
the file, but when I think of "global", I think of "global to the whole
kernel".

Anyway, not a problem...

greg k-h
