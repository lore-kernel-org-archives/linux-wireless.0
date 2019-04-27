Return-Path: <SRS0=RVLw=S5=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_PASS,URIBL_BLOCKED,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44DF2C43219
	for <linux-wireless@archiver.kernel.org>; Sat, 27 Apr 2019 06:36:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0E1162087C
	for <linux-wireless@archiver.kernel.org>; Sat, 27 Apr 2019 06:36:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1556346970;
	bh=uDeOhpk2m/dBsaQa2ougP/eQGldwZ+WxJ+1Wb0Om0Z0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=z1LgrvYXzKJivKhEJ+qU1VPbY9Z5lMIUpEI+nOvndjQ2IEPWhgtY9flTBYiHVx51Z
	 k/xVp+es63IpnXZT5neeLf/Bmn1aUFazGP66nkrNwE3tBGjXlwuHVg19YiH60beRro
	 /0RuPVrqlauDuaco/6vzbqUL8a29w5Grmt/3uyws=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726048AbfD0GgJ (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Sat, 27 Apr 2019 02:36:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:38078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726001AbfD0GgJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 27 Apr 2019 02:36:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1C847205ED;
        Sat, 27 Apr 2019 06:36:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556346967;
        bh=uDeOhpk2m/dBsaQa2ougP/eQGldwZ+WxJ+1Wb0Om0Z0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ypl760VuwBf59YODqtlsOQQA62TgZlMyvoQZwPD/vDHwfQFVGTC1QzG71mPEtG8A9
         2CGRcVY1V8zAhiVok3Q3JN+W6SY7ROF6GegjA+xv2kn3Gcd1Ezo5460u8cp9RM+yiU
         UYNZWmjleIocMHIFBs5YfqtcWFqnhxvRP/KdOcLA=
Date:   Sat, 27 Apr 2019 08:36:04 +0200
From:   "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To:     Tony Chuang <yhchuang@realtek.com>
Cc:     Kalle Valo <kvalo@codeaurora.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "johannes@sipsolutions.net" <johannes@sipsolutions.net>,
        Pkshih <pkshih@realtek.com>, Andy Huang <tehuang@realtek.com>,
        "Larry.Finger@lwfinger.net" <Larry.Finger@lwfinger.net>,
        "sgruszka@redhat.com" <sgruszka@redhat.com>,
        "briannorris@chromium.org" <briannorris@chromium.org>
Subject: Re: [PATCH v9 14/14] staging: rtlwifi: remove staging rtlwifi driver
Message-ID: <20190427063604.GD15324@kroah.com>
References: <1555653004-1795-1-git-send-email-yhchuang@realtek.com>
 <1555653004-1795-15-git-send-email-yhchuang@realtek.com>
 <87d0l9ufw5.fsf@kamboji.qca.qualcomm.com>
 <F7CD281DE3E379468C6D07993EA72F84D17E3307@RTITMBSVM04.realtek.com.tw>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <F7CD281DE3E379468C6D07993EA72F84D17E3307@RTITMBSVM04.realtek.com.tw>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On Fri, Apr 26, 2019 at 12:19:14PM +0000, Tony Chuang wrote:
> Hi Greg,
> 
> > -----Original Message-----
> > From: Kalle Valo [mailto:kvalo@codeaurora.org]
> > Sent: Friday, April 26, 2019 8:10 PM
> > To: Tony Chuang
> > Cc: linux-wireless@vger.kernel.org; johannes@sipsolutions.net; Pkshih; Andy
> > Huang; Larry.Finger@lwfinger.net; sgruszka@redhat.com;
> > briannorris@chromium.org; gregkh@linuxfoundation.org
> > Subject: Re: [PATCH v9 14/14] staging: rtlwifi: remove staging rtlwifi driver
> > 
> > <yhchuang@realtek.com> writes:
> > 
> > > From: Yan-Hsuan Chuang <yhchuang@realtek.com>
> > >
> > > The rtlwifi driver is conflicting with Realtek's new 802.11ac chip
> > > series driver rtw88, remove it to avoid racing with the same ID.
> > >
> > > The rtw88 driver can be found at drivers/net/wireless/realtek/rtw88
> > >
> > > Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > Signed-off-by: Yan-Hsuan Chuang <yhchuang@realtek.com>
> > 
> > BTW, this patch does not apply to wireless-drivers-next anymore. To
> > avoid any conflicts, would be it be safer that the driver is removed
> > directly from Greg's tree? After rtw88 is applied to
> > wireless-drivers-next, of course.
> > 
> > error: patch failed: drivers/staging/rtlwifi/Kconfig:1
> > error: drivers/staging/rtlwifi/Kconfig: patch does not apply
> > error: patch failed: drivers/staging/rtlwifi/efuse.c:1
> > error: drivers/staging/rtlwifi/efuse.c: patch does not apply
> > error: patch failed:
> > drivers/staging/rtlwifi/halmac/halmac_88xx/halmac_func_88xx.c:1
> > error: drivers/staging/rtlwifi/halmac/halmac_88xx/halmac_func_88xx.c: patch
> > does not apply
> > error: patch failed: drivers/staging/rtlwifi/pci.h:1
> > error: drivers/staging/rtlwifi/pci.h: patch does not apply
> > error: patch failed: drivers/staging/rtlwifi/phydm/phydm_rainfo.c:1
> > error: drivers/staging/rtlwifi/phydm/phydm_rainfo.c: patch does not apply
> > error: patch failed: drivers/staging/rtlwifi/phydm/rtl_phydm.c:1
> > error: drivers/staging/rtlwifi/phydm/rtl_phydm.c: patch does not apply
> > error: patch failed: drivers/staging/rtlwifi/rtl8822be/fw.c:1
> > error: drivers/staging/rtlwifi/rtl8822be/fw.c: patch does not apply
> > Patch failed at 0014 staging: rtlwifi: remove staging rtlwifi driver
> > 
> 
> Hi Greg,
> 
> Can you help us to remove the staging driver rtlwifi in your tree ?
> I think Kalle can issue a signal to you when he has done reviewing
> the rtw88 driver and merge it into wireless-drivers-next.

Sure, I will be glad to drop the driver from my tree once the new driver
has been added to the wireless-drivers-next tree.  Just let me know!

thanks,

greg k-h
