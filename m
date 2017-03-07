Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1050.oracle.com ([156.151.31.82]:30966 "EHLO
        userp1050.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754430AbdCGTZK (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 7 Mar 2017 14:25:10 -0500
Date: Tue, 7 Mar 2017 20:23:04 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Andrea Ghittino <aghittino@gmail.com>
Cc: aditya.shankar@microchip.com, ganesh.krishna@microchip.com,
        gregkh@linuxfoundation.org, linux-wireless@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: wilc1000: Fix sparse warnings incorrect type
 assignment
Message-ID: <20170307172304.GH4171@mwanda> (sfid-20170307_202800_359194_48860BA2)
References: <20170306211106.GA9885@myhd3>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170306211106.GA9885@myhd3>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Mar 06, 2017 at 10:11:21PM +0100, Andrea Ghittino wrote:
> Fixed sparse warnings
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
> 
> Signed-off-by: Andrea Ghittino <aghittino@gmail.com>
> ---
> Compile tested only

This commit doesn't tell me if you though about what you are doing at
all.  We get so many commits where people just randomly do random endian
things...  Did you think about this?  Could you resend with a better
commit message?

regards,
dan carpenter
