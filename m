Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from py-out-1112.google.com ([64.233.166.181]:40611 "EHLO
	py-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757071AbXJORz7 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 15 Oct 2007 13:55:59 -0400
Received: by py-out-1112.google.com with SMTP id u77so3162090pyb
        for <linux-wireless@vger.kernel.org>; Mon, 15 Oct 2007 10:55:58 -0700 (PDT)
To: Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [PATCH v2] mac80211: fix set_channel regression
Date: Mon, 15 Oct 2007 20:13:20 +0200
Cc: Marcus Better <marcus@better.se>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org,
	Michael Wu <flamingice@sourmilk.net>
References: <fdqhn4$qab$1@sea.gmane.org> <35945.80.169.182.16.1192448277.squirrel@www.dactylis.com> <1192448723.3349.32.camel@johannes.berg>
In-Reply-To: <1192448723.3349.32.camel@johannes.berg>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_A36EHueYIlroqfN"
Message-Id: <200710152013.20777.IvDoorn@gmail.com> (sfid-20071015_185606_013940_A8D48BFC)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Boundary-00=_A36EHueYIlroqfN
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

> > However there is a huge performance regression. "tptest" shows a TCP
> > throughput of under 300 kbit for the driver version 2.0.9 (current
> > wireless-2.6), compared to 7 Mbit for version 2.0.7 (with kernel
> > 2.6.23-rc3). The UDP speed was also affected but not as much, down from
> > around 5-10 Mbit to 1 Mbit.
> 
> I don't think this would be related to mac80211, I'll let Ivo handle the
> rest of this.

Could you enable debugfs and use attached debugfs script to create a dump
of the rt2x00 registers. Preferably a dump of both the rt2x00 2.0.7 and 2.0.9 versions.

Ivo

--Boundary-00=_A36EHueYIlroqfN
Content-Type: application/x-shellscript;
  name="debugfsdump"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="debugfsdump"

#!/bin/sh

echo "BBP:"
for ((i = 0; i < `cat chipset | grep bbp | cut -d ':' -f 2 | bc`; i++));
do
	echo -n "$i "
	echo $i > bbp_offset
	cat bbp_value
done

echo "CSR:"
for ((i = 0; i < `cat chipset | grep csr | cut -d ':' -f 2 | bc`; i++));
do
	echo -n "$i "
	echo $i > csr_offset
	cat csr_value
done

echo "EEPROM:"
for ((i = 0; i < `cat chipset | grep eeprom | cut -d ':' -f 2 | bc`; i++));
do
	echo -n "$i "
	echo $i > eeprom_offset
	cat eeprom_value
done

--Boundary-00=_A36EHueYIlroqfN--
