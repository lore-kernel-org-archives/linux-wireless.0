Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.154]:53026 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752496AbZCSQMP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Mar 2009 12:12:15 -0400
Received: by fg-out-1718.google.com with SMTP id e12so72826fga.17
        for <linux-wireless@vger.kernel.org>; Thu, 19 Mar 2009 09:12:11 -0700 (PDT)
From: Helmut Schaa <helmut.schaa@googlemail.com>
To: Reinette Chatre <reinette.chatre@intel.com>
Subject: Re: [PATCH 06/13] iwlcore: Fix scan problem, resource busy
Date: Thu, 19 Mar 2009 17:12:00 +0100
Cc: linville@tuxdriver.com, linux-wireless@vger.kernel.org,
	ipw3945-devel@lists.sourceforge.net,
	Mohamed Abbas <mohamed.abbas@intel.com>
References: <1237351913-19202-1-git-send-email-reinette.chatre@intel.com> <1237351913-19202-6-git-send-email-reinette.chatre@intel.com> <1237351913-19202-7-git-send-email-reinette.chatre@intel.com>
In-Reply-To: <1237351913-19202-7-git-send-email-reinette.chatre@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Message-Id: <200903191712.01325.helmut.schaa@gmail.com> (sfid-20090319_171219_801232_78F018CA)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

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
