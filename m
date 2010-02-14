Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-px0-f191.google.com ([209.85.216.191]:56433 "EHLO
	mail-px0-f191.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752158Ab0BNTYi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 14 Feb 2010 14:24:38 -0500
Message-ID: <4B784DF1.200@lwfinger.net>
Date: Sun, 14 Feb 2010 13:24:33 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Thomas Backlund <tmb@mandriva.org>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: linux-2..6.33-rc7 and b43
References: <4B77C819.9050602@mandriva.org> <4B782670.9080001@lwfinger.net> <4B784498.8030509@mandriva.org>
In-Reply-To: <4B784498.8030509@mandriva.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 02/14/2010 12:44 PM, Thomas Backlund wrote:
> 
> Nice solution.
> 
> What about making it autodetected ?
> Or is it only a "last resort" with the hopes of getting the issue fixed?

When we detect the problem, we are too far past the initialization to switch
from DMA to PIO.

We certainly hope to fix the issue. We do know that the failure occurs when b43
is loaded after a cold boot, but if one warm boots after using wl, then it works
OK. There is some kind of initialization problem that only shows on Atom and
some Intel Core Duo CPUs.

Larry
