Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:31350 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753877AbbFJJga (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jun 2015 05:36:30 -0400
Date: Wed, 10 Jun 2015 12:36:11 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Johnny Kim <johnny.kim@atmel.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
	linux-wireless@vger.kernel.org, Rachel.kim@atmel.com,
	dean.lee@atmel.com, tony.cho@atmel.com, chris.park@atmel.com
Subject: Re: [PATCH 1/4] staging: wilc1000: modify data type
Message-ID: <20150610093611.GD28762@mwanda> (sfid-20150610_113633_766980_D1E63EC4)
References: <1433923607-20927-1-git-send-email-johnny.kim@atmel.com>
 <1433923607-20927-2-git-send-email-johnny.kim@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1433923607-20927-2-git-send-email-johnny.kim@atmel.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 10, 2015 at 05:06:44PM +0900, Johnny Kim wrote:
> This replace the argument of the function to the independent data type
> in system.
> 
> Signed-off-by: Johnny Kim <johnny.kim@atmel.com>

This changelog says what you are doing but not why.

What is the point of ->u32Address?  Now that it's not 32 bits, the name
makes no sense.  Why not just make it a pointer?

There was someone changing all the datatypes with sed.  In some ways,
those patches were easier to review because they were mindless and not
really expected to make sense.  After we just sed the code to make it
look more normal then we can think about 64 bit bugs (like this patch
and the next).

regards,
dan carpenter

