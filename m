Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4194 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752625Ab2AMKaa (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Jan 2012 05:30:30 -0500
Date: Fri, 13 Jan 2012 11:29:09 +0100
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Jiri Kosina <jkosina@suse.cz>,
	Lucas De Marchi <lucas.demarchi@profusion.mobi>,
	linux-wireless@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [patch] ipw2x00: signedness bug handling frame length
Message-ID: <20120113102908.GB2214@redhat.com> (sfid-20120113_113036_217411_66E18227)
References: <20120112063449.GA2408@elgon.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20120112063449.GA2408@elgon.mountain>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jan 12, 2012 at 09:34:50AM +0300, Dan Carpenter wrote:
> This is basically just a cleanup.  Large positive numbers get counted as
> negative but then get implicitly cast to positive again for the checks
> that matter.
> 
> This does make a small difference in ipw_handle_promiscuous_rx() when we
> test "if (unlikely((len + IPW_RX_FRAME_SIZE) > skb_tailroom(rxb->skb)))"
> It should return there, but we don't return until a couple lines later
> when we test "if (len > IPW_RX_BUF_SIZE - sizeof(struct ipw_rt_hdr)) {".
> The difference is that in the second test the sizeof() means that there
> is an implied cast to unsigned.
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Not sure if making it "unsinged int" would be better, but this change is
fine to me as is too.

Reviewed-by: Stanislaw Gruszka <sgruszka@redhat.com>
