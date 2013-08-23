Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from canardo.mork.no ([148.122.252.1]:40872 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752943Ab3HWJkG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 Aug 2013 05:40:06 -0400
From: =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>
To: netdev@vger.kernel.org
Cc: =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
	Patrick McHardy <kaber@trash.net>,
	Jiri Pirko <jiri@resnulli.us>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>,
	libertas-dev@lists.infradead.org,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	devel@driverdev.osuosl.org,
	Forest Bond <forest@alittletooquiet.net>
Subject: [PATCH net-next 00/10] set addr_assign_type when inheriting a dev_addr
Date: Fri, 23 Aug 2013 11:35:03 +0200
Message-Id: <1377250513-3662-1-git-send-email-bjorn@mork.no> (sfid-20130823_114016_834622_E532A0B9)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Copying the dev_addr from a parent device is an operation
common to a number of drivers. The addr_assign_type should
be updated accordingly, either by reusing the value from
the source device or explicitly indicating that the address
is stolen by setting addr_assign_type to NET_ADDR_STOLEN.

This patch set adds a helper copying both the dev_addr and
the addr_assign_type, and use this helper in drivers which
don't currently set the addr_assign_type. Using NET_ADDR_STOLEN
might be more appropriate in some of these cases.  Please
let me know, and I'll update the patch accordingly.


Bjørn Mork (10):
  net: etherdevice: add address inherit helper
  net: vlan: inherit addr_assign_type along with dev_addr
  net: dsa: inherit addr_assign_type along with dev_addr
  net: macvlan: inherit addr_assign_type along with dev_addr
  net: team: inherit addr_assign_type along with dev_addr
  net: airo: inherit addr_assign_type along with dev_addr
  net: hostap: inherit addr_assign_type along with dev_addr
  net: libertas: inherit addr_assign_type along with dev_addr
  staging: vt6655: inherit addr_assign_type along with dev_addr
  staging: vt6656: inherit addr_assign_type along with dev_addr

 drivers/net/macvlan.c                     |    2 +-
 drivers/net/team/team.c                   |    2 +-
 drivers/net/wireless/airo.c               |    2 +-
 drivers/net/wireless/hostap/hostap_hw.c   |    2 +-
 drivers/net/wireless/hostap/hostap_main.c |    2 +-
 drivers/net/wireless/libertas/mesh.c      |    2 +-
 drivers/staging/vt6655/hostap.c           |    2 +-
 drivers/staging/vt6655/ioctl.c            |    2 +-
 drivers/staging/vt6655/wpactl.c           |    2 +-
 drivers/staging/vt6656/hostap.c           |    2 +-
 include/linux/etherdevice.h               |   19 +++++++++++++++++++
 net/8021q/vlan_dev.c                      |    2 +-
 net/dsa/slave.c                           |    2 +-
 13 files changed, 31 insertions(+), 12 deletions(-)

-- 
1.7.10.4

