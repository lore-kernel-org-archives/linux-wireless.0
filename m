Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:29082 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751611AbZG3VmS (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 30 Jul 2009 17:42:18 -0400
Subject: Re: [PATCH] compat-2.6:  Makefile: fixed test expressions for
 target install
From: Pavel Roskin <proski@gnu.org>
To: Joerg Albert <jal2@gmx.de>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <4A720FE4.4020301@gmx.de>
References: <4A720FE4.4020301@gmx.de>
Content-Type: text/plain
Date: Thu, 30 Jul 2009 17:42:16 -0400
Message-Id: <1248990136.10154.10.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2009-07-30 at 23:25 +0200, Joerg Albert wrote:
> This removes the two errors of [ with target "install"
> 
> make[1]: Leaving directory `/home/joerg/src/linux-2.6.30'
> [: 9: missing ]
> [: 9: missing ]
> depmod will prefer updates/ over kernel/ -- OK!

I believe "-a" in test is not very portable.  I remember getting
complaints about it.  I believe the built-in test command in bash 1.x
doesn't have it.  I'd rather stick with && and || written properly.

"-a" and -o" are currently only used in the clean target and in the
maintenance scripts, so they probably don't get enough testing on
systems with old bash.

-- 
Regards,
Pavel Roskin
