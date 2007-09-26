Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:35686
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751738AbXIZOlB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Sep 2007 10:41:01 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH v2] mac80211: fix interface initialisation and deinitialisation
Date: Wed, 26 Sep 2007 16:37:56 +0200
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Michael Wu <flamingice@sourmilk.net>,
	linux-wireless@vger.kernel.org
References: <200709252206.57855.mb@bu3sch.de> <1190755892.18521.330.camel@johannes.berg> <1190809643.4204.3.camel@johannes.berg>
In-Reply-To: <1190809643.4204.3.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200709261637.56556.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 26 September 2007 14:27:23 Johannes Berg wrote:
> When an interface is registered it is still uninitialised so
> ieee80211_if_reinit() can't be called on it (it will oops.)
> Hence, we need to move the uninit method assignment.
> 
> Also, this patch fixes the bug that the master device is never
> initialised nor deinitialised at all. Oddly, the deinit code
> had an if statement to not run some code when running for the
> master interface (which never happened), but that if statement
> is also wrong. Fix that too.
> 
> Now that the uninit code is run for the master device, another
> bug surfaced: it tries to remove all dependent interfaces and
> that oopses or BUGs at some point, either because it unregisters
> already unregistered interfaces (missing list_del bug) or due
> to trying to iterate a list that has had other things removed.
> Fix this too by handling the master interface specially.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

This works fine without any crashes or problems here.

-- 
Greetings Michael.
