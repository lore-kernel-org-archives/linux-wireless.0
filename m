Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bues.ch ([80.190.117.144]:53382 "EHLO bues.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751250Ab1JQOYw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 17 Oct 2011 10:24:52 -0400
Date: Mon, 17 Oct 2011 16:24:47 +0200
From: Michael =?UTF-8?B?QsO8c2No?= <m@bues.ch>
To: =?UTF-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>,
	b43-dev@lists.infradead.org
Subject: Re: [PATCH 3.2] b43: fill ctl1 word on all new PHYs, fix PHY errors
Message-ID: <20111017162447.5a758fda@milhouse> (sfid-20111017_162456_414015_9E9CE029)
In-Reply-To: <1318800236-5329-1-git-send-email-zajec5@gmail.com>
References: <1318800236-5329-1-git-send-email-zajec5@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 16 Oct 2011 23:23:56 +0200
Rafał Miłecki <zajec5@gmail.com> wrote:

> +	if (phy->type >= B43_PHYTYPE_N) {

I must say that I really dislike this. It's error prone (previous patch got it wrong)
and it's hard to read. Just spell out all types or use a switch statement, as appropriate.
It also makes grepping the sources a lot harder.
I don't see any real advantage.

-- 
Greetings, Michael.
