Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ug-out-1314.google.com ([66.249.92.175]:52698 "EHLO
	ug-out-1314.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374AbXJUQBs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 21 Oct 2007 12:01:48 -0400
Received: by ug-out-1314.google.com with SMTP id z38so804285ugc
        for <linux-wireless@vger.kernel.org>; Sun, 21 Oct 2007 09:01:47 -0700 (PDT)
To: bruno.vetel@wanadoo.fr
Subject: Re: [Fwd: Problem with a Driver rt73 in ad-hoc mode between a arm and a pc]
Date: Sun, 21 Oct 2007 18:20:12 +0200
Cc: linux-wireless@vger.kernel.org, rt2400-devel@lists.sourceforge.net
References: <1192979624.9056.23.camel@rigel.esas.fr> <200710211745.18430.IvDoorn@gmail.com> <1192982171.9056.34.camel@rigel.esas.fr>
In-Reply-To: <1192982171.9056.34.camel@rigel.esas.fr>
MIME-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_8w3GHABdMfa2NuO"
Message-Id: <200710211820.13002.IvDoorn@gmail.com> (sfid-20071021_170152_849265_257CB309)
From: Ivo van Doorn <ivdoorn@gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--Boundary-00=_8w3GHABdMfa2NuO
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Hi,

> > Could you try using wireshark or a similar tool to see if beacons
> > are correctly send out?
> > There are similar reports regarding rt73 which suggests that in adhoc
> > mode
> > the beacons are never being send out correctly.
> > 
> With wireshark on the pc or tcpdump on the arm board, I don't see any
> traffic.

Just what I expected. Could you use attached script to create a dump of the
registers. That way I can see if all beacon related registers have been initialized.

Ivo

--Boundary-00=_8w3GHABdMfa2NuO
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

--Boundary-00=_8w3GHABdMfa2NuO--
