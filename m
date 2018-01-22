Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43302 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751107AbeAVOps (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 Jan 2018 09:45:48 -0500
Date: Mon, 22 Jan 2018 15:45:47 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Dmitry Vyukov <dvyukov@google.com>
Cc: syzbot
        <bot+1fdad4e2731bf0c1bc19953ccc5061237ec92783@syzkaller.appspotmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        syzkaller-bugs@googlegroups.com,
        David Miller <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Eric Dumazet <edumazet@google.com>,
        jakub.kicinski@netronome.com,
        Willem de Bruijn <willemb@google.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        John Fastabend <john.fastabend@gmail.com>,
        "Tobin C. Harding" <me@tobin.cc>, netdev <netdev@vger.kernel.org>,
        linux-wireless@vger.kernel.org
Subject: Re: WARNING in sysfs_warn_dup
Message-ID: <20180122144547.GA3375@kroah.com> (sfid-20180122_154609_643714_1D7266D4)
References: <001a11c14bc837f9760560a03d51@google.com>
 <20171219090121.GA10221@kroah.com>
 <CACT4Y+ZggKsEjCRZsFPW5-7_ByBcz4G0uRdieLL==r4mLQjhFA@mail.gmail.com>
 <CACT4Y+ZOimZPrSfphPMiHKXA3=kOmaFfwdofrmuv_rpXmx+vgA@mail.gmail.com>
 <CACT4Y+YMMfsXb+X4ApcWW02Qe7FmARhHjg97H4J-369OEMnwhw@mail.gmail.com>
 <20180122140015.GA30036@kroah.com>
 <CACT4Y+bEG22Wa6hiBQ6YX7d=JrHKAXfwYm+tu6cWc7AiUZxYbw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CACT4Y+bEG22Wa6hiBQ6YX7d=JrHKAXfwYm+tu6cWc7AiUZxYbw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 22, 2018 at 03:30:12PM +0100, Dmitry Vyukov wrote:
> On Mon, Jan 22, 2018 at 3:00 PM, Greg KH <gregkh@linuxfoundation.org> wrote:
> > On Mon, Jan 22, 2018 at 02:47:33PM +0100, Dmitry Vyukov wrote:
> >> On Tue, Dec 19, 2017 at 10:06 AM, Dmitry Vyukov <dvyukov@google.com> wrote:
> >> > On Tue, Dec 19, 2017 at 10:03 AM, Dmitry Vyukov <dvyukov@google.com> wrote:
> >> >>
> >> >> On Tue, Dec 19, 2017 at 10:01 AM, Greg KH <gregkh@linuxfoundation.org> wrote:
> >> >>>
> >> >>> On Mon, Dec 18, 2017 at 08:57:01AM -0800, syzbot wrote:
> >> >>> > Hello,
> >> >>> >
> >> >>> > syzkaller hit the following crash on
> >> >>> > 6084b576dca2e898f5c101baef151f7bfdbb606d
> >> >>> > git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.git/master
> >> >>> > compiler: gcc (GCC) 7.1.1 20170620
> >> >>> > .config is attached
> >> >>> > Raw console output is attached.
> >> >>> >
> >> >>> > Unfortunately, I don't have any reproducer for this bug yet.
> >> >>> >
> >> >>> >
> >> >>> > netlink: 9 bytes leftover after parsing attributes in process
> >> >>> > `syz-executor3'.
> >> >>> > sg_write: data in/out 822404280/197 bytes for SCSI command 0x12-- guessing
> >> >>> > data in;
> >> >>> >    program syz-executor0 not setting count and/or reply_len properly
> >> >>> > sg_write: data in/out 262364/161 bytes for SCSI command 0xff-- guessing data
> >> >>> > in;
> >> >>> >    program syz-executor0 not setting count and/or reply_len properly
> >> >>> > WARNING: CPU: 1 PID: 22282 at fs/sysfs/dir.c:31 sysfs_warn_dup+0x60/0x80
> >> >>> > fs/sysfs/dir.c:30
> >> >>> > Kernel panic - not syncing: panic_on_warn set ...
> >> >>>
> >> >>> Looks like a networking issue, it tried to create two sysfs directories
> >> >>> with the same name, which isn't a sysfs bug :)
> >> >
> >> >
> >> > Now as plain text:
> >> >
> >> > +net/core/dev.c maintainers
> >>
> >>
> >> Also happens for wiphy_register (on upstream
> >> a8750ddca918032d6349adbf9a4b6555e7db20da):
> >>
> >> ------------[ cut here ]------------
> >> sysfs: cannot create duplicate filename
> >> '/class/ieee80211/š§"­ût{§Ô­ðô Š!× ž 7… Š†õiùS6 È< »þ {_CK5äá   ×ÝÊmô Be'
> >
> > That's a wonderful filename :)
> >
> >> WARNING: CPU: 1 PID: 8233 at fs/sysfs/dir.c:31
> >> sysfs_warn_dup+0x7e/0xa0 fs/sysfs/dir.c:30
> >
> > As this is just sysfs saying "Hey dummy, you are trying to do something
> > foolish here", what would be the better thing for it to do?
> >
> > Just printk(KERN_WARNING...) and then dump the stack?
> >
> > It seems the WARN_ON() that is currently being used is being treated as
> > an "error" by your testing, when really it isn't, unless the caller can
> > not handle the error being passed back up to it by the sysfs core.
> > Which it should, but I don't think you are even giving it the chance as
> > you are:
> >
> >> Kernel panic - not syncing: panic_on_warn set ...
> >
> > Yup, panic_on_warn :(
> >
> > ideas to make this easier for you?
> 
> 
> pr_warn or pr_warn_once (optionally followed by dump_stack) would work
> for syzbot.

This shouldn't be a _once() call, as it is called by things all over the
kernel, all with unique paths.

I'll go make up a patch for this, thanks.

greg k-h
