Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:38813 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752417AbaKSNfz (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Nov 2014 08:35:55 -0500
Message-ID: <1416404147.9374.2.camel@sipsolutions.net> (sfid-20141119_143558_086699_EAF4DCB5)
Subject: Re: [PATCH] device coredump: fix minor issue in Kconfig file
From: Johannes Berg <johannes@sipsolutions.net>
To: Amitkumar Karwar <akarwar@marvell.com>
Cc: linux-wireless@vger.kernel.org, dri-devel@lists.freedesktop.org,
	Xinming Hu <huxm@marvell.com>
Date: Wed, 19 Nov 2014 14:35:47 +0100
In-Reply-To: <1416403682-9203-1-git-send-email-akarwar@marvell.com>
References: <1416403682-9203-1-git-send-email-akarwar@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2014-11-19 at 05:28 -0800, Amitkumar Karwar wrote:
> if "CONFIG_DEV_COREDUMP=y" is added to configuration file, it
> gets removed when final configuration file is generated. The
> reason is it requires CONFIG_WANT_DEV_COREDUMP to be enabled.
> 
> Currently "make menuconfig" doesn't display an option to enable
> WANT_DEV_COREDUMP. This patch updates Kconfig so that user can
> enable WANT_DEV_COREDUMP.

This is completely intentional - drivers should "select
WANT_DEV_COREDUMP" and users are only able to set "ALLOW_DEV_COREDUMP=n"
to prevent it.

johannes

