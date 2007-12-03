Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.gmx.net ([213.165.64.20]:36897 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1752904AbXLCLb7 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Dec 2007 06:31:59 -0500
Subject: Re: [RFC][PATCH] mac80211: Use PID controller for TX rate control
From: Mattias Nissler <mattias.nissler@gmx.de>
To: Tomas Winkler <tomasw@gmail.com>
Cc: Stefano Brivio <stefano.brivio@polimi.it>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	"John W. Linville" <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>
In-Reply-To: <1ba2fa240712030321g58b8df39y24240c63facba2cd@mail.gmail.com>
References: <1196622331.7472.4.camel@localhost>
	 <20071203041608.3af3b462@morte> <1196679780.7470.9.camel@localhost>
	 <1ba2fa240712030321g58b8df39y24240c63facba2cd@mail.gmail.com>
Content-Type: text/plain
Date: Mon, 03 Dec 2007 12:31:54 +0100
Message-Id: <1196681514.7470.12.camel@localhost> (sfid-20071203_113202_821990_B556BF25)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Mon, 2007-12-03 at 13:21 +0200, Tomas Winkler wrote:
> A little suggestion, maybe instead of overriding the simple algorithm
> you should create new let say pid_controler rate scale algorithm.  It
> doesn't look simple anymore :)

I already thought so. But the original "simple" algorithm is totally
broken in most cases. Well, maybe except the cases perfect situation ->
no tx failures -> full rate and bad situation -> lots of tx failures ->
lowest rate. IMHO, we should just get rid of the old simple algorithm.

Mattias

