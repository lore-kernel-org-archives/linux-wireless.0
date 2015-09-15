Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f49.google.com ([209.85.220.49]:34877 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292AbbIOG1X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Sep 2015 02:27:23 -0400
Received: by pacfv12 with SMTP id fv12so170345277pac.2
        for <linux-wireless@vger.kernel.org>; Mon, 14 Sep 2015 23:27:23 -0700 (PDT)
Date: Tue, 15 Sep 2015 11:57:15 +0530
From: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To: Tony Cho <tony.cho@atmel.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
	rachel.kim@atmel.com, chris.park@atmel.com, austin.shin@atmel.com,
	linux-wireless@vger.kernel.org, johnny.kim@atmel.com,
	Nicolas.FERRE@atmel.com, adel.noureldin@atmel.com,
	leo.kim@atmel.com, adham.abozaeid@atmel.com
Subject: Re: [PATCH 0/7] remove wilc_errorsupport.h from the wilc driver
Message-ID: <20150915062715.GG12611@sudip-pc> (sfid-20150915_082726_660233_58631334)
References: <1442285621-29457-1-git-send-email-tony.cho@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1442285621-29457-1-git-send-email-tony.cho@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 15, 2015 at 11:53:34AM +0900, Tony Cho wrote:
> This patch aims to remove the wilc_errorsupport.h which is unnecessary in the
> wilc driver. This patch replaces the error types defined by wilc driver with
> kernel generic error types and removes macros which handles the errors.

Patch 2/7 and 4/7 are introducing new checkpatch warnings which again
some has to fix in a separate patch. Better to fix it while you are
sending. And instead of printk it should be pr_err or much better if you
can use netev_err. Looks like it can be used in some of the functions.

regards
sudip
