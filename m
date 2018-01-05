Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:47672 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752087AbeAETNq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 5 Jan 2018 14:13:46 -0500
Date: Fri, 5 Jan 2018 20:13:45 +0100
From: "Luis R. Rodriguez" <mcgrof@kernel.org>
To: Jelle van der Waa <jelle@vdwaa.nl>
Cc: "Luis R . Rodriguez" <mcgrof@kernel.org>,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH] crda: Fix error: =?utf-8?Q?`ke?= =?utf-8?B?eXPigJk=?=
 defined but not used
Message-ID: <20180105191345.GE22430@wotan.suse.de> (sfid-20180105_201350_226288_239F5A5A)
References: <20171204205239.6296-1-jelle@vdwaa.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <20171204205239.6296-1-jelle@vdwaa.nl>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 04, 2017 at 09:52:39PM +0100, Jelle van der Waa wrote:
> Fix error: ‘keys’ defined but not used [-Werror=unused-const-variable=]
> by informing GCC keys is unused.
> 
> Signed-off-by: Jelle van der Waa <jelle@vdwaa.nl>

Thanks, applied and pushed! Although this just fixes a compilation
warning, but since we do use -Werror and thus force any error to
fail compilation I've pushed out a new release with this fix
merged as v4.14.

If a new tarball is not kicked off soon [0] automatically I'll poke and see to
it. Note that as of kernel v4.15 (as of commit 007f6c5e6eb45 ("cfg80211:
support loading regulatory database as firmware file" we have the ability
now for the kernel to do this file lookup for us first, and only if
that fails will CRDA kick in.

[0] https://www.kernel.org/pub/software/network/crda/

  Luis
