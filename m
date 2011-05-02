Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gw0-f46.google.com ([74.125.83.46]:52840 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751771Ab1EBUBG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 May 2011 16:01:06 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTi=FT4v=Jvv5bQpUX15R87kPudKq=Q@mail.gmail.com>
References: <BANLkTintnaEj0DDjwQJjc4wpuz-c_QOGyg@mail.gmail.com>
	<1304303082.2833.159.camel@localhost>
	<BANLkTi=FT4v=Jvv5bQpUX15R87kPudKq=Q@mail.gmail.com>
Date: Mon, 2 May 2011 21:01:04 +0100
Message-ID: <BANLkTikHRAYYPj3y9JWLjpatdOCiRXD5Nw@mail.gmail.com> (sfid-20110502_220109_565383_4BADC101)
Subject: Re: Frequent spurious tx_timeouts for libertas
From: Daniel Drake <dsd@laptop.org>
To: Ben Hutchings <bhutchings@solarflare.com>
Cc: netdev@vger.kernel.org, libertas-dev@lists.infradead.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2 May 2011 20:59, Daniel Drake <dsd@laptop.org> wrote:
> dev->trans_start is unconditionally initialized by dev_activate() in
> sch_generic.c:

Also, many drivers (including libertas) set it in their tx_timeout handlers:
   dev->trans_start = jiffies; /* prevent tx timeout */
I don't understand why (the TX timeout has already occurred, it can't
be prevented at that stage).

Daniel
