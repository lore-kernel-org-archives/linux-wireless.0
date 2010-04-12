Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:7310 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753702Ab0DLVt2 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 12 Apr 2010 17:49:28 -0400
Subject: Re: [ath9k-devel] On ath9k debugfs, having trouble recompiling and
 inserting only ath9k
From: Pavel Roskin <proski@gnu.org>
To: Rakesh Kumar <gopchandani@gmail.com>
Cc: ath9k-devel@lists.ath9k.org, linux-wireless@vger.kernel.org
In-Reply-To: <n2icdc21431004112229n9303fcc1s788eadda177d079a@mail.gmail.com>
References: <n2icdc21431004112229n9303fcc1s788eadda177d079a@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 12 Apr 2010 17:49:26 -0400
Message-Id: <1271108966.15194.4.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2010-04-12 at 00:29 -0500, Rakesh Kumar wrote:
> So I modified few entries in ath9k's debug.c and used them in the
> code. Recompiled the module ath9k, went painlessly. But when I try to
> do following:
> 
> sudo insmod drivers/net/wireless/ath/ath9k/ath9k.ko
> 
> I get the following error: insmod: error inserting
> 'drivers/net/wireless/ath/ath9k/ath9k.ko': -1 Unknown symbol in module

Please use modprobe, not insmod, as modprobe can resolve symbols and
load the requisite modules first.

If modprobe doesn't help, use the "dmesg" command to see the kernel log.
You should see messages about unresolved symbols.  Maybe you misspelled
some function?

> I remember this error occurs when the module being inserted is not
> compiled with the kernel currently running. But in my case, that's not
> true.
> 
> dmesg only yeilds following pertinent line:
> 
> [29471.324717] ath9k: Unable to create debugfs root: -2
> 
> Which indicates a failure to create the root directory under
> /sys/kernel/debug/ath9k/...
> 
> Any ideas on why this is happening would be highly appreciated!

Maybe /sys/kernel/debug/ath9k is already present.  You may want to
reboot to "fix" it.

But I don't think you would get any message from the ath9k module if it
fails to load due to unresolved symbols.

-- 
Regards,
Pavel Roskin
