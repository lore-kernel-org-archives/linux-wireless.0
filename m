Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1050.oracle.com ([156.151.31.82]:37529 "EHLO
        userp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750799AbdCHGYz (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 8 Mar 2017 01:24:55 -0500
Date: Wed, 8 Mar 2017 09:22:06 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Andrea Ghittino <aghittino@gmail.com>
Cc: aditya.shankar@microchip.com, ganesh.krishna@microchip.com,
        gregkh@linuxfoundation.org, linux-wireless@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] staging: wilc1000: Fix sparse warnings incorrect type
 assignment
Message-ID: <20170308062206.GV4171@mwanda> (sfid-20170308_072528_523472_6E9F1D4B)
References: <20170307213641.GA4193@myhd3>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170307213641.GA4193@myhd3>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I think this change is buggy.

On Tue, Mar 07, 2017 at 10:36:53PM +0100, Andrea Ghittino wrote:
> Fixed sparse warnings related to the conversion of le16 and le32 to u16 and u32, during the update of internal structures
> 
> Fixed sparse warnings:
> drivers/staging/wilc1000//wilc_wfi_cfgoperations.c:2011:52: warning: incorrect type in assignment (different base types)
> drivers/staging/wilc1000//wilc_wfi_cfgoperations.c:2011:52:    expected unsigned short [unsigned] [assigned] [usertype] ht_ext_params
> drivers/staging/wilc1000//wilc_wfi_cfgoperations.c:2011:52:    got restricted __le16 const [usertype] extended_ht_cap_info
> drivers/staging/wilc1000//wilc_wfi_cfgoperations.c:2012:51: warning: incorrect type in assignment (different base types)
> drivers/staging/wilc1000//wilc_wfi_cfgoperations.c:2012:51:    expected unsigned int [unsigned] [assigned] [usertype] ht_tx_bf_cap
> drivers/staging/wilc1000//wilc_wfi_cfgoperations.c:2012:51:    got restricted __le32 const [usertype] tx_BF_cap_info
> drivers/staging/wilc1000//wilc_wfi_cfgoperations.c:2078:51: warning: incorrect type in assignment (different base types)
> drivers/staging/wilc1000//wilc_wfi_cfgoperations.c:2078:51:    expected unsigned short [unsigned] [assigned] [usertype] ht_capa_info
> drivers/staging/wilc1000//wilc_wfi_cfgoperations.c:2078:51:    got restricted __le16 const [usertype] cap_info
> drivers/staging/wilc1000//wilc_wfi_cfgoperations.c:2083:52: warning: incorrect type in assignment (different base types)
> drivers/staging/wilc1000//wilc_wfi_cfgoperations.c:2083:52:    expected unsigned short [unsigned] [assigned] [usertype] ht_ext_params
> drivers/staging/wilc1000//wilc_wfi_cfgoperations.c:2083:52:    got restricted __le16 const [usertype] extended_ht_cap_info
> drivers/staging/wilc1000//wilc_wfi_cfgoperations.c:2084:51: warning: incorrect type in assignment (different base types)
> drivers/staging/wilc1000//wilc_wfi_cfgoperations.c:2084:51:    expected unsigned int [unsigned] [assigned] [usertype] ht_tx_bf_cap
> drivers/staging/wilc1000//wilc_wfi_cfgoperations.c:2084:51:    got restricted __le32 const [usertype] tx_BF_cap_info
> 

What I want in a changelog is:  "We're copying data that's little endian
from (some place) to where ever and then we (whatever) do math using the
variable so it needs to be CPU endian.  Presumably this wasn't caught
in testing because it was only used on x86 or other little endian
systems."

In this case we're copying little endian data and then sending it
directly back to some place which requires little endian data so
converting it is a bug.

regards,
dan carpenter
