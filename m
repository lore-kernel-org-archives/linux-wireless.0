Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qw0-f46.google.com ([209.85.216.46]:32838 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755298Ab2BFPwv (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Feb 2012 10:52:51 -0500
Received: by qadc10 with SMTP id c10so2144827qad.19
        for <linux-wireless@vger.kernel.org>; Mon, 06 Feb 2012 07:52:50 -0800 (PST)
Message-ID: <4F2FF742.5070309@gmail.com> (sfid-20120206_165254_871024_8D6546F3)
Date: Mon, 06 Feb 2012 10:52:34 -0500
From: Richard Farina <sidhayn@gmail.com>
MIME-Version: 1.0
To: mcgrof@gmail.com
CC: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] Calling make directly is not permitted
References: <1328542694-20777-1-git-send-email-sidhayn@gmail.com>
In-Reply-To: <1328542694-20777-1-git-send-email-sidhayn@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/06/12 10:38, Rick Farina wrote:

I apologize, both this patch and my "add missing =y" patch should have
had compat-wireless in the subject line. I'm still learning to use git
send-email.

Anyone want to tell me how to make git stop add myself to the cc just
because the SOB line is in the commit message? Am I supposed to add the
SOB some other way?

Thanks!

-Rick
> make was being called directly, fix to $(MAKE)
>
> Signed-of-By: Rick Farina <sidhayn@gmail.com>
> ---
>  Makefile |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/Makefile b/Makefile
> index d586f45..440bd91 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -115,7 +115,7 @@ btuninstall:
>  	@echo
>  
>  btclean:
> -	make -C /lib/modules/$(shell uname -r)/build M=$(PWD) BT=TRUE clean
> +	$(MAKE) -C /lib/modules/$(shell uname -r)/build M=$(PWD) BT=TRUE clean
>  	@rm -f $(CREL_PRE)*
>  
>  install: uninstall install-modules install-scripts

