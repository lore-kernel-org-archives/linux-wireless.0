Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:34402 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751202AbbHRF61 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 18 Aug 2015 01:58:27 -0400
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Subject: Re: rtlwifi: rtl8192cu: Remove and replace routine in hw.c and mac.c
From: Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <1428343980-13954-1-git-send-email-ap420073@gmail.com>
To: Taehee Yoo <ap420073@gmail.com>
Cc: Larry.Finger@lwfinger.net, ap420073@gmail.com,
	linux-wireless@vger.kernel.org
Message-Id: <20150818055826.ED27A140302@smtp.codeaurora.org> (sfid-20150818_075830_319232_221F59D0)
Date: Tue, 18 Aug 2015 05:58:26 +0000 (UTC)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> I remove duplicated routines which related rtl92cu_set_hw_reg().
> 
> 1. rtl92c_set_qos() and HW_VAR_AC_PARAM routine are similar code.
> so i replace code with rtlpriv->cfg->ops->set_hw_reg().
> 
> 2. rtl92c_set_mac_addr() and 'HW_VAR_ETHER_ADDR' case at
> rtl92cu_set_hw_reg() routine are similar code.
> so i removed rtl92c_set_mac_addr() function.
> also it was not used anywhere.
> 
> 3. remove HW_VAR_ACM_CTRL routine in rtl92cu_set_hw_reg().
> if rtl_usb->acm_method is not EACMWAY2_SW, HW_VAR_ACM_CTRL is called
> from HW_VAR_AC_PARAM. but it never called. because acm_method is always
> EACMWAY2_SW. so i remove acm_method check routine
> and HW_VAR_ACM_CTRL routine.
> 
> both usb and pci interface is not used HW_VAR_ACM_CTRL.
> but i can't test pci interface module, so i didn't modify pci code.
> 
> Signed-off-by: Taehee Yoo <ap420073@gmail.com>

Thanks, applied to wireless-drivers-next.git.

Kalle Valo
