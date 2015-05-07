Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46426 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751314AbbEGOKL (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 7 May 2015 10:10:11 -0400
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: "Gujulan Elango\, Hari Prasath \(H.\)" <hgujulan@visteon.com>
Cc: Dan Carpenter <dan.carpenter@oracle.com>,
	"devel\@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
	"gregkh\@linuxfoundation.org" <gregkh@linuxfoundation.org>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"Larry.Finger\@lwfinger.net" <Larry.Finger@lwfinger.net>,
	"Babu\, Viswanathan \(V.\)" <vbabu3@visteon.com>
Subject: Re: [PATCH] staging: rtl8723au : remove goto & return error directly
References: <20150507111652.GA10574@IND12F0122>
	<wrfjk2wkoarp.fsf@ultrasam.lan.trained-monkey.org>
	<20150507121934.GH14154@mwanda> <20150507134344.GA11599@IND12F0122>
Date: Thu, 07 May 2015 10:09:59 -0400
In-Reply-To: <20150507134344.GA11599@IND12F0122> (Gujulan Elango's message of
	"Thu, 7 May 2015 13:49:07 +0000")
Message-ID: <wrfj3838o4w8.fsf@ultrasam.lan.trained-monkey.org> (sfid-20150507_161027_363298_38D1727B)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Gujulan Elango, Hari Prasath (H.)" <hgujulan@visteon.com> writes:
> On Thu, May 07, 2015 at 03:19:34PM +0300, Dan Carpenter wrote:
>> On Thu, May 07, 2015 at 08:03:06AM -0400, Jes Sorensen wrote:
>> > "Gujulan Elango, Hari Prasath (H.)" <hgujulan@visteon.com> writes:
>> > > Remove the goto and return error directly thereby removing a variable
>> > >
>> > > Signed-off-by: Hari Prasath Gujulan Elango <hgujulan@visteon.com>
>> > > ---
>> > >  drivers/staging/rtl8723au/os_dep/ioctl_cfg80211.c | 7 ++-----
>> > >  1 file changed, 2 insertions(+), 5 deletions(-)
>> > 
>> > NACK!
>> 
>> SHOUTING!
>> 
>> > 
>> > The goto is cleaner and more consistent, rather than hiding a return in
>> > the middle of the code.
>> 
>> More consistent with what?  There are already returns earlier in the
>> function.  Do-nothing gotos are pointless and annoying.
>> 
>> regards,
>> dan carpenter
>> 
>
> I sent this patch  because goto & return was mixed up in this function.
> There was a return as well as goto used. And i guess goto is not 
> encouraged anywhere. In this case especially,I couldn't see any 
> significant cleanup being done in the goto label.

I will accept a patch to remove the returns in the middle of the
function, if you wish to submit that.

A return at the very beginning of a function is OK, but in the middle of
a larger function they make it harder to catch when code exists.

Jes
