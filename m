Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:33500 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756191Ab3EQOj6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 May 2013 10:39:58 -0400
Message-ID: <1368801590.18033.7.camel@jlt4.sipsolutions.net> (sfid-20130517_164002_360704_419DBF24)
Subject: Re: [PATCHv2 00/18] Add support for 5 and 10 MHz channels
From: Johannes Berg <johannes@sipsolutions.net>
To: Sam Leffler <sleffler@google.com>
Cc: Simon Wunderlich <simon.wunderlich@s2003.tu-chemnitz.de>,
	Adrian Chadd <adrian@freebsd.org>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Mathias Kretschmer <mathias.kretschmer@fokus.fraunhofer.de>,
	Simon Wunderlich <siwu@hrz.tu-chemnitz.de>
Date: Fri, 17 May 2013 16:39:50 +0200
In-Reply-To: <CA+yqC4bY_5Vd=B7nnmjEnDS+gJwD7fFZBkUCKEw0vb0aWucD5Q@mail.gmail.com> (sfid-20130517_163323_137467_9055ADBE)
References: <1368627549-22518-1-git-send-email-siwu@hrz.tu-chemnitz.de>
	 <CAJ-VmonrfSx6KLjNdPwtV_8q=Jmjz9KRSYmoLSXt7yocU=y35A@mail.gmail.com>
	 <20130516114028.GA27887@pandem0nium>
	 <CAJ-Vmo=39cS38UCDeQrdJ7x-t=cyr8cnsf3G2opxyeY3KzWLUg@mail.gmail.com>
	 <20130517095825.GA1555@pandem0nium>
	 <CA+yqC4bY_5Vd=B7nnmjEnDS+gJwD7fFZBkUCKEw0vb0aWucD5Q@mail.gmail.com>
	 (sfid-20130517_163323_137467_9055ADBE)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

[You need to stop using HTML, it will never make it to our list :-) ]


>         The rates are divided by two or
>         four (for 10 and 5 MHz), and rounded up. That's pretty much
>         the only
>         thing which is changed to 20 MHz.
> 
> 
> I rounded down; can't remember why; probably because that was what the
> PSB (Public Safety Band) spec said to do.

Which is the PSB spec? The current version of 802.11 (-2012) clearly
wants to round up:

8.4.2.3 Supported Rates element
...

        Within Beacon, Probe Response, Association Response,
        Reassociation Response, Mesh Peering Open, and Mesh Peering
        Confirm management frames, each Supported Rate contained in the
        BSSBasicRateSet parameter is encoded as an octet with the MSB
        (bit 7) set to 1, and bits 6 to 0 are set to the data rate, if
        necessary rounded up to the next 500kb/s, in units of 500 kb/s.
        For example, a 2.25 Mb/s rate contained in the BSSBasicRateSet
        parameter is encoded as X'85'.

johannes


