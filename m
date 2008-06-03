Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:2418 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754362AbYFCCMb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Jun 2008 22:12:31 -0400
Subject: Re: [PATCH v2] ipw2200: queue direct scans
From: Zhu Yi <yi.zhu@intel.com>
To: Dan Williams <dcbw@redhat.com>
Cc: linux-wireless@vger.kernel.org,
	ipw2100-devel@lists.sourceforge.net,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <1212429083.10093.18.camel@localhost.localdomain>
References: <1208800153.30994.25.camel@localhost.localdomain>
	 <1208829043.5327.13.camel@debian.sh.intel.com>
	 <1212429083.10093.18.camel@localhost.localdomain>
Content-Type: text/plain; charset=UTF-8
Date: Tue, 03 Jun 2008 10:11:30 +0800
Message-Id: <1212459090.7814.401.camel@debian.sh.intel.com> (sfid-20080603_041238_716897_B7A640FA)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2008-06-02 at 13:51 -0400, Dan Williams wrote:
> =EF=BB=BFWhen another scan is in progress, a direct scan gets dropped=
 on the
> floor.  However, that direct scan is usually the scan that's really
> needed by userspace, and gets stomped on by all the broadcast scans
> the
> ipw2200 driver issues internally.  Make sure the direct scan happens
> eventually, and as a bonus ensure that the passive scan worker is
> cleaned up when appropriate.
>=20
> The change of request_passive_scan form a struct work to struct
> delayed_work is only to make the set_wx_scan() code a bit simpler,
> it's
> still only used with a delay of 0 to match previous behavior.
>=20
> Signed-off-by: Dan Williams <dcbw@redhat.com>
> ----
>=20
> v2: consolidate direct and normal scan helpers into
> ipw_request_scan_helper() per Zhu Yi's request

ACK.

Thanks,
-yi

--
To unsubscribe from this list: send the line "unsubscribe linux-wireles=
s" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
