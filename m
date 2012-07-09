Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:34079 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753206Ab2GILuw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 9 Jul 2012 07:50:52 -0400
Message-ID: <1341834647.4455.32.camel@jlt3.sipsolutions.net> (sfid-20120709_135055_842002_F9E960E0)
Subject: Re: [RHEL6 PATCH] iwlwifi: remove spurious warning
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
	linux-wireless@vger.kernel.org
Date: Mon, 09 Jul 2012 13:50:47 +0200
In-Reply-To: <1341834509-11601-1-git-send-email-sgruszka@redhat.com>
References: <1341834509-11601-1-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2012-07-09 at 13:48 +0200, Stanislaw Gruszka wrote:
> BZ#837754
> 
> Description:
> Some devices do not set SEQ_RX_FRAME flags for few commands that should
> not be reclaimed. It was supposed to be fixed in firmware, but it was
> not.
> 
> Upstream change also add possibility to configure which commands should
> not be reclaimed, but that option is not used - only original 6 commands
> are configured. So I did not backport that part, because it make things
> somewhat (not necessarily) complex.

Yeah, looks fine. I'd hoped it was fixed for iwlwifi drivers (we
couldn't remember if it was 4965 only or not) but it turns out it wasn't
so this is needed.

I don't know if there's anything I should do about this though?

johannes

