Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:39681 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757257Ab2BYBwL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Feb 2012 20:52:11 -0500
From: "Luis R. Rodriguez" <rodrigue@qca.qualcomm.com>
To: <linux-wireless@vger.kernel.org>
CC: <hauke@hauke-m.de>, <nbd@nbd.name>, <linville@tuxdriver.com>,
	"Luis R. Rodriguez" <mcgrof@frijolero.org>
Subject: [PATCH 0/5] compat / compat-wireless: merge autoconf generation
Date: Fri, 24 Feb 2012 17:52:01 -0800
Message-ID: <1330134726-1634-1-git-send-email-rodrigue@qca.qualcomm.com> (sfid-20120225_025215_154108_ABF2A9B3)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

From: Luis R. Rodriguez <mcgrof@frijolero.org>

While testing ckmake cross compiling compat through different kernels I
realized that compat was failing to build on some kernels but compat-wireless
was not. The reason for this turned out to be that compat did not have an
autoconf for the CONFIG_COMPAT_KERNEL_* variables. In order to make use
of a variable properly in code on kernel we need two things: a makefile
equivalent and a header file that defines it. The compat project had
only makefile variable generation while compat-wireless had makefile
variable generation with a *few* variables propagated to actual code.

To avoid issues with this any further I've decided to try merging the
autoconf effort for both projects and taking leads on what compat does
first.

compat then does the CONFIG_COMPAT_KERNEL_* trickery and generates a
clean .config for us. This in turn generates our compat's compat_autoconf.h.
The compat-wireless project leverages this work by dropping its own
Makefile hackery in favor of the same work and later also uses the same
.config to expand its own compat_autoconf.h.

John, I could use some extra help on reviewing the RHEL stuff. I'm going
to push this stuff out now to help with testing.

compat:

Luis R. Rodriguez (2):
  compat: fix few compilations by adding compat_autoconf.h support
  compat: add some initial RHEL support

 .gitignore                      |   10 ++++
 Makefile                        |   59 ++++++++++------------
 include/linux/compat_autoconf.h |   37 --------------
 scripts/gen-compat-autoconf.sh  |  105 +++++++++++++++++++++++++++++++++++++++
 scripts/gen-compat-config.sh    |   60 ++++++++++++++++++++++
 5 files changed, 201 insertions(+), 70 deletions(-)
 delete mode 100644 include/linux/compat_autoconf.h
 create mode 100755 scripts/gen-compat-autoconf.sh
 create mode 100755 scripts/gen-compat-config.sh

compat-wireless:

Luis R. Rodriguez (3):
  compat-wireless: fix old checks on KERNEL_SUBLEVEL
  compat-wireless: start using CONFIG_COMPAT_KERNEL_ in code
  compat-wireless: use compat's CONFIG_COMPAT_KERNEL_* variables
 Makefile                       |   22 ++++++++++++++++------
 config.mk                      |   24 ++++--------------------
 scripts/check_config.sh        |    9 +++++----
 scripts/gen-compat-autoconf.sh |   13 +++++++------
 4 files changed, 32 insertions(+), 36 deletions(-)

-- 
1.7.4.15.g7811d

