Return-Path: <SRS0=B73O=QI=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PULL_REQUEST,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63445C282D8
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Feb 2019 15:45:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2FE9D218EA
	for <linux-wireless@archiver.kernel.org>; Fri,  1 Feb 2019 15:45:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (1024-bit key) header.d=qca.qualcomm.com header.i=@qca.qualcomm.com header.b="HSz+AU3W"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729564AbfBAPp3 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 1 Feb 2019 10:45:29 -0500
Received: from alexa-out-ams-02.qualcomm.com ([185.23.61.163]:52657 "EHLO
        alexa-out-ams-02.qualcomm.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727308AbfBAPpZ (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 1 Feb 2019 10:45:25 -0500
X-Greylist: delayed 372 seconds by postgrey-1.27 at vger.kernel.org; Fri, 01 Feb 2019 10:45:24 EST
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=qca.qualcomm.com; i=@qca.qualcomm.com; q=dns/txt;
  s=qcdkim; t=1549035924; x=1580571924;
  h=from:to:cc:subject:date:message-id:
   content-transfer-encoding:mime-version;
  bh=B3k4ebMLiqI25wLnnmlM8RuSjuaaIcPdiaoCimR9Afo=;
  b=HSz+AU3WMZGCe9r/0JaszcvZf/7h6dWP/DKTRA+64IN0ByVui8CEkHgx
   UUeQ1O+iZMHXqsOUmUpn5JNx23YSipGqrWgP4kwgJBp/1MCWc21mHyvd5
   ErhZ4zvizj6E/uU8jaR1jw9qvN34paL+pqIO7Kue9TH6N+FJjU3xBs2A6
   E=;
X-IronPort-AV: E=Sophos;i="5.56,549,1539640800"; 
   d="scan'208";a="1910559"
Received: from ironmsg02-ams.qualcomm.com ([10.251.56.3])
  by alexa-out-ams-02.qualcomm.com with ESMTP; 01 Feb 2019 16:39:10 +0100
X-IronPort-AV: E=McAfee;i="5900,7806,9153"; a="7093206"
Received: from euamsexm01e.eu.qualcomm.com ([10.251.127.42])
  by ironmsg02-ams.qualcomm.com with ESMTP/TLS/AES256-SHA; 01 Feb 2019 16:39:09 +0100
Received: from euamsexm01a.eu.qualcomm.com (10.251.127.40) by
 euamsexm01e.eu.qualcomm.com (10.251.127.42) with Microsoft SMTP Server (TLS)
 id 15.0.1395.4; Fri, 1 Feb 2019 16:39:08 +0100
Received: from euamsexm01a.eu.qualcomm.com ([10.251.127.40]) by
 euamsexm01a.eu.qualcomm.com ([10.251.127.40]) with mapi id 15.00.1395.000;
 Fri, 1 Feb 2019 16:39:07 +0100
From:   Kalle Valo <kvalo@qca.qualcomm.com>
To:     "linux-firmware@kernel.org" <linux-firmware@kernel.org>
CC:     "ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: [PULL] ath10k firmware 2019-02-01
Thread-Topic: [PULL] ath10k firmware 2019-02-01
Thread-Index: AQHUukQAKz/jcxW64kS24Cm1Kb/GLw==
Date:   Fri, 1 Feb 2019 15:39:07 +0000
Message-ID: <1549035547599.95403@qca.qualcomm.com>
Accept-Language: en-GB, en-US
Content-Language: en-GB
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [199.106.107.6]
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

Hi,=0A=
=0A=
here are few ath10k firmware updates, please pull.=0A=
=0A=
Kalle=0A=
=0A=
The following changes since commit a8b75cac06f80dc1500ba385680ac5b5c1d1c4f8=
:=0A=
=0A=
  Merge tag 'add-rpi-fw' of ssh://gitolite.kernel.org/pub/scm/linux/kernel/=
git/matthias.bgg/linux-firmware (2019-01-18 07:04:02 -0500)=0A=
=0A=
are available in the git repository at:=0A=
=0A=
  git://git.kernel.org/pub/scm/linux/kernel/git/kvalo/linux-firmware.git at=
h10k-20190201=0A=
=0A=
for you to fetch changes up to 6b5e23a113704867df5205f31f02ffbc3ec4453e:=0A=
=0A=
  ath10k: QCA9984 hw1.0: update firmware-5.bin to 10.4-3.9.0.2-00021 (2019-=
02-01 17:22:55 +0200)=0A=
=0A=
----------------------------------------------------------------=0A=
Kalle Valo (4):=0A=
      ath10k: QCA6174 hw3.0: update board-2.bin=0A=
      ath10k: QCA9888 hw2.0: update firmware-5.bin to 10.4-3.9.0.2-00024=0A=
      ath10k: QCA988X hw2.0: update firmware-5.bin to 10.2.4-1.0-00043=0A=
      ath10k: QCA9984 hw1.0: update firmware-5.bin to 10.4-3.9.0.2-00021=0A=
=0A=
 WHENCE                              |   6 +++---=0A=
 ath10k/QCA6174/hw3.0/board-2.bin    | Bin 551128 -> 567608 bytes=0A=
 ath10k/QCA9888/hw2.0/firmware-5.bin | Bin 675492 -> 688536 bytes=0A=
 ath10k/QCA988X/hw2.0/firmware-5.bin | Bin 248200 -> 248840 bytes=0A=
 ath10k/QCA9984/hw1.0/firmware-5.bin | Bin 662084 -> 676316 bytes=0A=
 5 files changed, 3 insertions(+), 3 deletions(-)=0A=
