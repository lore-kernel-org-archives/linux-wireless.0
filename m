Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx4.wp.pl ([212.77.101.12]:40563 "EHLO mx4.wp.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751839AbbBFJF3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 6 Feb 2015 04:05:29 -0500
Date: Fri, 6 Feb 2015 09:58:46 +0100
From: Jakub =?UTF-8?B?S2ljacWEc2tp?= <moorray3@wp.pl>
To: Peter Oh <poh@qca.qualcomm.com>
Cc: <ath10k@lists.infradead.org>, <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v2] ath10k: Replace ioread with mb to drain write buffer
Message-ID: <20150206095846.5d46f11e@north> (sfid-20150206_100536_624377_E1DAF748)
In-Reply-To: <7a87e5df81499e4d26a4f8bedf76ed3250a6f7bb.1422663244.git.poh@qca.qualcomm.com>
References: <7a87e5df81499e4d26a4f8bedf76ed3250a6f7bb.1422663244.git.poh@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 30 Jan 2015 16:14:30 -0800, Peter Oh wrote:
> Using ioread() to perform draining write buffer is excessive.
> Use compact API, mb(), that intended to be used for the case.
> It reduces total 14 CPU clocks per interrupt.
>
> Signed-off-by: Peter Oh <poh@qca.qualcomm.com>

I have no idea what the code does but this change looks suspicious. 
Usually the point of ioread() is to flush the interconnect buffers 
while mb() ensures ordering only from the CPU perspective.

Could you provide the reason *why* flushing buffers is unnecessary
in the commit message?
