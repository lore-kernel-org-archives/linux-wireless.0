Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mu-out-0910.google.com ([209.85.134.185]:64761 "EHLO
	mu-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751850AbZCLX6g (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2009 19:58:36 -0400
Received: by mu-out-0910.google.com with SMTP id i10so798232mue.1
        for <linux-wireless@vger.kernel.org>; Thu, 12 Mar 2009 16:58:32 -0700 (PDT)
Subject: Re: [ipw3945-devel] [PATCH 3/8] iwl3945 : fix rate scaling
From: Maxim Levitsky <maximlevitsky@gmail.com>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: ipw3945-devel@lists.sourceforge.net,
	reinette chatre <reinette.chatre@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1236895396.17849.1.camel@maxim-laptop>
References: <1236795481-12757-1-git-send-email-reinette.chatre@intel.com>
	 <1236880246.13699.17.camel@rc-desk> <1236892879.30325.7.camel@maxim-laptop>
	 <200903122258.44393.helmut.schaa@gmail.com>
	 <1236895396.17849.1.camel@maxim-laptop>
Content-Type: text/plain; charset=UTF-8
Date: Fri, 13 Mar 2009 01:58:29 +0200
Message-Id: <1236902309.13039.10.camel@maxim-laptop> (sfid-20090313_005838_201222_F9F0C343)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2009-03-13 at 00:03 +0200, Maxim Levitsky wrote:
> On Thu, 2009-03-12 at 22:58 +0100, Helmut Schaa wrote:
> > Am Donnerstag, 12. M=C3=A4rz 2009 schrieb Maxim Levitsky:
> > > On Thu, 2009-03-12 at 10:50 -0700, reinette chatre wrote:
> > > > On Wed, 2009-03-11 at 19:29 -0700, Maxim Levitsky wrote:
> > > > > On Thu, 2009-03-12 at 03:29 +0200, Maxim Levitsky wrote:
> > [...]
> > > > > > On the other omitting  the 'disable_hw_scan=3D1' option (wh=
ich appears to
> > > > > > work once again, since  few days ago it broke s2disk with h=
ung scan) -
> > > > >=20
> > > > > Ah , I remember now. The disable_hw_scan=3D0 breaks (!)=20
> > > > > the rfkill support.
> > > >=20
> > > > Could you please provide more details about this issue? We are
> > > > interested in steps to reproduce and logs you may have.
> > >=20
> > > A way to reproduce (without NM):
> > >=20
> > > * Start scanning in a loop
> > > while true ; do sudo iwlist scan ; done
> > >=20
> > > * press rfkill - scan hangs forever.
> > > * press rfkill again - doesn't help
> > >=20
> > > I have acer 5720G with hardware rfkill.
> > >=20
> > >=20
> > > The problem seems to be that if user presses rfkill during scan, =
it
> > > hangs.
> >=20
> > I had similar issues (with current wireless-testing) related to rfk=
ill
> > and cfg80211-scanning. An "iwlist scan" only showed "Device or reso=
urce
> > busy" and cfg80211 was stuck in that state. Maybe your issue is rel=
ated?
> > See [1] and [2] for details.
> It isn't related, its the same issue, for sure.
> I'll try your patches, now.
>=20
> Best regards,
> 	Maxim Levitsky


I applied both your patches, and everything works perfectly.

Thanks a lot,
	Best regards,
		Maxim Levitsky



--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
