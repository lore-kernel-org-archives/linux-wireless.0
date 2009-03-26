Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:62384 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755094AbZCZUcM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Mar 2009 16:32:12 -0400
Subject: Re: [PATCH 2/3] iwlwifi: remove STATUS_ALIVE checking from rf_kill
From: reinette chatre <reinette.chatre@intel.com>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>,
	"Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>
In-Reply-To: <200903262049.18049.helmut.schaa@gmail.com>
References: <1238087650-26993-1-git-send-email-reinette.chatre@intel.com>
	 <200903262011.50118.helmut.schaa@gmail.com>
	 <1238095859.25000.54.camel@rc-desk>
	 <200903262049.18049.helmut.schaa@gmail.com>
Content-Type: text/plain; charset=UTF-8
Date: Thu, 26 Mar 2009 13:37:27 -0700
Message-Id: <1238099847.25000.63.camel@rc-desk> (sfid-20090326_213215_574214_46732F54)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2009-03-26 at 12:49 -0700, Helmut Schaa wrote:
> Am Donnerstag, 26. M=C3=A4rz 2009 schrieb reinette chatre:
> > On Thu, 2009-03-26 at 12:11 -0700, Helmut Schaa wrote:
> > > Am Donnerstag, 26. M=C3=A4rz 2009 schrieb reinette chatre:
> > > > On Thu, 2009-03-26 at 10:50 -0700, Helmut Schaa wrote:
> > > > > Hi,
> > > > >=20
> > > > > Am Donnerstag, 26. M=C3=A4rz 2009 schrieb Reinette Chatre:
> > > > > > From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> > > > > >=20
> > > > > > Remove STATUS_ALIVE checking when HW RF KILL disabled, the =
bit get
> > > > > > clear in __iwl_down() function; the additional checking wil=
l fail and
> > > > > > cause RF can not be turn back on.
> > > > >=20
> > > > > Are you sure this is needed? I'd argue we should only restart=
 the adapter
> > > > > if it was alive when it got rf_killed. In case the adapter wa=
s rf_killed
> > > > > while the interface was down I don't think we want to restart=
 the adapter
> > > > > immediately but first when the interface is taken up again.
> > > >=20
> > > > We also need to consider if a suspend/resume happens in the mid=
dle.
> > > > Without the patch, if you enable rfkill, suspend, resume, disab=
le
> > > > rfkill, then your interface cannot be brought up.
> > >=20
> > > I guess you refer to the situation where the interface is up, rig=
ht?
> > > Something like:
> > >=20
> > > - ifconfig wlan0 up
> > > - press killswitch (kill wireless)
> > > - suspend
> > > - resume
> > > - press killswitch (enable wireless)
> > > - here the interface should still be up
> > >=20
> > > As the interface is/was up, mac80211's resume handler should rest=
art the
> > > adapter and thus we wouldn't need to restart the adapter in the
> > > rfkill-handler, or did I miss anything?
> >=20
> > Yes, the resume handler will start the adapter (call "start"), but =
the
> > actions done by it will exit early because of rfkill being enabled.=
 The
> > STATUS_ALIVE bit will thus not be set after this is completed. Late=
r,
> > when user disables rfkill, we want to restart the adapter to get al=
l
> > this corrected, but this call currently fails because of this check=
=2E
>=20
> Got it, thanks for the explanation.
>=20
> Nevertheless, removing the check will result in restarting the adapte=
r even
> if the interface is down. So, I agree that we have a problem here but=
 I do
> not agree with the solution ;)

I agree that it is not efficient ... but it seems harmless.

> Maybe taking the interface up (not only pseudo-up, as done currently)=
 should
> be allowed even if wireless is killed? We already allow the interface=
 to
> stay up when the adapter gets rfkilled.

Knowing that rfkill is enabled enables us to save power by not bringing
everything up.

Reinette

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
