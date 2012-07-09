Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:35057 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752418Ab2GIQ7r (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jul 2012 12:59:47 -0400
Message-ID: <1341853186.4455.52.camel@jlt3.sipsolutions.net> (sfid-20120709_185950_752192_ADBB0E8B)
Subject: Re: [PATCH v2] mac80211: fix invalid band deref building preq IEs
From: Johannes Berg <johannes@sipsolutions.net>
To: Arik Nemtsov <arik@wizery.com>
Cc: linux-wireless@vger.kernel.org
Date: Mon, 09 Jul 2012 18:59:46 +0200
In-Reply-To: <1341853048-12150-1-git-send-email-arik@wizery.com> (sfid-20120709_185733_193592_62A3448A)
References: <1341853048-12150-1-git-send-email-arik@wizery.com>
	 (sfid-20120709_185733_193592_62A3448A)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-07-09 at 19:57 +0300, Arik Nemtsov wrote:
> The function building probe-request IEs does not validate the band is
> supported before dereferencing it. This can result in a panic when
> all bands are traversed, as done during sched-scan start.
> 
> Warn when this happens and return an empty probe request. Also fix
> sched-scan to not waste memory on unsupported bands.
> 
> Signed-off-by: Arik Nemtsov <arik@wizery.com>
> ---
> better? :)

Yeah I'll apply this :-)

I do wonder though why we even bother building probe request IEs for a
band if no channels from it are listed in the sched scan request.

johannes


