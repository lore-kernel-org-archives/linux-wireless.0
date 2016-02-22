Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from webbox1416.server-home.net ([77.236.96.61]:33622 "EHLO
	webbox1416.server-home.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754688AbcBVLQt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Feb 2016 06:16:49 -0500
From: Alexander Stein <alexander.stein@systec-electronic.com>
To: Colin Ian King <colin.king@canonical.com>
Cc: linux-kernel@vger.kernel.org,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Chaoming Li <chaoming_li@realsil.com.cn>,
	Kalle Valo <kvalo@codeaurora.org>,
	Priit Laes <plaes@plaes.org>, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH] rtlwifi: pass struct rtl_stats by reference as it is more efficient
Date: Mon, 22 Feb 2016 12:16:44 +0100
Message-ID: <1789324.SO5L4OcibE@ws-stein> (sfid-20160222_121721_187210_4F6308B3)
In-Reply-To: <56CADFF4.409@canonical.com>
References: <1456006227-10709-1-git-send-email-colin.king@canonical.com> <1498532.AoNxxa1Kry@ws-stein> <56CADFF4.409@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Monday 22 February 2016 10:16:20, Colin Ian King wrote:
> On 22/02/16 06:51, Alexander Stein wrote:
> > On Saturday 20 February 2016 22:10:27, Colin King wrote:
> >> From: Colin Ian King <colin.king@canonical.com>
> >>
> >> passing rtl_stats by value is inefficient; the structure is over 300
> >> bytes in size and generally just one field (packet_report_type)
> >> is being accessed, so the pass by value is a relatively large overhead.
> >> This change just affects just the rx_command_packet calls.
> > 
> > Why not using a const pointer?
> 
> const struct rtl_stats *const status?

I think "const structl rtl_stats* status" is enough, no need to make that pointer const itself. Dunno if that would make any difference for compilers in that case.
The idea is that you cannot change the passed struct, same as before because of copy by value.

Best regards,
Alexander

