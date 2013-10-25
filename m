Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:49547 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751788Ab3JYLSI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Oct 2013 07:18:08 -0400
Message-ID: <1382699879.12755.0.camel@jlt4.sipsolutions.net> (sfid-20131025_131812_339797_93A5160C)
Subject: Re: [PATCH] iwl3945: do not print RFKILL message
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org, Dietmar Rudolph <dietmar@crlf.de>
Date: Fri, 25 Oct 2013 13:17:59 +0200
In-Reply-To: <20131025103751.GB16384@redhat.com> (sfid-20131025_124130_652554_7E7D6F5E)
References: <20131025103751.GB16384@redhat.com>
	 (sfid-20131025_124130_652554_7E7D6F5E)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2013-10-25 at 12:37 +0200, Stanislaw Gruszka wrote:
> We can mess logs if user space try to open device again and again if
> RFKILL switch is on. Do not print message and return ERFKILL error
> instead to indicate where the problem is.

Are you maybe not calling wiphy_rfkill_set_hw_state() in the right
places?

johannes

