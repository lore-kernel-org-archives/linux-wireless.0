Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([72.66.92.28]:2081 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932940Ab0GUDlG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 20 Jul 2010 23:41:06 -0400
Date: Tue, 20 Jul 2010 23:41:50 -0400
From: Bob Copeland <me@bobcopeland.com>
To: Bruno Randolf <br1@einfach.org>
Cc: linux-wireless@vger.kernel.org, ath5k-devel@lists.ath5k.org,
	johannes@sipsolutions.net
Subject: Re: [PATCH/RFC 3/3] ath5k: trace resets
Message-ID: <20100721034150.GA16632@hash.localnet>
References: <1279395336-856-1-git-send-email-me@bobcopeland.com> <201007201420.49305.br1@einfach.org> <20100720145200.GB7049@hash.localnet> <201007211004.59372.br1@einfach.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <201007211004.59372.br1@einfach.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 21, 2010 at 10:04:59AM +0900, Bruno Randolf wrote:
> the difference. without tracing you can get 22Mbps, with tracing max 15Mbps 
> UDP thruput.

If so, and it's not an i-cache effect, then something is wrong with
the tracing subsystem.  It's supposed to compile to something like

if (tracing) {
   trace_callback();
}

That is exactly what we have with the debug infrastructure, but
the debug stuff is theoretically a bit worse since it tests for
tracing inside the callback.

Oh well, I guess I need to get my hands on one of these boards.

-- 
Bob Copeland %% www.bobcopeland.com

