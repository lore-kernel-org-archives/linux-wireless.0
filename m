Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:36850 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751387AbbFKPWc (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 11 Jun 2015 11:22:32 -0400
Message-ID: <1434036149.1915.15.camel@sipsolutions.net> (sfid-20150611_172235_580985_E2E58432)
Subject: Re: [PATCHv2 1/4] cfg80211: handle minimum bandwidth for quarter
 and half rates
From: Johannes Berg <johannes@sipsolutions.net>
To: Matthias May <matthias.may@neratec.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 11 Jun 2015 17:22:29 +0200
In-Reply-To: <5579831F.3020304@neratec.com>
References: <1434020791-16291-1-git-send-email-matthias.may@neratec.com>
		 <1434020791-16291-2-git-send-email-matthias.may@neratec.com>
		 (sfid-20150611_130650_868019_E29B6AA4) <1434023059.1915.12.camel@sipsolutions.net>
	 <5579831F.3020304@neratec.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2015-06-11 at 14:46 +0200, Matthias May wrote:

> Using the dummy country code:
> country XS: DFS-UNSET
>      (5170 - 5180 @ 5), (N/A, 14), (N/A)
>      (5175 - 5185 @ 10), (N/A, 17), (N/A)
>      (5170 - 5190 @ 20), (N/A, 20), (N/A)
> 
> For a center freq of 5175
> The first loop finds the first rule. --> we want this.
> The second loop doesn't find anything.
> The third loop doesn't find anything.
> 
> However for a center freq of 5180
> The first loop find the first rule
> The second loop find the second rule
> The third loop find the third rule. --> We want this
> 
> If there are different overlapping rules for the different bandwidths 
> different results can be returned, especially at the border of a 
> frequency range.

Hmmm. Can we just forbid those overlapping rules, and say you want
AUTO-BW?

I mean, do you see a reason for this otherwise?

johannes

