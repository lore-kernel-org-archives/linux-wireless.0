Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:58292 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752368Ab3F2UIq (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 29 Jun 2013 16:08:46 -0400
Message-ID: <51CF3EC9.3000707@openwrt.org> (sfid-20130629_220849_160124_826ACAE2)
Date: Sat, 29 Jun 2013 22:08:41 +0200
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Jean-Pierre Tosoni <jp.tosoni@acksys.fr>
CC: linux-wireless@vger.kernel.org
Subject: Re: [RFC v2] mac80211: Use libnl-configurable values for retry counts
References: <1372351227-25575-1-git-send-email-jp.tosoni@acksys.fr>
In-Reply-To: <1372351227-25575-1-git-send-email-jp.tosoni@acksys.fr>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2013-06-27 6:40 PM, Jean-Pierre Tosoni wrote:
> From: J.P. Tosoni <jp.tosoni@acksys.fr>
> 
> In the rate control algorithms, the maximum retry count is limited by
> a) a constant value obtained from the hardware driver
> b) a constant limit (6ms) on the time allowed for all
>    retries of each frame.
> 
> Replace the retry count by existing configurable values from nl80211.
> Use wiphy->retry_long for frames whose length exceed rts_threshold.
> Use wiphy->retry_short for all other frames.
> Check that the configured value does not exceed driver capabilities.
> Use the new values as soon as the next frame is transmitted.
> 
> Caveat: the retry count for frames sent outside the context of a STA is
> still taken from the hardware driver.
> ---
> What I am seeking with this patch:
> I believe the configuration of the retries will help making recovery
> much faster when an AP (in infrastructure mode) or a peer (in mesh
> mode) suddenly disappears.
I'm all for reducing retries, but I think the way you're applying the
limit is problematic.
If minstrel decides to use many retries for a high rate and you're
simply cutting off all retries that exceed the configured limit, you're
potentially inviting quite a bit of unnecessary packet loss.
I'm planning to remove the use of retry rate slot 4 (fallback to lowest
rate) from minstrel, since max_prob_rate should already provide quite
decent reliability.

- Felix
