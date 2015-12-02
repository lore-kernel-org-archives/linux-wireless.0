Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:51981 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753506AbbLBJwC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Dec 2015 04:52:02 -0500
Message-ID: <1449049918.2449.6.camel@sipsolutions.net> (sfid-20151202_105234_793578_BABB20D8)
Subject: Re: [PATCH] mac80211_hwsim: missing NULL check
From: Johannes Berg <johannes@sipsolutions.net>
To: Rahul Jain <rahul.jain@samsung.com>, kvalo@codeaurora.org
Cc: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, Amit Khatri <amit.khatri@samsung.com>
Date: Wed, 02 Dec 2015 10:51:58 +0100
In-Reply-To: <1448867812-11089-1-git-send-email-rahul.jain@samsung.com> (sfid-20151130_081822_747132_014FEC1F)
References: <1448867812-11089-1-git-send-email-rahul.jain@samsung.com>
	 (sfid-20151130_081822_747132_014FEC1F)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2015-11-30 at 12:46 +0530, Rahul Jain wrote:
> From: Amit Khatri <amit.khatri@samsung.com>
> 
> txrate variable might be NULL and passing inside function
> without NULL check.

Applied. However, this comes with a big BUT.

I seems to always be rewriting your static checker patches, or asking
for clarification, rewording, etc.

Please: review what I did to this commit, and in the future please
submit patches that actually describe what's going on, what you're
doing, and why you're doing it.

IOW, analyse the code and don't just do the minimum necessary to shut
up the static checker. Doing that is fairly much useless, especially in
really obscure cases like this.

I'm going to drop further patches like this one without warning.

johannes
