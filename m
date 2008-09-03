Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from hostap.isc.org ([149.20.54.63]:37849 "EHLO hostap.isc.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755691AbYICOGR (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 3 Sep 2008 10:06:17 -0400
Date: Wed, 3 Sep 2008 17:05:17 +0300
From: Jouni Malinen <j@w1.fi>
To: "John W. Linville" <linville@tuxdriver.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>,
	Kalle Valo <kalle.valo@nokia.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: at76_usb.[ch] gone fishing from wireless-testing ?
Message-ID: <20080903140517.GU17345@jm.kir.nu> (sfid-20080903_160643_709149_040F4EC3)
References: <43e72e890809021953o29c6ba53wcdf7630d4ff10b30@mail.gmail.com> <87vdxedje8.fsf@nokia.com> <43e72e890809022003gfd462d2ma8d68f032754c121@mail.gmail.com> <20080903125352.GI3050@tuxdriver.com> <20080903130439.GJ3050@tuxdriver.com> <20080903132448.GT17345@jm.kir.nu> <20080903133802.GK3050@tuxdriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20080903133802.GK3050@tuxdriver.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 03, 2008 at 09:38:03AM -0400, John W. Linville wrote:
> On Wed, Sep 03, 2008 at 04:24:48PM +0300, Jouni Malinen wrote:
> > I don't see -wl in EXTRAVERSION in kernel.org version (1) or my own
> > clone. Both are at commit 908dd0b965e64fcc2eb64152bac65f2876c34e0b. I
> > noticed this disappearing at one of the updates since I had to add a
> > local patch to be able to update my modules without rebooting..

> The -wl comes from localversion-wireless in the kernel's root
> directory.  Has something changed recently to break that mechanism?

Interesting.. I tried it now and it does indeed work, i.e., I get -wl
from localversion-wireless. I have no idea what happened earlier, but
'make modules; sudo make modules_install' ended up installing modules
into 2.6.27-rc4, not 2.6.27-rc4-wl after one of the git tree updates. I
did not look at details at that point and just added -wl to Makefile
EXTRAVERSION. Anyway, it is not needed anymore.

-- 
Jouni Malinen                                            PGP id EFC895FA
