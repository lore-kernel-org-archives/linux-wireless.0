Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:54962 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751455AbXLFJu3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 6 Dec 2007 04:50:29 -0500
Subject: Re: [PATCH] libertas: fix data packet size errors
From: David Woodhouse <dwmw2@infradead.org>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Dan Williams <dcbw@redhat.com>,
	libertas-dev@lists.infradead.org
In-Reply-To: <200712061015.54478.hs4233@mail.mn-solutions.de>
References: <200712061015.54478.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Thu, 06 Dec 2007 09:50:26 +0000
Message-Id: <1196934626.13978.485.camel@pmac.infradead.org> (sfid-20071206_095032_744686_9417ED29)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Thu, 2007-12-06 at 10:15 +0100, Holger Schurig wrote:
> 
> +       /* This is a workaround for a firmware that reports too much
> +        * bytes */
> +       *len -= 8
>         ret = 0;

You might want another semicolon somewhere in there?

And if we're not looking at the length at all, that's bad. We should
probably at _least_ compare it with the size field, to make sure we got
everything that was sent, and that we're not reading off the end of the
buffer.

-- 
dwmw2

