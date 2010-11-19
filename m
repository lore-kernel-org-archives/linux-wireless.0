Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:54836 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932350Ab0KSVqk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Nov 2010 16:46:40 -0500
Subject: Re: Linux Client vs. CISCO AP with band select
From: Dan Williams <dcbw@redhat.com>
To: Wolfgang Breyha <wbreyha@gmx.net>
Cc: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Date: Fri, 19 Nov 2010 15:45:49 -0600
In-Reply-To: <4CE6EA98.3020300@gmx.net>
References: <4CE6EA98.3020300@gmx.net>
Content-Type: text/plain; charset="UTF-8"
Message-ID: <1290203150.2497.22.camel@dcbw.foobar.com>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2010-11-19 at 22:22 +0100, Wolfgang Breyha wrote:
> Hi!
> 
> I'm working at the IT department at the University of Vienna. We've a
> large installation of CISCO APs providing WLAN access to students and
> employees. All of these APs provide both 2,4GHz and 5GHz channels. CISCO
> provides two features called "load balancing" and "band select".
> 
> At least "band select" causes lots of troubles using a Linux client. It
> needs a big portion of luck to successfully connect.
> 
> I'm using my HP Elitebook 2540p with Intel 6200 abgn
> pci id: 8086:4239 (rev 35)
> 
> Starting with Fedora 13, now Fedora 14 I tried to get into all the
> wireless stuff. Currently I'm running compat-wireless-20101115 and
> wpa_supplicant 0.7.3. Additionally I patched NetworkManager to use a
> timeout of 180 seconds instead of the default 25 and "-D nl80211" as

Eww, 180 seconds indicates something is clearly wrong with the network
setup or the driver.  Based on your description below, we do need to
figure out something in the supplicant or driver to better handle this
behavior.  We will be adding settings to NM to lock/prefer specific
bands too.

(NM 0.9 will default to nl80211 supplicant driver)

> driver for wpa_supplicant. Firmware used is iwlwifi-6000-4.ucode.
> 
> AFAIK "band select" tries to "convince" a client to prefer 5GHz channels
> by not answering to 2.4GHz probes at least two times (configurable with
> 2 as default) the same client asks. But the AP appears in scans since
> beacons are received as usual.
> 
> In my case I see 10 BSSIDs for this SSID. 2 strong 2.4GHz APs and the
> first 5GHz AP appears on third position reception wise. wpa_supplicant
> starts authentication at the strongest. Then I see a probe request for
> the SSID in wireshark, but no response from the selected BSSID. No
> authentication packet is seen from wireshark.
> 
> Authentication times out. And then the worst case scenario takes
> place... wpa_supplicant retries and retries the same AP with time outs
> and scans in between. Sometimes even 180 seconds is not enough to try an
> other AP.

Yeah, there's gotta be some better way to handle this.  The cisco
behavior seems like a huge hack that tries to work around Windows
specific 802.11 stack behavior, but unfortunately we've got to handle it
as well.  Not sure how that should happen though.

Dan

> I can provide sample wpa_supplicant.log and wireshark traces if of interest.
> 
> I just built wireless-compat 20101119 with DEBUG_VERBOSE and can get
> details if needed.
> 
> Last but not least I tried with Windows. Windows is able to connected
> even to the 2.4GHz channels. I've monitored the channel with my linux
> machine while windows connected to the 2.4GHz AP. All I see are
> unanswered probes also, but Windows seems to simply send an
> authentication request afterwards and gets an answer then.
> 
> I can't figure out how CISCO hopes that a client behaves to cooperate
> well with this feature.
> 
> I'm sorry that I'm not very proficient with all that wireless stuff yet,
> but I'll try to improve and help as good as possible if that's appreciated.
> 
> With kind regards,
> Wolfgang Breyha
> University of Vienna


