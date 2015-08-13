Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:26783 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753664AbbHMTI6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 13 Aug 2015 15:08:58 -0400
Date: Thu, 13 Aug 2015 22:08:45 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Chandra S Gorentla <csgorentla@gmail.com>
Cc: gregkh@linuxfoundation.org, johnny.kim@atmel.com,
	rachel.kim@atmel.com, dean.lee@atmel.com, chris.park@atmel.com,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: wilc1000: Process WARN, INFO options of debug
 levels from user
Message-ID: <20150813190844.GB4484@mwanda> (sfid-20150813_210903_737055_F5171CB1)
References: <1439400958-10454-1-git-send-email-csgorentla@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1439400958-10454-1-git-send-email-csgorentla@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Aug 12, 2015 at 11:05:58PM +0530, Chandra S Gorentla wrote:
> -	if (copy_from_user(buffer, buf, count)) {
> +	ret = simple_write_to_buffer(buffer, sizeof(buffer), ppos, buf, count);

This part doesn't make sense.  Use copy_from_user().  Also it's not NUL
terminated so it leads to a read past the end of the array later.  In
the original code, we just looked at the first char and didn't use
kstrtoint() so we didn't care about NUL termination.

regards,
dan carpenter
