Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from perninha.conectiva.com.br ([200.140.247.100]:50975 "EHLO
	perninha.conectiva.com.br" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753187AbYJ2SmC (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 Oct 2008 14:42:02 -0400
From: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
To: Larry Finger <Larry.Finger@lwfinger.net>
Subject: Re: [RFC/RFT] rtl8187: Reduce delays to reduce startup time
Date: Wed, 29 Oct 2008 16:42:16 -0200
Cc: htl10@users.sourceforge.net, Pavel Roskin <proski@gnu.org>,
	wireless <linux-wireless@vger.kernel.org>
References: <838057.50079.qm@web23102.mail.ird.yahoo.com> <49088F7D.8020102@lwfinger.net>
In-Reply-To: <49088F7D.8020102@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Message-Id: <200810291642.16697.herton@mandriva.com.br> (sfid-20081029_194208_797266_A2652C17)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 29 October 2008 14:29:49 Larry Finger wrote:
> The current driver for the RTL8187 and RTL8187B USB devices contain a large
> number of sleep statements, which causes the driver to take a very long time
> to initialize and connect. An audit was undertaken to test which, if any, of
> these delays could be eliminated.
> 
> The first thing I noted was that calls to rtl8225_write_ofdm(),
> rtl8225_write_cck(), and rtl8225_write() all go through either
> rtl8225_write_bang() or rtl8225_write_8051() and that both those routines
> finish with an msleep() call; therefore sequences such as
> rtl8225_write(); msleep(1) should not be needed. After removing the msleep()
> calls of this type, the initialization routine was much faster without affecting
> any functionality.
> 
> Next, I experimented with removing those calls with sleeps greater than 1
> second - again there was no negative effect.
> 
> These changes are most important for the execution of routine
> rtl8225z2_b_rf_init() where the time went from 14.84 sec to 7.90 sec.
> 
> Please test these changes to verify that these changes do not affect correct
> operations of other versions of either the RTL8187 or RTL8187B chips.

I tested here with one 8187B and another 8187L and don't found problems. Just
don't know about the 8187L part that you changed, may be the original authors
of 8187L should comment about it. Otherwise you can add:
Tested-by: Herton Ronaldo Krzesinski <herton@mandriva.com.br>

> 
> Signed-off-by: Larry Finger <Larry.Finger@lwfinger.net>
> ---
> 

--
[]'s
Herton
