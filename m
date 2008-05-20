Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.241]:22786 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752628AbYETIqW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 May 2008 04:46:22 -0400
Received: by an-out-0708.google.com with SMTP id d40so533434and.103
        for <linux-wireless@vger.kernel.org>; Tue, 20 May 2008 01:46:22 -0700 (PDT)
Message-ID: <43e72e890805200146t24e1978axce7c5851453301c@mail.gmail.com> (sfid-20080520_104627_109172_6CE1C77F)
Date: Tue, 20 May 2008 01:46:21 -0700
From: "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>
To: "Michael Bernhard" <michael.bernhard@bfh.ch>
Subject: Re: [PATCH 2/3 v2] compat-2.6: Add some missing functions and macros
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <12109470283444-git-send-email-michael.bernhard@bfh.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <12109457272730-git-send-email-michael.bernhard@bfh.ch>
	 <12109470283444-git-send-email-michael.bernhard@bfh.ch>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, May 16, 2008 at 7:10 AM, Michael Bernhard
<michael.bernhard@bfh.ch> wrote:

> diff --git a/compat/compat.h b/compat/compat.h
> index 4ae26ac..0d940ab 100644
> --- a/compat/compat.h
> +++ b/compat/compat.h
> @@ -30,6 +30,9 @@
>  #include <linux/init.h>
>  #include <linux/uaccess.h>
>
> +#include <linux/unaligned/access_ok.h>
> +#include <linux/unaligned/generic.h>
> +
>  #include <net/arp.h>
>  #include <net/neighbour.h>

This only solves the compatibility for x86 arch. I have handled the
porting of this by actually looking at all architectures and see how
they managed to support the new unaligned API. You can find these
changes here

http://tinyurl.com/5unrhz

Thanks for the patches though. I have pushed the required changes in.

  Luis
