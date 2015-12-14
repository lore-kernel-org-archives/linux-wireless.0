Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:52338 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932241AbbLNLsE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Dec 2015 06:48:04 -0500
From: Kalle Valo <kvalo@codeaurora.org>
To: Grant Grundler <grundler@google.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	David Lin <dlin@marvell.com>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Chor Teck Law <ctlaw@marvell.com>,
	Pete Hsieh <peteh@marvell.com>
Subject: Re: [PATCH v7] Add new mac80211 driver mwlwifi.
References: <b11fd1b49b274142b85296c11c634635@SC-EXCH02.marvell.com>
	<1448018530.3141.25.camel@sipsolutions.net>
	<CANEJEGv7ENTJu4YHz1x2_ve2M6-3Nn8X-0aC2hA3o1mUs3tQ1g@mail.gmail.com>
Date: Mon, 14 Dec 2015 13:47:57 +0200
In-Reply-To: <CANEJEGv7ENTJu4YHz1x2_ve2M6-3Nn8X-0aC2hA3o1mUs3tQ1g@mail.gmail.com>
	(Grant Grundler's message of "Fri, 11 Dec 2015 16:46:28 -0800")
Message-ID: <8737v545g2.fsf@kamboji.qca.qualcomm.com> (sfid-20151214_124812_567072_11D94443)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Grant Grundler <grundler@google.com> writes:

> Sorry for the late response...just one point below
>
> On Fri, Nov 20, 2015 at 3:22 AM, Johannes Berg <johannes@sipsolutions.net>
> wrote:
>
>     > +#define MWL_DRV_NAME     KBUILD_MODNAME
>     > +#define MWL_DRV_VERSION       "10.3.0.14"
>
>     versions like that are generally fairly useless since you don't update
>     them for every commit ...
>
>
> When backporting to other kernel trees, it's extremely handy to have a
> DRV_VERSION.
>
> Checking if a particular kernel build has the expected driver version trivial.
>  "mod_info" dumps the driver version for modules (which this will usually be
> too).
>
> And yes, it won't get updated for every commit only because other version
> control might encapsulate those changes. Not every distro makes their build
> versioning accessible to outsiders. So it's still helpful even if not perfect.
>
> Marvell can update this every time they resync with their own internal
> versions.

But the problem is that you cannot really trust this driver version
string. I found a perfect example from another Marvell driver:

5e6e3a92b9a4c drivers/net/wireless/mwifiex/main.c (Bing Zhao 2011-03-21 18:00:50 -0700   25) #define VERSION   "1.0"

So nobody has updated that version string since the initial commit from
2011 and that driver has had over 900 non-merge commits after that.
Because of bad cases like this I think having a driver specific versions
in in-tree drivers are just noise and unnecessary extra work. When
porting a driver to another tree git commit ids, release tag names or
git-describe output are much better ways to identify the driver version.

-- 
Kalle Valo
