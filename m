Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:6942 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755681Ab2B1BF4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 27 Feb 2012 20:05:56 -0500
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
To: <linux-wireless@vger.kernel.org>
CC: <hauke@hauke-m.de>, <nbd@nbd.name>, <linville@tuxdriver.com>,
	"Luis R. Rodriguez" <mcgrof@frijolero.org>
Subject: [PATCH 0/7] compat: optimize build
Date: Mon, 27 Feb 2012 17:05:34 -0800
Message-ID: <1330391141-19909-1-git-send-email-rodrigue@qca.qualcomm.com> (sfid-20120228_020604_445450_087686FB)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luis R. Rodriguez <mcgrof@frijolero.org>

Hauke reported that parallel building was borked with the latest
autoconf fixes on compat. This series addresses that but also optimizes
things a bit further now now that I've gone down the rabbit hole of
reviewing make -d and also studying GNU Make's jobserver [0]. The thing
that impresses me was the inherent expectation and support by GNU Make
on recursion when you'd expect it to be supported. Unfortunately none
of this was documented well but I hope this series and my rants helps
with spreading some of the documentation love on this.

[0] http://mcgrof.blogspot.com/2012/02/gnu-things-are-gnu-simplicity-of-gnu.html

Luis R. Rodriguez (7):
  compat: fix parallel builds
  compat: move definition of COMPAT_CONFIG and COMPAT_AUTOCONF
  compat: explicitly define paths for local configs
  compat: remove dubious clean at install target
  compat: split COMPAT_CONFIG and COMPAT_AUTOCONF targets
  compat: avoid unnecessary recursion to include a file
  compat: optimize building by extending .PHONY

 Makefile |   27 +++++++++++----------------
 1 files changed, 11 insertions(+), 16 deletions(-)

-- 
1.7.4.15.g7811d

