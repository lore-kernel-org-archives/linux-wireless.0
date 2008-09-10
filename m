Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:39338 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750745AbYIJSRF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Sep 2008 14:17:05 -0400
Subject: Re: [PATCH 1/2 v6] cfg80211: Add new wireless regulatory
	infrastructure
From: Marcel Holtmann <holtmann@linux.intel.com>
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
Cc: linville@tuxdriver.com, johannes@sipsolutions.net,
	linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <1221027589-19203-2-git-send-email-lrodriguez@atheros.com>
References: <1221027589-19203-1-git-send-email-lrodriguez@atheros.com>
	 <1221027589-19203-2-git-send-email-lrodriguez@atheros.com>
Content-Type: text/plain
Date: Wed, 10 Sep 2008 20:17:30 +0200
Message-Id: <1221070650.13336.20.camel@californication> (sfid-20080910_201710_268530_48CBC48F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Luis,

> This adds the new wireless regulatory infrastructure. The
> main motiviation behind this was to centralize regulatory
> code as each driver was implementing their own regulatory solution,
> and to replace the initial centralized code we have where:
> 
> * only 3 regulatory domains are supported: US, JP and EU
> * regulatory domains can only be changed through module parameter
> * all rules were built statically in the kernel
> 
> We now have support for regulatory domains for many countries
> and regulatory domains are now queried through a userspace agent
> through udev allowing distributions to update regulatory rules
> without updating the kernel.
> 
> Each driver can regulatory_hint() a regulatory domain
> based on either their EEPROM mapped regulatory domain value to a
> respective ISO/IEC 3166-1 country code or pass an internally built
> regulatory domain. We also add support to let the user set the
> regulatory domain through userspace in case of faulty EEPROMs to
> further help compliance.

thanks for the write-up and examples. I like it a lot and gives driver
maintainers a nice understanding what to do.

While reading through it, I came to think about regulatory_hint(). So is
there a use case where would give it the alpha2 code and the domain
itself at the same time? If not, then it would make more sense to split
this into two functions. Maybe something regulatory_alpha2_hint() and
regulatory_domain_hint(). Just a thought.

Regards

Marcel


