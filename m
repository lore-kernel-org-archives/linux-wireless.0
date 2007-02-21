Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fencepost.gnu.org ([199.232.76.164]:49638 "EHLO
	fencepost.gnu.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932315AbXBUBS4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Feb 2007 20:18:56 -0500
Received: from proski by fencepost.gnu.org with local (Exim 4.60)
	(envelope-from <proski@gnu.org>)
	id 1HJg6p-0000b6-9x
	for linux-wireless@vger.kernel.org; Tue, 20 Feb 2007 20:17:27 -0500
Subject: Re: [PATCH] rt2x00: Fix max_rssi values signedness bug
From: Pavel Roskin <proski@gnu.org>
To: Michael Buesch <mb@bu3sch.de>
Cc: John Linville <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <200702202102.14354.mb@bu3sch.de>
References: <200702202102.14354.mb@bu3sch.de>
Content-Type: text/plain
Date: Tue, 20 Feb 2007 20:18:49 -0500
Message-Id: <1172020729.6042.2.camel@dv>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2007-02-20 at 21:02 +0100, Michael Buesch wrote:
> char is not signed on all architectures.
> This fixes a compiletime warning and bug on PPC.

Then we have a bigger problem.  Please see include/net/d80211.h:

> /* Maximum values for various statistics.
>  * Leave at 0 to indicate no support. Use negative numbers for dBm. */
> char max_rssi;
> char max_signal;
> char max_noise;

So, there will be no dBm on PowerPC.  I think those fields should be
"signed char".

-- 
Regards,
Pavel Roskin

