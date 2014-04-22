Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-la0-f46.google.com ([209.85.215.46]:51598 "EHLO
	mail-la0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757214AbaDVReH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Apr 2014 13:34:07 -0400
Received: by mail-la0-f46.google.com with SMTP id hr17so4578849lab.19
        for <linux-wireless@vger.kernel.org>; Tue, 22 Apr 2014 10:34:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <1397645621-32447-1-git-send-email-janusz.dziedzic@tieto.com>
References: <1397645621-32447-1-git-send-email-janusz.dziedzic@tieto.com>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Tue, 22 Apr 2014 10:33:46 -0700
Message-ID: <CAB=NE6VNHBrk+HWGLZxNOBFXsGv6XLQus8zTx-AP2Ye6jbgnPA@mail.gmail.com> (sfid-20140422_193416_747224_9CFE3BE6)
Subject: Re: [PATCH] cfg80211: reg: track crda request
To: Janusz Dziedzic <janusz.dziedzic@tieto.com>,
	Sander Eikelenboom <linux@eikelenboom.it>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 16, 2014 at 3:53 AM, Janusz Dziedzic
<janusz.dziedzic@tieto.com> wrote:
>
>  static void reg_timeout_work(struct work_struct *work)
>  {
> -       REG_DBG_PRINT("Timeout while waiting for CRDA to reply, restoring regulatory settings\n");
> +       struct regulatory_request *lr;
> +
>         rtnl_lock();
> -       restore_regulatory_settings(true);
> +
> +       lr = get_last_request();
> +       REG_DBG_PRINT("Timeout while waiting for CRDA to reply %s request, restoring regulatory settings\n",
> +                     reg_initiator_name(lr->initiator));
> +
> +       switch (lr->initiator) {
> +       case NL80211_REGDOM_SET_BY_CORE:
> +       case NL80211_REGDOM_SET_BY_DRIVER:
> +               /* Call CRDA again for last request */
> +               reg_process_hint(lr);
> +               break;
> +       case NL80211_REGDOM_SET_BY_USER:
> +               restore_regulatory_settings(true);
> +               break;
> +       case NL80211_REGDOM_SET_BY_COUNTRY_IE:
> +               restore_regulatory_settings(false);
> +               break;
> +       default:
> +               WARN_ON(1);
> +               break;
> +       }
>         rtnl_unlock();
>  }

Janusz,

As is, we don't ever bail out and could end up triggering CRDA to be
called every ~3 seconds with this patch. This is why I had added the
opportunistic triggers, which are technically still in place today but
there are only a few entries for those to kick off: beacon hints on 5
GHz for cards that enable beacon hints. I don't think its a good idea
we have a a recurring timer trigger for this. I think we need to
consider a time at which we should give up on CRDA being present and
instead rely on userspace to let us know its ready (ideally userspace
would do something with inotify on the path) so we can kick the queue
again.

Thoughts?

  Luis
