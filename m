Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:42116 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751785AbZFBNP2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Jun 2009 09:15:28 -0400
Date: Tue, 2 Jun 2009 09:12:23 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org
Subject: Re: [PATCH] nl80211: use GFP_ATOMIC for michael mic failure message
Message-ID: <20090602131222.GA30509@tuxdriver.com>
References: <20090602040503.GA5385@hash.localnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090602040503.GA5385@hash.localnet>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 02, 2009 at 12:05:04AM -0400, Bob Copeland wrote:
> nl80211_michael_mic_failure can be called in atomic context but
> does a GFP_KERNEL allocation.  Fixes the error below:

This is not the first one of these.  Anyone care to audit nl80211.c for others?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
