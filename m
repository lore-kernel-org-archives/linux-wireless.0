Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from osg.samsung.com ([64.30.133.232]:61717 "EHLO osg.samsung.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752167AbeEGJgD (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 7 May 2018 05:36:03 -0400
From: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To: Linux Doc Mailing List <linux-doc@vger.kernel.org>
Cc: Mauro Carvalho Chehab <mchehab+samsung@kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        linux-wireless@vger.kernel.org, linux-mtd@lists.infradead.org,
        linux-fbdev@vger.kernel.org, linux-can@vger.kernel.org,
        "Luis R. Rodriguez" <mcgrof@kernel.org>, linux-iio@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-crypto@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-pm@vger.kernel.org
Subject: [PATCH 00/18] Fix some build warnings/errors with Sphinx
Date: Mon,  7 May 2018 06:35:36 -0300
Message-Id: <cover.1525684985.git.mchehab+samsung@kernel.org> (sfid-20180507_113853_452809_8074FE6B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I decided to give a try with Sphinx last stable version
(1.17.4), and noticed several issues. The worse one was
with the networking book: a non-standard footnote there
with [*] instead of a number causes it to break PDF building.

So, I took some spare time to address some warnings all over
the tree, and moved a few text documents to a book. I with
I had more time to move the other ones and to solve other
warnings.

Mauro Carvalho Chehab (18):
  docs: can.rst: fix a footnote reference
  docs: fix location of request_firmware & friends
  docs: */index.rst: Add newer documents to their respective index.rst
  docs: admin-guide: add bcache documentation
  docs: core-api: add cachetlb documentation
  docs: core-api: add cgroup-v2 documentation
  docs: core-api: add circular-buffers documentation
  docs: driver-api: add clk documentation
  net: mac80211.h: fix a bad comment line
  rcu: rcupdate.h: get rid of Sphinx warnings at rcu_pointer_handoff()
  docs: crypto_engine.rst: Fix two parse warnings
  time: timer.c: adjust a kernel-doc comment
  wait: wait.h: Get rid of a kernel-doc/Sphinx warnings
  fbdev: modedb.c: fix a kernel-doc markup
  iio: iio.h: use nested struct support on kernel-doc markup
  mtd: rawnand.h: use nested union kernel-doc markups
  docs: uio-howto.rst: use a code block to solve a warning
  w1: w1_io.c: fix a kernel-doc warning

 Documentation/00-INDEX                        | 10 -------
 .../{bcache.txt => admin-guide/bcache.rst}    |  0
 .../cgroup-v2.rst}                            |  0
 Documentation/admin-guide/index.rst           |  2 ++
 .../admin-guide/kernel-parameters.txt         |  2 +-
 .../{cachetlb.txt => core-api/cachetlb.rst}   |  0
 .../circular-buffers.rst}                     |  0
 Documentation/core-api/index.rst              |  2 ++
 Documentation/crypto/crypto_engine.rst        |  8 +++---
 Documentation/crypto/index.rst                |  1 +
 Documentation/dell_rbu.txt                    |  4 +--
 Documentation/{clk.txt => driver-api/clk.rst} |  0
 .../firmware/fallback-mechanisms.rst          |  2 +-
 .../driver-api/firmware/request_firmware.rst  | 17 +++++++-----
 Documentation/driver-api/index.rst            |  2 ++
 Documentation/driver-api/infrastructure.rst   |  2 +-
 Documentation/driver-api/uio-howto.rst        |  3 ++-
 Documentation/memory-barriers.txt             |  4 +--
 Documentation/networking/can.rst              |  4 +--
 .../power/suspend-and-cpuhotplug.txt          |  2 +-
 Documentation/process/index.rst               |  1 +
 Documentation/security/index.rst              |  2 ++
 .../translations/ko_KR/memory-barriers.txt    |  4 +--
 drivers/video/fbdev/core/modedb.c             | 22 ++++++++--------
 drivers/w1/w1_io.c                            |  1 +
 include/linux/iio/iio.h                       | 24 ++++++++---------
 include/linux/mtd/rawnand.h                   | 26 +++++++++++++------
 include/linux/rcupdate.h                      |  5 ++--
 include/linux/wait.h                          |  2 +-
 include/net/mac80211.h                        |  2 +-
 kernel/time/timer.c                           | 14 +++++-----
 31 files changed, 93 insertions(+), 75 deletions(-)
 rename Documentation/{bcache.txt => admin-guide/bcache.rst} (100%)
 rename Documentation/{cgroup-v2.txt => admin-guide/cgroup-v2.rst} (100%)
 rename Documentation/{cachetlb.txt => core-api/cachetlb.rst} (100%)
 rename Documentation/{circular-buffers.txt => core-api/circular-buffers.rst} (100%)
 rename Documentation/{clk.txt => driver-api/clk.rst} (100%)

-- 
2.17.0
