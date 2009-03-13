Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f176.google.com ([209.85.220.176]:36998 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751396AbZCMG3H convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Mar 2009 02:29:07 -0400
Received: by fxm24 with SMTP id 24so2516592fxm.37
        for <linux-wireless@vger.kernel.org>; Thu, 12 Mar 2009 23:29:03 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [ipw3945-devel] [PATCH 3/8] iwl3945 : fix rate scaling
Date: Fri, 13 Mar 2009 07:28:51 +0100
Cc: Helmut Schaa <helmut.schaa@googlemail.com>,
	ipw3945-devel@lists.sourceforge.net,
	reinette chatre <reinette.chatre@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <1236795481-12757-1-git-send-email-reinette.chatre@intel.com> <1236895396.17849.1.camel@maxim-laptop> <1236902309.13039.10.camel@maxim-laptop>
In-Reply-To: <1236902309.13039.10.camel@maxim-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-Id: <200903130728.52116.helmut.schaa@gmail.com> (sfid-20090313_072912_656768_4BF5362C)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Freitag, 13. M=C3=A4rz 2009 schrieb Maxim Levitsky:
> On Fri, 2009-03-13 at 00:03 +0200, Maxim Levitsky wrote:
> > On Thu, 2009-03-12 at 22:58 +0100, Helmut Schaa wrote:
> > > Am Donnerstag, 12. M=C3=A4rz 2009 schrieb Maxim Levitsky:
> > > > On Thu, 2009-03-12 at 10:50 -0700, reinette chatre wrote:
> > > > > On Wed, 2009-03-11 at 19:29 -0700, Maxim Levitsky wrote:
> > > > > > On Thu, 2009-03-12 at 03:29 +0200, Maxim Levitsky wrote:
> > > [...]
> > > > > > > On the other omitting  the 'disable_hw_scan=3D1' option (=
which appears to
> > > > > > > work once again, since  few days ago it broke s2disk with=
 hung scan) -
> > > > > >=20
> > > > > > Ah , I remember now. The disable_hw_scan=3D0 breaks (!)=20
> > > > > > the rfkill support.
> > > > >=20
> > > > > Could you please provide more details about this issue? We ar=
e
> > > > > interested in steps to reproduce and logs you may have.
> > > >=20
> > > > A way to reproduce (without NM):
> > > >=20
> > > > * Start scanning in a loop
> > > > while true ; do sudo iwlist scan ; done
> > > >=20
> > > > * press rfkill - scan hangs forever.
> > > > * press rfkill again - doesn't help
> > > >=20
> > > > I have acer 5720G with hardware rfkill.
> > > >=20
> > > >=20
> > > > The problem seems to be that if user presses rfkill during scan=
, it
> > > > hangs.
> > >=20
> > > I had similar issues (with current wireless-testing) related to r=
fkill
> > > and cfg80211-scanning. An "iwlist scan" only showed "Device or re=
source
> > > busy" and cfg80211 was stuck in that state. Maybe your issue is r=
elated?
> > > See [1] and [2] for details.
> > It isn't related, its the same issue, for sure.
> > I'll try your patches, now.
> >=20
> > Best regards,
> > 	Maxim Levitsky
>=20
>=20
> I applied both your patches, and everything works perfectly.

Great. Thanks for testing.

Helmut
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
