Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:24258 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933766Ab0EDVLw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 May 2010 17:11:52 -0400
Subject: Re: A file to print the release of loaded compat-wireless stuff
From: Pavel Roskin <proski@gnu.org>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <x2q43e72e891005041344gb9945d73p3d97e648fd13aa85@mail.gmail.com>
References: <x2q43e72e891005041344gb9945d73p3d97e648fd13aa85@mail.gmail.com>
Content-Type: text/plain
Date: Tue, 04 May 2010 17:11:49 -0400
Message-Id: <1273007509.12618.1.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-05-04 at 13:44 -0700, Luis R. Rodriguez wrote:
> It seems there is a reasonable need to find out what version of
> compat-wireless you have running. This will be a dated thing when
> based on linux-next but more importantly it will contain the 2.6.3x.y
> release the release was based on for the stable releases. Any ideas of
> what filesystem API to use for this, I was thinking maybe a simple
> sysfs entry for the compat module. Thoughts, preferences?

We could use a read-only parameter of the compat module.  Then the
version would be in /sys/module/compat/parameters/version

Module parameters are visible in sysfs even if the code is compiled into
the kernel.

-- 
Regards,
Pavel Roskin
