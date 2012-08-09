Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ob0-f174.google.com ([209.85.214.174]:34256 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753893Ab2HIDh5 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 8 Aug 2012 23:37:57 -0400
Received: by obbuo13 with SMTP id uo13so8699obb.19
        for <linux-wireless@vger.kernel.org>; Wed, 08 Aug 2012 20:37:57 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1344481126-15702-1-git-send-email-andy@greyhouse.net>
References: <1344481126-15702-1-git-send-email-andy@greyhouse.net>
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Wed, 8 Aug 2012 20:37:36 -0700
Message-ID: <CAB=NE6XfyQSjWHrr97L29hRzRx-H4wsPHMQ7mG4n9D_e7p46=A@mail.gmail.com> (sfid-20120809_053833_049316_D7CCC427)
Subject: Re: [PATCH] compat: support RHEL6.3 as a build target
To: Andy Gospodarek <andy@greyhouse.net>
Cc: lf_driver_backport@lists.linux-foundation.org,
	linux-wireless@vger.kernel.org, Phil Perry <phil@elrepo.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 8, 2012 at 7:58 PM, Andy Gospodarek <andy@greyhouse.net> wrote:
> This patch allows me to compile and load the latest compat modules on
> RHEL6.3.  Users of compat on RHEL6 should note that you should set
> CONFIG_COMPAT_KFIFO=n as those bits are not needed at all.
>
> Signed-off-by: Andy Gospodarek <andy@greyhouse.net>

Thanks! Any chance you can git fetch; git rebase; (ensuring you have
42faf2dc8d8 at tip) and then try running:

./bin/get-compat-kernels

This can take ~10 minutes

And then test compile your changes with:

./bin/ckmake

And provide that as part of your commit log message? We can likely add
the RHEL kernels to the ./bin/get-compat-kernels if you can figure out
a way to unpack them for any user out there on any Linux distribution.
This way I can gate future patches from being merged unless they also
give me a good set of results from ckmake.

Thoughts ?

  Luis
