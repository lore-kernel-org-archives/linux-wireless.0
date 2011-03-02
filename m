Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64192 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752980Ab1CBROa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 2 Mar 2011 12:14:30 -0500
Received: by fxm17 with SMTP id 17so194664fxm.19
        for <linux-wireless@vger.kernel.org>; Wed, 02 Mar 2011 09:14:29 -0800 (PST)
From: Christian Lamparter <chunkeey@googlemail.com>
To: Michael =?utf-8?q?B=C3=BCsch?= <mb@bu3sch.de>
Subject: Re: Powersave broken on p54
Date: Wed, 2 Mar 2011 18:13:52 +0100
Cc: "linux-wireless" <linux-wireless@vger.kernel.org>
References: <1299003142.6461.12.camel@maggie>
In-Reply-To: <1299003142.6461.12.camel@maggie>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Message-Id: <201103021813.52719.chunkeey@googlemail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday 01 March 2011 19:12:22 Michael Büsch wrote:
> Hi,
> 
> I'm using compat-wireless-2011-02-25 on my p54-spi device (n810).
> Powersave is pretty much completely broken with this release.
> With an older release from several weeks ago it used to work, though.
hmm, several weeks ago? Not alot was changed in the last few weeks,
sure there was the rssi->dbm update (I hope you've already updated
your eeprom image.) Then p54_flush and some tx_flag updates, but
the driver's PS code was not touched.

> As soon as I enable PS, the link gets horrible latencies of
> about 20 seconds or more per ping packet, for example.
> It also saves hardly any power. (measured on the power supply).
> 
> Any ideas what could go wrong here?
No idea, it looks like the ps-poll is broken, because
"iwconfig wlanX power timeout 10" fixes the long delays
almost immediately. [let's see if there's more]

Regards,
	Chr
