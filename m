Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:21732 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933075Ab1JNOmr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Oct 2011 10:42:47 -0400
Date: Fri, 14 Oct 2011 10:42:29 -0400
From: Pavel Roskin <proski@gnu.org>
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: How to create library module with callbacks?
Message-ID: <20111014104229.7738c6cc@mj> (sfid-20111014_164301_821803_E26D6B57)
In-Reply-To: <CACna6ryphLSrh5vtOEDXek7s9DGxWKSSgQB-KJVLyzfmBCP3KA@mail.gmail.com>
References: <CACna6ryphLSrh5vtOEDXek7s9DGxWKSSgQB-KJVLyzfmBCP3KA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 14 Oct 2011 15:21:16 +0200
Rafał Miłecki <zajec5@gmail.com> wrote:

> I want to create module library, which will handle PHY operations on
> Broadcom card. For most of the time, I'm going to call library
> functions from b43.
> 
> However, there are places where I need to call some (b43) driver
> function from library module.
> 
> How can I handle that? Should I pass some functions pointers to the
> library? Is that going to work? Or is there a better approach?

Yes, that should work.  All modules and the kernel live in the same
address space.  But you should make sure that those pointers won't be
used if the calling module is unloaded.

In fact, b43 does it already with mac80211, ssb and bcma.  See
b43_hw_ops, b43_ssb_driver and b43_bcma_driver in the code.

-- 
Regards,
Pavel Roskin
