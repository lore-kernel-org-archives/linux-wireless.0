Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pf0-f179.google.com ([209.85.192.179]:34144 "EHLO
	mail-pf0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750777AbbL1Bee (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Dec 2015 20:34:34 -0500
Received: by mail-pf0-f179.google.com with SMTP id e65so52750182pfe.1
        for <linux-wireless@vger.kernel.org>; Sun, 27 Dec 2015 17:34:34 -0800 (PST)
From: Bjorn Andersson <bjorn@kryo.se>
To: Eugene Krasnikov <k.eugene.e@gmail.com>,
	Kalle Valo <kvalo@codeaurora.org>
Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>,
	Mark Rutland <mark.rutland@arm.com>,
	Pawel Moll <pawel.moll@arm.com>,
	Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org,
	fengwei.yin@linaro.org, linux-arm-msm@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
	netdev@vger.kernel.org, wcn36xx@lists.infradead.org
Subject: [PATCH 0/4] WCN36xx convert to mainline SMD interface
Date: Sun, 27 Dec 2015 17:34:23 -0800
Message-Id: <1451266467-15377-1-git-send-email-bjorn.andersson@sonymobile.com> (sfid-20151228_023440_064971_D06CB4B1)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The mainline kernel now has the necessary implementations for SMD, SMSM and
WCNSS_CTRL. This series provides the changes necessary for the wcn36xx driver
to utilize this infrastructure and make this driver work in mainline.


A driver for loading the WCNSS firmware, through remoteproc, has been posted
here [1]. Upon starting this the necessary SMD channels will be registered,
which triggers the probe of the wcn36xx driver.

With this, the only missing piece for having fully working Qualcomm WiFi in
mainline is the RPM clock-controller, needed by the remoteproc driver for doing
XO calibration during boot of the WCNSS core. This is being worked on
separately.

[1] https://lkml.org/lkml/2015/12/27/185

Bjorn Andersson (4):
  wcn36xx: Fold indication payload into message header
  wcn36xx: Change indication list lock to spinlock
  wcn36xx: Transition driver to SMD client
  dt: binding: Add Qualcomm wcn36xx WiFi binding

 .../bindings/net/wireless/qcom,wcn36xx-wifi.txt    |  76 ++++++++++++++
 drivers/net/wireless/ath/wcn36xx/Kconfig           |   2 +-
 drivers/net/wireless/ath/wcn36xx/dxe.c             |  16 +--
 drivers/net/wireless/ath/wcn36xx/main.c            | 111 ++++++++++++---------
 drivers/net/wireless/ath/wcn36xx/smd.c             |  51 +++++-----
 drivers/net/wireless/ath/wcn36xx/smd.h             |   6 +-
 drivers/net/wireless/ath/wcn36xx/wcn36xx.h         |  23 ++---
 7 files changed, 188 insertions(+), 97 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/net/wireless/qcom,wcn36xx-wifi.txt

-- 
2.5.0

