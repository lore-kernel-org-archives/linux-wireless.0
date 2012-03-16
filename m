Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:44839 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030769Ab2CPMxB (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 16 Mar 2012 08:53:01 -0400
Subject: Re: [RFC 1/3] mac80211: do not scan and monitor connection in
 parallel
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1331899378-10543-1-git-send-email-sgruszka@redhat.com>
References: <1331899378-10543-1-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 16 Mar 2012 13:52:58 +0100
Message-ID: <1331902378.6753.3.camel@jlt3.sipsolutions.net> (sfid-20120316_135306_225400_2696D67F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-03-16 at 13:02 +0100, Stanislaw Gruszka wrote:
> Before we send probes in connection monitoring we check if scan is not
> pending. But we do that check without locking. Fix that and also do not
> start scan if connection monitoring is in progress.

Wouldn't it be easier to just abort the check instead of deferring the
scan?

johannes


