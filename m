Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:37740 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752281AbZC0P6J (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 27 Mar 2009 11:58:09 -0400
Subject: Re: [PATCH 2/3] iwlwifi: remove STATUS_ALIVE checking from rf_kill
From: reinette chatre <reinette.chatre@intel.com>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>,
	"Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>
In-Reply-To: <200903270718.18593.helmut.schaa@gmail.com>
References: <1238087650-26993-1-git-send-email-reinette.chatre@intel.com>
	 <1238087650-26993-2-git-send-email-reinette.chatre@intel.com>
	 <1238087650-26993-3-git-send-email-reinette.chatre@intel.com>
	 <200903270718.18593.helmut.schaa@gmail.com>
Content-Type: text/plain; charset=UTF-8
Date: Fri, 27 Mar 2009 09:03:38 -0700
Message-Id: <1238169818.25568.8.camel@rc-desk> (sfid-20090327_165812_350478_1AD31026)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2009-03-26 at 23:18 -0700, Helmut Schaa wrote:
> Hi again,
>=20
> Am Donnerstag, 26. M=C3=A4rz 2009 schrieb Reinette Chatre:
> > Remove STATUS_ALIVE checking when HW RF KILL disabled, the bit get
> > clear in __iwl_down() function; the additional checking will fail a=
nd
> > cause RF can not be turn back on.
>=20
> Maybe just checking for is_open instead of STATUS_ALIVE will fix the =
issue
> too? I only had a quick look but it looks possible. AFAICS is_open in=
dicates
> if the interface was taken up by mac80211. So if the interface is up =
but
> STATUS_ALIVE is not set we want to restart the adapter after unkillin=
g but
> if the interface is still down (is_open=3D=3D0) we do not want to res=
tart the
> adapter. Furthermore, is_open is also set in case the interface was t=
aken
> up but wireless was rfkilled.

Very good idea ... I'm looking into this.

Reinette

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
