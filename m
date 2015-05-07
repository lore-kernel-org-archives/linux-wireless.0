Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:45838 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750755AbbEGOJD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 May 2015 10:09:03 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: "Gujulan Elango\, Hari Prasath \(H.\)" <hgujulan@visteon.com>,
	"devel\@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
	"gregkh\@linuxfoundation.org" <gregkh@linuxfoundation.org>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Larry.Finger\@lwfinger.net" <Larry.Finger@lwfinger.net>
Subject: Re: [PATCH] staging: rtl8723au : remove goto & return error directly
References: <20150507111652.GA10574@IND12F0122>
	<wrfjk2wkoarp.fsf@ultrasam.lan.trained-monkey.org>
	<20150507121934.GH14154@mwanda>
Date: Thu, 07 May 2015 10:08:51 -0400
In-Reply-To: <20150507121934.GH14154@mwanda> (Dan Carpenter's message of "Thu,
	7 May 2015 15:19:34 +0300")
Message-ID: <wrfj7fsko4y4.fsf@ultrasam.lan.trained-monkey.org> (sfid-20150507_160907_493989_9EC6FB96)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dan Carpenter <dan.carpenter@oracle.com> writes:
> On Thu, May 07, 2015 at 08:03:06AM -0400, Jes Sorensen wrote:
>> "Gujulan Elango, Hari Prasath (H.)" <hgujulan@visteon.com> writes:
>> > Remove the goto and return error directly thereby removing a variable
>> >
>> > Signed-off-by: Hari Prasath Gujulan Elango <hgujulan@visteon.com>
>> > ---
>> >  drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c | 7 ++-----
>> >  1 file changed, 2 insertions(+), 5 deletions(-)
>> 
>> NACK!
>
> SHOUTING!

It's normal to write NACK in upper case
>
>> 
>> The goto is cleaner and more consistent, rather than hiding a return in
>> the middle of the code.
>
> More consistent with what?  There are already returns earlier in the
> function.  Do-nothing gotos are pointless and annoying.

That is *your* preference!

Having returns scattered randomly throughout the code is annoying and
hard to catch when reading the code!

This case is *not* a bug, so it comes down to personal preference of the
maintainer. For code you maintain, feel free to do as you like, I will
*not* never bother you for this kind of preference issues, I will tell
you if I spot an actual bug.

This is one of the problems with checkpatch style tools, they have
become harassment tools, for some people to impose their personal
preferences onto others.

It would be so much more valuable if they just focused on real bugs!

Jes
