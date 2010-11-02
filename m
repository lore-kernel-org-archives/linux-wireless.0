Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:45485 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751518Ab0KBIbE (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 2 Nov 2010 04:31:04 -0400
Date: Tue, 2 Nov 2010 09:31:01 +0100
From: Lennert Buytenhek <buytenh@wantstofly.org>
To: Brian Cavagnolo <brian@cozybit.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 7/7] mac80211: unset SDATA_STATE_OFFCHANNEL when cancelling a scan
Message-ID: <20101102083100.GN1733@mail.wantstofly.org>
References: <1288659351-22313-1-git-send-email-brian@cozybit.com> <1288659351-22313-7-git-send-email-brian@cozybit.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1288659351-22313-7-git-send-email-brian@cozybit.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 01, 2010 at 05:55:51PM -0700, Brian Cavagnolo wrote:

> For client STA interfaces, ieee80211_do_stop unsets the relevant
> interface's SDATA_STATE_RUNNING state bit prior to cancelling an
> interrupted scan.  When ieee80211_offchannel_return is invoked as
> part of cancelling the scan, it doesn't bother unsetting the
> SDATA_STATE_OFFCHANNEL bit because it sees that the interface is
> down.  Normally this doesn't matter because when the client STA
> interface is brought back up, it will probably issue a scan.  But
> in some cases (e.g., the user changes the interface type while it
> is down), the SDATA_STATE_OFFCHANNEL bit will remain set.  This
> prevents the interface queues from being started.  So we
> unconditionally unset this bit when we cancel a scan.

How does this patch fit into the series?
