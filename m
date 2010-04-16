Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42354 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932446Ab0DPU56 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Apr 2010 16:57:58 -0400
Subject: Re: [PATCH 2/2] iwmc3200wifi: check sparse endianness annotations
From: Johannes Berg <johannes@sipsolutions.net>
To: Pavel Roskin <proski@gnu.org>
Cc: Zhu Yi <yi.zhu@intel.com>, linville@tuxdriver.com,
	linux-wireless@vger.kernel.org,
	Samuel Ortiz <sameo@linux.intel.com>
In-Reply-To: <1271451350.16507.2.camel@mj>
References: <1271381324-21044-1-git-send-email-yi.zhu@intel.com>
	 <1271381324-21044-2-git-send-email-yi.zhu@intel.com>
	 <1271451350.16507.2.camel@mj>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 16 Apr 2010 22:57:46 +0200
Message-ID: <1271451466.8043.0.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-04-16 at 16:55 -0400, Pavel Roskin wrote:
> On Fri, 2010-04-16 at 09:28 +0800, Zhu Yi wrote:
> > From: Samuel Ortiz <sameo@linux.intel.com>
> > 
> > Add -D__CHECK_ENDIAN__ to driver ccflags so that sparse will
> > always check endianness by default.
> 
> I believe it's wrong.  I would be fine with enabling __CHECK_ENDIAN__
> for the whole kernel by default (perhaps with an option to disable it).
> But there is no reason why some particular drivers need that check more
> than the rest of the kernel.

We've done it on other drivers -- we can't do it for all of the kernel
because that would drown people in warnings, but for those drivers that
_should_ be clean it ought to be fine to add it by default.

johannes

