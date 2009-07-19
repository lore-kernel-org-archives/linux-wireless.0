Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f184.google.com ([209.85.210.184]:49145 "EHLO
	mail-yx0-f184.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753417AbZGSMvv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 19 Jul 2009 08:51:51 -0400
Received: by yxe14 with SMTP id 14so2912186yxe.33
        for <linux-wireless@vger.kernel.org>; Sun, 19 Jul 2009 05:51:50 -0700 (PDT)
Date: Sun, 19 Jul 2009 14:53:39 +0300 (EAT)
From: Dan Carpenter <error27@gmail.com>
To: yi.zhu@intel.com
cc: linux-wireless@vger.kernel.org
Subject: iwmc3200wifi: using freed memory in iwm_hal_send_target_cmd()
Message-ID: <alpine.DEB.2.00.0907171555200.12306@bicker>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I found this with a source code checker (http://repo.or.cz/w/smatch.git).

We free "cmd" on line 390 and then dereference it on line 396.  I don't 
know what we should return in that case or I would have sent a patch.  
Sorry.

drivers/net/wireless/iwmc3200wifi/hal.c
   390          if (!udma_cmd->resp)
   391                  kfree(cmd);
   392  
   393          if (ret < 0)
   394                  return ret;
   395  
   396          return cmd->seq_num;

regards,
dan carpenter
