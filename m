Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.perches.com ([173.55.12.10]:4076 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932248Ab1CCULA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 3 Mar 2011 15:11:00 -0500
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
In-Reply-To: <477F20668A386D41ADCC57781B1F704307F5150C5A@SC-VEXCH1.marvell.com>
References: <1299105113-3052-1-git-send-email-bzhao@marvell.com>
	 <1299139646.4338.69.camel@Joe-Laptop>
	 <477F20668A386D41ADCC57781B1F704307F5150C5A@SC-VEXCH1.marvell.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 03 Mar 2011 12:10:58 -0800
Message-ID: <1299183058.4338.148.camel@Joe-Laptop>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-03-03 at 11:24 -0800, Bing Zhao wrote:
> For example, I can do "format 'mwifiex cmd' +p" and
> "format 'mwifiex event' +p" to enable debugging for "cmd" and "event" only.

Cute.  That works.

Most similar current uses are a
integer bitmap equivalent.

echo bitmap_value > module_control_variable

if (module_control_variable & type)
	print...

I think that's cleaner and less error prone
myself but opinions certainly vary.

> > Perhaps use use dev/netdev/wiphy_<level> where it makes
> > sense?
> I thought that too. But these APIs require a parameter of "struct device *".
> Some of mwifiex_ functions do not have this parameter.

Sure, but the places that do have an available
struct device|net_device|wiphy should use the
equivalent appropriate call.

cheers, Joe

