Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:48954 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751291AbYJTQ47 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 20 Oct 2008 12:56:59 -0400
Subject: Re: [PATCH] libertas: fix CF firmware loading
From: Dan Williams <dcbw@redhat.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com
In-Reply-To: <200810200847.40420.hs4233@mail.mn-solutions.de>
References: <1224267349.4010.2.camel@dhcp-100-3-195.bos.redhat.com>
	 <200810200847.40420.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Mon, 20 Oct 2008 12:55:42 -0400
Message-Id: <1224521742.29822.8.camel@dhcp-100-3-195.bos.redhat.com> (sfid-20081020_185704_109926_9007406C)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-10-20 at 08:47 +0200, Holger Schurig wrote:
> > From: Ryan Mallon <ryan@bluewatersys.com>
> >
> > Change the return value of if_cs_poll_while_fw_download to
> > zero on success, so that the firmware loading functions also
> > correctly return zero on success.
> >
> > Signed-off-by: Ryan Mallon <ryan@bluewatersys.com>
> > Acked-by: Dan Williams <dcbw@redhat.com>
> 
> The patch is ok, but the description is wrong.
> 
> The function is supposed to return some error back, which is 
> negative, e.g. -ETIME. And callers test for (ret < 0) to find 
> out about the error condition. See here:

Hmm, yeah, you're right.  John, can drop this if you want.

Dan


