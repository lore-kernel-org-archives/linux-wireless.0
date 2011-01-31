Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bar.sig21.net ([80.81.252.164]:52048 "EHLO bar.sig21.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754195Ab1AaVFG (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Jan 2011 16:05:06 -0500
Date: Mon, 31 Jan 2011 22:05:02 +0100
From: Johannes Stezenbach <js@sig21.net>
To: Ivo Van Doorn <ivdoorn@gmail.com>
Cc: users@rt2x00.serialmonkey.com, linux-wireless@vger.kernel.org,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [RFC] rt2x00: Add autowakeup timer for receiving beacons while
 in powersave mode
Message-ID: <20110131210502.GA15042@sig21.net>
References: <201101311600.39486.IvDoorn@gmail.com>
 <20110131181725.GA11054@sig21.net>
 <AANLkTin+cpLWKbX4YaLUUiR_UAKqSPFy-9Lt1cjK3wOs@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <AANLkTin+cpLWKbX4YaLUUiR_UAKqSPFy-9Lt1cjK3wOs@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Mon, Jan 31, 2011 at 08:00:09PM +0100, Ivo Van Doorn wrote:
> 
> > Also, I think rt2x00dev->beacon_int is in TUs, not msecs.
> 
> Nope, it is in msecs :)

Please forgive my insistence, but I'm not content with your answer ;-/

rt2x00lib_config_erp() passes it to rt2800_config_erp()
which writes beacon_int * 16 to BCN_TIME_CFG_BEACON_INTERVAL,
which is dcoumented as "in unit of 1/16 TU".


Johannes
