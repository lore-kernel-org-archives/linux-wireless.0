Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qg0-f50.google.com ([209.85.192.50]:36396 "EHLO
	mail-qg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751302AbcA3Gxy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Jan 2016 01:53:54 -0500
MIME-Version: 1.0
In-Reply-To: <1454123891.10099.89.camel@perches.com>
References: <20160129172908.GA14077@Karyakshetra> <wrfjk2ms465z.fsf@redhat.com>
 <CAGRGNgWQvdfQc-L9z0NKCyCOorxU0seQ-XvYnZDBWA3QKySrRA@mail.gmail.com>
 <1454117303.10099.84.camel@perches.com> <CAGRGNgU2EuY9fpe8rhHtA8OLDRC0s5=tcBStqpq=ZbMNrnuf0w@mail.gmail.com>
 <1454123891.10099.89.camel@perches.com>
From: Bhakti Priya <bhaktipriya96@gmail.com>
Date: Sat, 30 Jan 2016 12:23:14 +0530
Message-ID: <CAFNHFT9nosMWgAvDdhvpMQLa2+02kD-wk0ChuZWpvCbLGMFYOg@mail.gmail.com> (sfid-20160130_075432_832592_405CFB9D)
Subject: Re: [PATCH] staging: rtl8723au: Fixes unnecessary return warning
To: Joe Perches <joe@perches.com>
Cc: Julian Calaby <julian.calaby@gmail.com>,
	Jes Sorensen <Jes.Sorensen@redhat.com>,
	Larry Finger <Larry.Finger@lwfinger.net>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Alexander Kuleshov <kuleshovmail@gmail.com>,
	Haneen Mohammed <hamohammed.sa@gmail.com>,
	Andreas Ruprecht <andreas.ruprecht@fau.de>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Thank you for your reply. I've just sent version 2 of the patch with
the blank lines removed.
I will be happy to extend checkpatch.pl. As suggested by you, I am
trying to detect such blank lines in a line removal patch by checking
if the line above the deleted line was a blank line and the line
following the deleted line had a closing brace.
Can you please guide me and let me know if I am headed in the right direction.

Thanks,
Bhaktipriya


On Sat, Jan 30, 2016 at 8:48 AM, Joe Perches <joe@perches.com> wrote:
> On Sat, 2016-01-30 at 14:09 +1100, Julian Calaby wrote:
>> Hi Joe,
>
> Hello Julian.
>
>> On Sat, Jan 30, 2016 at 12:28 PM, Joe Perches <joe@perches.com>
>> wrote:
>> > On Sat, 2016-01-30 at 10:17 +1100, Julian Calaby wrote:
>> > > On Sat, Jan 30, 2016 at 5:00 AM, Jes Sorensen <Jes.Sorensen@redha
>> > > t.com> wrote:
>> > > > Bhaktipriya Shridhar <bhaktipriya96@gmail.com> writes:
>> > > > > This patch fixes checkpatch.pl warning in rtw_mlme_ext.c
>> > > > > file.
>> > > > > WARNING: void function return statements are not generally
>> > > > > useful
>> > []
>> > > > > diff --git a/drivers/staging/rtl8723au/core/rtw_mlme_ext.c
>> > > > > b/drivers/staging/rtl8723au/core/rtw_mlme_ext.c
>> > []
>> > > > > @@ -2657,7 +2657,6 @@ static void issue_probersp(struct
>> > > > > rtw_adapter *padapter, unsigned char *da)
>> > > > >
>> > > > >       dump_mgntframe23a(padapter, pmgntframe);
>> > > > >
>> > > > > -     return;
>> > > > >  }
>> > > >
>> > > > If you insist on pushing this rather unncessary change, please
>> > > > do it
>> > > > properly, and remove the blank line before the return statement
>> > > > as well.
>> > >
>> > > As Jes said, you need to remove the blank lines before the
>> > > returns
>> > > too. checkpatch should have picked this up, you did run the patch
>> > > through checkpatch before you sent it, right?
>> >
>> > checkpatch doesn't pick this up.
>> >
>> > If you'd like to make it do so, you're welcome to try
>> > but it's likely a bit more complicated than it appears.
>>
>> I meant the extra blank lines, not the useless return statements.
>
> I understood what you meant.
>
> It's relatively difficult to determine that a line removal
> patch causes a blank line to appear before a closing brace.
>
> You're welcome to extend checkpatch to find these things,
> but there are likely many additional patch types that need
> to be considered.  Remember patches can add, modify and
> delete lines.
>
> cheers, Joe
