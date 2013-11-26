Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-oa0-f52.google.com ([209.85.219.52]:44985 "EHLO
	mail-oa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753917Ab3KZJVu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 26 Nov 2013 04:21:50 -0500
Received: by mail-oa0-f52.google.com with SMTP id h16so5665106oag.39
        for <linux-wireless@vger.kernel.org>; Tue, 26 Nov 2013 01:21:49 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <CAMJBoFNRW98z1yepDDWdhi3K5VXF+QeO7yTCLy3wx4Uocgz+9A@mail.gmail.com>
References: <loom.20131118T143002-687@post.gmane.org>
	<1385396191.4443.44.camel@jlt4.sipsolutions.net>
	<1385399816.8710.16.camel@dcbw.foobar.com>
	<1385404573.4443.58.camel@jlt4.sipsolutions.net>
	<1385410695.26827.4.camel@dcbw.foobar.com>
	<CABo8O+fRPk0GJxw-UA4wD-8fcoNF-Zqt-_DjoALpm91Oz95ZaA@mail.gmail.com>
	<CAMJBoFNRW98z1yepDDWdhi3K5VXF+QeO7yTCLy3wx4Uocgz+9A@mail.gmail.com>
Date: Tue, 26 Nov 2013 10:21:49 +0100
Message-ID: <CABo8O+eriYPqut3c1Nv-WmpAmD8oZ8ZJUiZk-UGWeg0CmG-UPw@mail.gmail.com> (sfid-20131126_102158_583184_DC24375C)
Subject: Re: Roaming with libertas and wpa_supplicant not working
From: Troels Nilsson <nilsson.troels@gmail.com>
To: Vitaly Wool <vitalywool@gmail.com>
Cc: Dan Williams <dcbw@redhat.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

>> > > > > > Hi,
>> > > > > >
>> > > > > > We are having a problem with a custom device which uses the
>> > > > > > libertas wifi
>> > > > > > driver (on kernel 3.4.24) together with wpa_supplicant (0.7.3).
>> > > > > > More
>> > > > > > specifically, whenever wpa_supplicant attempts to roam to a
>> > > > > > different access
>> > > > > > point it gets a EALREADY error.
>
> May I ask why you use *that* old wpa_supplicant?
>
Our user-space is Ubuntu 12.04 (plus some of our own bits), which uses
that version. Do you think this is fixed in a newer version of
wpa_supplicant?

>> > > > > >
>> > > > > > I have tracked down the problem to this check in sme.c:
>> > > > > >
>> > > > > >         if (wdev->sme_state != CFG80211_SME_IDLE)
>> > > > > >                 return -EALREADY;
>> > > > >
>> > > > > This no longer exists - please try a newer kernel.
>> Yes, I saw that it was removed/rewritten in 3.11. However, that is
>> quite a jump in kernel versions for us at this point, so we will
>> probably prefer to patch the 3.4 series.
>>
>
> I would suggest using backports (formerly known as compat-wireless) in that
> case.
That could be a solution as well, thanks for the suggestion.
