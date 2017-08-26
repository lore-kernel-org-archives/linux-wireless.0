Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:39322 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751973AbdHZJfA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 26 Aug 2017 05:35:00 -0400
From: "Winkler, Tomas" <tomas.winkler@intel.com>
To: Arvind Yadav <arvind.yadav.cs@gmail.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH] nfc: pn544: mei: constify mei_cl_device_id
Date: Sat, 26 Aug 2017 09:34:56 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B74A091F9@hasmsx109.ger.corp.intel.com> (sfid-20170826_113513_987578_6E95EB75)
References: <4ba05401d57ab830769ef411420efdd62fa3f883.1503728344.git.arvind.yadav.cs@gmail.com>
In-Reply-To: <4ba05401d57ab830769ef411420efdd62fa3f883.1503728344.git.arvind.yadav.cs@gmail.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> 
> mei_cl_device_id are not supposed to change at runtime.
> mei driver is working with const 'id_table'. So mark the non-const
> mei_cl_device_id structs as const.
> 
> Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
Ack

>  drivers/nfc/pn544/mei.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/nfc/pn544/mei.c b/drivers/nfc/pn544/mei.c index
> ad57a8e..a6c2e9c 100644
> --- a/drivers/nfc/pn544/mei.c
> +++ b/drivers/nfc/pn544/mei.c
> @@ -66,7 +66,7 @@ static int pn544_mei_remove(struct mei_cl_device
> *cldev)
>  	return 0;
>  }
> 
> -static struct mei_cl_device_id pn544_mei_tbl[] = {
> +static const struct mei_cl_device_id pn544_mei_tbl[] = {
>  	{ PN544_DRIVER_NAME, MEI_NFC_UUID, MEI_CL_VERSION_ANY},
> 
>  	/* required last entry */
> --
> 2.7.4
