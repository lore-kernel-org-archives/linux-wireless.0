Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f219.google.com ([209.85.220.219]:33771 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932723Ab0BYOkJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 25 Feb 2010 09:40:09 -0500
Received: by fxm19 with SMTP id 19so6324353fxm.21
        for <linux-wireless@vger.kernel.org>; Thu, 25 Feb 2010 06:40:07 -0800 (PST)
MIME-Version: 1.0
Date: Thu, 25 Feb 2010 09:40:06 -0500
Message-ID: <6b5e31691002250640k154a1f22xa46bac547c69b250@mail.gmail.com>
Subject: Ath5k and Retransmissions (Retries)
From: Andrew Blaich <ablaich@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi everyone,

   I have been attempting, unsuccessfully, to alter the number
retransmissions any particular transmission rate uses.  My card is
reported as an AR5414 (Atheros) and the ath5k driver is being loaded.
My understanding based on the source code in compat-wireless is that
the retry count for the rates are set, ideally in the rate control
algorithm, e.g. minstrel, and is then passed off to the hardware at
some point in the transmit chain.  Is there a lower limit that the
hardware accepts for retransmission values?  I've been trying to set
the value to 1 and then potenially to 0 to completely disable
retransmissions, for experimentation purposes.  However, despite
whatever value the data structures in the codereport back to me, I've
been through what I believe to be every file in the compat-wireless
that deals with  retries, when I sniff the wireless channel using a
separate node I am still seeing retransmissions being produced for the
particularly flow I have established.

Is this a hardware issue of which I will not be able to fix the
retransmissions, or is there something more obvious I am missing and
perhaps you can lend some wisdom as to the appropriate locations to
change the retry limit so that the hardware will obey the value.

Thank you.

-Andrew
