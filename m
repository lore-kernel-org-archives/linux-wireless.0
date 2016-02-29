Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oi0-f54.google.com ([209.85.218.54]:34112 "EHLO
	mail-oi0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750712AbcB2VeS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Feb 2016 16:34:18 -0500
Received: by mail-oi0-f54.google.com with SMTP id m82so114949811oif.1
        for <linux-wireless@vger.kernel.org>; Mon, 29 Feb 2016 13:34:17 -0800 (PST)
Subject: Re: alfa awus036nhr v2 and module rtl8xxxu
To: Jes Sorensen <Jes.Sorensen@redhat.com>
References: <loom.20160128T003525-188@post.gmane.org>
 <wrfjd1sco25f.fsf@redhat.com> <56B38CDF.9010806@lwfinger.net>
 <wrfjd1scmkz6.fsf@redhat.com> <wrfj60xxd2f5.fsf@redhat.com>
 <56BA8E5D.5090402@lwfinger.net> <wrfjlh6tb9zt.fsf@redhat.com>
 <CAOhKHAXH-PCyWQSpuuZ=-6BnE0PeDks-4p9A3G_86OHLfEdU=w@mail.gmail.com>
 <56BB5C16.8070206@lwfinger.net> <wrfjk2lomobj.fsf@redhat.com>
 <56D3EBCF.7000206@lwfinger.net> <wrfj7fhnn1jk.fsf@redhat.com>
Cc: dsadsa sadsad <natserver2@gmail.com>,
	linux-wireless@vger.kernel.org
From: Larry Finger <Larry.Finger@lwfinger.net>
Message-ID: <56D4B956.8030408@lwfinger.net> (sfid-20160229_223421_233977_519DE210)
Date: Mon, 29 Feb 2016 15:34:14 -0600
MIME-Version: 1.0
In-Reply-To: <wrfj7fhnn1jk.fsf@redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/29/2016 06:28 AM, Jes Sorensen wrote:
> That one I have never seen before - could you try and insert some debug
> prints to see where the RF initialization fails?

The call to usb_control_msg() is returning -EPROTO (-71), but sometimes the 
system works. I added the following patch:

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c 
b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
index 38aa3c2..8ab77a0 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.c
@@ -1979,9 +1979,12 @@ static int rtl8xxxu_write_rfreg(struct rtl8xxxu_priv *priv,

         /* Use XB for path B */
         ret = rtl8xxxu_write32(priv, rtl8xxxu_rfregs[path].lssiparm, dataaddr);
-       if (ret != sizeof(dataaddr))
+       if (ret != sizeof(dataaddr)) {
+               pr_info("**** rtl8xxxu_write32() error %d: path %d, reg: 0x%x, 
data 0x%x, dataaddr 0x%x, lssiparm 0x%x\n",
+                       ret, path, reg, data, dataaddr, 
rtl8xxxu_rfregs[path].lssiparm);
+               dump_stack();
                 retval = -EIO;
-       else
+       } else
                 retval = 0;

         udelay(1);

When the error happens, my log contains

[52347.751420] **** rtl8xxxu_write32() error -71: path 0, reg: 0x2a, data 0x5, 
dataaddr 0x2a00005, lssiparm 0x840
[52347.751427] CPU: 0 PID: 5743 Comm: systemd-udevd Not tainted 4.5.0-rc2-jes+ #2
[52347.751429] Hardware name: TOSHIBA TECRA A50-A/TECRA A50-A, BIOS Version 4.20 
   04/17/2014
[52347.751430]  00000000fffffffb ffff880117e139b8 ffffffff813d7722 ffff880101fb2860
[52347.751433]  ffff880117e13a00 ffffffffa066ed56 ffffffff00000840 0000000500000010
[52347.751435]  ffffffffa06803c0 ffff880101fb2860 0000000000000000 0000000000000031
[52347.751437] Call Trace:
[52347.751442]  [<ffffffff813d7722>] dump_stack+0x4b/0x79
[52347.751446]  [<ffffffffa066ed56>] rtl8xxxu_write_rfreg+0x146/0x150 [rtl8xxxu]
[52347.751448]  [<ffffffffa0672c32>] rtl8xxxu_init_phy_rf+0x152/0x240 [rtl8xxxu]
[52347.751451]  [<ffffffffa0676c89>] rtl8192cu_init_phy_rf+0x69/0x70 [rtl8xxxu]
[52347.751453]  [<ffffffffa06783ac>] rtl8xxxu_init_device.isra.36+0x57c/0x14d0 
[rtl8xxxu]
[52347.751456]  [<ffffffff815146a8>] ? release_firmware+0x58/0x70
[52347.751458]  [<ffffffffa067a0d5>] rtl8xxxu_probe+0xdd5/0x1130 [rtl8xxxu]
[52347.751461]  [<ffffffff815829a8>] usb_probe_interface+0x1c8/0x310
[52347.751463]  [<ffffffff814ff507>] driver_probe_device+0x247/0x460

--snip--

[52347.751487]  [<ffffffff811899ea>] do_init_module+0x60/0x1ee
[52347.751489]  [<ffffffff81108e51>] load_module+0x1ee1/0x2830
[52347.751491]  [<ffffffff81105230>] ? __symbol_put+0x50/0x50
[52347.751493]  [<ffffffff811098d9>] SyS_init_module+0x139/0x180
[52347.751495]  [<ffffffff81776c17>] entry_SYSCALL_64_fastpath+0x12/0x6f
[52347.751498] usb 3-6: Failed to initialize RF

Perhaps you can recognize what is wrong.

Larry

