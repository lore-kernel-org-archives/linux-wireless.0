Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:21325 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107Ab3IYSYS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Sep 2013 14:24:18 -0400
Date: Wed, 25 Sep 2013 21:23:59 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Bing Zhao <bzhao@marvell.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"kernel-janitors@vger.kernel.org" <kernel-janitors@vger.kernel.org>
Subject: Re: [patch] mwifiex: potential integer underflow in
 mwifiex_ret_wmm_get_status()
Message-ID: <20130925182359.GV6247@mwanda> (sfid-20130925_224457_715037_F08D0F7D)
References: <20130925085729.GC6661@elgon.mountain>
 <477F20668A386D41ADCC57781B1F70430F45077CDA@SC-VEXCH1.marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <477F20668A386D41ADCC57781B1F70430F45077CDA@SC-VEXCH1.marvell.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Sep 25, 2013 at 09:25:46AM -0700, Bing Zhao wrote:
> Hi Dan,
> 
> > If "resp_len" gets set to negative then it counts as a high positive value.
> > 
> > Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> > ---
> > I spotted this reviewing the int => bool changes, but I don't have the
> > hardware and can't test it.
> 
> Thanks for spotting this potential integer underflow problem.
> 
> I think we can change the 'resp_len' variable type to a signed integer
> to fix this issue.

No, that doesn't work because the comparison against sizeof() get's
promoted to size_t.  In other words, negative values still count as
large positive values.

regards,
dan carpenter

