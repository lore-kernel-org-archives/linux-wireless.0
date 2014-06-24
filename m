Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ie0-f181.google.com ([209.85.223.181]:60854 "EHLO
	mail-ie0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752513AbaFXSZH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jun 2014 14:25:07 -0400
Received: by mail-ie0-f181.google.com with SMTP id y20so628830ier.40
        for <linux-wireless@vger.kernel.org>; Tue, 24 Jun 2014 11:25:05 -0700 (PDT)
Message-ID: <1403634304.1189.10.camel@nm-ws> (sfid-20140624_202511_853163_B2C4EE59)
Subject: Re: RTLWIFI - RTL8192CU troubles
From: Steve Brown <sbrown@cortland.com>
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Cc: Steve Brown <sbrown@cortland.com>,
	Larry Finger <larry.finger@lwfinger.net>
Date: Tue, 24 Jun 2014 12:25:04 -0600
In-Reply-To: <1403482954.22303.28.camel@nm-ws>
References: <1403482954.22303.28.camel@nm-ws>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


On Sun, 2014-06-22 at 18:22 -0600, Steve Brown wrote:
> I have an RTL8188CUS dongle. My test setup is a Beaglebone black w/
> wireless-testing of a few days ago on a debian rootfs. It is set up as
> an unencrypted station. The AP uses a Ubiquiti SR71-A (AR9160), has been
> in service for some time, is running compat-wireless-2014-05-22 and
> isn't suspect.
> 
> After scp'ing several 10MB files in either direction, traffic stops.
> Well, not all the traffic. If I ping the AP, Wireshark on a separate
> computer and monitor interface shows that the ping from the station gets
> on the air and so does the AP's ack, but no ping reply is sent by the
> AP. ARP broadcasts from the station are ack'ed and responded to, just
> not the pings. If I run tcpdump on the station's interface, it shows the
> ARP packets and their response and any other broadcast traffic, just not
> the ping or reply. Lastly, this only occurs in HT mode.
> 
> I've compared the Wireshark dumps of the pings from before the interface
> hangs up and after and can't see any difference.
> 
After looking at some more wireshark output, the problem seems to be
that the aggregation sessions deadlock when a second one starts before
the first one completes. That would explain why it only occurs in HT
mode.

The sequence on the air before the deadlock is:

STA->AP block ack req
STA->AP ping req
AP->STA block ack resp
AP->STA ping resp
AP->STA block ack req
STA->AP block ack resp

The sequence on the air after the deadlock is:

AP->STA block ack req
STA->AP block ack req
AP->STA block ack resp
STA->AP block ack resp
STA->AP ping req
...
STA->AP ping req (repeats)

I noticed a fix for a similar problem with ath9k in the description of patch: 
ath9k: prevent aggregation session deadlocks
08c96abd611beadf2af414a306fe0fb02ba706ff

Steve



