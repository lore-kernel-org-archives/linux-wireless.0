Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:35958 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751434AbdJLKen (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 12 Oct 2017 06:34:43 -0400
Date: Thu, 12 Oct 2017 12:34:50 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Kalle Valo <kvalo@codeaurora.org>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Ping-Ke Shih <pkshih@realtek.com>,
        Yan-Hsuan Chuang <yhchuang@realtek.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Souptick Joarder <jrdr.linux@gmail.com>,
        devel@driverdev.osuosl.org, linux-wireless@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: Two rtlwifi drivers?
Message-ID: <20171012103450.GA24647@kroah.com> (sfid-20171012_123508_276300_F8D9FA56)
References: <20170824100832.lcmbwcjhzwlgozeh@mwanda>
 <87h8wxw4bq.fsf@kamboji.qca.qualcomm.com>
 <652d42ad-a077-530b-743f-d38ddf3ff677@lwfinger.net>
 <87k202qcjr.fsf@kamboji.qca.qualcomm.com>
 <20171011131310.GF32250@kroah.com>
 <87h8v4pxqp.fsf@kamboji.qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <87h8v4pxqp.fsf@kamboji.qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Oct 12, 2017 at 11:38:06AM +0300, Kalle Valo wrote:
> > So what to do?  Any ideas?  What makes your life easier?  You can just
> > ignore the staging tree, as it should not affect your portion of the
> > kernel at all, right?
> 
> Yes, I automatically ignore anything staging related. But the problem is
> that we now have two drivers with the same name and people don't always
> remember to prefix the patch with "staging: ". So on a bad day I might
> accidentally apply a patch which was meant for your tree. Of course I
> immediately revert it as soon as I, or someone else, catches that but
> annoying still.

It doesn't bother me if you apply staging patches, I can handle the
merge issues :)

> I think we have two options here:
> 
> 1) We set a deadline (like 12 months or something) for the
>    drivers/staging/rtlwifi and after that you refuse to take any patches
>    for it. Hopefully this makes it clear for everyone that this fork is
>    just temporary. I think Larry is trying to do this, which is great.

Fine with me, if Larry is ok with it.

> 2) We move the whole rtlwifi driver to staging. A very bad option but
>    still better than forking the drivers.

Ick, I don't want that to have to happen, that would not be good for the
users of other devices that the "real" rtlwifi driver supports.

thanks,

greg k-h
