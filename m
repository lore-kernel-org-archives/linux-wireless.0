Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f52.google.com ([209.85.220.52]:36793 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159AbbJJIzr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Oct 2015 04:55:47 -0400
Date: Sat, 10 Oct 2015 14:25:39 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Colin King <colin.king@canonical.com>
Cc: Johnny Kim <johnny.kim@atmel.com>,
	Rachel Kim <rachel.kim@atmel.com>,
	Dean Lee <dean.lee@atmel.com>,
	Chris Park <chris.park@atmel.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: wilc1000: fix memory leak on mgmt_tx on error
 return path
Message-ID: <20151010085539.GM4795@sudip-pc> (sfid-20151010_105636_999580_C443C619)
References: <1444389093-10309-1-git-send-email-colin.king@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1444389093-10309-1-git-send-email-colin.king@canonical.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Oct 09, 2015 at 12:11:33PM +0100, Colin King wrote:
> From: Colin Ian King <colin.king@canonical.com>
> 
> Static analysis with cppcheck found the following memory leak:
> 
> [drivers/staging/wilc1000/linux_mon.c:255]: (error) Memory leak: mgmt_tx
> 
> Free mgmt_tx on the error return path when mgmt_tx->buff fails to be
> allocated.
> 
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---

This has already been done by:
f638dd3918a4 ("staging: wilc1000: fix potential memory leak")

regards
sudip
