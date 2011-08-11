Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:50617 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068Ab1HKNXz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Aug 2011 09:23:55 -0400
Subject: Re: commit 50d3dfb72 corrupt memory
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Jouni Malinen <jouni@qca.qualcomm.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20110811131937.GA4903@redhat.com>
References: <20110811131937.GA4903@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 11 Aug 2011 15:23:50 +0200
Message-ID: <1313069030.3992.8.camel@jlt3.sipsolutions.net> (sfid-20110811_152358_615705_46AF1180)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2011-08-11 at 15:19 +0200, Stanislaw Gruszka wrote:
> My system crash when try to connet to wireless network since
> 
> commit 50d3dfb728e987790cf3d973aaf5fba2433771d8
> Author: Jouni Malinen <jouni@qca.qualcomm.com>
> Date:   Mon Aug 8 12:11:52 2011 +0300
> 
>     cfg80211/nl80211: Send AssocReq IEs to user space in AP mode
> 
> assoc_req_ies is not initialized hence NLA_PUT may write
> on random address. I think station_info->filled should be
> used for check.

Yeah, see [PATCH] cfg80211: fix a crash in nl80211_send_station from
Felix.

johannes

