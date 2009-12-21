Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from a-pb-sasl-quonix.pobox.com ([208.72.237.25]:55852 "EHLO
	sasl.smtp.pobox.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753074AbZLURgK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 21 Dec 2009 12:36:10 -0500
Received: from sasl.smtp.pobox.com (unknown [127.0.0.1])
	by a-pb-sasl-quonix.pobox.com (Postfix) with ESMTP id B34A389AE0
	for <linux-wireless@vger.kernel.org>; Mon, 21 Dec 2009 12:36:03 -0500 (EST)
Received: from a-pb-sasl-quonix. (unknown [127.0.0.1])
	by a-pb-sasl-quonix.pobox.com (Postfix) with ESMTP id A5ADF89ADF
	for <linux-wireless@vger.kernel.org>; Mon, 21 Dec 2009 12:36:03 -0500 (EST)
Received: from deuteronomy.jumbo (unknown [68.93.99.187]) (using TLSv1 with
 cipher DHE-RSA-AES256-SHA (256/256 bits)) (No client certificate requested)
 by a-pb-sasl-quonix.pobox.com (Postfix) with ESMTPSA id 55CDA89ADB for
 <linux-wireless@vger.kernel.org>; Mon, 21 Dec 2009 12:36:03 -0500 (EST)
Date: Mon, 21 Dec 2009 11:36:02 -0600
From: Corey Wright <undefined@pobox.com>
To: linux-wireless@vger.kernel.org
Subject: Re: Compat-wireless releases for 2.6.33-rc1 and 2.6.32.2
Message-Id: <20091221113602.50579359.undefined@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

(my apologies to those with thread-aware mail user agents as this is not a
true reply as i'm not subscribed to linux-wireless, but copied from
marc.info's raw message display.)

> If there are any bugs please report them
> through linux-wireless.

> I've tested ath5k on 2.6.27.41 on x86_64 and
> send this e-mail out through it.

> While at it 2.6.32.2 got released today so I just updated a release
> for that so users can benefit from the few fixes [3], you can check
> the ChangeLog for that on the wireless for details on the changes [4].

i tested ath5k from compat-wireless-2.6.32 on 2.6.27.41 and from
compat-wireless-2.6.32.2 on 2.6.27.42 and i needed this patch [1]
to avoid duplicate ieee80211_rx symbol in ieee80211 (from kernel) &
mac80211 (from compat-wireless).

[1] http://patchwork.kernel.org/patch/54569/

i see that the patch was applied to compat-wireless-2.6.33-rc1, but i
wonder if it should be backported to the 2.6.32.2 release.

actually, i have no personal stake in the fix as after i got it to work i
learned that the new release is not compatible with my older distro-provided
user-land (doesn't recognize it as wireless), which i don't feel like
upgrading/self-maintaining and possibly descending into dependency-hell, so
i'm sticking with compat-wireless-2.6.30 (compat-wireless-2.6.31-rc7 release
didn't seem to work as well as 2.6.30), but thought the finding might be of
interest to others (possibly stumbling upon this searching for
"compat-wireless-2.6.32 ieee80211_rx ieee80211 mac80211 duplicate symbol"
or something similar).

thanks for compat-wireless!

corey
-- 
undefined@pobox.com
