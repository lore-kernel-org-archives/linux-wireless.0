Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pg0-f42.google.com ([74.125.83.42]:45058 "EHLO
        mail-pg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751174AbeAVPFG (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 22 Jan 2018 10:05:06 -0500
Received: by mail-pg0-f42.google.com with SMTP id m136so348917pga.12
        for <linux-wireless@vger.kernel.org>; Mon, 22 Jan 2018 07:05:06 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <20180122144547.GA3375@kroah.com>
References: <001a11c14bc837f9760560a03d51@google.com> <20171219090121.GA10221@kroah.com>
 <CACT4Y+ZggKsEjCRZsFPW5-7_ByBcz4G0uRdieLL==r4mLQjhFA@mail.gmail.com>
 <CACT4Y+ZOimZPrSfphPMiHKXA3=kOmaFfwdofrmuv_rpXmx+vgA@mail.gmail.com>
 <CACT4Y+YMMfsXb+X4ApcWW02Qe7FmARhHjg97H4J-369OEMnwhw@mail.gmail.com>
 <20180122140015.GA30036@kroah.com> <CACT4Y+bEG22Wa6hiBQ6YX7d=JrHKAXfwYm+tu6cWc7AiUZxYbw@mail.gmail.com>
 <20180122144547.GA3375@kroah.com>
From: Dmitry Vyukov <dvyukov@google.com>
Date: Mon, 22 Jan 2018 16:04:45 +0100
Message-ID: <CACT4Y+Z7WTfxTBx1bhnZAo4bFzFcmKeYBvSALdF7vFiMcfB7OA@mail.gmail.com> (sfid-20180122_160531_636408_16F9C831)
Subject: Re: WARNING in sysfs_warn_dup
To: Greg KH <gregkh@linuxfoundation.org>
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
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 22, 2018 at 3:45 PM, Greg KH <gregkh@linuxfoundation.org> wrote=
:
> On Mon, Jan 22, 2018 at 03:30:12PM +0100, Dmitry Vyukov wrote:
>> On Mon, Jan 22, 2018 at 3:00 PM, Greg KH <gregkh@linuxfoundation.org> wr=
ote:
>> > On Mon, Jan 22, 2018 at 02:47:33PM +0100, Dmitry Vyukov wrote:
>> >> On Tue, Dec 19, 2017 at 10:06 AM, Dmitry Vyukov <dvyukov@google.com> =
wrote:
>> >> > On Tue, Dec 19, 2017 at 10:03 AM, Dmitry Vyukov <dvyukov@google.com=
> wrote:
>> >> >>
>> >> >> On Tue, Dec 19, 2017 at 10:01 AM, Greg KH <gregkh@linuxfoundation.=
org> wrote:
>> >> >>>
>> >> >>> On Mon, Dec 18, 2017 at 08:57:01AM -0800, syzbot wrote:
>> >> >>> > Hello,
>> >> >>> >
>> >> >>> > syzkaller hit the following crash on
>> >> >>> > 6084b576dca2e898f5c101baef151f7bfdbb606d
>> >> >>> > git://git.kernel.org/pub/scm/linux/kernel/git/next/linux-next.g=
it/master
>> >> >>> > compiler: gcc (GCC) 7.1.1 20170620
>> >> >>> > .config is attached
>> >> >>> > Raw console output is attached.
>> >> >>> >
>> >> >>> > Unfortunately, I don't have any reproducer for this bug yet.
>> >> >>> >
>> >> >>> >
>> >> >>> > netlink: 9 bytes leftover after parsing attributes in process
>> >> >>> > `syz-executor3'.
>> >> >>> > sg_write: data in/out 822404280/197 bytes for SCSI command 0x12=
-- guessing
>> >> >>> > data in;
>> >> >>> >    program syz-executor0 not setting count and/or reply_len pro=
perly
>> >> >>> > sg_write: data in/out 262364/161 bytes for SCSI command 0xff-- =
guessing data
>> >> >>> > in;
>> >> >>> >    program syz-executor0 not setting count and/or reply_len pro=
perly
>> >> >>> > WARNING: CPU: 1 PID: 22282 at fs/sysfs/dir.c:31 sysfs_warn_dup+=
0x60/0x80
>> >> >>> > fs/sysfs/dir.c:30
>> >> >>> > Kernel panic - not syncing: panic_on_warn set ...
>> >> >>>
>> >> >>> Looks like a networking issue, it tried to create two sysfs direc=
tories
>> >> >>> with the same name, which isn't a sysfs bug :)
>> >> >
>> >> >
>> >> > Now as plain text:
>> >> >
>> >> > +net/core/dev.c maintainers
>> >>
>> >>
>> >> Also happens for wiphy_register (on upstream
>> >> a8750ddca918032d6349adbf9a4b6555e7db20da):
>> >>
>> >> ------------[ cut here ]------------
>> >> sysfs: cannot create duplicate filename
>> >> '/class/ieee80211/=C5=A1=C2=A7"=C2=AD=C3=BBt{=C2=A7=C3=94=C2=AD=C3=B0=
=C3=B4 =C5=A0!=C3=97 =C5=BE 7=E2=80=A6 =C5=A0=E2=80=A0=C3=B5i=C3=B9S6 =C3=
=88< =C2=BB=C3=BE {_CK5=C3=A4=C3=A1   =C3=97=C3=9D=C3=8Am=C3=B4 Be'
>> >
>> > That's a wonderful filename :)
>> >
>> >> WARNING: CPU: 1 PID: 8233 at fs/sysfs/dir.c:31
>> >> sysfs_warn_dup+0x7e/0xa0 fs/sysfs/dir.c:30
>> >
>> > As this is just sysfs saying "Hey dummy, you are trying to do somethin=
g
>> > foolish here", what would be the better thing for it to do?
>> >
>> > Just printk(KERN_WARNING...) and then dump the stack?
>> >
>> > It seems the WARN_ON() that is currently being used is being treated a=
s
>> > an "error" by your testing, when really it isn't, unless the caller ca=
n
>> > not handle the error being passed back up to it by the sysfs core.
>> > Which it should, but I don't think you are even giving it the chance a=
s
>> > you are:
>> >
>> >> Kernel panic - not syncing: panic_on_warn set ...
>> >
>> > Yup, panic_on_warn :(
>> >
>> > ideas to make this easier for you?
>>
>>
>> pr_warn or pr_warn_once (optionally followed by dump_stack) would work
>> for syzbot.
>
> This shouldn't be a _once() call, as it is called by things all over the
> kernel, all with unique paths.
>
> I'll go make up a patch for this, thanks.

#syz fix: sysfs: turn WARN() into pr_warn()
