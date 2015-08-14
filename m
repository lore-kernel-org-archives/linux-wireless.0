Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:53677 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754003AbbHNI3I (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 14 Aug 2015 04:29:08 -0400
Message-ID: <1439540944.2091.10.camel@sipsolutions.net> (sfid-20150814_102940_877645_8714F33D)
Subject: GCOV_PROFILE_ALL breaks BUILD_BUG_ON(!is_power_of_2(8))
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
	linux-kernel <linux-kernel@vger.kernel.org>
Date: Fri, 14 Aug 2015 10:29:04 +0200
In-Reply-To: <1439457109-21833-1-git-send-email-johannes@sipsolutions.net> (sfid-20150813_111207_653261_1F4C7F80)
References: <1439457109-21833-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20150813_111207_653261_1F4C7F80)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

+linux-kernel

> +#define DECLARE_EWMA(name, _factor, _weight)> 	> 	> 	> 	> \
> +> 	> struct ewma_##name {> 	> 	> 	> 	> 	> 	> \
> +> 	> 	> unsigned long internal;> 	> 	> 	> 	> 	> \
> +> 	> };> 	> 	> 	> 	> 	> 	> 	> 	> \
> +> 	> static inline void ewma_##name##_init(struct ewma_##name *e)> 	> \
> +> 	> {> 	> 	> 	> 	> 	> 	> 	> 	> \
> +> 	> 	> BUILD_BUG_ON(!__builtin_constant_p(_factor));> 	> 	> \
> +> 	> 	> BUILD_BUG_ON(!__builtin_constant_p(_weight));> 	> 	> \
> +> 	> 	> BUILD_BUG_ON(!is_power_of_2(_factor));> 	> 	> 	> \
> +> 	> 	> BUILD_BUG_ON(!is_power_of_2(_weight));> 	> 	> 	> \
> 

So this seemed fine to me, but for some reason the compiler is saying
the BUILD_BUG_ON(!is_power_of_2(x)) fails, if and only if (!)
CONFIG_GCOV_PROFILE_ALL is enabled, which seems to boil down to the
compiler option -fprofile-arcs.

I'm going to replace this with just the code itself, i.e.

                /* both must be a power of 2 */
                BUILD_BUG_ON(_factor & (_factor - 1));
                BUILD_BUG_ON(_weight & (_weight - 1));

but should I have expected this?

johannes
