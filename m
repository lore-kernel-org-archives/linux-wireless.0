Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from cavan.codon.org.uk ([93.93.128.6]:37500 "EHLO
	vavatch.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755183AbZC1PCF (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Mar 2009 11:02:05 -0400
Date: Sat, 28 Mar 2009 15:02:02 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: linux-wireless@vger.kernel.org, Ivo van Doorn <ivdoorn@gmail.com>
Subject: Re: [RFC] rfkill/rfkill-input userspace API
Message-ID: <20090328150202.GD27812@srcf.ucam.org> (sfid-20090328_160209_345999_60A20053)
References: <1238169485-29298-1-git-send-email-hmh@hmh.eng.br> <20090327221147.GA499@srcf.ucam.org> <20090328123645.GD7439@khazad-dum.debian.net> <20090328124719.GF7439@khazad-dum.debian.net> <20090328125301.GA26537@srcf.ucam.org> <20090328144823.GA6420@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20090328144823.GA6420@khazad-dum.debian.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, Mar 28, 2009 at 11:48:23AM -0300, Henrique de Moraes Holschuh wrote:

> I can live with that.  Very well, I will hunt down what version of
> evdev we have in Debian stable and unstable, what version of evdev
> stopped doing grab-by-default, and document this in a few places.

The change was in commit 4912e2aa7f867a86d383010023b8426c881fb3b0 which 
was on October 16th of last year. It does depend on having an X server 
that sets the console into raw mode - the only reason evdev was ever 
doing the grabs was because that particular bit of magic had ended up in 
the legacy keyboard driver rather than being in the server core, and 
everybody had forgotten how this stuff worked.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
