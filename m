Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:51204 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S1755648Ab0KSVWp (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Nov 2010 16:22:45 -0500
Message-ID: <4CE6EA98.3020300@gmx.net>
Date: Fri, 19 Nov 2010 22:22:32 +0100
From: Wolfgang Breyha <wbreyha@gmx.net>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Linux Client vs. CISCO AP with band select
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi!

I'm working at the IT department at the University of Vienna. We've a
large installation of CISCO APs providing WLAN access to students and
employees. All of these APs provide both 2,4GHz and 5GHz channels. CISCO
provides two features called "load balancing" and "band select".

At least "band select" causes lots of troubles using a Linux client. It
needs a big portion of luck to successfully connect.

I'm using my HP Elitebook 2540p with Intel 6200 abgn
pci id: 8086:4239 (rev 35)

Starting with Fedora 13, now Fedora 14 I tried to get into all the
wireless stuff. Currently I'm running compat-wireless-20101115 and
wpa_supplicant 0.7.3. Additionally I patched NetworkManager to use a
timeout of 180 seconds instead of the default 25 and "-D nl80211" as
driver for wpa_supplicant. Firmware used is iwlwifi-6000-4.ucode.

AFAIK "band select" tries to "convince" a client to prefer 5GHz channels
by not answering to 2.4GHz probes at least two times (configurable with
2 as default) the same client asks. But the AP appears in scans since
beacons are received as usual.

In my case I see 10 BSSIDs for this SSID. 2 strong 2.4GHz APs and the
first 5GHz AP appears on third position reception wise. wpa_supplicant
starts authentication at the strongest. Then I see a probe request for
the SSID in wireshark, but no response from the selected BSSID. No
authentication packet is seen from wireshark.

Authentication times out. And then the worst case scenario takes
place... wpa_supplicant retries and retries the same AP with time outs
and scans in between. Sometimes even 180 seconds is not enough to try an
other AP.

I can provide sample wpa_supplicant.log and wireshark traces if of interest.

I just built wireless-compat 20101119 with DEBUG_VERBOSE and can get
details if needed.

Last but not least I tried with Windows. Windows is able to connected
even to the 2.4GHz channels. I've monitored the channel with my linux
machine while windows connected to the 2.4GHz AP. All I see are
unanswered probes also, but Windows seems to simply send an
authentication request afterwards and gets an answer then.

I can't figure out how CISCO hopes that a client behaves to cooperate
well with this feature.

I'm sorry that I'm not very proficient with all that wireless stuff yet,
but I'll try to improve and help as good as possible if that's appreciated.

With kind regards,
Wolfgang Breyha
University of Vienna
-- 
Wolfgang Breyha <wbreyha@gmx.net> | http://www.blafasel.at/
Vienna University Computer Center | Austria
