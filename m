Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:33051 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755692AbZC0PkP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Mar 2009 11:40:15 -0400
Subject: Re: [PATCH 2/3] iwlwifi: remove STATUS_ALIVE checking from rf_kill
From: reinette chatre <reinette.chatre@intel.com>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>,
	"Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>
In-Reply-To: <200903270725.35166.helmut.schaa@gmail.com>
References: <1238087650-26993-1-git-send-email-reinette.chatre@intel.com>
	 <200903262158.52601.helmut.schaa@gmail.com>
	 <1238110011.10348.19.camel@rc-desk>
	 <200903270725.35166.helmut.schaa@gmail.com>
Content-Type: text/plain; charset=UTF-8
Date: Fri, 27 Mar 2009 08:45:44 -0700
Message-Id: <1238168744.25568.4.camel@rc-desk> (sfid-20090327_164019_466426_5804863A)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Helmut,

On Thu, 2009-03-26 at 23:25 -0700, Helmut Schaa wrote:
> Hi,
>=20
> Am Freitag, 27. M=C3=A4rz 2009 schrieb reinette chatre:
> > On Thu, 2009-03-26 at 13:58 -0700, Helmut Schaa wrote:
> > > Assume the following situation:
> > >=20
> > > You only have one killswitch for both, wireless and bluetooth. Th=
e wireless
> > > interface is down because it is unused and the user wants to use =
bluetooth
> > > and enables it via the killswitch which also means that wireless =
gets
> > > unkilled. Now restarting the adapter needs more power then keepin=
g the
> > > adapter down. In short: if the interface is down the user (space)=
 does not
> > > want to use the interface and probably wants to save power as wel=
l.
> >=20
> > Your measurements are very fine grained :) Will this be measureable=
?
>=20
> Heh, you know the internals of the devive ;) but I guess waking up th=
e
> adapter (and thus starting the firmware) even if the interface is unu=
sed
> will surely need more power than not doing so.

If interface is down then mac will not ask us to start the interface in
the first place. If interface is up and mac asks us to start interface
then the driver will do so. In this case, if rfkill is enabled, then th=
e
driver will not do much ... definitely not load firmware and thus start
using up power. Only when the user changes rfkill state will we actuall=
y
get the firmware going.

Reinette


--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
