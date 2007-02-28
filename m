Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s131.mittwaldmedien.de ([62.216.178.31]:4768 "EHLO
	s131.mittwaldmedien.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751025AbXB1QHy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 28 Feb 2007 11:07:54 -0500
From: Holger Schurig <hs4233@mail.mn-solutions.de>
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH 14/28] rt2x00: Create rt2x00lib module
Date: Wed, 28 Feb 2007 17:07:45 +0100
Cc: Ivo van Doorn <ivdoorn@gmail.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org
References: <200702281507.13004.IvDoorn@gmail.com> <200702281612.51383.IvDoorn@gmail.com> <1172676338.5015.20.camel@johannes.berg>
In-Reply-To: <1172676338.5015.20.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200702281707.45348.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> No, that's not true, if RT2X00_LIB has no help text it would
> never show up to the user.

No, that's not true either. It's not a feature of the help text, 
but of the little description behind the bool or tristate 
option.

The following example would make a CONFIG_LIBERAS entry, that can 
be tristate, and is automatically set correctly. If I set 
LIBERTAS_CS to "m", it would be "m". If it is "y", it would 
be "y" as well. And if LIBERTAS_CS is "m", but LIBERTAS_USB 
is "y", it would still be "y". Kconfig is sane enought to find 
out what it should do.



config LIBERTAS
	tristate
	depends on NET_RADIO

config LIBERTAS_CS
        tristate "Marvell Libertas 8388 CF 802.11b/g cards"
        depends on PCMCIA && EXPERIMENTAL
        select FW_LOADER
	select LIBERTAS
        ---help---
          A driver for Marvell Libertas 8385 compact flash
          devices.

config LIBERTAS_USB
        tristate "Marvell Libertas 8388 USB 802.11b/g cards"
        depends on USB
        select FW_LOADER
	select LIBERTAS
        ---help---
          A driver for Marvell Libertas 8388 USB devices.

config LIBERTAS_DEBUG
        bool "Enable full debugging in the Libertas library"
        depends on LIBERTAS
        ---help---
          Debugging support
