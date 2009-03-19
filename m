Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:60856 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752273AbZCSTAl (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Mar 2009 15:00:41 -0400
Date: Thu, 19 Mar 2009 14:46:16 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: Reinette Chatre <reinette.chatre@intel.com>,
	linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Mohamed Abbas <mohamed.abbas@intel.com>
Subject: Re: [PATCH 06/13] iwlcore: Fix scan problem, resource busy
Message-ID: <20090319184616.GC3587@tuxdriver.com> (sfid-20090319_200042_952884_B1C5C139)
References: <1237351913-19202-1-git-send-email-reinette.chatre@intel.com> <1237351913-19202-6-git-send-email-reinette.chatre@intel.com> <1237351913-19202-7-git-send-email-reinette.chatre@intel.com> <200903191712.01325.helmut.schaa@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <200903191712.01325.helmut.schaa@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Mar 19, 2009 at 05:12:00PM +0100, Helmut Schaa wrote:
> Hi,
>=20
> Am Mittwoch, 18. M=E4rz 2009 schrieb Reinette Chatre:
> > From: Mohamed Abbas <mohamed.abbas@intel.com>
> >=20
> > when mac80211 issues scan request to lower driver, it always expect
> > a scan_complete notification from the driver, this driver make sure
> > we call scan_completed on all exit path in iwl_mac_hw_scan.
>=20
> It should suffice to return an error in iwl_mac_hw_scan (as done with=
out
> this patch). The problem was mac80211 not calling cfg80211 in case of=
 a
> failure. [1] should fix that. Hence, this workaround in iwlwifi shoul=
d
> not be needed.
>=20
> Helmut
>=20
> [1] http://git.kernel.org/?p=3Dlinux/kernel/git/linville/wireless-tes=
ting.git;a=3Dcommit;h=3Da3fa954ddc4509721a691dd685c3d102cba0b58e

I think Helmut is right.  I'm dropping patch 6/13.

John
--=20
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
