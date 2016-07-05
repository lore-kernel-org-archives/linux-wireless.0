Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from paleale.coelho.fi ([176.9.41.70]:33022 "EHLO
	farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752611AbcGEOMW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Jul 2016 10:12:22 -0400
Message-ID: <1467727939.4193.3.camel@coelho.fi> (sfid-20160705_161225_090483_4DC3CDCB)
From: Luca Coelho <luca@coelho.fi>
To: johannes@sipsolutions.net
Cc: linux-wireless@vger.kernel.org,
	Avraham Stern <avraham.stern@intel.com>,
	Assaf Krauss <assaf.krauss@intel.com>,
	David Spinadel <david.spinadel@intel.com>
Date: Tue, 05 Jul 2016 17:12:19 +0300
In-Reply-To: <1467727813-2196-1-git-send-email-luca@coelho.fi>
References: <1467721394-8195-5-git-send-email-luca@coelho.fi>
	 <1467727813-2196-1-git-send-email-luca@coelho.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Subject: Re: [PATCH v2] nl80211: Add info to scan results to support beacon
 report
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2016-07-05 at 17:10 +0300, Luca Coelho wrote:
> From: Avraham Stern <avraham.stern@intel.com>
> 
> Beacon report radio measurement requires reporting observed BSSs
> on the channels specified in the beacon request. If the measurement
> mode is set to passive or active, it requires actually performing a
> scan (passive or active, accordingly), and reporting the time that
> the scan was started and the time each beacon/probe was received
> (both in terms of TSF of the BSS of the requesting AP). If the
> request mode is table, this information is optional.
> In addition, the radio measurement request specifies the channel
> dwell time for the measurement.
> 
> In order to use scan for beacon report when the mode is active or
> passive, add a parameter to scan request that specifies the
> channel dwell time, and add scan start time and beacon received time
> to scan results information.
> 
> Supporting beacon report is required for Multi Band Operation (MBO).
> 
> Signed-off-by: Assaf Krauss <assaf.krauss@intel.com>
> Signed-off-by: David Spinadel <david.spinadel@intel.com>
> Signed-off-by: Avraham Stern <avraham.stern@intel.com>
> Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
> ---

Forgot to say, the non-mac80211 driver changes are just compiled-
tested.

--
Luca.
