Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rcsinet15.oracle.com ([148.87.113.117]:45225 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027Ab2ENIbl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 May 2012 04:31:41 -0400
Date: Mon, 14 May 2012 11:34:15 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: linux-wireless@vger.kernel.org, Julia Lawall <julia@diku.dk>
Subject: Re: net: wireless: add brcm80211 drivers
Message-ID: <20120514083415.GA16999@mwanda> (sfid-20120514_103144_832842_DB5381C2)
References: <20120513174333.GB4280@elgon.mountain>
 <4FB0AF4B.9070606@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4FB0AF4B.9070606@broadcom.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 14, 2012 at 09:07:55AM +0200, Arend van Spriel wrote:
> Thanks for running smatch. I will look in the current code base and fix
> this. Just out of curiosity: Another static checker used regularly is
> Coccinelle. What are the pros and cons of smatch compared to Coccinelle?
> 
> Gr. AvS

That's a tricky question because of my obvious bias as the author
of Smatch, and I'm not an expert on Coccinelle.  ;)

Smatch works on the preprocessed code and Coccinelle works on .c
code.  So some things are easier to check for in Coccinelle.  I've
generally found hacks to get the information I need in Smatch but
sometimes it's gnarly.  So a one liner in Coccinelle is twenty lines
of code in Smatch which require in depth knowledge of Smatch and
Sparse.

Smatch doesn't fix the bugs it finds.

The other advantage for Coccinelle is that you can run it on other
architecture's code without setting up a cross compile environment.

What Smatch does that Coccinelle doesn't is that it tries to track
the values of all the variables.  This means you can detect array
overflows, for example.  Smatch tries to track values across
function calls as well, with the recent database work.

That's really the long term goal of Smatch, to track the value of
every variable in the kernel.  But there is still a lot of work to
do.  :P

regards,
dan carpenter
