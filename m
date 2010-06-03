Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:26502 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756639Ab0FCPzK (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Jun 2010 11:55:10 -0400
Subject: Re: IWL3945 problems in 2.6.35-rc1
From: reinette chatre <reinette.chatre@intel.com>
To: "sedat.dilek@gmail.com" <sedat.dilek@gmail.com>
Cc: "Kolekar, Abhijeet" <abhijeet.kolekar@intel.com>,
	Maxim Levitsky <maximlevitsky@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	iwlwifi maling list <ipw3945-devel@lists.sourceforge.net>
In-Reply-To: <AANLkTinDduWj_BbLINeMmF3hChf4x2znxDLhWDDJzQqY@mail.gmail.com>
References: <1275395142.14385.6.camel@maxim-laptop>
	 <1275404221.2839.2.camel@maxim-laptop>
	 <AANLkTinmjlukRABwWWVuO6VRHrULcqB7Zk_HQZSDicKr@mail.gmail.com>
	 <1275419000.5225.0.camel@abhi-desktop>
	 <AANLkTimRt-8d5RkBtGVyReASZqBFIjSzOHPFV6RVjYlV@mail.gmail.com>
	 <1275544803.2091.30386.camel@rchatre-DESK>
	 <AANLkTinDduWj_BbLINeMmF3hChf4x2znxDLhWDDJzQqY@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 Jun 2010 08:55:08 -0700
Message-ID: <1275580508.2091.31607.camel@rchatre-DESK>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Sedat,

On Thu, 2010-06-03 at 02:18 -0700, Sedat Dilek wrote:
> The good news at first:
> Your patch applies against 2.6.35-rc1 vanilla (tested with linux-2.6 GIT).

That was what you asked for.

> BUT....
> This patch should be renamed to "iwl3945-fix-internal-scan-2.6.35-rc1.patch".

Feel free to rename it.


> It differs from the one in iwiwifi-2.6 (see below).

Right, I had to make a change to the patch to get it to apply to
2.6.35-rc1.

> Thus, I said to myself let's dig deeper into it.
> 
> First, here is my GIT workflow (I use linux-2.6 rcX, later pull in
> wireless-2.6 and finally iwlwifi-2.6 master GIT)
> 
> [CODE]
> $ git clone git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux-2.6.git
> 
> $ git reset --hard v2.6.35-rc1
> 
> $ git pull git://git.kernel.org/pub/scm/linux/kernel/git/linville/wireless-2.6.git
> master:wireless-2.6

ok so far.

> 
> $ git pull http://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-2.6.git
> master:iwlwifi-2.6

Don't do this. iwlwifi-2.6's master branch is a clone of
wireless-testing's master branch plus all the iwlwifi patches that has
not been sent to wireless-testing yet.

> [/CODE]
> 
> If I do so, I get NON-iwlwifi related stuff pulled in and that should
> not be the case?

This is how we work. iwlwifi-2.6's master branch tracks upstream
wireless development from wireless-testing. 

> I am not a git tool expert, there might be some magic tricks I do not know.
> Thanks for any hints on git tool :-).
> 
> It would be very helpfull (if you want people to follow iwlwifi
> development) to have something similiar like in linux-wireless GIT
> trees - just a proposal:
> 
> iwlwifi-2.6 -> wireless-2.6 -> net-2.6 -> linux-2.6
> iwlwifi-next-2.6 -> wireless-next-2.6 -> net-next-2.6 -> linux-next
> iwlwifi-testing -> wireless-testing

iwlwifi-2.6 has a wireless-2.6 and wireless-next-2.6 branch that
accomplishes this. We do not see the need for more repositories.

> As I said I am no git expert, so I don't know if you want to setup 3
> diverse GIT repsoitories (as John did for wireless-* trees) or have 3
> different GIT branches within existing iwlwifi-2.6 GIT repository as
> in drm-2.6 [1].

We have three branches.

Reinette

