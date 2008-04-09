Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from c60.cesmail.net ([216.154.195.49]:34284 "EHLO c60.cesmail.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752425AbYDIS7Z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Apr 2008 14:59:25 -0400
Subject: Re: [PATCH] Add Realtek 8187B support
From: Pavel Roskin <proski@gnu.org>
To: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Cc: linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
In-Reply-To: <200804091436.23685.herton@mandriva.com.br>
References: <200804081931.07638.herton@mandriva.com.br>
	 <1207714923.8539.26.camel@rd>  <200804091436.23685.herton@mandriva.com.br>
Content-Type: text/plain
Date: Wed, 09 Apr 2008 14:59:23 -0400
Message-Id: <1207767563.3944.7.camel@dv> (sfid-20080409_195929_663745_0CC7D2D7)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, 2008-04-09 at 14:36 -0300, Herton Ronaldo Krzesinski wrote:

> I run checkpatch.pl, I just didn't fixed these because they were lines already
> this way, my patch got these because I moved reset code common to rtl8187b
> and rtl8187 (new rtl8187_cmd_reset function) out of rtl8187_init_hw. Also I
> introduced some new ones, these lines are over 80 characters:
> rtl818x_iowrite8(priv, &priv->map->CONFIG3, reg | RTL818X_CONFIG3_ANAPARAM_WRITE);
> rtl818x_iowrite8(priv, &priv->map->EEPROM_CMD, RTL818X_EEPROM_CMD_CONFIG);
> 
> Should I fix all of these ocurrences in rtl8187b patch or in a new patch?

I feel bad that you have to deal with sloppy code left by others, but
these are the rules of the game.  I suggest that you do all cleanups
first as separate patches, and then the user-visible changes.  The only
exception is then your user visible changes replace the old code.

I could do some cleanups myself, but I think it would be easier for you
to do it at once rather than merge my patches.

Or maybe we should ask the existing maintainers to prepare a clean
playground for new contributors?  Michael?  Andrea?

-- 
Regards,
Pavel Roskin
