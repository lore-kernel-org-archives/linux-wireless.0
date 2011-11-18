Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:38794 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752266Ab1KRW0W (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Nov 2011 17:26:22 -0500
Message-ID: <1321655181.2367.1.camel@Joe-Laptop> (sfid-20111118_232633_000954_89604409)
Subject: Re: [PATCH] compat-wireless: avoid pr_fmt build SPAM
From: Joe Perches <joe@perches.com>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: linux-wireless@vger.kernel.org, Hauke Mehrtens <hauke@hauke-m.de>,
	"Luis R. Rodriguez" <lrodriguez@qca.qualcomm.com>
Date: Fri, 18 Nov 2011 14:26:21 -0800
In-Reply-To: <1321649673-15874-1-git-send-email-linville@tuxdriver.com>
References: <1321649673-15874-1-git-send-email-linville@tuxdriver.com>
Content-Type: text/plain; charset="UTF-8"
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

Why not undef pr_fmt after the compat-* headers?


