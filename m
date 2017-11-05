Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from eggs.gnu.org ([208.118.235.92]:33746 "EHLO eggs.gnu.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750724AbdKEUxT (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sun, 5 Nov 2017 15:53:19 -0500
Received: from Debian-exim by eggs.gnu.org with spam-scanned (Exim 4.71)
        (envelope-from <nikolas@gnu.org>)
        id 1eBRuu-0001W5-Bf
        for linux-wireless@vger.kernel.org; Sun, 05 Nov 2017 15:53:17 -0500
Subject: Re: rtl8821ae dbi read question
To: Larry Finger <Larry.Finger@lwfinger.net>,
        linux-wireless@vger.kernel.org, pkshih@realtek.com
References: <d46763ef-14d1-a6fa-fb33-a0bd676ef056@gnu.org>
 <695fe947-7b0d-ef4b-5e90-ff503df6a08b@lwfinger.net>
From: Nik Nyby <nikolas@gnu.org>
Message-ID: <6155a30b-ca6d-e27d-701e-9e1876a982ff@gnu.org> (sfid-20171105_215329_868070_5F32F172)
Date: Sun, 5 Nov 2017 15:53:06 -0500
MIME-Version: 1.0
In-Reply-To: <695fe947-7b0d-ef4b-5e90-ff503df6a08b@lwfinger.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/05/2017 11:50 AM, Larry Finger wrote:
> 
> If you read the commit message for commit b8b8b16352cd, you will find 
> that we do not understand why using a byte read causes failure, but 
> reverting the change so that it is a word read made it function again. 
> The "fix" was found by a user doing bisection, and verified on my 
> system, where the RTL8821AE has stable connections. The transfer rates 
> take wild swings, but the connection is not dropped.
> 
> If you NIC behaves differently, then you will need to help us debug the 
> problem. If you had a kernel that worked, then you might try bisection. 

I just tested on kernels 4.12 and 4.13 - my connection gets dropped on 
those kernels as well. Right now I'm using 4.14-rc7.

> If that is not possible, you might try various combinations of module 
> parameters aspm, int_clear, and msi
Thanks for these suggestions. Disabling ASPM solves my connection 
dropping issue! Previously, I was getting disconnected around 10 seconds 
after starting "git clone" on a large git repository. Now, I haven't 
seen the connection drop once.

I can help debug the issue. I'm using a Lenovo Ideapad 320-15ABR laptop. 
Here's the lspci -vv info for my NIC:

01:00.0 Network controller: Realtek Semiconductor Co., Ltd. RTL8821AE 
802.11ac PCIe Wireless Network Adapter
         Subsystem: Lenovo RTL8821AE 802.11ac PCIe Wireless Network Adapter
         Control: I/O+ Mem+ BusMaster+ SpecCycle- MemWINV- VGASnoop- 
ParErr- Stepping- SERR- FastB2B- DisINTx+
         Status: Cap+ 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- 
<TAbort- <MAbort- >SERR- <PERR- INTx-
         Latency: 0, Cache Line Size: 32 bytes
         Interrupt: pin A routed to IRQ 33
         Region 0: I/O ports at 2000 [size=256]
         Region 2: Memory at f0b00000 (64-bit, non-prefetchable) [size=16K]
         Capabilities: <access denied>
         Kernel driver in use: rtl8821ae
