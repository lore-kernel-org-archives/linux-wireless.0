Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:51991 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803AbbHQRmf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Aug 2015 13:42:35 -0400
Date: Mon, 17 Aug 2015 20:42:41 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: =?iso-8859-1?Q?Rapha=EBl?= Beamonte <raphael.beamonte@gmail.com>
Cc: Johnny Kim <johnny.kim@atmel.com>,
	Rachel Kim <rachel.kim@atmel.com>,
	Dean Lee <dean.lee@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] staging: wilc1000: remove FREE_WILC_BUFFER()
Message-ID: <20150817174241.GD5610@mwanda> (sfid-20150817_194253_205231_0AF245A3)
References: <CAE_Gge0m4KRC7UJntqnsXPeO9HZ7dg9UexLAi__2EN+ouGGw9w@mail.gmail.com>
 <cover.1439827537.git.raphael.beamonte@gmail.com>
 <da93f43d9e56eedb2afbf12387b782c4e686c7b7.1439827537.git.raphael.beamonte@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <da93f43d9e56eedb2afbf12387b782c4e686c7b7.1439827537.git.raphael.beamonte@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Aug 17, 2015 at 12:08:34PM -0400, Raphaël Beamonte wrote:
> It was just a wrapper around kfree(), so call that instead.
> 
> Signed-off-by: Raphaël Beamonte <raphael.beamonte@gmail.com>
> ---
> +	kfree(exported_g_tx_buf);
> +	exported_g_tx_buf = NULL;

No need to add these new NULL assignments.  The module is unloading so
no one cat re-use these pointers.  Also as a process rule, you should
write down any behaviour changes in the changelog and why you think they
are needed.

regards,
dan carpenter

