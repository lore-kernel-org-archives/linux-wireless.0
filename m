Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33057 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1947094Ab3BHXAg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 8 Feb 2013 18:00:36 -0500
Message-ID: <1360364431.29851.40.camel@jlt4.sipsolutions.net> (sfid-20130209_000039_103847_DCD3729D)
Subject: Re: [PATCH] mac80211: fix CONFIG_MAC80211=n build breakage
From: Johannes Berg <johannes@sipsolutions.net>
To: Thomas Pedersen <thomas@cozybit.com>
Cc: linux-wireless@vger.kernel.org
Date: Sat, 09 Feb 2013 00:00:31 +0100
In-Reply-To: <1360364077-12204-1-git-send-email-thomas@cozybit.com> (sfid-20130208_235546_505783_FFC77B27)
References: <1360364077-12204-1-git-send-email-thomas@cozybit.com>
	 (sfid-20130208_235546_505783_FFC77B27)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-02-08 at 14:54 -0800, Thomas Pedersen wrote:
> The original mesh_sta_cleanup() declaration should have been 
> inside the ifdef.

Nah, the one in the #else can just be removed since it's only ever
called from where the compiler can prove it won't be needed so no
linkage is generated. I already fixed it anyway, and amended the
original patch rebasing my tree.

:-)

johannes

