Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:21173 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751372Ab1FJI75 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 Jun 2011 04:59:57 -0400
Date: Fri, 10 Jun 2011 11:00:09 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Eliad Peller <eliad@wizery.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: add cancel_hw_scan() callback
Message-ID: <20110610090009.GA2503@redhat.com> (sfid-20110610_110000_892180_B7EFD9BD)
References: <1307691952-10980-1-git-send-email-eliad@wizery.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1307691952-10980-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jun 10, 2011 at 10:45:52AM +0300, Eliad Peller wrote:
> When suspending, __ieee80211_suspend() calls ieee80211_scan_cancel(),
> which will only cancel sw scan. In order to cancel hw scan, the
> low-level driver has to cancel it in the suspend() callback. however,
> this is too late, as a new scan_work will be enqueued (while the driver
> is going into suspend).
> 
> Add a new cancel_hw_scan() callback, asking the driver to cancel an
> active hw scan, and call it in ieee80211_scan_cancel().

Looks reasonable, but could you also update a comments?

> +	/*
> +	 * The scan is canceled, but stop work from being pending.

Also this one is not valid and should be removed.

Stanislaw
