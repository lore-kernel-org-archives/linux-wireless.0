Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:24285 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754759AbaIQI0s (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 17 Sep 2014 04:26:48 -0400
Date: Wed, 17 Sep 2014 11:26:27 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Kieron Browne <kieron.browne@gmail.com>
Cc: Larry.Finger@lwfinger.net, Jes.Sorensen@redhat.com,
	gregkh@linuxfoundation.org, linux-wireless@vger.kernel.org,
	devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] staging: rtl8723au: fix sparse incorrect type
 assignment warnings
Message-ID: <20140917082627.GH17875@mwanda> (sfid-20140917_102715_315905_CE9F2AC7)
References: <1410906489-26671-1-git-send-email-kieron.browne@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1410906489-26671-1-git-send-email-kieron.browne@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Sep 16, 2014 at 11:28:09PM +0100, Kieron Browne wrote:
> Use cpu_to_le16 to cast int for assignment to __le16 members
> 

"cast" is the wrong word.  It's really doing a byte swap.  It fixes a
bug on big endian systems.

But the patch is ok and matches how the other rtl drivers do it.

regards,
dan carpenter

