Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:48652 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752951AbaFXL7V (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jun 2014 07:59:21 -0400
Message-ID: <1403611146.10831.1.camel@jlt4.sipsolutions.net> (sfid-20140624_135923_974502_4BA5C475)
Subject: Re: [PATCH v10 1/5] mac80211: implement multi-vif in-place
 reservations
From: Johannes Berg <johannes@sipsolutions.net>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Luca Coelho <luca@coelho.fi>
Date: Tue, 24 Jun 2014 13:59:06 +0200
In-Reply-To: <CA+BoTQkNKQq2vQ1OY9jt9S4uvgWGuSn9NvwjTfZZOYMxB3_1QQ@mail.gmail.com> (sfid-20140624_135524_109890_341E226D)
References: <1402577680-17888-1-git-send-email-michal.kazior@tieto.com>
	 <1403009938-1084-1-git-send-email-michal.kazior@tieto.com>
	 <1403009938-1084-2-git-send-email-michal.kazior@tieto.com>
	 <1403528633.4418.27.camel@jlt4.sipsolutions.net>
	 <CA+BoTQkNKQq2vQ1OY9jt9S4uvgWGuSn9NvwjTfZZOYMxB3_1QQ@mail.gmail.com>
	 (sfid-20140624_135524_109890_341E226D)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2014-06-24 at 13:55 +0200, Michal Kazior wrote:

> >> +                     if (WARN_ON(!ctx->replace_ctx))
> >> +                             return -EINVAL;
> >
> > This also leaks "vif_chsw".
> 
> This should be a `goto` too.

This was the first thing I'd actually looked at, and there's currently
no label that frees vif_chsw :)

> I'll re-spin once I fix all the problems that I'm aware of now.

Thanks.

johannes

