Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.190]:16742 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753951AbZCQWDp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Mar 2009 18:03:45 -0400
Received: by nf-out-0910.google.com with SMTP id d21so46194nfb.21
        for <linux-wireless@vger.kernel.org>; Tue, 17 Mar 2009 15:03:42 -0700 (PDT)
From: Ivo van Doorn <ivdoorn@gmail.com>
To: Antonio Marques <froz@icix.org>
Subject: Re: rt2x00 mesh support
Date: Tue, 17 Mar 2009 23:03:39 +0100
Cc: Andrey Yurovsky <andrey@cozybit.com>,
	linux-wireless@vger.kernel.org
References: <E8FC0565-5438-4AB5-A004-CD31DD9C1AA3@icix.org> <200903171031.41302.IvDoorn@gmail.com> <58D3A916-8548-4DEC-BEC6-09AFE4CEBCBD@icix.org>
In-Reply-To: <58D3A916-8548-4DEC-BEC6-09AFE4CEBCBD@icix.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Message-Id: <200903172303.40046.IvDoorn@gmail.com> (sfid-20090317_230349_555025_0E1FF310)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 17 March 2009, Antonio Marques wrote:
> On Mar 17, 2009, at 9:31 , Ivo van Doorn wrote:
> > On Monday 16 March 2009, Antonio Marques wrote:
> >> On Mar 16, 2009, at 14:58 , Ivo van Doorn wrote:
> >>> On Monday 16 March 2009, Ant=F3nio Marques wrote:
> >>>>
> >>>> As requested, I have attached the output of the script run befor=
e =20
> >>>> and
> >>>> after
> >>>> running 'iwlist mesh scan'. Unfortunately there seems to be no
> >>>> change in
> >>>> the output. I have also included the queue statistics as these d=
o
> >>>> change from
> >>>> one state to the next. Any further pointers to help debug this? =
=20
> >>>> I'll
> >>>> gladly test
> >>>> any patches that try to address this issue.
> >>>
> >>> The dumps aren't correct, I had forgotten to update the script on
> >>> the website
> >>> after some API for the rt2x00 debugfs interface changes recently.
> >>> Attached is the correct patch.
> >>>
> >>> Ivo
> >>> <rt2x00_regdump.sh>
> >>
> >> Fixed, new dumps are attached.
> >
> > Thanks for the dumps, the reason why the beaconing isn't working
> > is (fortunately) very obvious from the registers point of view.
> > The "generate beacons" bit is simply not enabled. However the reaso=
n
> > why this bit has not been set escapes me. Could you apply the attac=
hed
> > patch? This will add extra debug messages to the driver to see when=
 =20
> > the
> > beacon generation bit is set.
> >
> > Thanks,
> >
> > Ivo
> > <rt73usb.beacon.diff>
>=20
> Here are the relevant portions of the dmesg with the aforementioned
> patch applied.
>=20
> After interface creation and before 'iwlist mesh scan':

<...snip...>

> Hope this is useful.

It absolutely is :)

Thanks,

Ivo
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
