Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:35577 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751101AbbFKLda (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jun 2015 07:33:30 -0400
Message-ID: <1434022407.1915.10.camel@sipsolutions.net> (sfid-20150611_133333_747988_E093E01F)
Subject: Re: [PATCHv2 1/4] cfg80211: handle minimum bandwidth for quarter
 and half rates
From: Johannes Berg <johannes@sipsolutions.net>
To: Matthias May <matthias.may@neratec.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 11 Jun 2015 13:33:27 +0200
In-Reply-To: <1434020791-16291-2-git-send-email-matthias.may@neratec.com> (sfid-20150611_130650_868019_E29B6AA4)
References: <1434020791-16291-1-git-send-email-matthias.may@neratec.com>
	 <1434020791-16291-2-git-send-email-matthias.may@neratec.com>
	 (sfid-20150611_130650_868019_E29B6AA4)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2015-06-11 at 13:06 +0200, Matthias May wrote:
> This patch changes the API of freq_freq_info() to take as additional argument
> the minimum bandwidth the caller can handle.
> If multiple rules match, the match with the widest bandwidth is returned.

You can't make a patch like this that breaks the compile - all these
need to be a single patch.

That said, you could get away with not changing the public
freq_reg_info() API since the callers thereof don't need it, you could
make a __freq_reg_info() that has the bandwidth and freq_reg_info() that
doesn't.

johannes

