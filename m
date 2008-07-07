Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.182]:31663 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757232AbYGGVjg (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 7 Jul 2008 17:39:36 -0400
Received: by wa-out-1112.google.com with SMTP id j37so1469442waf.23
        for <linux-wireless@vger.kernel.org>; Mon, 07 Jul 2008 14:39:34 -0700 (PDT)
Message-ID: <1ba2fa240807071439n666abcd8od31bd51dd927dfa1@mail.gmail.com> (sfid-20080707_233956_210260_4FA29ACE)
Date: Tue, 8 Jul 2008 00:39:34 +0300
From: "Tomas Winkler" <tomasw@gmail.com>
To: "Andrew Lutomirski" <andy@luto.us>
Subject: Re: [BUG] iwl4965: huge latency and errors when unblocking the hardware rfkill
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <cb0375e10807071156x26df8332j4b167e8cc9bb289@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
References: <cb0375e10807071156x26df8332j4b167e8cc9bb289@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jul 7, 2008 at 9:56 PM, Andrew Lutomirski <andy@luto.us> wrote:
> This is wireless-testing c80200cd38c265da90f0d9d031ace84aa56b0453, pulled today.
>
> I have a Lenovo X61s with a physical rfkill switch (the kind that
> slides between blocked and unblocked).
>
> If I turn off the hardware rfkill switch (set to block) while
> associated, I lose the connection (obviously).  If I turn it back on
> again (set to unblock), I get a lot of latency (my mouse stops moving
> for a second or two) and I sometimes get errors in the syslog like
> this:
>
> iwl4965: Error sending REPLY_CT_KILL_CONFIG_CMD: time out after 500ms.
>
> The card fails to associate afterwards.  If I tell network-manager to
> turn off wireless, then block rfkill, then wait a few seconds, then
> unblock it, then turn nm back on, everything works again.
>
> This seems like at least two different bugs:
>
>  - iwl4965 causes latency.  This latency issue has been reproducible
> every time for me on 2.6.24-ubuntu_something, 2.5.25, wireless-compat
> (recent), and current wireless-testing.
>  - iwl4965 doesn't work right after hard unblocking rfkill.
>
> I'm happy to do further troubleshooting and/or test patches.
>
> --Andy
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
We have few RF kill fixes, just need to rebase them again after latest
Henrique's patches. Hope to post them in next days.
Thanks
Tomas
