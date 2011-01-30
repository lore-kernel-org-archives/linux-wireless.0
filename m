Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-yx0-f174.google.com ([209.85.213.174]:50102 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752771Ab1A3TaT (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 30 Jan 2011 14:30:19 -0500
Received: by yxt3 with SMTP id 3so1704277yxt.19
        for <linux-wireless@vger.kernel.org>; Sun, 30 Jan 2011 11:30:18 -0800 (PST)
Message-ID: <4D45BC76.1080501@lwfinger.net>
Date: Sun, 30 Jan 2011 13:31:02 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Hauke Mehrtens <hauke@hauke-m.de>
CC: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	george0505 <george0505@realtek.com>,
	'Zhaoming_Li' <chaoming_li@realsil.com.cn>
Subject: Re: [RFC/RFT 1/8] rtlwifi: Prepare core for addition of USB driver
References: <1296411100-5675-1-git-send-email-Larry.Finger@lwfinger.net> <1296411100-5675-2-git-send-email-Larry.Finger@lwfinger.net> <4D45AEB1.3010207@hauke-m.de>
In-Reply-To: <4D45AEB1.3010207@hauke-m.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/30/2011 12:32 PM, Hauke Mehrtens wrote:
> .....
> Now rtlwifi depends on usb (which is missing in KConfig), also when
> using the PCIe chip RTL8192CE. Would it not be better to have one
> interface independent core of rtlwifi as a module and one extra module
> for usb and one for pcie support? I have not looked into the source code
> if it is easily possible to do so.

Actually, RTL8192CE does not depend on USB nor does the implementation prior to
these patches.

I do see a couple of problems with the Kconfig. RTL8192CE needs to have a
dependence on PCI, and RTLWIFI needs to be dependent on RTL8192CE || RTL8192CU.

Sure it would be possible to split rtlwifi into 3 parts. I don't know how much
work it would be, but the lsmod size for all 3 parts together is 113332. If we
take the USB part out, it is 101654. Is this enough of a memory savings once the
additional memory to handle the linkage between the core and the PCI/USB parts
is taken into account?

Thanks,

Larry
