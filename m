Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:56998 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757357AbZJ3TPD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Oct 2009 15:15:03 -0400
Date: Fri, 30 Oct 2009 15:11:26 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH] mac80211: make CALL_TXH a statement
Message-ID: <20091030191126.GC2586@tuxdriver.com>
References: <1256802228.3865.55.camel@johannes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1256802228.3865.55.camel@johannes.local>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 29, 2009 at 08:43:48AM +0100, Johannes Berg wrote:
> The multi-line code in this macro wasn't wrapped
> in do {} while (0) so we cannot use it in an if()
> branch safely in the future -- fix that.
> 
> Signed-off-by: Johannes Berg <johannes@sipsolutions.net>

do {...} while (0) won't work for that either, right?  You need
({...}) instead if you want to return a value.  Is that what you want?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
