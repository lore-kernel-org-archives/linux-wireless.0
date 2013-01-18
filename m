Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail022-1.exch022.serverdata.net ([64.78.22.98]:46381 "EHLO
	mail022-1.exch022.serverdata.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751011Ab3ARJHH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Jan 2013 04:07:07 -0500
Message-ID: <50F910B6.4020302@posedge.com> (sfid-20130118_100714_726376_5CC74F8D)
Date: Fri, 18 Jan 2013 14:37:02 +0530
From: Srinivasan B <srinivasanb@posedge.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
CC: johannes@sipsolutions.net
Subject: [RFC - v1 - design doc] hostapd:  Beacon generation with Power Constraint
 IE - 11h TPC
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,
     This design document proposes changes in hostapd to include "Power 
Constraint IE" in beacon.

Main Idea:
--------------
Based on the current operation mode (11a) and 80211h flag enabled in 
hostapd.conf and if the operating channel is within 5.25-5.35 GHz and 
5.47-5.725 GHz band hostapd supports the following:

1.Power Constraint:
---------------------------
Including "Power Constraint IE" in beacon with appropriate value for 
"Local power constraint" helps the device/AP to be in compliance with 
802.11h (part of 11n / wpa2 interop test specification).

1.1 Ability for an AP to generate beacons/probe response with Power 
Constraint IE:

     * hostapd generates beacons with "Power constraint IE" with value 
for "Local Power Constraint" set to 0dB.

1.2 Reason for setting "Local Power Constraint" as 0db:

     * Section (h)(1) of Electronic Code of Federal Regulations (e-CFR) 
states that TPC mechanism is not required for systems with an e.i.r.p. 
of less than 500 mW. U-NII devices operating in the 5.25-5.35 GHz band 
and the 5.47-5.725 GHz band shall employ a TPC mechanism
     * As per FCC standard, for country US, the MAX TX power for UNII-2 
band is 23dB/200mW.
     * As per CRDA, as an example, the Max TX power provided for UNII-2 
band for country US is 20dbm/100mW which is below the mimimum 
requirement to start TPC.
     * As per ETSI standard, the MAX TX power for UNII-2 band is 23dB. 
As per CRDA, as an example, the MAX TX power for UNII-2 band for country 
SWITZERLAND (CH) is 20dB.      * Since CRDA provides a reduced TX power 
level, value of 0dB provides an opportunity for the client devices to 
operate at Power Limit provided by CRDA (Local MAX TX power = regulatory 
max - power constraint).

Looking forward for suggestions & information.

Thanks & regards,
Srinivasan
