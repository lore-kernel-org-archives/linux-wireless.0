Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:41217 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752571Ab0IAK7c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 1 Sep 2010 06:59:32 -0400
Subject: Re: [PATCH w-t] iwlwifi: rewrite iwl-scan.c to avoid race
 conditions
From: Johannes Berg <johannes@sipsolutions.net>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
	Reinette Chatre <reinette.chatre@intel.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
In-Reply-To: <20100831150021.GA10963@redhat.com>
References: <20100831150021.GA10963@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 01 Sep 2010 12:59:20 +0200
Message-ID: <1283338760.4131.22.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2010-08-31 at 17:00 +0200, Stanislaw Gruszka wrote:

> Scan works have now custom workqueue to allow scan functions
> to run in parallel with other iwlwifi works, which could wait
> for scan abort finish.

Do we really need a complete workqueue? It seems like the relevant work
structs that really do need to be waited for from the workqueue can be
queued with schedule_work? Shouldn't that only be a few of them anyway?

johannes

