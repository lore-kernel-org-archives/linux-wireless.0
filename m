Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:42191 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750812AbdGJI6L (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 10 Jul 2017 04:58:11 -0400
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v6A8sogU089593
        for <linux-wireless@vger.kernel.org>; Mon, 10 Jul 2017 04:57:56 -0400
Received: from e34.co.us.ibm.com (e34.co.us.ibm.com [32.97.110.152])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2bjufqdms4-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-wireless@vger.kernel.org>; Mon, 10 Jul 2017 04:57:56 -0400
Received: from localhost
        by e34.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-wireless@vger.kernel.org> from <rui.teng@linux.vnet.ibm.com>;
        Mon, 10 Jul 2017 02:57:55 -0600
From: Rui Teng <rui.teng@linux.vnet.ibm.com>
To: Aditya Shankar <aditya.shankar@microchip.com>,
        Ganesh Krishna <ganesh.krishna@microchip.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org,
        Rui Teng <rui.teng@linux.vnet.ibm.com>
Subject: [PATCH] drivers/staging/wilc1000: fix sparse warning: right shift by bigger than source value
Date: Mon, 10 Jul 2017 16:57:31 +0800
Message-Id: <20170710085731.28397-1-rui.teng@linux.vnet.ibm.com> (sfid-20170710_105845_329453_23FCEDA0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch sets memory to zero directly to avoid unnecessary shift and
bitwise operations on bool type, which can fix a sparse warning and also
improve performance.

Signed-off-by: Rui Teng <rui.teng@linux.vnet.ibm.com>
---
 drivers/staging/wilc1000/host_interface.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/wilc1000/host_interface.c b/drivers/staging/wilc1000/host_interface.c
index 2568dfc15181..036c5c19a016 100644
--- a/drivers/staging/wilc1000/host_interface.c
+++ b/drivers/staging/wilc1000/host_interface.c
@@ -2416,10 +2416,9 @@ static void Handle_SetMulticastFilter(struct wilc_vif *vif,
 		goto ERRORHANDLER;
 
 	pu8CurrByte = wid.val;
-	*pu8CurrByte++ = (strHostIfSetMulti->enabled & 0xFF);
-	*pu8CurrByte++ = ((strHostIfSetMulti->enabled >> 8) & 0xFF);
-	*pu8CurrByte++ = ((strHostIfSetMulti->enabled >> 16) & 0xFF);
-	*pu8CurrByte++ = ((strHostIfSetMulti->enabled >> 24) & 0xFF);
+	memset(pu8CurrByte, 0, 4);
+	*pu8CurrByte = (strHostIfSetMulti->enabled & 0xFF);
+	pu8CurrByte += 4;
 
 	*pu8CurrByte++ = (strHostIfSetMulti->cnt & 0xFF);
 	*pu8CurrByte++ = ((strHostIfSetMulti->cnt >> 8) & 0xFF);
-- 
2.11.0
