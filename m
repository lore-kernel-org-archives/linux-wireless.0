Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga09.intel.com ([134.134.136.24]:43326 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752095Ab1CDREp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 4 Mar 2011 12:04:45 -0500
Subject: Re: [PATCH 3/3] iwlwifi: avoid too frequent recover from statistics
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1299257511-5241-3-git-send-email-sgruszka@redhat.com>
References: <1299257511-5241-1-git-send-email-sgruszka@redhat.com>
	 <1299257511-5241-3-git-send-email-sgruszka@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 04 Mar 2011 08:46:26 -0800
Message-ID: <1299257186.5082.139.camel@wwguy-huron>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Stanislaw,

On Fri, 2011-03-04 at 08:51 -0800, Stanislaw Gruszka wrote:
> Usually H/W generate statistics notify once per about 100ms, but
> sometimes we can receive notify in shorter time, even 2 ms.
> 
> This can be problem for plcp health and ack health checking.
> 
> I.e. with 2 plcp errors happens randomly in 2 ms duration, we
> exceed plcp delta threshold equal to 100 (2*100/2).
> 
> Also checking ack's in short time, can results not necessary false
> positive and firmware reset, for example when channel is noised and
> we do not receive ACKs frames or when remote device does not send
> ACKs at the moment.
> 
> Patch change code to do statistic check and possible recovery only
> if 99ms elapsed from last check. Forced delay should assure we have
> good statistic data to estimate hardware state.
> 
> Signed-off-by: Stanislaw Gruszka <sgruszka@redhat.com>
Acked-by: Wey-Yi Guy <wey-yi.w.guy@intel.com>

this plcp and ack count getting really complicate and not sure really
worth doing it? but ok for now

Wey

