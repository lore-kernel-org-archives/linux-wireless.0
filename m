Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:56458 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755892Ab1BIOp0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Feb 2011 09:45:26 -0500
Date: Wed, 9 Feb 2011 09:42:26 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
Cc: linux-wireless@vger.kernel.org, lrodriguez@atheros.com
Subject: Re: [RFC] ath9k: Fix ath9k prevents CPU to enter C3 states
Message-ID: <20110209144225.GC2494@tuxdriver.com>
References: <1297262007-15128-1-git-send-email-mshajakhan@atheros.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1297262007-15128-1-git-send-email-mshajakhan@atheros.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Feb 09, 2011 at 08:03:27PM +0530, Mohammed Shafi Shajakhan wrote:
> From: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>
> 
> The DMA latency issue is observed only in Intel pinetrail platforms but
> in the driver we had a default PM-QOS value of 55. This caused
> unnecessary power consumption and battery drain in other platforms.
> Address this issue by disabling PM-QOS by default by setting it's value
> as '0' and making code changes appropriately.This addresses the bug:
> https://bugzilla.kernel.org/show_bug.cgi?id=27532
> 	If the user sees some DMA latency issue he can still use the pmqos as a
> module parameter to trade power for throughput as below:
> sudo modprobe ath9k pmqos=55
> 
> Signed-off-by: Mohammed Shafi Shajakhan <mshajakhan@atheros.com>

Seems a bit unclear to me -- if you have ath9k_pm_qos_value then why
use ATH9K_PM_QOS_DEFAULT_VALUE at all?

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
