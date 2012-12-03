Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ia0-f174.google.com ([209.85.210.174]:50876 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751758Ab2LCQTc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Dec 2012 11:19:32 -0500
Received: by mail-ia0-f174.google.com with SMTP id y25so2275379iay.19
        for <linux-wireless@vger.kernel.org>; Mon, 03 Dec 2012 08:19:32 -0800 (PST)
Message-ID: <50BCD110.6050803@lwfinger.net> (sfid-20121203_171936_244331_4B1E99D6)
Date: Mon, 03 Dec 2012 10:19:28 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Nathan Hintz <nlhintz@hotmail.com>
CC: linux-wireless@vger.kernel.org
Subject: Re: brcmsmac: Data bus error in reading tsf_random
References: <50BAB095.2070103@hauke-m.de> <loom.20121203T054035-582@post.gmane.org>
In-Reply-To: <loom.20121203T054035-582@post.gmane.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/02/2012 10:47 PM, Nathan Hintz wrote:

> I encountered a similar DBE using the "broadcom-wl" driver (OpenWRT) on a
> Linksys E3000; except that it occurred when reading "ifs_ctl" (offset 0x688).
> I too tried putting in some printk's (in linux_osl.c), which caused the
> problem to go away.  I eventually found that doing a dummy read of 4 bytes
> at that particular address just prior to the actual two byte read caused
> the problem to go away as well (an ugly hack).  I can reproduce it if you
> want a stack trace.

Does an ndelay(xx), with xx of 10 or so, be as effective as the dummy read? It 
is not a lot less of a hack, but it would indicate the source of the problem.

Larry

