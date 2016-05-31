Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44703 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755489AbcEaSYC (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 31 May 2016 14:24:02 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Daniel Lenski <dlenski@gmail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH] rtl8xxxu: increase polling timeout for firmware startup
References: <1463594249-19524-1-git-send-email-dlenski@gmail.com>
	<wrfjinyayf2i.fsf@redhat.com> <wrfjwpmagtgd.fsf@redhat.com>
	<CAOw_LSEHTM47ro=W_DBWSpX1SJ9YR+EvJQ+6qja-XvHH1JToiQ@mail.gmail.com>
Date: Tue, 31 May 2016 14:24:00 -0400
In-Reply-To: <CAOw_LSEHTM47ro=W_DBWSpX1SJ9YR+EvJQ+6qja-XvHH1JToiQ@mail.gmail.com>
	(Daniel Lenski's message of "Tue, 31 May 2016 10:59:27 -0700")
Message-ID: <wrfjinxudr27.fsf@redhat.com> (sfid-20160531_202425_489240_4E599E45)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Daniel Lenski <dlenski@gmail.com> writes:
> On Tue, May 31, 2016 at 8:04 AM, Jes Sorensen <Jes.Sorensen@redhat.com> wrote:
>> Given your follow-on discoveries, do you still want me to apply the poll
>> timeout patch, or should we wait until we nail down the reset code issue
>> first?
>
> No, I don't think the timeout patch is worth appying. I believe it
> was just dumb luck that it worked when I initially tested it,
> because I did not understand how to reproducibly generate the
> incomplete-reset condition then.
>
> One the other hand, the power-cycle-and-retry approach has been 100%
> reliable for me. It has never failed to bring up the device in the
> last 8-10 days and probably a few dozen reboots.
>
> The patch for this could be applied as-is and I expect it will fix the
> issue for other users who've reported it, though I understand that
> you're interested in identifying the root cause issue with the reset
> sequence as well.

Thanks for the update!

I would like if you could try to break down the power_off sequence of
code to try to figure out exactly what part of it does the trick.

Maybe try if this sequence does the trick first:

        /* Reset MCU IO Wrapper */
        val8 = rtl8xxxu_read8(priv, REG_RSV_CTRL + 1);
        val8 &= ~BIT(0);
        rtl8xxxu_write8(priv, REG_RSV_CTRL + 1, val8);

        val8 = rtl8xxxu_read8(priv, REG_RSV_CTRL + 1);
        val8 |= BIT(0);
        rtl8xxxu_write8(priv, REG_RSV_CTRL + 1, val8);

        /* RSV_CTRL 0x1C[7:0] = 0x0e  lock ISO/CLK/Power control register */
        rtl8xxxu_write8(priv, REG_RSV_CTRL, 0x0e);

If that doesn't do it, try to call rtl8xxxu_emu_to_disabled() instead;

Cheers,
Jes
