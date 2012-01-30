Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:53805 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753373Ab2A3TbZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 30 Jan 2012 14:31:25 -0500
Received: from uucp by smtp.tuxdriver.com with local-rmail (Exim 4.63)
	(envelope-from <linville@tuxdriver.com>)
	id 1Rrwwk-0001iu-CF
	for linux-wireless@vger.kernel.org; Mon, 30 Jan 2012 14:31:22 -0500
Received: from linville-8530p.local (linville-8530p.local [127.0.0.1])
	by linville-8530p.local (8.14.4/8.14.4) with ESMTP id q0UJSBMm007288
	for <linux-wireless@vger.kernel.org>; Mon, 30 Jan 2012 14:28:12 -0500
Received: (from linville@localhost)
	by linville-8530p.local (8.14.4/8.14.4/Submit) id q0UJSBoF007286
	for linux-wireless@vger.kernel.org; Mon, 30 Jan 2012 14:28:11 -0500
Date: Mon, 30 Jan 2012 14:28:11 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: linux-wireless@vger.kernel.org
Subject: micro-project proposal -- WARN_ON -> WARN_ON_ONCE under
 drivers/net/wireless
Message-ID: <20120130192811.GD2493@tuxdriver.com> (sfid-20120130_203128_719625_5245B17D)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Anyone looking for a little "janitorial" project to do under the
drivers/net/wireless tree?

find drivers/net/wireless/ -type f -exec grep -H WARN_ON {} \; | \
	grep -v WARN_ON_ONCE | wc -l
653

That looks like an awful lot of "WARN_ON" calls.  Do all of them
really need to SPAM the log files every single time they are hit?
Couldn't a lot of them be WARN_ON_ONCE instead?

Patches welcome...

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
