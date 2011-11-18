Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61867 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753266Ab1KRAcI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Nov 2011 19:32:08 -0500
Received: by fagn18 with SMTP id n18so3728272fag.19
        for <linux-wireless@vger.kernel.org>; Thu, 17 Nov 2011 16:32:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <1321571145-23893-1-git-send-email-hauke@hauke-m.de>
References: <1321564991-7249-2-git-send-email-hauke@hauke-m.de> <1321571145-23893-1-git-send-email-hauke@hauke-m.de>
From: "Luis R. Rodriguez" <mcgrof@frijolero.org>
Date: Thu, 17 Nov 2011 16:31:46 -0800
Message-ID: <CAB=NE6V-e3+3wY+gCTtWBwzzotbEaG=N2dBASASX1qX0VGwAKg@mail.gmail.com> (sfid-20111118_013212_243639_F0A88329)
Subject: Re: [PATCH v2 2/3] compat: backport kfree_rcu()
To: Hauke Mehrtens <hauke@hauke-m.de>
Cc: linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 17, 2011 at 3:05 PM, Hauke Mehrtens <hauke@hauke-m.de> wrote:
> This adds a nested function everywhere kfree_rcu() was called. This
> function frees the memory and is given as a function to call_rcu().
> The kfree_rcu define was made by Johannes Berg.
> The rcu callback could happen every time also after the module was
> unloaded and this will cause problems.
> A rcu_barrier() was added into every module_exit so that this will not
> be called after the module was unloaded.
>
> The define overwriting module_exit is based on the original module_exit
> which looks like this:
> /* This is only required if you want to be unloadable. */
> /#define module_exit(exitfn)                                    \
>        static inline exitcall_t __exittest(void)               \
>        { return exitfn; }                                      \
>        void cleanup_module(void) __attribute__((alias(#exitfn)));
>
> We replaced the call to the actual function exitfn() with a call to our
> function which calls the original exitfn() and then rcu_barrier()
>
> As a module will not be unloaded that ofter it should not have a big
> performance impact when rcu_barrier() is called on every module exit,
> also when no kfree_rcu() backport is used in that module.
>
> Signed-off-by: Hauke Mehrtens <hauke@hauke-m.de>
> CC: Johannes Berg <johannes@sipsolutions.net>
> ---
> v2: remove compile check for exitfn
>    make function static

Wow, that's pretty fucking hairy, good stuff though, thanks! Applied and pushed!

  Luis
