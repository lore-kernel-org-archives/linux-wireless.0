Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iw0-f178.google.com ([209.85.223.178]:46631 "EHLO
	mail-iw0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752747AbZI1WSF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 28 Sep 2009 18:18:05 -0400
Received: by iwn8 with SMTP id 8so2802377iwn.33
        for <linux-wireless@vger.kernel.org>; Mon, 28 Sep 2009 15:18:09 -0700 (PDT)
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@gmail.com>
Date: Mon, 28 Sep 2009 15:17:49 -0700
Message-ID: <43e72e890909281517k23abaf8dvd3e84837ce307429@mail.gmail.com>
Subject: Firmware versioning best practices
To: linux-wireless <linux-wireless@vger.kernel.org>
Cc: reinette chatre <reinette.chatre@intel.com>,
	Kalle Valo <kalle.valo@nokia.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Christian Lamparter <chunkeey@web.de>,
	Bob Copeland <me@bobcopeland.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

The ath_hif_usb driver will require the ar9271 firmware file but in
the future an open firmware might become available. The ar9170 driver
already is under the same situation already: a closed firmware is
available but an open firmware can be used, only thing is ar9170 uses
the same firmware name for both. We *could* change ar9170 to use the
Intel practice of tagging a version at the end of each firmware
release, like ar9170-1.fw but ar9170 originally was implemented with a
2-stage firmware requirement and so ar9170-1.fw is already taken.

ar9170 still needs a solution for the different firmwares, once we
start supporting the open firmware through some sort of release but
I'd like to address ath_hif_usb now early so that we don't run into
these snags and use some decent convention that is easy to follow.

As I noted above, Intel seems to use the device-1.fw, device-2.fw
naming convention. Is this the best approach? Or shall we have the
same firmware filename and simply query the firmware for a map of
capabilities? Any other ideas?

  Luis
