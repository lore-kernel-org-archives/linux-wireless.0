Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:57548 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752673AbbFJJyM (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Jun 2015 05:54:12 -0400
Message-ID: <1433930048.3145.0.camel@sipsolutions.net> (sfid-20150610_115416_930993_D11ED82A)
Subject: Re: [PATCH v2] mac80211: Fix a case of incorrect metric used when
 forwarding a PREQ
From: Johannes Berg <johannes@sipsolutions.net>
To: agreen@cococorp.com
Cc: linux-wireless@vger.kernel.org, Jesse Jones <jjones@cococorp.com>
Date: Wed, 10 Jun 2015 11:54:08 +0200
In-Reply-To: <557774B8.6000702@cococorp.com> (sfid-20150610_012050_857822_799081EF)
References: <557774B8.6000702@cococorp.com>
	 (sfid-20150610_012050_857822_799081EF)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2015-06-09 at 16:20 -0700, Alexis Green wrote:
> This patch fixes a bug in hwmp_preq_frame_process where the wrong metric
> can be used when forwarding a PREQ. This happens because the code uses
> the same metric variable to record the value of the metric to the source
> of the PREQ and the value of the metric to the target of the PREQ.
> 
> This comes into play when both reply and forward are set which happens
> when IEEE80211_PREQ_PROACTIVE_PREP_FLAG is set and when MP_F_DO | MP_F_RF
> is set. The original code had a special case to handle the first case
> but not the second.
> 
> The patch uses distinct variables for the two metrics which makes the
> code flow much clearer and removes the need to restore the original
> value of metric when forwarding.

Applied, thanks.

johannes

