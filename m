Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:52819 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751597AbdGUPIa (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 21 Jul 2017 11:08:30 -0400
Date: Fri, 21 Jul 2017 17:08:20 +0200
From: Greg KH <gregkh@linux.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Kalle Valo <kvalo@codeaurora.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        Birming Chiu <birming@realtek.com>, Pkshih <pkshih@realtek.com>
Subject: Re: New Realtek driver
Message-ID: <20170721150820.GC18198@kroah.com> (sfid-20170721_171204_601666_483DBD6A)
References: <50a63e7a-045a-3386-661a-5bfe077e5b0a@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <50a63e7a-045a-3386-661a-5bfe077e5b0a@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Jul 20, 2017 at 08:18:13PM -0500, Larry Finger wrote:
> Kalle and Greg,
> 
> Once again I find myself in the awkward position of needing to submit code
> to two different trees, i.e. wireless and staging.
> 
> The code in question concerns a new Realtek device, the RTL8822BE. The
> device is already shipping, and Realtek would like it to be available in
> kernel 3.14. As it consists of ~120,000 new lines of code, I have assured
> Realtek that 3.14 would not be possible, at least in the wireless tree. What
> I plan to do is submit the changes in the existing drivers through wireless,
> and the three totally new drivers through staging. My expectation is that
> this code would live for a relatively short time there, but going that route
> would give time for the code to be reviewed properly, but still be available
> in a kernel driver. All of the new code will be available in a GitHub repo
> maintained by Realtek for those users whose distros do not configure
> anything in staging.
> 
> For my part, I will push the wireless tree material as fast as I can and
> hope there is time available near the end of the 4.13-rcX sequence for the
> material to reach 4.14-rc1.

Why do you need a staging driver to have changes in the wireless tree?
Staging drivers should be self-contained and not rely on anything
outside of it in order to work properly (i.e. don't add code to the real
kernel only for a staging driver.)

thanks,

greg k-h
