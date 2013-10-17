Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:43737 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755305Ab3JQNjU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Oct 2013 09:39:20 -0400
Message-ID: <1382017156.14410.1.camel@jlt4.sipsolutions.net> (sfid-20131017_153922_818401_B9D8C99F)
Subject: Re: [PATCH 3.12] mac80211: disable WMM with invalid parameters
From: Johannes Berg <johannes@sipsolutions.net>
To: linux-wireless@vger.kernel.org
Cc: Antonio Quartulli <antonio@meshcoding.com>
Date: Thu, 17 Oct 2013 15:39:16 +0200
In-Reply-To: <1381995881-16935-1-git-send-email-johannes@sipsolutions.net> (sfid-20131017_100807_627538_36C9C531)
References: <1381995881-16935-1-git-send-email-johannes@sipsolutions.net>
	 (sfid-20131017_100807_627538_36C9C531)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-10-17 at 09:44 +0200, Johannes Berg wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> Some APs (notably a Sitecom WL-153 v1 with firmware 1.45) are sending
> invalid WMM parameters setting AIFSN, ECWmin and ECWmax to zero. The
> spec mandates that the value of AIFSN is at least 2, and some cards
> (e.g. Intel with the iwldvm driver) can't transmit when the invalid
> QoS parameters are actually uploaded to the firmware.
> 
> Since there's little chance of being able to guess the values that
> the AP actually meant, disable WMM if such an invalid case is found.
> Since ECWmin/ECWmax are allowed to be zero, only verify AIFSN >= 2
> and ECWmin <= ECWmax.

I've applied a fixed version.

johannes

