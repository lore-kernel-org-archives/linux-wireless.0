Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.ukfsn.org ([77.75.108.10]:34239 "EHLO mail.ukfsn.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752075Ab1AaQdU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 Jan 2011 11:33:20 -0500
Received: from localhost (smtp-filter.ukfsn.org [192.168.54.205])
	by mail.ukfsn.org (Postfix) with ESMTP id B103DDEC8F
	for <linux-wireless@vger.kernel.org>; Mon, 31 Jan 2011 16:13:10 +0000 (GMT)
Received: from mail.ukfsn.org ([192.168.54.25])
	by localhost (smtp-filter.ukfsn.org [192.168.54.205]) (amavisd-new, port 10024)
	with ESMTP id IUq12YKSpDRJ for <linux-wireless@vger.kernel.org>;
	Mon, 31 Jan 2011 16:13:10 +0000 (GMT)
Received: from stargate.localnet (unknown [84.45.236.142])
	by mail.ukfsn.org (Postfix) with ESMTP id 6CE2CDEC85
	for <linux-wireless@vger.kernel.org>; Mon, 31 Jan 2011 16:13:10 +0000 (GMT)
From: David Goodenough <david.goodenough@btconnect.com>
To: linux-wireless@vger.kernel.org
Subject: How do I use the UK 5.8GHz lightly regulated band with the regulatory DB?
Date: Mon, 31 Jan 2011 16:13:07 +0000
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <201101311613.07381.david.goodenough@btconnect.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

In the UK Ofcom (our regulator) has designated a portion of spectrum at
5.8GHz for use outdoors, with 4W EIRP and requiring DFS, on payment of
an annual fee of GBP 1.00 per client/access-point (to a minimum of GBP 50.00).
With the standard GB regulatory db entry this is excluded.

How do I add this (had anyone already done this) and how to I restrict the DFS
code to remain within this range rather than using any of the other channels
that require DFS?

The GB regulatory domain database entry normally reads:-

country GB:
       (2402 - 2482 @ 40), (N/A, 20)
       (5170 - 5250 @ 40), (N/A, 20)
       (5250 - 5330 @ 40), (N/A, 20), DFS
       (5490 - 5710 @ 40), (N/A, 27), DFS

BTW I notice that in some countries some frequencies are marked NO_OUTDOOR
but the 5.1, 5.2 and 5.4 bands are not marked NO_OUTDOOR for GB.  Is there
a reason for this?

>From the relevant Ofcom document for the 5.8 GHz band 
(http://stakeholders.ofcom.org.uk/binaries/spectrum/spectrum-policy-
area/spectrum-management/research-guidelines-tech-info/interface-
requirements/uk_interface_2007.pdf page 6) we find:-

Table 3.1: Minimum requirements for the use of: - Fixed Broadband Radio
Systems operating in the 5725 - 5850 MHz band (Band C)
Mandatory (1-9)
 1 Frequency band                 5725 MHz to 5850 MHz
 2 Radio service                      Fixed
 3 Application                         Fixed Wireless Access
 4 Channelling modulation      N/A
 5 Maximum transmit power    Maximum mean e.i.r.p. of 4W
    limit                                    Maximum mean e.i.r.p. density of              
                                              23dBm/MHz
 6   Channel occupation rules N/A
 7   Duplex type/separation     TDD
 8   Licensing Regime               A licence is required
 9   Additional essential           N/A
          requirements
Informative (10-13)
 10  Frequency planning        DFS and TPC is assumed to be implemented as
       assumptions                   specified in ETSI harmonised European
                                              standard EN 302 502
 11 Reference                        EN 302 502
 12 Remarks                          N/A
 13 EU Notification Number   2006/422/UK

 NOTE
   The frequency range 5795-5815 MHz shall not be used and should be notched 
   out to protect RTTT devices

So that would appear to require two extra lines:-

       (5725 - 5795 @ 40), (N/A, 27), DFS
       (5815 - 5850 @ 40), (N/A, 27), DFS
 
But these two lines have to be available for DFS hopping, and the two 
indoor bands in the regular GB spec have to be excluded.  How is this
achieved?  Or do I have to have a 

David
