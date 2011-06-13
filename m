Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40075 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752002Ab1FMLLi (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 13 Jun 2011 07:11:38 -0400
Date: Mon, 13 Jun 2011 13:12:07 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Eliad Peller <eliad@wizery.com>
Cc: Johannes Berg <johannes@sipsolutions.net>,
	linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2] mac80211: add cancel_hw_scan() callback
Message-ID: <20110613111206.GA5316@redhat.com> (sfid-20110613_131201_213790_73E5C028)
References: <1307958450-11500-1-git-send-email-eliad@wizery.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1307958450-11500-1-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 13, 2011 at 12:47:30PM +0300, Eliad Peller wrote:
> When suspending, __ieee80211_suspend() calls ieee80211_scan_cancel(),
> which will only cancel sw scan. In order to cancel hw scan, the
> low-level driver has to cancel it in the suspend() callback. however,
> this is too late, as a new scan_work will be enqueued (while the driver
> is going into suspend).
> 
> Add a new cancel_hw_scan() callback, asking the driver to cancel an
> active hw scan, and call it in ieee80211_scan_cancel().
> 
> Signed-off-by: Eliad Peller <eliad@wizery.com>

Reviewed-by: Stanislaw Gruszka <sgruszka@redhat.com>

Thanks
