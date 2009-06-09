Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:36027 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751776AbZFIAl5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Jun 2009 20:41:57 -0400
Subject: Re: BUG at net/wireless/reg.c:2132 on PowerPC
From: Pavel Roskin <proski@gnu.org>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <4A2D9B23.20208@lwfinger.net>
References: <1244501988.25158.57.camel@mj>  <4A2D9B23.20208@lwfinger.net>
Content-Type: text/plain
Date: Mon, 08 Jun 2009 20:41:58 -0400
Message-Id: <1244508118.28215.2.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2009-06-08 at 18:13 -0500, Larry Finger wrote:

> I don't know what is triggering the kernel BUG, but you have an error
> in your udev rules. The pertinent file is
> /etc/udev/rules.d/70-persistent-net.rules. Any rule that renames a
> wireless device should look like the following:
> 
> SUBSYSTEM=="net", ACTION=="add", DRIVERS=="?*", \
> ATTR{address}=="00:90:4b:d2:1f:cd", ATTR{type}=="1", \
> KERNEL=="wlan*", NAME="wlan0"
> 
> The ATTR{address} should match the MAC address of the device, but the
> ATTR{type}=="1" is really important as it keeps the master device from
> being renamed, which is the usual cause of the presence of a name like
> wlanX_rename.

I actually removed 70-persistent-net.rules, but I think "1" was there.
The failed rename was due to /etc/sysconfig/network-scripts/ifcfg-wlan0
that was specifying the MAC address that must have conflicted with the
udev rules.

-- 
Regards,
Pavel Roskin
