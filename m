Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from qw-out-2122.google.com ([74.125.92.24]:34003 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757318AbZEDQRU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 4 May 2009 12:17:20 -0400
MIME-Version: 1.0
In-Reply-To: <1241453096-8517-1-git-send-email-jirislaby@gmail.com>
References: <1241453096-8517-1-git-send-email-jirislaby@gmail.com>
Date: Mon, 4 May 2009 12:17:19 -0400
Message-ID: <b6c5339f0905040917s72b9f515h40be93fbf04c2182@mail.gmail.com>
Subject: Re: [PATCH 1/2] mac80211: minstrel, fix memory corruption
From: Bob Copeland <me@bobcopeland.com>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: johannes@sipsolutions.net, linux-wireless@vger.kernel.org,
	linux-kernel@vger.kernel.org, Felix Fietkau <nbd@openwrt.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, May 4, 2009 at 12:04 PM, Jiri Slaby <jirislaby@gmail.com> wrote:
> minstrel doesn't count max rate count in fact, since it doesn't use
> a loop variable `i' and hence allocs space only for bitrates found in
> the first band.

Nice catch, I don't know how many times I read that and didn't see
it.  Hopefully that has some bearing on this long standing bug:

http://bugzilla.kernel.org/show_bug.cgi?id=12490

-- 
Bob Copeland %% www.bobcopeland.com
