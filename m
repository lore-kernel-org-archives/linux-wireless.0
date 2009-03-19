Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:28551 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751032AbZCST6r convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Mar 2009 15:58:47 -0400
From: "Abbas, Mohamed" <mohamed.abbas@intel.com>
To: Helmut Schaa <helmut.schaa@googlemail.com>,
	"Chatre, Reinette" <reinette.chatre@intel.com>
CC: "linville@tuxdriver.com" <linville@tuxdriver.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ipw3945-devel@lists.sourceforge.net"
	<ipw3945-devel@lists.sourceforge.net>
Date: Thu, 19 Mar 2009 12:58:43 -0700
Subject: RE: [PATCH 06/13] iwlcore: Fix scan problem, resource busy
Message-ID: <26E9B811E137AB4B95200FD4C950886B25DDE919@orsmsx507.amr.corp.intel.com> (sfid-20090319_205849_394662_7984FB2D)
References: <1237351913-19202-1-git-send-email-reinette.chatre@intel.com>
 <1237351913-19202-6-git-send-email-reinette.chatre@intel.com>
 <1237351913-19202-7-git-send-email-reinette.chatre@intel.com>
 <200903191712.01325.helmut.schaa@gmail.com>
In-Reply-To: <200903191712.01325.helmut.schaa@gmail.com>
Content-Type: text/plain; charset=iso-8859-1
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Yes if mac80211 is fixed to accept failure then this patch not needed. =
I did not get is there us a patch that already fix this or I need to do=
 it myself.
Mohamed

-----Original Message-----
=46rom: Helmut Schaa [mailto:helmut.schaa@googlemail.com]=20
Sent: Thursday, March 19, 2009 9:12 AM
To: Chatre, Reinette
Cc: linville@tuxdriver.com; linux-wireless@vger.kernel.org; ipw3945-dev=
el@lists.sourceforge.net; Abbas, Mohamed
Subject: Re: [PATCH 06/13] iwlcore: Fix scan problem, resource busy

Hi,

Am Mittwoch, 18. M=E4rz 2009 schrieb Reinette Chatre:
> From: Mohamed Abbas <mohamed.abbas@intel.com>
>=20
> when mac80211 issues scan request to lower driver, it always expect
> a scan_complete notification from the driver, this driver make sure
> we call scan_completed on all exit path in iwl_mac_hw_scan.

It should suffice to return an error in iwl_mac_hw_scan (as done withou=
t
this patch). The problem was mac80211 not calling cfg80211 in case of a
failure. [1] should fix that. Hence, this workaround in iwlwifi should
not be needed.

Helmut

[1] http://git.kernel.org/?p=3Dlinux/kernel/git/linville/wireless-testi=
ng.git;a=3Dcommit;h=3Da3fa954ddc4509721a691dd685c3d102cba0b58e
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
