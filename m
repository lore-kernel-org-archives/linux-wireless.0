Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f176.google.com ([209.85.214.176]:49565 "EHLO
	mail-ob0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746AbaLZClc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Dec 2014 21:41:32 -0500
Received: by mail-ob0-f176.google.com with SMTP id vb8so33297557obc.7
        for <linux-wireless@vger.kernel.org>; Thu, 25 Dec 2014 18:41:31 -0800 (PST)
Message-ID: <549CCAD8.70704@lwfinger.net> (sfid-20141226_034153_901732_8F187EB0)
Date: Thu, 25 Dec 2014 20:41:28 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Christopher Chavez <chrischavez@gmx.us>,
	linux-wireless@vger.kernel.org
Subject: Re: p54usb kernel panic on recent mainline kernels
References: <CAAFQ00kq-5+TFkH+i5fMXATxVCy-DeLP4G+D6+dxDSRo-fh6Xw@mail.gmail.com>
In-Reply-To: <CAAFQ00kq-5+TFkH+i5fMXATxVCy-DeLP4G+D6+dxDSRo-fh6Xw@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/24/2014 10:39 PM, Christopher Chavez wrote:
> When a device using p54usb joins/connects/associates with an access
> point, a kernel panic occurs.
> The AP tested uses WPA2; have not tested whether the issue occurs for
> other security types or ad hoc connections. The specific devices
> tested are 2Wire 802.11g USB v1 (vendor 1630 device 0005). The
> firmware used is 2.13.1.0.lm86.arm (a.k.a. "isl3886usb" recommended on
> wireless.kernel.org). Tested on Ubuntu 14.10, 32-bit x86 (have not
> tested 64-bit or other architectures). Tested on machines with Intel
> and SiS USB chipsets. I can try collecting more info (e.g. dmesg
> output), and am currently bisecting the kernel somewhere around
> 3.17-rc1.
>
> Should this be reported as a kernel bug or with the driver?

It looks as if this is a bug in p54usb. I Think that I have duplicated the 
problem. On my system, the crash doesn't happen when it associates, but crashes 
when longer packets are transmitted.

I did not get the entire traceback, but I got a reference to p54_tx_80211+0x3de 
from p54common.ko. Using gdb to disassemble this reference, the erring code is 
as follows:

(gdb) l *p54_tx_80211+0x3de
0x3c9e is in p54_tx_80211 (drivers/net/wireless/p54/txrx.c:913).
908                             memcpy(skb_put(skb, 8), &(info->control.hw_key->key
909                                     [NL80211_TKIP_DATA_OFFSET_TX_MIC_KEY]), 8);
910                     }
911                     /* reserve some space for ICV */
912                     len += info->control.hw_key->icv_len;
913                     memset(skb_put(skb, info->control.hw_key->icv_len), 0,
914                            info->control.hw_key->icv_len);
915             } else {
916                     txhdr->key_type = 0;
917                     txhdr->key_len = 0;

At present I do not know why there is a problem with skb_put() here. Perhaps 
someone else will know before I find it.

In any case, file a bug report at bugzilla.kernel.org, mark it as a regression, 
and post the bug number here. If you are able to finish the bisection, that 
would be helpful.

Larry

