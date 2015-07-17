Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f47.google.com ([74.125.82.47]:36037 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751502AbbGQTnO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Jul 2015 15:43:14 -0400
Received: by wgxm20 with SMTP id m20so89508462wgx.3
        for <linux-wireless@vger.kernel.org>; Fri, 17 Jul 2015 12:43:13 -0700 (PDT)
From: =?utf-8?B?U3rFkXRzIMOBa29z?= <szotsaki@gmail.com>
To: Christian Lamparter <chunkeey@googlemail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Kernel BUG in rtl92s_phy_chk_fwcmd_iodone():<0-0> Set FW Cmd fail
Date: Fri, 17 Jul 2015 21:43:11 +0200
Message-ID: <44939605.9vv6ehsMWa@linux-suse.hu> (sfid-20150717_214320_139989_63F0E89B)
In-Reply-To: <3490881.Z6v5kN1kTe@debian64>
References: <4407990.FztixZGyze@linux-suse.hu> <3490881.Z6v5kN1kTe@debian64>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Christian Lamparter a következőt írta ekkor: 2015. július 9. 15:39:43
> On Tuesday, July 07, 2015 11:56:21 PM Szőts Ákos wrote:
> > I have an RTL8191SU 802.11n USB WLAN Adapter with rtl8192su driver.
> > Unfortunately, I have to turn it off and on sometimes to make it work. I
> > use NetworkManager with KDE 5 nm-applet in which I simply turn off the
> > wireless capability then on again.
> > 
> > Once I did this, I got a kernel BUG. Here is the link for the full text:
> > http://paste.opensuse.org/view/simple/25089935
> 
> This message lets you know that a firmware command has timed out.
> A call trace is included to let you know what the driver was doing
> at the time. If this problem bothers you, the information from the
> trace should help to debug it and make a patch.

Thank you for the hint. Doing some printk's, it was revealed that 
rtl8191s/phy_common.c:_rtl92s_phy_set_fwcmd_io first tried to 
FW_CMD_PAUSE_DM_BY_SCAN then to FW_CMD_RESUME_DM_BY_SCAN. 

Turning the adapter off and on again fixed the issue, the networks appeared 
again, but I don't know why the scan timed out. Unfortunately, I don't know 
anything about the firmwares of the wireless drivers, so I can't trace it 
further and create a patch.

> 
> > kernel: rtl8192s_common:rtl92s_phy_chk_fwcmd_iodone():<0-0> Set FW Cmd
> > fail!! kernel: ------------[ cut here ]------------
> > kernel: WARNING: CPU: 3 PID: 1105 at
> > /home/aki/temp/rtl8192su/rtlwifi/rtl8192s/phy_common.c:1192
> > rtl92s_phy_chk_fwcmd_iodone+0x65/0xb0 [rtl8192s_common]()
> > kernel: Modules linked in: rtl8192su(O) rtl8192s_common(O) rtl_usb(O)
> > rtlwifi(O)... kernel: Call Trace:
> > kernel:  [<ffffffff816d178e>] dump_stack+0x4c/0x6e
> > kernel:  [<ffffffff8106b4fa>] warn_slowpath_common+0x8a/0xc0
> > kernel:  [<ffffffff8106b5ea>] warn_slowpath_null+0x1a/0x20
> > kernel:  [<ffffffffa05ef875>] rtl92s_phy_chk_fwcmd_iodone+0x65/0xb0
> > [rtl8192s_common]
> > kernel:  [<ffffffffa05f1c31>] _rtl92s_phy_set_fwcmd_io+0xe1/0x670
> > [rtl8192s_common]
> > kernel:  [<ffffffffa05f2279>] rtl92s_phy_set_fw_cmd+0xb9/0x7b0
> > [rtl8192s_common] kernel:  [<ffffffffa05f29aa>]
> > rtl92s_phy_scan_operation_backup+0x3a/0x90 [rtl8192s_common]
> > kernel:  [<ffffffffa061b8d9>] rtl_op_sw_scan_start+0xa9/0x170 [rtlwifi]
> 
> Regards,
> Christian
