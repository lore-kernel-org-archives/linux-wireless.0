Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:46103 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755155AbZCZXVX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Mar 2009 19:21:23 -0400
Subject: Re: [PATCH 2/3] iwlwifi: remove STATUS_ALIVE checking from rf_kill
From: reinette chatre <reinette.chatre@intel.com>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>,
	"Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>
In-Reply-To: <200903262158.52601.helmut.schaa@gmail.com>
References: <1238087650-26993-1-git-send-email-reinette.chatre@intel.com>
	 <200903262049.18049.helmut.schaa@gmail.com>
	 <1238099847.25000.63.camel@rc-desk>
	 <200903262158.52601.helmut.schaa@gmail.com>
Content-Type: text/plain; charset=UTF-8
Date: Thu, 26 Mar 2009 16:26:51 -0700
Message-Id: <1238110011.10348.19.camel@rc-desk> (sfid-20090327_002127_033746_FBB392B9)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Helmut,

On Thu, 2009-03-26 at 13:58 -0700, Helmut Schaa wrote:
> Am Donnerstag, 26. M=C3=A4rz 2009 schrieb reinette chatre:
> > On Thu, 2009-03-26 at 12:49 -0700, Helmut Schaa wrote:
> > > Am Donnerstag, 26. M=C3=A4rz 2009 schrieb reinette chatre:
> > > > On Thu, 2009-03-26 at 12:11 -0700, Helmut Schaa wrote:
> > > > > Am Donnerstag, 26. M=C3=A4rz 2009 schrieb reinette chatre:
> > > > > > On Thu, 2009-03-26 at 10:50 -0700, Helmut Schaa wrote:
> > > > > > > Hi,
> > > > > > >=20
> > > > > > > Am Donnerstag, 26. M=C3=A4rz 2009 schrieb Reinette Chatre=
:
> > > > > > > > From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> > > > > > > >=20
> > > > > > > > Remove STATUS_ALIVE checking when HW RF KILL disabled, =
the bit get
> > > > > > > > clear in __iwl_down() function; the additional checking=
 will fail and
> > > > > > > > cause RF can not be turn back on.
> > > > > > >=20
> > > > > > > Are you sure this is needed? I'd argue we should only res=
tart the adapter
> > > > > > > if it was alive when it got rf_killed. In case the adapte=
r was rf_killed
> > > > > > > while the interface was down I don't think we want to res=
tart the adapter
> > > > > > > immediately but first when the interface is taken up agai=
n.
> > > > > >=20
> > > > > > We also need to consider if a suspend/resume happens in the=
 middle.
> > > > > > Without the patch, if you enable rfkill, suspend, resume, d=
isable
> > > > > > rfkill, then your interface cannot be brought up.
> > > > >=20
> > > > > I guess you refer to the situation where the interface is up,=
 right?
> > > > > Something like:
> > > > >=20
> > > > > - ifconfig wlan0 up
> > > > > - press killswitch (kill wireless)
> > > > > - suspend
> > > > > - resume
> > > > > - press killswitch (enable wireless)
> > > > > - here the interface should still be up
> > > > >=20
> > > > > As the interface is/was up, mac80211's resume handler should =
restart the
> > > > > adapter and thus we wouldn't need to restart the adapter in t=
he
> > > > > rfkill-handler, or did I miss anything?
> > > >=20
> > > > Yes, the resume handler will start the adapter (call "start"), =
but the
> > > > actions done by it will exit early because of rfkill being enab=
led. The
> > > > STATUS_ALIVE bit will thus not be set after this is completed. =
Later,
> > > > when user disables rfkill, we want to restart the adapter to ge=
t all
> > > > this corrected, but this call currently fails because of this c=
heck.
> > >=20
> > > Got it, thanks for the explanation.
> > >=20
> > > Nevertheless, removing the check will result in restarting the ad=
apter even
> > > if the interface is down. So, I agree that we have a problem here=
 but I do
> > > not agree with the solution ;)
> >=20
> > I agree that it is not efficient ... but it seems harmless.
>=20
> Assume the following situation:
>=20
> You only have one killswitch for both, wireless and bluetooth. The wi=
reless
> interface is down because it is unused and the user wants to use blue=
tooth
> and enables it via the killswitch which also means that wireless gets
> unkilled. Now restarting the adapter needs more power then keeping th=
e
> adapter down. In short: if the interface is down the user (space) doe=
s not
> want to use the interface and probably wants to save power as well.

Your measurements are very fine grained :) Will this be measureable?
Right now things do not work and this patch fixes it.=20

> > > Maybe taking the interface up (not only pseudo-up, as done curren=
tly) should
> > > be allowed even if wireless is killed? We already allow the inter=
face to
> > > stay up when the adapter gets rfkilled.
> >=20
> > Knowing that rfkill is enabled enables us to save power by not brin=
ging
> > everything up.
>=20
> Yes, but user (space) knows that the wireless card consumes more powe=
r if the
> interface is up. And if you use NM for example it will just take the =
interface
> down when the killswitch gets activated.

> Another solution would be to
> 1) not allow the interface to go up when it is rfkilled, and

We currently do this.

> 2) take the interface down when it gets rfkilled
>=20
> However, I'm not sure if 2 is possible without help of mac80211 and i=
f it
> makes sense to change an interface state from within the driver.

Like you say ... probably not the driver's place to do this.

Reinette


--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
