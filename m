Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.atheros.com ([12.19.149.2]:27996 "EHLO mail.atheros.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751299Ab1CLG0l (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Mar 2011 01:26:41 -0500
Received: from mail.atheros.com ([10.10.20.107])
	by sidewinder.atheros.com
	for <linux-wireless@vger.kernel.org>; Fri, 11 Mar 2011 22:26:18 -0800
Date: Sat, 12 Mar 2011 11:56:32 +0530
From: Vasanthakumar Thiagarajan <vasanth@atheros.com>
To: Felix Fietkau <nbd@openwrt.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>
Subject: Re: [PATCH] ath9k: fix aggregation related interoperability issues
Message-ID: <20110312062632.GA6049@vasanth-laptop>
References: <1299888688-25201-1-git-send-email-nbd@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1299888688-25201-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Mar 12, 2011 at 05:41:28AM +0530, Felix Fietkau wrote:
> Some clients seems to keep track of their reorder window even after an
> aggregation session has been disabled. This causes issues if there are
> still retried but not completed frames pending for the TID.
> To ensure that rx does not stall in such situations, set sendbar to 1
> for any frame purged from the TID queue on teardown.

Once decided to to terminate the aggr session, sending a delba for that tid
seems to be the right thing.

Vasanth
