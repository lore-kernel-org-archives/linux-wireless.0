Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:46119 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754777Ab2DXPLV (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Apr 2012 11:11:21 -0400
Received: by obbta14 with SMTP id ta14so1270188obb.19
        for <linux-wireless@vger.kernel.org>; Tue, 24 Apr 2012 08:11:20 -0700 (PDT)
Message-ID: <4F96C292.8080902@lwfinger.net> (sfid-20120424_171124_849833_5C44A43E)
Date: Tue, 24 Apr 2012 10:11:14 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: jorge potosme <jorge_potosme@hotmail.com>
CC: wireless <linux-wireless@vger.kernel.org>
Subject: Re: Low wireless ratio with RTL8188CE, dont get all wireless AP
References: <BLU0-SMTP2056B92726653D8AAE3E9EF9A210@phx.gbl> <4F95E825.5060902@lwfinger.net> <BLU0-SMTP371AD602F7E93D9310AF9AF9A260@phx.gbl>
In-Reply-To: <BLU0-SMTP371AD602F7E93D9310AF9AF9A260@phx.gbl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 04/24/2012 07:26 AM, jorge potosme wrote:
> The drirver can connect without problems, but i cant get a full list of all
> access points, i dunno so much about coding drivers but i saw some diferences
> with the source code of some driver files on linux-3.1.10 and linux-3.3.2, well
> now ill try with kernel 3.3.3.
>
> *kernel 3.1.10*
> */drivers/net/wireless/rtlwifi/rtl8192ce/hw.c*
> lines 924,926 and 927 kernel 3.3.2 dont have that lines
> lines 1202,1213 are diferent on kernel 3.3.2
>
> *kernel 3.1.10*
> */drivers/net/wireless/rtlwifi/rtl8192ce/sw.c*
>
> /* request fw */
> err = request_firmware(&firmware, rtlpriv->cfg->fw_name,
> rtlpriv->io.dev);
>
> *on kernel 3.3.2*
>
> /* request fw */
> if (IS_VENDOR_UMC_A_CUT(rtlhal->version) &&
> !IS_92C_SERIAL(rtlhal->version))
> rtlpriv->cfg->fw_name = "rtlwifi/rtl8192cfwU.bin";
> else if (IS_81xxC_VENDOR_UMC_B_CUT(rtlhal->version))
> rtlpriv->cfg->fw_name = "rtlwifi/rtl8192cfwU_B.bin";
>
> rtlpriv->max_fw_size = 0x4000;
> pr_info("Using firmware %s\n", rtlpriv->cfg->fw_name);
> err = request_firmware_nowait(THIS_MODULE, 1, rtlpriv->cfg->fw_name,
> rtlpriv->io.dev, GFP_KERNEL, hw,
> rtl_fw_cb);

Two points to consider: (1) Unless you are paying for private consulting, never 
drop any mailing lists from your replies. Use "Reply All", not "Reply". (2) 
Always use the diff utility with the "-u" option to show differences in source 
files.

Larry



