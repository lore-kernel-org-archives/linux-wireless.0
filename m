Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44769 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950Ab0CHIJC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 8 Mar 2010 03:09:02 -0500
Subject: Re: [PATCH] crda: do not embed crypto data when USE_OPENSSL=1
From: Johannes Berg <johannes@sipsolutions.net>
To: Kel Modderman <kel@otaku42.de>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <201003060059.42588.kel@otaku42.de>
References: <201003050008.51066.kel@otaku42.de>
	 <201003051156.11922.kel@otaku42.de> <20100305040853.GA4640@tuxdriver.com>
	 <201003060059.42588.kel@otaku42.de>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 08 Mar 2010 09:08:55 +0100
Message-ID: <1268035735.3819.17.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2010-03-06 at 00:59 +1000, Kel Modderman wrote:

> I am obviously having hard time clearly communicating what I think is wrong,

Yes.

> so attached is 2 files demonstrating the problem with step by step reproducible
> commands with output. regdb-upgrade-does-not-work.txt shows the current
> behaviour which must be improved, regdb-upgrade-does-work.txt shows
> the behaviour with my patch applied. The patch which was used is also attached.

That isn't helping, we don't want to do your work of digging through :)

The building-in keys code should NOT be removed, it should be possible
to build in keys AND use external keys (and I still think the external
key code should be optional since it is _quite_ different from internal
keys).

What exactly happens when you build in keys and use external ones? The
code I originally wrote should try to validate the database using all
available keys, it seems like that was broken and you're trying to fix
the symptom rather than the cause.

johannes

