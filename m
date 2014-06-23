Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f169.google.com ([209.85.223.169]:64057 "EHLO
	mail-ie0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751101AbaFWAWf (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 22 Jun 2014 20:22:35 -0400
Received: by mail-ie0-f169.google.com with SMTP id at1so5217047iec.0
        for <linux-wireless@vger.kernel.org>; Sun, 22 Jun 2014 17:22:35 -0700 (PDT)
Received: from [192.168.2.6] (50-77-43-154-static.hfc.comcastbusiness.net. [50.77.43.154])
        by mx.google.com with ESMTPSA id 8sm27500368igr.2.2014.06.22.17.22.34
        for <linux-wireless@vger.kernel.org>
        (version=TLSv1 cipher=RC4-SHA bits=128/128);
        Sun, 22 Jun 2014 17:22:34 -0700 (PDT)
Message-ID: <1403482954.22303.28.camel@nm-ws> (sfid-20140623_022239_029735_F85949F6)
Subject: RTLWIFI - RTL8192CU troubles
From: Steve Brown <sbrown@cortland.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Sun, 22 Jun 2014 18:22:34 -0600
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I have an RTL8188CUS dongle. My test setup is a Beaglebone black w/
wireless-testing of a few days ago on a debian rootfs. It is set up as
an unencrypted station. The AP uses a Ubiquiti SR71-A (AR9160), has been
in service for some time, is running compat-wireless-2014-05-22 and
isn't suspect.

After scp'ing several 10MB files in either direction, traffic stops.
Well, not all the traffic. If I ping the AP, Wireshark on a separate
computer and monitor interface shows that the ping from the station gets
on the air and so does the AP's ack, but no ping reply is sent by the
AP. ARP broadcasts from the station are ack'ed and responded to, just
not the pings. If I run tcpdump on the station's interface, it shows the
ARP packets and their response and any other broadcast traffic, just not
the ping or reply. Lastly, this only occurs in HT mode.

I've compared the Wireshark dumps of the pings from before the interface
hangs up and after and can't see any difference.

I repeated this using an X86_64 machine and the same usb dongle. I have
two of the dongles and they behave identically. Further, I've compiled
the Realtek driver (8192cu) and it doesn't exhibit this behavior.

Thanks,

Steve


