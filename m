Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46432 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751245Ab3KOSp0 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 15 Nov 2013 13:45:26 -0500
Date: Fri, 15 Nov 2013 13:45:10 -0500
From: Dave Jones <davej@redhat.com>
To: Kees Cook <keescook@chromium.org>
Cc: "Theodore Ts'o" <tytso@mit.edu>,
	Daniel Borkmann <dborkman@redhat.com>,
	"David S. Miller" <davem@davemloft.net>,
	shemminger@networkplumber.org, Florian Weimer <fweimer@redhat.com>,
	netdev@vger.kernel.org, Eric Dumazet <eric.dumazet@gmail.com>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] random: seed random_int_secret at least poorly at
 core_initcall time
Message-ID: <20131115184510.GA911@redhat.com> (sfid-20131115_194532_028390_BA45111B)
References: <cover.1384160397.git.dborkman@redhat.com>
 <2ea03f60bb65429cbe5d74a6d356fde3eefcf06c.1384160397.git.dborkman@redhat.com>
 <20131111134357.GC10104@thunk.org>
 <20131112000307.GB14929@order.stressinduktion.org>
 <20131112115350.GA14077@thunk.org>
 <20131112131627.GD14929@order.stressinduktion.org>
 <20131112134603.GE14929@order.stressinduktion.org>
 <20131114025448.GB31602@thunk.org>
 <CAGXu5j+ySEdQBXKkspYC=svfekBja2Z_2tcWSAOEbvyiMLf=aA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAGXu5j+ySEdQBXKkspYC=svfekBja2Z_2tcWSAOEbvyiMLf=aA@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Nov 15, 2013 at 10:33:04AM -0800, Kees Cook wrote:
 
 > Ingo wanted even more
 > unpredictability, in the face of total failure from these more dynamic
 > sources, so x86 also "seeds" itself with the build string and the
 > boot_params. These last two are hardly high entropy, but they should
 > at least make 2 different systems not have _identical_ entropy at the
 > start. It's far from cryptographically secure, but it's something, I
 > hope.

Those are both likely to be the same on some configurations.
On x86, we could maybe hash the dmi tables ? Vendor stupidity aside,
things like serial numbers in those tables _should_ be different.
 
	Dave

