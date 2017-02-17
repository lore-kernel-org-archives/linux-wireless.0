Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from Galois.linutronix.de ([146.0.238.70]:55781 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754882AbdBQKRG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 17 Feb 2017 05:17:06 -0500
Date: Fri, 17 Feb 2017 11:16:59 +0100 (CET)
From: Thomas Gleixner <tglx@linutronix.de>
To: Marc Zyngier <marc.zyngier@arm.com>
cc: kernel test robot <fengguang.wu@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Tomasz Nowicki <tn@semihalf.com>,
        Christoffer Dall <christoffer.dall@linaro.org>,
        Sasha Levin <alexander.levin@verizon.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        Johannes Berg <johannes.berg@intel.com>
Subject: Re: [linux-stable] 4fc2942b6e kernel BUG at
 kernel/time/hrtimer.c:109!
In-Reply-To: <0f58a1d0-a2e6-9430-7883-68e986ccb4c0@arm.com>
Message-ID: <alpine.DEB.2.20.1702171115050.3536@nanos> (sfid-20170217_111711_159142_2684489A)
References: <20170217052607.glbumukvoz4pilvt@wfg-t540p.sh.intel.com> <alpine.DEB.2.20.1702171014430.3536@nanos> <0f58a1d0-a2e6-9430-7883-68e986ccb4c0@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 17 Feb 2017, Marc Zyngier wrote:

> On 17/02/17 09:28, Thomas Gleixner wrote:
> > On Fri, 17 Feb 2017, kernel test robot wrote:
> > 
> >> Hi Marc,
> >>
> >> We find this oops in linux-4.4.y. The gcc-6 compiled mainline kernel is fine.
> 
> The last bit is worrying, as mainline has the exact same bug. Has it
> been tested the same way?

The thing is that we reverted that patch in mainline:

See: commit 82e88ff1ea948d83125a8aaa7c9809f03ccc500f

I don't know why I reverted that as well. I should have kept it. Darn. I
cherry pick it and send it linus wards next week.

Thanks,

	tglx
