Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:21826 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755193AbZCZSRj (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 26 Mar 2009 14:17:39 -0400
Subject: Re: [PATCH 2/3] iwlwifi: remove STATUS_ALIVE checking from rf_kill
From: reinette chatre <reinette.chatre@intel.com>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>,
	"Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>
In-Reply-To: <200903261850.09869.helmut.schaa@gmail.com>
References: <1238087650-26993-1-git-send-email-reinette.chatre@intel.com>
	 <1238087650-26993-2-git-send-email-reinette.chatre@intel.com>
	 <1238087650-26993-3-git-send-email-reinette.chatre@intel.com>
	 <200903261850.09869.helmut.schaa@gmail.com>
Content-Type: text/plain; charset=UTF-8
Date: Thu, 26 Mar 2009 11:22:45 -0700
Message-Id: <1238091765.25000.46.camel@rc-desk> (sfid-20090326_191742_854827_06B53209)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2009-03-26 at 10:50 -0700, Helmut Schaa wrote:
> Hi,
>=20
> Am Donnerstag, 26. M=C3=A4rz 2009 schrieb Reinette Chatre:
> > From: Wey-Yi Guy <wey-yi.w.guy@intel.com>
> >=20
> > Remove STATUS_ALIVE checking when HW RF KILL disabled, the bit get
> > clear in __iwl_down() function; the additional checking will fail a=
nd
> > cause RF can not be turn back on.
>=20
> Are you sure this is needed? I'd argue we should only restart the ada=
pter
> if it was alive when it got rf_killed. In case the adapter was rf_kil=
led
> while the interface was down I don't think we want to restart the ada=
pter
> immediately but first when the interface is taken up again.

We also need to consider if a suspend/resume happens in the middle.
Without the patch, if you enable rfkill, suspend, resume, disable
rfkill, then your interface cannot be brought up.

Reinette

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
