Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qc0-f176.google.com ([209.85.216.176]:35025 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751211AbbFHAnH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 7 Jun 2015 20:43:07 -0400
From: David Decotigny <ddecotig@gmail.com>
To: Larry Finger <Larry.Finger@lwfinger.net>,
	Jes Sorensen <Jes.Sorensen@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
	linux-kernel@vger.kernel.org
Cc: Joe Perches <joe@perches.com>,
	Dan Carpenter <dan.carpenter@oracle.com>,
	David Decotigny <ddecotig@gmail.com>
Subject: [PATCH v2 0/2] staging: rtl8723au: core: endianness issues
Date: Sun,  7 Jun 2015 17:43:00 -0700
Message-Id: <1433724182-657-1-git-send-email-ddecotig@gmail.com> (sfid-20150608_024344_404890_820FBDB0)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The code shows a couple inconsistencies (described in commit
descriptions) which would not be an issue on little-endian cpus, but
could cause breakage on non-LE cpus. Note: I could not test on real
hardware, these patches created based on sparse reports.

Hostory:
  - resending the same patches to correct recipients, only changed
    commit descriptions (credits to Dan Carpenter)

############################################
# Patch Set Summary:

David Decotigny (2):
  staging: rtl8723au: core: avoid bitwise arithmetic with forced
    endianness
  staging: rtl8723au: core: remove redundant endianness conversion

 drivers/staging/rtl8723au/core/rtw_mlme_ext.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

-- 
2.2.0.rc0.207.ga3a616c

