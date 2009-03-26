Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bw0-f169.google.com ([209.85.218.169]:57977 "EHLO
	mail-bw0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761196AbZCZTMD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Mar 2009 15:12:03 -0400
Received: by bwz17 with SMTP id 17so698526bwz.37
        for <linux-wireless@vger.kernel.org>; Thu, 26 Mar 2009 12:11:58 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: reinette chatre <reinette.chatre@intel.com>
Subject: Re: [PATCH 2/3] iwlwifi: remove STATUS_ALIVE checking from rf_kill
Date: Thu, 26 Mar 2009 20:11:49 +0100
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>,
	"Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>
References: <1238087650-26993-1-git-send-email-reinette.chatre@intel.com> <200903261850.09869.helmut.schaa@gmail.com> <1238091765.25000.46.camel@rc-desk>
In-Reply-To: <1238091765.25000.46.camel@rc-desk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-Id: <200903262011.50118.helmut.schaa@gmail.com> (sfid-20090326_201208_778747_061772BA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Am Donnerstag, 26. M=C3=A4rz 2009 schrieb reinette chatre:
> On Thu, 2009-03-26 at 10:50 -0700, Helmut Schaa wrote:
> > Hi,
> >=20
> > Am Donnerstag, 26. M=C3=A4rz 2009 schrieb Reinette Chatre:
> > > From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> > >=20
> > > Remove STATUS_ALIVE checking when HW RF KILL disabled, the bit ge=
t
> > > clear in __iwl_down() function; the additional checking will fail=
 and
> > > cause RF can not be turn back on.
> >=20
> > Are you sure this is needed? I'd argue we should only restart the a=
dapter
> > if it was alive when it got rf_killed. In case the adapter was rf_k=
illed
> > while the interface was down I don't think we want to restart the a=
dapter
> > immediately but first when the interface is taken up again.
>=20
> We also need to consider if a suspend/resume happens in the middle.
> Without the patch, if you enable rfkill, suspend, resume, disable
> rfkill, then your interface cannot be brought up.

I guess you refer to the situation where the interface is up, right?
Something like:

- ifconfig wlan0 up
- press killswitch (kill wireless)
- suspend
- resume
- press killswitch (enable wireless)
- here the interface should still be up

As the interface is/was up, mac80211's resume handler should restart th=
e
adapter and thus we wouldn't need to restart the adapter in the
rfkill-handler, or did I miss anything?

Thanks,
Helmut
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
