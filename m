Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:38896 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751875AbdATMv3 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 20 Jan 2017 07:51:29 -0500
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Subject: Re: [RFC] ath10k: silence firmware file probing warnings
From: Kalle Valo <kvalo@qca.qualcomm.com>
In-Reply-To: <1468933237-5226-1-git-send-email-michal.kazior@tieto.com>
References: <1468933237-5226-1-git-send-email-michal.kazior@tieto.com>
To: Michal Kazior <michal.kazior@tieto.com>
CC: <linux-wireless@vger.kernel.org>, <ath10k@lists.infradead.org>
Message-ID: <6e5d0596c4af46668c02356ba17a4e5f@euamsexm01a.eu.qualcomm.com> (sfid-20170120_135133_230591_184AC667)
Date: Fri, 20 Jan 2017 13:51:22 +0100
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Michal Kazior <michal.kazior@tieto.com> wrote:
> Firmware files are versioned to prevent older
> driver instances to load unsupported firmware
> blobs. This is reflected with a fallback logic
> which attempts to load several firmware files.
> 
> This however produced a lot of unnecessary
> warnings sometimes confusing users and leading
> them to rename firmware files making things even
> more confusing.
> 
> Hence use request_firmware_direct() which does not
> produce extra warnings. This shouldn't really
> break anything because most modern systems don't
> rely on udev/hotplug helpers to load firmware
> files anymore.
> 
> Signed-off-by: Michal Kazior <michal.kazior@tieto.com>

This ended into a rather long discussion, see the full thread from the patchwork link
below, but I'll try to summarise it here:

* Nobody stepped up and mentioned that they need/use the user fallback helper with ath10k.

* Felix confirmed that LEDE creates the calibration file before loading ath10k
  so this should not break LEDE.

* This also fixes a 60 second delay per _each_ unexistent firmware/calibration
  file with distros which have CONFIG_FW_LOADER_USER_HELPER_FALLBACK enabled,
  RHEL being a notable example. Using ath10k with firmware-2.bin this might
  end up into a five minute delay in boot.

* Luis is working on new drvdata interface for kernel, but that's not merged yet.

Based on this I think the right approach is to apply this patch. Any concerns?

While writing this I started to suspect is it just by accident that
request_firmware_direct() does not print any error messages and
request_firmware() again does print those? Let's hope nobody decides to change
that.  And at least Luis' drvdata interface has a documented 'optional' flag,
so we can always switch to using that (once it's merged):

* struct drvdata_req_params - driver data request parameters
* @optional: if true it is not a hard requirement by the caller that this
*	file be present. An error will not be recorded if the file is not
*	found.

Michal, do you mind if I'll add more info to the commit log and submit this RFC
as a proper patch? It still seems to apply and work just fine.

-- 
https://patchwork.kernel.org/patch/9237095/

Documentation about submitting wireless patches and checking status
from patchwork:

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
