Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:34288 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756027Ab2B0Xb5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Feb 2012 18:31:57 -0500
Date: Mon, 27 Feb 2012 18:29:47 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: wireless-testing fail compiling
Message-ID: <20120227232946.GG26664@tuxdriver.com> (sfid-20120228_003201_455572_5A20029B)
References: <1330374499.12612.18.camel@wwguy-huron>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <1330374499.12612.18.camel@wwguy-huron>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Feb 27, 2012 at 12:28:19PM -0800, Guy, Wey-Yi wrote:
> build break in the latest wireless-testing
> 
> fs/autofs4/inode.c: In function ‘autofs4_fill_super’:
> fs/autofs4/inode.c:228: error: implicit declaration of function
> ‘is_compat_task’
> make[2]: *** [fs/autofs4/inode.o] Error 1
> make[1]: *** [fs/autofs4] Error 2
> make: *** [fs] Error 2
> 
> 
> fs/autofs4/dev-ioctl.c: In function ‘autofs_dev_ioctl_setpipefd’:
> fs/autofs4/dev-ioctl.c:388: error: implicit declaration of function
> ‘is_compat_task’
> make[2]: *** [fs/autofs4/dev-ioctl.o] Error 1

It looks like that line was added in commit
a32744d4abae24572eff7269bc17895c41bd0085, which came into
wireless-testing as part of 3.3-rc5.

FWIW, it built for me.  I'm using a config derived from what is in
Fedora 17.  Maybe you should try a clean build?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
