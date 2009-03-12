Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f176.google.com ([209.85.220.176]:48971 "EHLO
	mail-fx0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750809AbZCLV7F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 12 Mar 2009 17:59:05 -0400
Received: by fxm24 with SMTP id 24so2344704fxm.37
        for <linux-wireless@vger.kernel.org>; Thu, 12 Mar 2009 14:59:02 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Maxim Levitsky <maximlevitsky@gmail.com>
Subject: Re: [ipw3945-devel] [PATCH 3/8] iwl3945 : fix rate scaling
Date: Thu, 12 Mar 2009 22:58:43 +0100
Cc: ipw3945-devel@lists.sourceforge.net,
	reinette chatre <reinette.chatre@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
References: <1236795481-12757-1-git-send-email-reinette.chatre@intel.com> <1236880246.13699.17.camel@rc-desk> <1236892879.30325.7.camel@maxim-laptop>
In-Reply-To: <1236892879.30325.7.camel@maxim-laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Message-Id: <200903122258.44393.helmut.schaa@gmail.com> (sfid-20090312_225917_080392_41A2E3C4)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Donnerstag, 12. M=E4rz 2009 schrieb Maxim Levitsky:
> On Thu, 2009-03-12 at 10:50 -0700, reinette chatre wrote:
> > On Wed, 2009-03-11 at 19:29 -0700, Maxim Levitsky wrote:
> > > On Thu, 2009-03-12 at 03:29 +0200, Maxim Levitsky wrote:
[...]
> > > > On the other omitting  the 'disable_hw_scan=3D1' option (which =
appears to
> > > > work once again, since  few days ago it broke s2disk with hung =
scan) -
> > >=20
> > > Ah , I remember now. The disable_hw_scan=3D0 breaks (!)=20
> > > the rfkill support.
> >=20
> > Could you please provide more details about this issue? We are
> > interested in steps to reproduce and logs you may have.
>=20
> A way to reproduce (without NM):
>=20
> * Start scanning in a loop
> while true ; do sudo iwlist scan ; done
>=20
> * press rfkill - scan hangs forever.
> * press rfkill again - doesn't help
>=20
> I have acer 5720G with hardware rfkill.
>=20
>=20
> The problem seems to be that if user presses rfkill during scan, it
> hangs.

I had similar issues (with current wireless-testing) related to rfkill
and cfg80211-scanning. An "iwlist scan" only showed "Device or resource
busy" and cfg80211 was stuck in that state. Maybe your issue is related=
?
See [1] and [2] for details.

Helmut

[1] http://marc.info/?l=3Dlinux-wireless&m=3D123661005000427&w=3D2
[2] http://marc.info/?l=3Dlinux-wireless&m=3D123686313707477&w=3D2
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
