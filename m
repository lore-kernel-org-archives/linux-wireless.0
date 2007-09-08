Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-ip-62-75-166-246.inaddr.intergenia.de ([62.75.166.246]:44431
	"EHLO vs166246.vserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753390AbXIHQfg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Sep 2007 12:35:36 -0400
From: Michael Buesch <mb@bu3sch.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: COMMON symbol warnings
Date: Sat, 8 Sep 2007 18:35:01 +0200
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Daniel Drake <dsd@gentoo.org>,
	Ulrich Kunitz <kune@deine-taler.de>
References: <1189100314.28781.112.camel@johannes.berg> <20070908130118.GA11648@infradead.org>
In-Reply-To: <20070908130118.GA11648@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Message-Id: <200709081835.02212.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 08 September 2007, Christoph Hellwig wrote:
> > WARNING: "zd_workqueue" [drivers/net/wireless/zd1211rw-mac80211/zd1211rw-mac80211] is COMMON symbol
> > WARNING: "zd_workqueue" [drivers/net/wireless/zd1211rw/zd1211rw] is COMMON symbol
> > 
> > any idea what that means?
> 
> Yes.  It means a variable is declared in multiple places and the linker
> merges it for you.  The fix is to make sure these are declared extern in
> all places but one.

Do you need an own workqueue in zd? Can you use the one mac80211 exports?

