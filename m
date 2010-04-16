Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:34310 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932417Ab0DPVe7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Apr 2010 17:34:59 -0400
Subject: Re: [PATCH 2/2] iwmc3200wifi: check sparse endianness annotations
From: Pavel Roskin <proski@gnu.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Zhu Yi <yi.zhu@intel.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org,
	Samuel Ortiz <sameo@linux.intel.com>
In-Reply-To: <1271451466.8043.0.camel@jlt3.sipsolutions.net>
References: <1271381324-21044-1-git-send-email-yi.zhu@intel.com>
	 <1271381324-21044-2-git-send-email-yi.zhu@intel.com>
	 <1271451350.16507.2.camel@mj>
	 <1271451466.8043.0.camel@jlt3.sipsolutions.net>
Content-Type: text/plain
Date: Fri, 16 Apr 2010 17:34:58 -0400
Message-Id: <1271453698.16507.26.camel@mj>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-04-16 at 22:57 +0200, Johannes Berg wrote:

> We've done it on other drivers -- we can't do it for all of the kernel
> because that would drown people in warnings, but for those drivers that
> _should_ be clean it ought to be fine to add it by default.

Oh, I see, there are several precedents.

That said, there are not many warnings added by __CHECK_ENDIAN__.  In my
x86_64 configuration, sparse produces 2316 lines of output without
__CHECK_ENDIAN__ and 3526 lines with __CHECK_ENDIAN__, a 52% increase.
That's hardly "drowning".

Also, the warnings about endianess are perhaps the most useful of all
sparse warnings.

-- 
Regards,
Pavel Roskin
