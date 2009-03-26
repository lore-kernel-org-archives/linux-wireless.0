Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f158.google.com ([209.85.220.158]:48325 "EHLO
	mail-fx0-f158.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932587AbZCZTt3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Mar 2009 15:49:29 -0400
Received: by fxm2 with SMTP id 2so731709fxm.37
        for <linux-wireless@vger.kernel.org>; Thu, 26 Mar 2009 12:49:27 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: reinette chatre <reinette.chatre@intel.com>
Subject: Re: [PATCH 2/3] iwlwifi: remove STATUS_ALIVE checking from rf_kill
Date: Thu, 26 Mar 2009 20:49:17 +0100
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>,
	"Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>
References: <1238087650-26993-1-git-send-email-reinette.chatre@intel.com> <200903262011.50118.helmut.schaa@gmail.com> <1238095859.25000.54.camel@rc-desk>
In-Reply-To: <1238095859.25000.54.camel@rc-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-Id: <200903262049.18049.helmut.schaa@gmail.com> (sfid-20090326_204956_475372_57D28EE1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Donnerstag, 26. M=C3=A4rz 2009 schrieb reinette chatre:
> On Thu, 2009-03-26 at 12:11 -0700, Helmut Schaa wrote:
> > Am Donnerstag, 26. M=C3=A4rz 2009 schrieb reinette chatre:
> > > On Thu, 2009-03-26 at 10:50 -0700, Helmut Schaa wrote:
> > > > Hi,
> > > >=20
> > > > Am Donnerstag, 26. M=C3=A4rz 2009 schrieb Reinette Chatre:
> > > > > From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> > > > >=20
> > > > > Remove STATUS_ALIVE checking when HW RF KILL disabled, the bi=
t get
> > > > > clear in __iwl_down() function; the additional checking will =
fail and
> > > > > cause RF can not be turn back on.
> > > >=20
> > > > Are you sure this is needed? I'd argue we should only restart t=
he adapter
> > > > if it was alive when it got rf_killed. In case the adapter was =
rf_killed
> > > > while the interface was down I don't think we want to restart t=
he adapter
> > > > immediately but first when the interface is taken up again.
> > >=20
> > > We also need to consider if a suspend/resume happens in the middl=
e.
> > > Without the patch, if you enable rfkill, suspend, resume, disable
> > > rfkill, then your interface cannot be brought up.
> >=20
> > I guess you refer to the situation where the interface is up, right=
?
> > Something like:
> >=20
> > - ifconfig wlan0 up
> > - press killswitch (kill wireless)
> > - suspend
> > - resume
> > - press killswitch (enable wireless)
> > - here the interface should still be up
> >=20
> > As the interface is/was up, mac80211's resume handler should restar=
t the
> > adapter and thus we wouldn't need to restart the adapter in the
> > rfkill-handler, or did I miss anything?
>=20
> Yes, the resume handler will start the adapter (call "start"), but th=
e
> actions done by it will exit early because of rfkill being enabled. T=
he
> STATUS_ALIVE bit will thus not be set after this is completed. Later,
> when user disables rfkill, we want to restart the adapter to get all
> this corrected, but this call currently fails because of this check.

Got it, thanks for the explanation.

Nevertheless, removing the check will result in restarting the adapter =
even
if the interface is down. So, I agree that we have a problem here but I=
 do
not agree with the solution ;)

Maybe taking the interface up (not only pseudo-up, as done currently) s=
hould
be allowed even if wireless is killed? We already allow the interface t=
o
stay up when the adapter gets rfkilled.

Helmut
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
