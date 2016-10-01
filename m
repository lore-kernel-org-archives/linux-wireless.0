Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0088.hostedemail.com ([216.40.44.88]:34096 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1750839AbcJAUBC (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 1 Oct 2016 16:01:02 -0400
Message-ID: <1475352058.1996.1.camel@perches.com> (sfid-20161001_220219_126529_30E473B6)
Subject: Re: [PATCH] realtek: rtl8xxxu: Use const init arrays
From: Joe Perches <joe@perches.com>
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: Kalle Valo <kvalo@codeaurora.org>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Sat, 01 Oct 2016 13:00:58 -0700
In-Reply-To: <wrfj37kf6gvd.fsf@redhat.com>
References: <459bf15427d92cd052fb2fe080438fd97a8a6cd8.1475343483.git.joe@perches.com>
         <wrfj37kf6gvd.fsf@redhat.com>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2016-10-01 at 14:53 -0400, Jes Sorensen wrote:
> Joe Perches <joe@perches.com> writes:
> > Make the init arrays const to reduce data.
> > $ size drivers/net/wireless/realtek/rtl8xxxu/built-in.o* (allyesconfig: x86-32)
> >    text	   data	    bss	    dec	    hex	filename
> >   80107	  13651	     58	  93816	  16e78	drivers/net/wireless/realtek/rtl8xxxu/built-in.o.new
> >   65303	  28435	     58	  93796	  16e64	drivers/net/wireless/realtek/rtl8xxxu/built-in.o.old
> In total you grow the kernel by 20 bytes. You reduce the data segment
> substantially while growing the text segment instead.

No, not really.   The alignment boundaries move a bit for
this particular compilation.  It could go the other way for
a different compiler version or set of CONFIG options.

What's important is multiple pages of .data move to .rodata.
