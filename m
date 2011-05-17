Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:35864 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756318Ab1EQTOH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 May 2011 15:14:07 -0400
Date: Tue, 17 May 2011 12:10:36 -0700
From: Greg KH <greg@kroah.com>
To: Jonas Gorski <jonas.gorski@gmail.com>
Cc: Arend van Spriel <arend@broadcom.com>, gregkh@suse.de,
	devel@linuxdriverproject.org, linux-wireless@vger.kernel.org
Subject: Re: [PATCH 04/32] staging: brcm80211: got rid of #ifdef __mips__
 sections in hnddma.c
Message-ID: <20110517191036.GA27593@kroah.com> (sfid-20110517_211412_280174_0DD73927)
References: <1305280792-9475-1-git-send-email-arend@broadcom.com>
 <1305280792-9475-4-git-send-email-arend@broadcom.com>
 <BANLkTimEX7Mrg6HTdQdJDStyc9ZTpd7nKw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <BANLkTimEX7Mrg6HTdQdJDStyc9ZTpd7nKw@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, May 14, 2011 at 12:16:31PM +0200, Jonas Gorski wrote:
> On 13 May 2011 11:59, Arend van Spriel <arend@broadcom.com> wrote:
> > From: Roland Vossen <rvossen@broadcom.com>
> >
> > Code cleanup. Broadcom MIPS chips in big endian mode have a memory window
> > in which sdram contents is byte swapped. Code in hnddmac.c makes use of
> > this window. Reworked code so the #ifdef __mips__ is moved from .c to
> > .h file.
> 
> Shouldn't this be guarded with e.g. CONFIG_BCM63XX instead of
> __mips__? Not every big endian mips is a broadcom ;-). I don't know if
> there are further Broadcom ones, the only other I know is bcm47xx and
> that one is little endian.

Good point, now dropped.

greg k-h
