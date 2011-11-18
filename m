Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:32874 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751444Ab1KRVAS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Nov 2011 16:00:18 -0500
Subject: Re: [PATCH] compat-wireless: avoid pr_fmt build SPAM
From: Johannes Berg <johannes@sipsolutions.net>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>,
	"Luis R. Rodriguez" <lrodriguez@qca.qualcomm.com>
In-Reply-To: <1321649673-15874-1-git-send-email-linville@tuxdriver.com> (sfid-20111118_215835_740990_2277842B)
References: <1321649673-15874-1-git-send-email-linville@tuxdriver.com>
	 (sfid-20111118_215835_740990_2277842B)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 18 Nov 2011 22:00:12 +0100
Message-ID: <1321650012.10266.78.camel@jlt3.sipsolutions.net> (sfid-20111118_220022_179882_D3157BC8)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2011-11-18 at 15:54 -0500, John W. Linville wrote:
> The way the compat-* header files are included causes the default
> pr_fmt definition from <linux/kernel.h> to be evaluated for every file.
> Files that define pr_fmt then generate a lot of build SPAM about
> pr_fmt being redefined.
> 
> Eliminate the build noise by preemptively undefining pr_fmt in those
> files that define it.  This is accomplished by adding a patch to the
> patches directory.

This patch is going to be relatively painful when files move etc -- is
that really worth it? I for one will just drop it in our compat version
if it goes in since I don't even have all the files it patches :-)

johannes

