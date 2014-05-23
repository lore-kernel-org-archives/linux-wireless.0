Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from dedo.coelho.fi ([88.198.205.34]:44063 "EHLO dedo.coelho.fi"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751439AbaEWJOy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 May 2014 05:14:54 -0400
Message-ID: <1400836483.25946.37.camel@dubbel> (sfid-20140523_111458_795792_DA32F73F)
From: Luca Coelho <luca@coelho.fi>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Michal Kazior <michal.kazior@tieto.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Date: Fri, 23 May 2014 12:14:43 +0300
In-Reply-To: <1400835498.4358.9.camel@jlt4.sipsolutions.net>
References: <1400769938.4174.29.camel@jlt4.sipsolutions.net>
	 <1400812703-15685-1-git-send-email-luca@coelho.fi>
	 <CA+BoTQkof_e_T=xegftVHdKK_XFeb2HegOQWmV5+PkCdLkzEyg@mail.gmail.com>
	 (sfid-20140523_100116_761277_D988CC7D) <1400835498.4358.9.camel@jlt4.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [PATCH] mac80211: add a single-transaction driver op to switch
 contexts
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2014-05-23 at 10:58 +0200, Johannes Berg wrote:
> On Fri, 2014-05-23 at 10:01 +0200, Michal Kazior wrote:
> 
> > So.. which patch are we going forward with? Luca's or mine? Either way
> > is fine with me as long as we reach a conclusion :-)
> 
> Looks like both are missing some things? Luca's doesn't have tracing,
> and supports just a single interface (which you'll not like :) ) but
> personally I liked the struct API a bit better than multiple double
> pointer arrays you had.

What do you mean mine doesn't support tracing? Check the bottom of the
patch again. :) I don't think it's the most beautiful code, but it seems
to work. :)

Also, my patch *does* support multiple vifs.  But the code we have
doesn't support it, so I call the new op with a single-vif only.
Michal's patch doesn't call the new op (only on a later patch), so it's
pretty much the same.

--
Luca.

