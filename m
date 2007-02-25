Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailgate.cesmail.net ([216.154.195.36]:41209 "HELO
	mailgate.cesmail.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752312AbXBYEaD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 24 Feb 2007 23:30:03 -0500
Message-ID: <20070224233001.3ok4k0c00ksos4sw@webmail.spamcop.net>
Date: Sat, 24 Feb 2007 23:30:01 -0500
From: Pavel Roskin <proski@gnu.org>
To: Alex Davis <alex14641@yahoo.com>
Cc: larry.finger@lwfinger.net, linux-wireless@vger.kernel.org,
	bcm43xx-dev@lists.berlios.de
Subject: Re: Patch to allow specification of interface name prefix
References: <510326.55988.qm@web50211.mail.yahoo.com>
In-Reply-To: <510326.55988.qm@web50211.mail.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Quoting Alex Davis <alex14641@yahoo.com>:

> This patch will allow you to specify the interface name prefix of wireless
> devices.
>
> On my machine, the wireless devices under the bcm43xx driver are named
> 'ethx'; I
> would really rather have them called 'wlanx', like bcm43xx-d80211 does.

You can use ifrename from wireless tools.  Use the option that checks the
ethtool information.

Jean has just released Wireless Tools 29-pre12, which can read symlinks in
sysfs.  That would allow renaming d80211 based network devices by checking the
"driver" symlinks in sysfs.  I asked Jean to do that with bcm43xx_d80211 in
mind.

It's not that I'm against your patch.  I'm rather ambivalent.  But I think using
ifrename could reduce the need in kernel support for interface renaming.

--
Regards,
Pavel Roskin
