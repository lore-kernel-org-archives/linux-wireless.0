Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from alt-proxy13.mail.unifiedlayer.com ([67.222.34.81]:39332 "HELO
	alt-proxy13.mail.unifiedlayer.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751888AbaAXFcr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 24 Jan 2014 00:32:47 -0500
Message-ID: <1390541559.2436.125.camel@Wailaba2> (sfid-20140124_063253_165700_564A243A)
Subject: Re: [alsa-devel] [ISSUE] rtl8192ce appears to interfere with	ALSA
 playback
From: Olivier Langlois <olivier@trillion01.com>
To: Takashi Iwai <tiwai@suse.de>
Cc: LANGLOIS Olivier PIS -EXT
	<olivier.pis.langlois@transport.alstom.com>,
	"alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	James Cameron <quozl@laptop.org>,
	"daniel@zonque.org" <daniel@zonque.org>
Date: Fri, 24 Jan 2014 00:32:39 -0500
In-Reply-To: <s5h1tzyu0em.wl%tiwai@suse.de>
References: <1389767820.2436.45.camel@Wailaba2>
	 <52D6BEEF.5050705@lwfinger.net> <52D76D56.6060906@trillion01.com>
	 <20140116055547.GU19393@us.netrek.org> <1390464800.2436.111.camel@Wailaba2>
	 <s5htxcvt718.wl%tiwai@suse.de>
	 <89F8E4011FD7234ABFE48744E300CBC206BCE732@041-DB3MPN1-092.041d.mgd.msft.net>
	 <s5h1tzyu0em.wl%tiwai@suse.de>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Takashi,

On Thu, 2014-01-23 at 17:29 +0100, Takashi Iwai wrote:

> Which machine and codec?  For example, Lenovo IdeaPad with ALC269 is
> known to be broken with 48kHz, so we have a fixed rate limitation in
> the driver.
> 

it is a hpmini. I have this from dmesg:

[    9.638142] hda_codec: 92HD81B1X5: Apply fix-func for HP
[    9.639859] hda-codec: Enable HP auto-muting on NID 0xb
[    9.639888] hda-codec: Enable auto-mic switch on NID 0x11/0xa/0x0
[    9.642312] hda_codec: 92HD81B1X5: Apply fix-func for HP


> Other than the hardware restriction, you may play more with
> position_fix or bdl_pos_adj option of snd-hda-intel driver.
> 
thank you for the advice. I'll take a look on these params to see what
they do. However, because my sound card works very well all the time
except that I have underruns that happens only when wpa_supplicant is
doing this:

wlan0: Control interface command 'STATUS'
wlan0: State: DISCONNECTED -> SCANNING
...
wlan0: No suitable network found
wlan0: Setting scan request: 5 sec 0 usec
wlan0: Checking for other virtual interfaces sharing same radio (phy0)
in event_scan_results
wlan0: Starting AP scan for wildcard SSID
WPS: Building WPS IE for Probe Request
WPS:  * Version (hardcoded 0x10)
WPS:  * Request Type
WPS:  * Config Methods (148)
WPS:  * UUID-E
WPS:  * Primary Device Type
WPS:  * RF Bands (1)
WPS:  * Association State
WPS:  * Configuration Error (0)
WPS:  * Device Password ID (0)
WPS:  * Device Name
P2P: * P2P IE header
P2P: * Capability dev=21 group=00
P2P: * Listen Channel: Regulatory Class 81 Channel 1
nl80211: Scan SSID - hexdump_ascii(len=0): [NULL]
nl80211: Scan extra IEs - hexdump(len=101): xxx
Scan requested (ret=0) - scan timeout 30 seconds
nl80211: Event message available
nl80211: Scan trigger
nl80211: Event message available
nl80211: New scan results available
wlan0: Event SCAN_RESULTS (3) received
nl80211: Received scan results (19 BSSes)
wlan0: BSS: Start scan result update 2

when wlan0 goes to connected or I just turn off the wifi, underruns go
away, I'll check first what rtl8192ce's nl80211 interface implementation
does when asked to perform a scan.

thank you again for your suggestions,
Olivier


