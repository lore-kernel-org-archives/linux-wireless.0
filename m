Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:21211 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932330AbZCZTZb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Mar 2009 15:25:31 -0400
Subject: Re: [PATCH 2/3] iwlwifi: remove STATUS_ALIVE checking from rf_kill
From: reinette chatre <reinette.chatre@intel.com>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>,
	"Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>
In-Reply-To: <200903262011.50118.helmut.schaa@gmail.com>
References: <1238087650-26993-1-git-send-email-reinette.chatre@intel.com>
	 <200903261850.09869.helmut.schaa@gmail.com>
	 <1238091765.25000.46.camel@rc-desk>
	 <200903262011.50118.helmut.schaa@gmail.com>
Content-Type: text/plain; charset=UTF-8
Date: Thu, 26 Mar 2009 12:30:59 -0700
Message-Id: <1238095859.25000.54.camel@rc-desk> (sfid-20090326_202534_991454_81519F98)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2009-03-26 at 12:11 -0700, Helmut Schaa wrote:
> Am Donnerstag, 26. M=C3=A4rz 2009 schrieb reinette chatre:
> > On Thu, 2009-03-26 at 10:50 -0700, Helmut Schaa wrote:
> > > Hi,
> > >=20
> > > Am Donnerstag, 26. M=C3=A4rz 2009 schrieb Reinette Chatre:
> > > > From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> > > >=20
> > > > Remove STATUS_ALIVE checking when HW RF KILL disabled, the bit =
get
> > > > clear in __iwl_down() function; the additional checking will fa=
il and
> > > > cause RF can not be turn back on.
> > >=20
> > > Are you sure this is needed? I'd argue we should only restart the=
 adapter
> > > if it was alive when it got rf_killed. In case the adapter was rf=
_killed
> > > while the interface was down I don't think we want to restart the=
 adapter
> > > immediately but first when the interface is taken up again.
> >=20
> > We also need to consider if a suspend/resume happens in the middle.
> > Without the patch, if you enable rfkill, suspend, resume, disable
> > rfkill, then your interface cannot be brought up.
>=20
> I guess you refer to the situation where the interface is up, right?
> Something like:
>=20
> - ifconfig wlan0 up
> - press killswitch (kill wireless)
> - suspend
> - resume
> - press killswitch (enable wireless)
> - here the interface should still be up
>=20
> As the interface is/was up, mac80211's resume handler should restart =
the
> adapter and thus we wouldn't need to restart the adapter in the
> rfkill-handler, or did I miss anything?

Yes, the resume handler will start the adapter (call "start"), but the
actions done by it will exit early because of rfkill being enabled. The
STATUS_ALIVE bit will thus not be set after this is completed. Later,
when user disables rfkill, we want to restart the adapter to get all
this corrected, but this call currently fails because of this check.

Reinette


--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
