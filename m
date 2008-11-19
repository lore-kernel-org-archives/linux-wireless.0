Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:25329 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750738AbYKSVwB (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 19 Nov 2008 16:52:01 -0500
Subject: Re: [PATCH] wireless: sysfs was displaying different values for
	level and noise than procfs
From: Pavel Roskin <proski@gnu.org>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: Andrey Borzenkov <arvidjaar@mail.ru>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20081119200856.GH3485@tuxdriver.com>
References: <200811151831.26403.arvidjaar@mail.ru>
	 <1227122019.2196.14.camel@dv> <200811192245.29487.arvidjaar@mail.ru>
	 <20081119200856.GH3485@tuxdriver.com>
Content-Type: text/plain
Date: Wed, 19 Nov 2008 16:51:58 -0500
Message-Id: <1227131518.3571.16.camel@dv> (sfid-20081119_225207_085809_144B09A0)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-11-19 at 15:08 -0500, John W. Linville wrote:

> > But positive dBm is not even possible to represnt right now. It is
> > u8 and is displayed as ((s32)level - 256); so it is *always*
> > negative.

I would force dBm to be between -192 and 63.  That would cover
everything even remotely possible.

> And what is your perspective regarding potential 'userland ABI'
> issues of either this patch or of Pavel's suggestion?

In my opinion, discrepancy between procfs and sysfs is permissible.  If
the sysfs interface has been wrong, we should be able to change the
format.  As for the procfs interface, it could be deprecated.

-- 
Regards,
Pavel Roskin
