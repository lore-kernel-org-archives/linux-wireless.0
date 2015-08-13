Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:48371 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752061AbbHMNWM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2015 09:22:12 -0400
Message-ID: <1439472129.2114.32.camel@sipsolutions.net> (sfid-20150813_152215_196001_34F08701)
Subject: Re: [PATCH 3/3] iw: Avoid possible memory leak for cb
From: Johannes Berg <johannes@sipsolutions.net>
To: amit.khatri@samsung.com
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	Rahul Jain <rahul.jain@samsung.com>,
	HEMANSHU SRIVASTAVA <hemanshu.s@samsung.com>,
	Nitin Jhanwar <nitin.j@samsung.com>
Date: Thu, 13 Aug 2015 15:22:09 +0200
In-Reply-To: <1629204510.56471439461785277.JavaMail.weblogic@ep2mlwas02d>
References: <1629204510.56471439461785277.JavaMail.weblogic@ep2mlwas02d>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This patch doesn't look correct - in the case that 'cb' fails to
allocate, the existing code is actually correct. In the case that s_cb
fails to allocate, it's clearly incorrect, but that means the two
conditions need to be disentangled, no?

Also, I've applied the other two patches despite them being severely
mangled - please try to improve your submission process so the patches
can apply - perhaps send them to yourself and see if 'git am' can
handle them to figure out what's wrong.

johannes
