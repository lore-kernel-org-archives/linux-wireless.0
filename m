Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:39516 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756978AbYBNBZu (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 13 Feb 2008 20:25:50 -0500
Subject: Re: kernel 2.6.25-rc1 and no /dev/rt73usb
From: Pavel Roskin <proski@gnu.org>
To: Adam Turk <bofh1234@hotmail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <BAY101-W101597BA2B1DDD58D6F497C8250@phx.gbl>
References: <BAY101-W101597BA2B1DDD58D6F497C8250@phx.gbl>
Content-Type: text/plain
Date: Wed, 13 Feb 2008 20:25:47 -0500
Message-Id: <1202952347.29519.5.camel@dv> (sfid-20080214_012554_278794_AF3F76B6)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-02-13 at 20:14 -0500, Adam Turk wrote:

> However no rt73usb device is created.  Why isn't this working?  

Network devices don't have corresponding device nodes under /dev.  They
can be seen with "ifconfig -a", and the wireless properties can be
examined and changed with iwconfig.

The messages may be different because you changed the debug level or
because the device is not brought up by some reason.  By the way, it's
better to examine kernel messages with the dmesg command, because is
shows all messages, whereas syslog can suppress some of them.

-- 
Regards,
Pavel Roskin
