Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:32818 "EHLO
	mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210AbcFXMe6 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jun 2016 08:34:58 -0400
Received: by mail-wm0-f68.google.com with SMTP id r201so4641309wme.0
        for <linux-wireless@vger.kernel.org>; Fri, 24 Jun 2016 05:34:57 -0700 (PDT)
From: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
To: ath9k-devel@qca.qualcomm.com, linux-wireless@vger.kernel.org,
	ath9k-devel@lists.ath9k.org
Cc: nbd@nbd.name, chunkeey@googlemail.com, mark.rutland@arm.com,
	robh+dt@kernel.org, arend.vanspriel@broadcom.com
Subject: [RFC v3] ath9k: add devicetree support to ath9k
Date: Fri, 24 Jun 2016 14:34:27 +0200
Message-Id: <20160624123430.4097-1-martin.blumenstingl@googlemail.com> (sfid-20160624_143502_526013_AAC452C2)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This series adds support for configuring ath9k based devices via
devicetree. This was tested on PCI(e) based devices. This should work
for AHB based devices as well as soon as the ath79 platform is ready
to populate the ath9k wmac via devicetree.

This series depends on my previous series:
"ath9k: extend and improve handling of ath9k_platform_data"

changes in v1 -> v2:
This addresses all issues found by Christian Lamparter (thanks!), the
detailed changes are documented in each patch.

changes in v2 -> v3:
The qca,eeprom-name was property was replaced by qca,no-eeprom, which
moves the filename for the eeprom firmware from the devicetree to ath9k
(where the filename is now auto-generated). Additionally this contains
fixes for the documentation (some properties were missing, an invalid
property in the example, etc.). The detailed changes are documented in
each patch.

