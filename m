Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:52210 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753369Ab1CLNvk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 12 Mar 2011 08:51:40 -0500
Message-ID: <4D7B7A68.2090900@openwrt.org>
Date: Sat, 12 Mar 2011 14:51:36 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Vasanthakumar Thiagarajan <vasanth@atheros.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linville@tuxdriver.com" <linville@tuxdriver.com>,
	Luis Rodriguez <Luis.Rodriguez@Atheros.com>
Subject: Re: [PATCH] ath9k: fix aggregation related interoperability issues
References: <1299888688-25201-1-git-send-email-nbd@openwrt.org> <20110312062632.GA6049@vasanth-laptop>
In-Reply-To: <20110312062632.GA6049@vasanth-laptop>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-03-12 7:26 AM, Vasanthakumar Thiagarajan wrote:
> On Sat, Mar 12, 2011 at 05:41:28AM +0530, Felix Fietkau wrote:
>> Some clients seems to keep track of their reorder window even after an
>> aggregation session has been disabled. This causes issues if there are
>> still retried but not completed frames pending for the TID.
>> To ensure that rx does not stall in such situations, set sendbar to 1
>> for any frame purged from the TID queue on teardown.
> 
> Once decided to to terminate the aggr session, sending a delba for that tid
> seems to be the right thing.
The session is terminated properly through a DELBA either way, my patch
only affects what happens to frames during the cleanup, as some clients
seem to have issues here. User reports confirm that this patch
significantly improves connection stability.

- Felix
