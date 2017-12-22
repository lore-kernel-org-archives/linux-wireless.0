Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:38680 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751349AbdLVGDI (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 22 Dec 2017 01:03:08 -0500
Received: from mail-it0-f70.google.com ([209.85.214.70])
        by youngberry.canonical.com with esmtps (TLS1.0:RSA_AES_128_CBC_SHA1:16)
        (Exim 4.76)
        (envelope-from <seth.forshee@canonical.com>)
        id 1eSGQE-0002dI-Vd
        for linux-wireless@vger.kernel.org; Fri, 22 Dec 2017 06:03:07 +0000
Received: by mail-it0-f70.google.com with SMTP id a3so9799276itg.7
        for <linux-wireless@vger.kernel.org>; Thu, 21 Dec 2017 22:03:06 -0800 (PST)
From: Seth Forshee <seth.forshee@canonical.com>
To: linux-wireless@vger.kernel.org, wireless-regdb@lists.infradead.org
Cc: Johannes Berg <johannes@sipsolutions.net>
Subject: [PATCH 0/6] wireless-regdb: Support for new binary database format
Date: Fri, 22 Dec 2017 00:02:57 -0600
Message-Id: <20171222060303.14478-1-seth.forshee@canonical.com> (sfid-20171222_070343_262039_288D675B)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series starts with Johannes' patch for generating regulatory
databases using the new format and adds various fixes and pieces which
were missing such as installation to the firmware path, manual page
updates, etc. It also restores support for the older database format to
maintain compatibility with using CRDA on older kernels.

I've tested the results with 4.15 and things look to be working. I want
to apply this in the next couple of days and get a new release out, so
please let me know soon if you seen any issues.

Thanks,
Seth

Johannes Berg (1):
  regdb: write firmware file format (version code 20)

Seth Forshee (5):
  wireless-regdb: Restore generation of old format database files
  wireless-regdb: Add sforshee's x509 certificate
  wireless-regdb: Better support for generating public certificates
  wireless-regdb: Install regulatory.db and regulatory.db.p7s to
    /lib/firmware
  wireless-regdb: Document regulatory.db in the manual page

 Makefile          |  37 +++++++++++----
 README            |   4 +-
 db2fw.py          | 133 ++++++++++++++++++++++++++++++++++++++++++++++++++++++
 gen-pubcert.sh    |  18 ++++++++
 regulatory.bin.5  |  32 +++++++++----
 regulatory.db.5   |   1 +
 sforshee.x509.pem |  17 +++++++
 7 files changed, 220 insertions(+), 22 deletions(-)
 create mode 100755 db2fw.py
 create mode 100755 gen-pubcert.sh
 create mode 100644 regulatory.db.5
 create mode 100644 sforshee.x509.pem
