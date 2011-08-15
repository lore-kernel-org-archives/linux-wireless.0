Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:24614 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751633Ab1HOKxP (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Aug 2011 06:53:15 -0400
Date: Mon, 15 Aug 2011 12:51:48 +0200
From: Stanislaw Gruszka <sgruszka@redhat.com>
To: Felix Fietkau <nbd@openwrt.org>
Cc: linux-wireless@vger.kernel.org, linville@tuxdriver.com,
	lrodriguez@atheros.com
Subject: Re: [PATCH] ath9k: remove a bogus WARN_ON
Message-ID: <20110815105146.GA15300@redhat.com> (sfid-20110815_125318_985304_91BBFA1D)
References: <1313252029-17665-1-git-send-email-nbd@openwrt.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1313252029-17665-1-git-send-email-nbd@openwrt.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Aug 13, 2011 at 10:13:49AM -0600, Felix Fietkau wrote:
> On embedded hardware it's normal to not have a PCI device for the PCI
> bridge that the wifi card is attached to. pdev->bus->self will be
> NULL in that case. In that case, simply return without emitting an
> useless kernel stack trace.

Patch is obviously ok, ACK. However I'm not sure if we should not
do anything regarding ASPM. Perhaps there is other way to find out
pcie parent ASPM settings on embedded systems?

Stanislaw
