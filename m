Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:59433 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752843Ab1AXOaI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Jan 2011 09:30:08 -0500
Date: Mon, 24 Jan 2011 09:21:54 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Helmut Schaa <helmut.schaa@googlemail.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: Survey data inconsistencies between drivers
Message-ID: <20110124142153.GA10676@tuxdriver.com>
References: <201101241229.50142.helmut.schaa@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201101241229.50142.helmut.schaa@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 24, 2011 at 12:29:49PM +0100, Helmut Schaa wrote:

> In order to have consistent survey data between drivers I'd propose the
> following approach:
> 
> - The driver's get_survey callback only returns relative survey data for the
>   currently active channel. That means reading the current busy time statistics
>   from the hw and clearing the appropriate counters.
> - mac80211 would keep track of accumulating the gathered survey data.
> - mac80211 would read the survey data before each channel change and update
>   the approriate channel's survey data just as ath9k does right now.
> 
> Any arguments against such a unification?

Sounds reasonable to me.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
