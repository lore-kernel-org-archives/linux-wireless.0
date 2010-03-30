Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:48691 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754433Ab0C3UaQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Mar 2010 16:30:16 -0400
Date: Tue, 30 Mar 2010 16:28:49 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: wireless <linux-wireless@vger.kernel.org>
Subject: Re: Your netbook
Message-ID: <20100330202848.GO13120@tuxdriver.com>
References: <4BB21787.4040501@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4BB21787.4040501@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Mar 30, 2010 at 10:23:51AM -0500, Larry Finger wrote:

> If possible, I would like you to do one more test on that troublesome netbook.
> Please build a kernel with CONFIG_MMIOTRACE=y and build the Broadcom wl driver
> for it. Starting with wl unloaded, issue the following commands (as root):
> 
> echo 10000 > /sys/kernel/debug/tracing/buffer_size_kb
> echo mmiotrace > /sys/kernel/debug/tracing/current_tracer
> cat /sys/kernel/debug/tracing/trace_pipe > wl_dump.txt &
> modprobe -v wl
> 
> After the wireless network device gets created, etc., then
> 
> echo nop > /sys/kernel/debug/tracing/current_tracer
> sleep 1
> killproc cat
> 
> and send me the file wl_dump.txt. With it, I will be able to see if the Broadcom
> driver is actually finding an SPROM that b43 is missing.

Done:

	http://www.kernel.org/pub/linux/kernel/people/linville/ssb-debug/wl_dump.txt.gz

Hth!

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
