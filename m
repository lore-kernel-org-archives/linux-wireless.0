Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.gmx.net ([212.227.17.22]:65408 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751515AbeAWPFX (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 23 Jan 2018 10:05:23 -0500
Received: from mail-ot0-f182.google.com ([74.125.82.182]) by mail.gmx.com
 (mrgmx102 [212.227.17.168]) with ESMTPSA (Nemesis) id
 0M7m0a-1f05QH1ms4-00vMyi for <linux-wireless@vger.kernel.org>; Tue, 23 Jan
 2018 16:05:21 +0100
Received: by mail-ot0-f182.google.com with SMTP id t35so644386otd.13
        for <linux-wireless@vger.kernel.org>; Tue, 23 Jan 2018 07:05:21 -0800 (PST)
MIME-Version: 1.0
Reply-To: cyp@abwesend.de
In-Reply-To: <CALY9mdxV_TyzREiKzARV_pH4gknW983wA+o+wd2GPGNd-1QPrw@mail.gmail.com>
References: <CALY9mdzC06HRmPGF1q5G9Gz7Qc5miww8xuK-1rsGE37yMaQj1Q@mail.gmail.com>
 <1516713855.8658.18.camel@intel.com> <CALY9mdxV_TyzREiKzARV_pH4gknW983wA+o+wd2GPGNd-1QPrw@mail.gmail.com>
From: cyp@abwesend.de
Date: Tue, 23 Jan 2018 16:05:19 +0100
Message-ID: <CALY9mdxTPtvD_gugE=mfWatcCnK1Xe4k9JMMn5-oS6WRSOnW5g@mail.gmail.com> (sfid-20180123_160547_765585_51F40E5A)
Subject: Fwd: iwlegacy: Please change led_mode default to _LED_RF_STATE
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Emmanuel and I are not the maintainers of iwlegacy, so I'm adding
> the linux-wireless mailing list and Stanislaw, who is the actual
> maintainer.

The issue is the same for iwlwifi:
while most iwiwifi device cfgs have  led_mode = IWL_LED_RF_STATE
iwlwifi/cfg/1000.c and iwlwifi/cfg/5000.c   have led_mode = IWL_LED_BLINK,
which in turn causes the led to be configured to blink *by default*
(up to 20x/sec!),
which in turn is a human factor problem if the led is bright and/or in
the user's face.

The (potential) solution is also the same as for iwlegacy:
In iwlwifi/dvm/led.c : iwl_leds_init() : line 183

- if (mode == IWL_LED_DEFAULT)
-              mode = priv->cfg->led_mode;

+  if (mode != IWL_LED_BLINK) /* if user does not explicitly request
blink ... */
+             mode = IWL_LED_RF_STATE; /* then use a stable indicator
for sanity and consistency */


Sebastian's response that I should then update modprobe options is
missing the point.
The point is: defaults ought to be sane to begin with, and (ideally) consistent.
*I* know what to do. Many (most?) users will not, hence the dozens of
requests for help (since 2008!).

Regards,
Cyrus
