Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from webbox1416.server-home.net ([77.236.96.61]:56953 "EHLO
	webbox1416.server-home.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750774AbcBVG6H (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Feb 2016 01:58:07 -0500
From: Alexander Stein <alexander.stein@systec-electronic.com>
To: linux-kernel@vger.kernel.org
Cc: Colin King <colin.king@canonical.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Chaoming Li <chaoming_li@realsil.com.cn>,
	Kalle Valo <kvalo@codeaurora.org>,
	Priit Laes <plaes@plaes.org>, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org
Subject: Re: [PATCH] rtlwifi: pass struct rtl_stats by reference as it is more efficient
Date: Mon, 22 Feb 2016 07:51:08 +0100
Message-ID: <1498532.AoNxxa1Kry@ws-stein> (sfid-20160222_075833_205392_5883DF2D)
In-Reply-To: <1456006227-10709-1-git-send-email-colin.king@canonical.com>
References: <1456006227-10709-1-git-send-email-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Saturday 20 February 2016 22:10:27, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> passing rtl_stats by value is inefficient; the structure is over 300
> bytes in size and generally just one field (packet_report_type)
> is being accessed, so the pass by value is a relatively large overhead.
> This change just affects just the rx_command_packet calls.

Why not using a const pointer?

Best regards,
Alexander

