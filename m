Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.perches.com ([173.55.12.10]:4087 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759012Ab1CCWkP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Mar 2011 17:40:15 -0500
Subject: RE: [PATCH v2] mwifiex: remove PRINTM/HEXDUMP and associated
From: Joe Perches <joe@perches.com>
To: Bing Zhao <bzhao@marvell.com>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Amitkumar Karwar <akarwar@marvell.com>,
	Kiran Divekar <dkiran@marvell.com>,
	Yogesh Powar <yogeshp@marvell.com>,
	Marc Yang <yangyang@marvell.com>,
	Frank Huang <frankh@marvell.com>
In-Reply-To: <477F20668A386D41ADCC57781B1F704307F5150CCD@SC-VEXCH1.marvell.com>
References: <1299105113-3052-1-git-send-email-bzhao@marvell.com>
	 <1299139646.4338.69.camel@Joe-Laptop>
	 <477F20668A386D41ADCC57781B1F704307F5150CCD@SC-VEXCH1.marvell.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 Mar 2011 14:40:12 -0800
Message-ID: <1299192012.4338.170.camel@Joe-Laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-03-03 at 14:04 -0800, Bing Zhao wrote:
> Hi Joe,
> 
> > Please use pr_fmt
> > #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> > to prefix "mwifiex: " rather than put it each
> > format string.
>  
> For pr_debug, the original "fmt" is used to construct the _ddebug descriptor:
> 
> #define dynamic_pr_debug(fmt, ...) do {                                 \
>         static struct _ddebug descriptor                                \
>         __used                                                          \
>         __attribute__((section("__verbose"), aligned(8))) =             \
>         { KBUILD_MODNAME, __func__, __FILE__, fmt, __LINE__,            \
>                 _DPRINTK_FLAGS_DEFAULT };                               \
> ......
> 
> So the prefix won't appear in dynamic_debug/control as the "format" string.
> 
> Do you think we should use pr_fmt(fmt) to construct _ddebug descriptor?
>         { KBUILD_MODNAME, __func__, __FILE__, pr_fmt(fmt), __LINE__,            \
> 
> Otherwise, I still have to add "mwifiex: " prefix for every pr_debug() call.

No, I believe that's incorrect.

#define dynamic_pr_debug(fmt, ...) do {					\
	static struct _ddebug descriptor				\
	__used								\
	__attribute__((section("__verbose"), aligned(8))) =		\
	{ KBUILD_MODNAME, __func__, __FILE__, fmt, __LINE__,		\
		_DPRINTK_FLAGS_DEFAULT };				\
	if (unlikely(descriptor.enabled))				\
		printk(KERN_DEBUG pr_fmt(fmt),	##__VA_ARGS__);		\
	} while (0)


dynamic_pr_debug does emit the format string
with pr_fmt(fmt).


