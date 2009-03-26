Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fk-out-0910.google.com ([209.85.128.191]:7903 "EHLO
	fk-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753036AbZCZU7F convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Mar 2009 16:59:05 -0400
Received: by fk-out-0910.google.com with SMTP id 18so331185fkq.5
        for <linux-wireless@vger.kernel.org>; Thu, 26 Mar 2009 13:59:01 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: reinette chatre <reinette.chatre@intel.com>
Subject: Re: [PATCH 2/3] iwlwifi: remove STATUS_ALIVE checking from rf_kill
Date: Thu, 26 Mar 2009 21:58:51 +0100
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>,
	"Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>
References: <1238087650-26993-1-git-send-email-reinette.chatre@intel.com> <200903262049.18049.helmut.schaa@gmail.com> <1238099847.25000.63.camel@rc-desk>
In-Reply-To: <1238099847.25000.63.camel@rc-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-Id: <200903262158.52601.helmut.schaa@gmail.com> (sfid-20090326_215910_826112_026A34FF)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Donnerstag, 26. M=C3=A4rz 2009 schrieb reinette chatre:
> On Thu, 2009-03-26 at 12:49 -0700, Helmut Schaa wrote:
> > Am Donnerstag, 26. M=C3=A4rz 2009 schrieb reinette chatre:
> > > On Thu, 2009-03-26 at 12:11 -0700, Helmut Schaa wrote:
> > > > Am Donnerstag, 26. M=C3=A4rz 2009 schrieb reinette chatre:
> > > > > On Thu, 2009-03-26 at 10:50 -0700, Helmut Schaa wrote:
> > > > > > Hi,
> > > > > >=20
> > > > > > Am Donnerstag, 26. M=C3=A4rz 2009 schrieb Reinette Chatre:
> > > > > > > From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> > > > > > >=20
> > > > > > > Remove STATUS_ALIVE checking when HW RF KILL disabled, th=
e bit get
> > > > > > > clear in __iwl_down() function; the additional checking w=
ill fail and
> > > > > > > cause RF can not be turn back on.
> > > > > >=20
> > > > > > Are you sure this is needed? I'd argue we should only resta=
rt the adapter
> > > > > > if it was alive when it got rf_killed. In case the adapter =
was rf_killed
> > > > > > while the interface was down I don't think we want to resta=
rt the adapter
> > > > > > immediately but first when the interface is taken up again.
> > > > >=20
> > > > > We also need to consider if a suspend/resume happens in the m=
iddle.
> > > > > Without the patch, if you enable rfkill, suspend, resume, dis=
able
> > > > > rfkill, then your interface cannot be brought up.
> > > >=20
> > > > I guess you refer to the situation where the interface is up, r=
ight?
> > > > Something like:
> > > >=20
> > > > - ifconfig wlan0 up
> > > > - press killswitch (kill wireless)
> > > > - suspend
> > > > - resume
> > > > - press killswitch (enable wireless)
> > > > - here the interface should still be up
> > > >=20
> > > > As the interface is/was up, mac80211's resume handler should re=
start the
> > > > adapter and thus we wouldn't need to restart the adapter in the
> > > > rfkill-handler, or did I miss anything?
> > >=20
> > > Yes, the resume handler will start the adapter (call "start"), bu=
t the
> > > actions done by it will exit early because of rfkill being enable=
d. The
> > > STATUS_ALIVE bit will thus not be set after this is completed. La=
ter,
> > > when user disables rfkill, we want to restart the adapter to get =
all
> > > this corrected, but this call currently fails because of this che=
ck.
> >=20
> > Got it, thanks for the explanation.
> >=20
> > Nevertheless, removing the check will result in restarting the adap=
ter even
> > if the interface is down. So, I agree that we have a problem here b=
ut I do
> > not agree with the solution ;)
>=20
> I agree that it is not efficient ... but it seems harmless.

Assume the following situation:

You only have one killswitch for both, wireless and bluetooth. The wire=
less
interface is down because it is unused and the user wants to use blueto=
oth
and enables it via the killswitch which also means that wireless gets
unkilled. Now restarting the adapter needs more power then keeping the
adapter down. In short: if the interface is down the user (space) does =
not
want to use the interface and probably wants to save power as well.

> > Maybe taking the interface up (not only pseudo-up, as done currentl=
y) should
> > be allowed even if wireless is killed? We already allow the interfa=
ce to
> > stay up when the adapter gets rfkilled.
>=20
> Knowing that rfkill is enabled enables us to save power by not bringi=
ng
> everything up.

Yes, but user (space) knows that the wireless card consumes more power =
if the
interface is up. And if you use NM for example it will just take the in=
terface
down when the killswitch gets activated.

Another solution would be to
1) not allow the interface to go up when it is rfkilled, and
2) take the interface down when it gets rfkilled

However, I'm not sure if 2 is possible without help of mac80211 and if =
it
makes sense to change an interface state from within the driver.

Helmut
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
