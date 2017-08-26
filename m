Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:48897 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752145AbdHZJeg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 26 Aug 2017 05:34:36 -0400
From: "Winkler, Tomas" <tomas.winkler@intel.com>
To: Arvind Yadav <arvind.yadav.cs@gmail.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: RE: [PATCH] nfc: microread: mei: constify mei_cl_device_id
Date: Sat, 26 Aug 2017 09:34:32 +0000
Message-ID: <5B8DA87D05A7694D9FA63FD143655C1B74A091E9@hasmsx109.ger.corp.intel.com> (sfid-20170826_113450_574135_6B853D80)
References: <27f776943a6fd60e938b53673fba7562241ba1bd.1503728505.git.arvind.yadav.cs@gmail.com>
In-Reply-To: <27f776943a6fd60e938b53673fba7562241ba1bd.1503728505.git.arvind.yadav.cs@gmail.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> mei_cl_device_id are not supposed to change at runtime.
> mei driver is working with const 'id_table'. So mark the non-const
> mei_cl_device_id structs as const.
> 
> Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
Ack.
>  drivers/nfc/microread/mei.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/nfc/microread/mei.c b/drivers/nfc/microread/mei.c index
> eb5eddf..70bf7a1 100644
> --- a/drivers/nfc/microread/mei.c
> +++ b/drivers/nfc/microread/mei.c
> @@ -66,7 +66,7 @@ static int microread_mei_remove(struct mei_cl_device
> *cldev)
>  	return 0;
>  }
> 
> -static struct mei_cl_device_id microread_mei_tbl[] = {
> +static const struct mei_cl_device_id microread_mei_tbl[] = {
>  	{ MICROREAD_DRIVER_NAME, MEI_NFC_UUID,
> MEI_CL_VERSION_ANY},
> 
>  	/* required last entry */
> --
> 2.7.4
