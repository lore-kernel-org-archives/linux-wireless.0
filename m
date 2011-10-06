Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:59855 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756723Ab1JFTkJ (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Oct 2011 15:40:09 -0400
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1RBtna-0005c4-RS
	for linux-wireless@vger.kernel.org; Thu, 06 Oct 2011 21:40:06 +0200
Received: from s660-4.noc.RWTH-Aachen.DE ([134.130.4.244])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 06 Oct 2011 21:40:06 +0200
Received: from toddy by s660-4.noc.RWTH-Aachen.DE with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 06 Oct 2011 21:40:06 +0200
To: linux-wireless@vger.kernel.org
From: Toddy <toddy@fishpost.de>
Subject: Re: Alfa AWUS036NHR with RTL8188RU chipset
Date: Thu, 6 Oct 2011 16:25:25 +0000 (UTC)
Message-ID: <loom.20111006T181210-236@post.gmane.org> (sfid-20111006_214013_455580_13208323)
References: <4E77F631.3030202@googlemail.com> <4E77F9FD.1020204@googlemail.com> <4E780309.9010601@lwfinger.net> <4E785DB3.5040109@googlemail.com> <4E7907D3.1020606@googlemail.com> <4E792994.1080809@lwfinger.net> <4E79B1D0.7090602@googlemail.com> <4E79F87F.1050402@lwfinger.net> <4E7A38D0.7070304@googlemail.com> <4E7A4310.30106@lwfinger.net> <4E7A48D1.8050009@googlemail.com> <4E7A4B03.4070006@lwfinger.net> <4E7A4B9C.5040000@googlemail.com> <4E7A4BFB.2080102@googlemail.com> <4E7A529E.1040808@lwfinger.net> <loom.20110930T160704-310@post.gmane.org> <4E85DDA9.3090300@lwfinger.net> <loom.20110930T195810-426@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I also have the AWUS036NHR device and I got it working on Ubuntu 11.04
2.6.38-11-generic x64. The only thing I did is to compile&install
compat-wireless-2.6.39-1 (same as beini!) which can be found here:
http://www.orbit-lab.org/kernel/compat-wireless-2.6-stable/v2.6.39/

There was only one strange thing: In drivers/net/wireless/rtlwifi/rtl8192cu/sw.c
there is no entry for the AWUS036NHR so that no driver is loaded when I plugged
the USB in, but in older versions of compat-wireless (e.g. 2.6.38) there IS one
entry for this device. The entry looks like this:

/* 8188RU in Alfa AWUS036NHR */
{RTL_USB_DEVICE(USB_VENDER_ID_REALTEK, 0x817f, rtl92cu_hal_cfg)}

So I patched the file, compiled&installed it and everything worked! Could
someone patch the sources and add this device? Thanks!

Toddy



