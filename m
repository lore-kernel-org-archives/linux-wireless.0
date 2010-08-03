Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:58092 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751377Ab0HCCbZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Aug 2010 22:31:25 -0400
Received: by gwb20 with SMTP id 20so1462211gwb.19
        for <linux-wireless@vger.kernel.org>; Mon, 02 Aug 2010 19:31:24 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4C577DB3.4050902@gmail.com>
References: <1280799971-7091-1-git-send-email-justinmattock@gmail.com>
	<AANLkTimmiraT1wV_=zxUmfKPz7D78uOdY4s67pVXOntA@mail.gmail.com>
	<4C577DB3.4050902@gmail.com>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Tue, 3 Aug 2010 12:31:04 +1000
Message-ID: <AANLkTi=ZEKts2eW8KjvkNN0h5ogPkEwjfjbMYHjcjx+s@mail.gmail.com>
Subject: Re: [PATCH v3]hostap:hostap_ioctl.c Fix variable 'ret' set but not
	used
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: linux-wireless@vger.kernel.org, j@w1.fi, linville@tuxdriver.com,
	mcgrof@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 3, 2010 at 12:23, Justin P. Mattock <justinmattock@gmail.com> wrote:
> wait im lost.. looking at your patch looks the same(number wise) except I
> see different parts of code in there:
>
> hostap_set_word(dev, HFA384X_RID_CNFROAMINGMODE,
>                                HFA384X_ROAMING_FIRMWARE);
>
> -       return 0;
> +       return ret;
>
>
>
> mine is:
>
> printk(KERN_DEBUG "SCANREQUEST failed\n");
> -               ret = -EINVAL;
> +               return ret;
>
>
> The tree Im using is Linus's tree.

I'm using wireless-testing, and the line you're changing is #1692, I'm
changing #1699.

Thanks,

-- 

Julian Calaby

Email: julian.calaby@gmail.com
.Plan: http://sites.google.com/site/juliancalaby/
