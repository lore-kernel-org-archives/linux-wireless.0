Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:54678 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932137Ab1KHWPF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Nov 2011 17:15:05 -0500
Subject: Re: [PATCH] net/wireless: add COUNTRY to to regulatory device
 uevent
From: Johannes Berg <johannes@sipsolutions.net>
To: Scott James Remnant <scott@netsplit.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Kay Sievers <kay.sievers@vrfy.org>,
	Greg Kroah-Hartman <gregkh@suse.de>,
	Sam Leffler <sleffler@chromium.org>, keybuk@google.com,
	"Luis R. Rodriguez" <mcgrof@gmail.com>
In-Reply-To: <1299609930-14011-1-git-send-email-scott@netsplit.com>
References: <1299609930-14011-1-git-send-email-scott@netsplit.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Nov 2011 23:15:00 +0100
Message-ID: <1320790500.23056.0.camel@jlt3.sipsolutions.net> (sfid-20111108_231510_564110_8A45BA00)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-03-08 at 10:45 -0800, Scott James Remnant wrote:
> From: Scott James Remnant <keybuk@google.com>
> 
> Regulatory devices issue change uevents to inform userspace of a need
> to call the crda tool; however these can often be sent before udevd is
> running, and were not previously included in the results of
> udevadm trigger (which requests a new change event using the /uevent
> attribute of the sysfs object).
> 
> Add a uevent function to the device type which includes the COUNTRY
> information from the last request if it has yet to be processed, the
> case of multiple requests is already handled in the code by checking
> whether an unprocessed one is queued in the same manner and refusing
> to queue a new one.
> 
> The existing udev rule continues to work as before.

Luis points out that it looks like this caused the crash I reported
earlier today -- in the module exit path we have a use-after-free of
last_request now.

johannes

