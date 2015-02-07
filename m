Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.w1.fi ([212.71.239.96]:55752 "EHLO
	li674-96.members.linode.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754781AbbBGL6C (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 7 Feb 2015 06:58:02 -0500
Date: Sat, 7 Feb 2015 13:57:58 +0200
From: Jouni Malinen <j@w1.fi>
To: Eliad Peller <eliad@wizery.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH v2 3/3] mac80211: don't defer scans in case of radar
 detection
Message-ID: <20150207115758.GA503@w1.fi> (sfid-20150207_125806_988414_A00AA915)
References: <1420645811-17877-1-git-send-email-eliad@wizery.com>
 <1420645811-17877-3-git-send-email-eliad@wizery.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1420645811-17877-3-git-send-email-eliad@wizery.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 07, 2015 at 05:50:11PM +0200, Eliad Peller wrote:
> Radar detection can last indefinite time. There is no
> point in deferring a scan request in this case - simply
> return -EBUSY.

> diff --git a/net/mac80211/scan.c b/net/mac80211/scan.c
> @@ -505,7 +505,7 @@ static int __ieee80211_start_scan(struct ieee80211_sub_if_data *sdata,
> -	if (local->scan_req)
> +	if (local->scan_req || ieee80211_is_radar_required(local))
>  		return -EBUSY;

This seems to be breaking a hwsim test case sequence of ap_vht80plus80
followed by ap_vht80. In such a case, all the HT40 scans for ap_vht80
fail due to this added condition resulting in -EBUSY being returned
every time. It looks like this happens even if I change ap_vht80 to use
the same country code (US) as ap_vht80plus80, so the change in the
country code does not explain this either.

I'm not sure what is causing the issue here, but it looks like something
in ap_vht80plus80 (i.e., an attempt to enable a channel combination that
would require DFS on one of the 80 MHz segments) leaves behind state
that makes ieee80211_is_radar_required(local) return true even when it
shouldn't. DFS for 80+80 is not yet supported, so I'd assume this is
somehow related to that. Anyway, I don't think mac80211 should behave in
this way.
 
-- 
Jouni Malinen                                            PGP id EFC895FA
