Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52945 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750929AbcGUHKA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jul 2016 03:10:00 -0400
Date: Thu, 21 Jul 2016 09:09:39 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Michal Kazior <michal.kazior@tieto.com>
Cc: kvalo@qca.qualcomm.com, linux-wireless@vger.kernel.org,
	ath10k@lists.infradead.org
Subject: Re: [RFC] ath10k: silence firmware file probing warnings
Message-ID: <20160721070938.GA2658@redhat.com> (sfid-20160721_091003_936981_8F08E07D)
References: <1468933237-5226-1-git-send-email-michal.kazior@tieto.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1468933237-5226-1-git-send-email-michal.kazior@tieto.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jul 19, 2016 at 03:00:37PM +0200, Michal Kazior wrote:
> Firmware files are versioned to prevent older
> driver instances to load unsupported firmware
> blobs. This is reflected with a fallback logic
> which attempts to load several firmware files.
> 
> This however produced a lot of unnecessary
> warnings sometimes confusing users and leading
> them to rename firmware files making things even
> more confusing.

This happens on kernels configured with
CONFIG_FW_LOADER_USER_HELPER_FALLBACK and cause not only ugly warnings,
but also 60 seconds delay before loading next firmware version.
For some reason RHEL kernel needs above config option, so this
patch is very welcome from my perspective.

Stanislaw
