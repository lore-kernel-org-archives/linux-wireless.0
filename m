Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wi0-f178.google.com ([209.85.212.178]:45490 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755877Ab2EARNr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 1 May 2012 13:13:47 -0400
Received: by wibhq7 with SMTP id hq7so3972871wib.1
        for <linux-wireless@vger.kernel.org>; Tue, 01 May 2012 10:13:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <4595B4D22AB93C4FABBA84AAD5AA37FD143115@ORSMSX103.amr.corp.intel.com>
References: <20120422182928.GA2854@ritirata.org>
	<20120430145803.GE2630@ritirata.org>
	<20120430170337.GA2560@tuxdriver.com>
	<4595B4D22AB93C4FABBA84AAD5AA37FD143115@ORSMSX103.amr.corp.intel.com>
Date: Tue, 1 May 2012 20:13:46 +0300
Message-ID: <CANUX_P1Nx4jYbRwehi+qW-2RVy=ntb_cCzBzpYXkJysuPvrCPA@mail.gmail.com> (sfid-20120501_191351_460970_9BEEABA5)
Subject: Re: iwlwifi warn_slowpath with 3.*
From: Emmanuel Grumbach <egrumbach@gmail.com>
To: "Venkataraman, Meenakshi" <meenakshi.venkataraman@intel.com>
Cc: "John W. Linville" <linville@tuxdriver.com>,
	Antonio Quartulli <ordex@autistici.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I am not sure the patch will help because the race is _very_ unlikely.
But I would be glad to know if you can reproduce on latest
compat-wireless.
How reproducible is that on 3.3.3 ? Is that 100% ?

I guess my machine doesn't have IOMMU, but honestly, I am not sure I
know how to check.

On Tue, May 1, 2012 at 19:52, Venkataraman, Meenakshi
<meenakshi.venkataraman@intel.com> wrote:
>
> Hi John, Antonio,
>
> Emmanuel found a race condition in rx buffer allocation/deallocation, and
> attached is a patch that fixes it.
>
> >> > since linux-3.0 (I don't remember if it was the case even before),
> >> > I'm getting this output in dmesg:
> >> >
> >> > [   53.662990] ------------[ cut here ]------------
> >> > [   53.663016] WARNING: at drivers/iommu/intel-iommu.c:2911
> >> > intel_unmap_page+0x14b/0x180()
> >> > [   53.663047] Hardware name: Latitude E5420
> >> > [   53.663066] Driver unmaps unmatched page at PFN ffd1a000
> >>
> >>
> >> I see that I always get the same addr passed to the unmap function:
> >>
> >> [   23.950535] Driver unmaps unmatched page at PFN ffd1a000
> >>
> >> is it a coincidence?
> >> I'm running linux-3.3.3 right now. I can try wireless-testing if it
> >> would help.
>
> [MV] Antonio -- can you try out the patch attached and let us know if you
> continue to see the problem?
>
> >Just for the record, we are seeing a similar problem on RHEL 6.3 (which
> > has an
> >iwlwifi driver derived from linux-3.2).
> >
> >       https://bugzilla.redhat.com/show_bug.cgi?id=815998
>
> [MV] John -- I'll update the redhat bugzilla as well.
>
> Thanks
> Meenakshi
