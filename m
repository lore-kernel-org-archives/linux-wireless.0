Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.15.19]:53515 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752155AbdATLYT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 20 Jan 2017 06:24:19 -0500
MIME-Version: 1.0
Message-ID: <trinity-f818c38b-7cc2-4d89-a960-a1485efa51d4-1484910843965@3capp-gmx-bs36> (sfid-20170120_122449_608765_0D163B9B)
From: "Lino Sanfilippo" <LinoSanfilippo@gmx.de>
To: "Larry Finger" <Larry.Finger@lwfinger.net>
Cc: "Bharat Kumar Gogada" <bharat.kumar.gogada@xilinx.com>,
        chaoming_li@realsil.com.cn, linux-wireless@vger.kernel.org,
        linux-kernel@vger.kernel.org, kvalo@codeaurora.org,
        netdev@vger.kernel.org, rgummal@xilinx.com,
        "Bharat Kumar Gogada" <bharatku@xilinx.com>
Subject: Re: Re: [PATCH] rtlwifi: rtl8192x: Enabling and disabling hardware
 interrupts after enabling local irq flags
Content-Type: text/plain; charset=UTF-8
Date: Fri, 20 Jan 2017 12:14:03 +0100
In-Reply-To: <b2e783f6-fa09-e287-8119-266299cdae22@lwfinger.net>
References: <1484820854-16719-1-git-send-email-bharatku@xilinx.com>,
 <b2e783f6-fa09-e287-8119-266299cdae22@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

>
> 
> This patch should be enhanced with the smb_xx() calls as suggested by by Lino.
> 

If you do this, please place the smp_rmb() before the if condition in the irq
handler like

smp_rmb();
if (rtlpci->irq_enabled == 0) {
    return ret;


as I think that the suggestion I made before was not correct (sorry for the
confusion). 

Regards,
Lino 
 
