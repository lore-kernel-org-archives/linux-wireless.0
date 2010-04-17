Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:37911 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752126Ab0DQIVD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 17 Apr 2010 04:21:03 -0400
Subject: Re: [PATCH 2/2] iwmc3200wifi: check sparse endianness annotations
From: Johannes Berg <johannes@sipsolutions.net>
To: Pavel Roskin <proski@gnu.org>
Cc: Zhu Yi <yi.zhu@intel.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org,
	Samuel Ortiz <sameo@linux.intel.com>
In-Reply-To: <1271453698.16507.26.camel@mj>
References: <1271381324-21044-1-git-send-email-yi.zhu@intel.com>
	 <1271381324-21044-2-git-send-email-yi.zhu@intel.com>
	 <1271451350.16507.2.camel@mj>
	 <1271451466.8043.0.camel@jlt3.sipsolutions.net>
	 <1271453698.16507.26.camel@mj>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 17 Apr 2010 10:20:41 +0200
Message-ID: <1271492441.5157.1.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-04-16 at 17:34 -0400, Pavel Roskin wrote:
> On Fri, 2010-04-16 at 22:57 +0200, Johannes Berg wrote:
> 
> > We've done it on other drivers -- we can't do it for all of the kernel
> > because that would drown people in warnings, but for those drivers that
> > _should_ be clean it ought to be fine to add it by default.
> 
> Oh, I see, there are several precedents.
> 
> That said, there are not many warnings added by __CHECK_ENDIAN__.  In my
> x86_64 configuration, sparse produces 2316 lines of output without
> __CHECK_ENDIAN__ and 3526 lines with __CHECK_ENDIAN__, a 52% increase.
> That's hardly "drowning".

Other people feel differently by that, evidenced by the "lack of
enthusiasm" for adding endian checking by default.

> Also, the warnings about endianess are perhaps the most useful of all
> sparse warnings.

I agree, so I want them whenever I run sparse on code I own.

However, I'm simply not willing to fight for making endian checking
default kernel-wide to achieve that goal. You may disagree, and you're
welcome to pick that fight. Until then, please let us do what gets our
job done.

johannes

