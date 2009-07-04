Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f207.google.com ([209.85.218.207]:64952 "EHLO
	mail-bw0-f207.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753181AbZGDJD0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Jul 2009 05:03:26 -0400
Received: by bwz3 with SMTP id 3so763443bwz.37
        for <linux-wireless@vger.kernel.org>; Sat, 04 Jul 2009 02:03:29 -0700 (PDT)
Date: Sat, 4 Jul 2009 13:03:46 +0400
From: Alexander Barinov <alex.barinov@gmail.com>
To: linux-wireless@vger.kernel.org
Subject: BUG REPORT: libertas causing kernel lockups
Message-ID: <20090704130346.01b2e869@dream>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I have Eking I1 UMPC that features Marvell 8686 SDIO wireless card. I
am currently using vanilla kernel 2.6.30, but the bug is there on
Debian 2.26 and 2.29 as well as vanilla 2.29 kernels I tried previously

The initial symptom of the bug was system lockup when executing 'ifdown
eth0' with 'BUG: scheduling while atomic'. Trying to understand the
cause of the bug and find a workaround I was able to find an easier way
to reproduce it. By executing 'cat /proc/net/wireless' I get the same
bug:

BUG: scheduling while atomic: cat/1885/0x00000002 
Pid: 1885, comm: cat Not tainted 2.6.30.090704 #2 
Call Trace: 
[<c042eb7f>] ? __schedule+0x37f/0x8c0 
[<c01237cd>] ? try_to_wake_up+0x8d/0x1e0 
[<c011ee0e>] ? __wake_up+0x3e/0x60 
[<c02e882c>] ? __lbs_cmd_async+0x11c/0x280 
[<c018ddbe>] ? d_rehash+0x2e/0x50 
[<c042f0d0>] ? schedule+0x10/0x30 
[<c02e8be4>] ? __lbs_cmd+0xa4/0x1a0 
[<c02ea3f0>] ? lbs_cmd_copyback+0x0/0x40 
[<c013c460>] ? autoremove_wake_function+0x0/0x50 
[<c02e67d5>] ? lbs_get_wireless_stats+0xf5/0x3c0 
[<c02ea3f0>] ? lbs_cmd_copyback+0x0/0x40 
[<c03fb1e7>] ? wireless_seq_show+0x47/0x180 
[<c03965bf>] ? dev_seq_start+0x1f/0xb0 
[<c0196c6d>] ? seq_read+0x1fd/0x360 
[<c0196a70>] ? seq_read+0x0/0x360 
[<c01b4774>] ? proc_reg_read+0x64/0xa0 
[<c01b4710>] ? proc_reg_read+0x0/0xa0 
[<c017f9ab>] ? vfs_read+0x9b/0x120 
[<c017fb01>] ? sys_read+0x41/0x80 
[<c0102f21>] ? syscall_call+0x7/0xb

Please let me know if I should provide any additional details regarding
the bug.

-- 
Alex
