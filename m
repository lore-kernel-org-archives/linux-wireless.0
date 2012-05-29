Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:7764 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750696Ab2E2LYo (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 29 May 2012 07:24:44 -0400
Date: Tue, 29 May 2012 13:24:09 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: run scan after finish connection monitoring
Message-ID: <20120529112407.GB2441@redhat.com> (sfid-20120529_132447_880801_E50A5ED5)
References: <1337174840-2658-1-git-send-email-sgruszka@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1337174840-2658-1-git-send-email-sgruszka@redhat.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 16, 2012 at 03:27:20PM +0200, Stanislaw Gruszka wrote:
> commit 133d40f9a22bdfd2617a446f1e3209537c5415ec
> Author: Stanislaw Gruszka <sgruszka@redhat.com>
> Date:   Wed Mar 28 16:01:19 2012 +0200
> 
>     mac80211: do not scan and monitor connection in parallel
> 
> add bug, which make possible to start a scan and never finish it, so
> make every new scanning request finish with -EBUSY error. This can
> happen on code paths where we finish connection monitoring and clear
> IEEE80211_STA_*_POLL flags, but do not check if scan was deferred.
> This patch fixes those code paths.

This patch fix commit, which went to Linus (3.5-rc) kernel, so should be
applied there as well. 

Stanislaw
