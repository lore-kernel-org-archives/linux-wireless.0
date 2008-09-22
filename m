Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lirone.symas.net ([64.71.152.235]:58692 "EHLO lirone.symas.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751497AbYIVJJy (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Sep 2008 05:09:54 -0400
Message-ID: <48D760D8.3050501@symas.com> (sfid-20080922_110958_499622_15608DDF)
Date: Mon, 22 Sep 2008 02:09:44 -0700
From: Howard Chu <hyc@symas.com>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <lrodriguez@atheros.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: ath9k problems
References: <48D5CAD0.1080909@symas.com> <f488382f0809202122v4c77bc96r54edd24bdf365724@mail.gmail.com> <20080922064831.GB19580@tesla>
In-Reply-To: <20080922064831.GB19580@tesla>
Content-Type: multipart/mixed;
 boundary="------------090504070306030309080202"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------090504070306030309080202
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Luis R. Rodriguez wrote:
> On Sat, Sep 20, 2008 at 09:22:56PM -0700, Steven Noonan wrote:
>> On Sat, Sep 20, 2008 at 9:17 PM, Howard Chu<hyc@symas.com>  wrote:

>>> I tried pulling the wireless-testing branch and found it behaved strangely
>>> as well - within about 30 seconds of idle time it would die. But, it would
>>> usually immediately begin to reconnect (and succeed). My logs were full of
>>> "ForceXPAon: 0" messages which I found were from ath9_hw_reset(), which were
>>> all being called from set_channel, during the scan that took place when the
>>> card was not associated with the AP. It typically occurred every 30-35
>>> seconds.
>> I'm sure the ath9k guys can be more informative about what
>> 'ForceXPAon: 0' is all about,
>
> Its set *all the time* for our newer chipsets and can be safely ignored.
> Not sure what the register is exactly for but its always set on
> our newer chipsets upon reset.

Yes, I understood that. But the fact that it was being logged repeatedly even 
after a session was connected, whereas before it always stopped once an 
association was made, was suspicious. And in fact I now see that it gets 
logged repeatedly because the association is repeatedly lost and re-established.

For example - I added DPRINTFs to all the places that called ath9_hw_reset() 
to see why the ForceXPAon message was occurring so often, and got the attached 
log. I note that ForceXPAon doesn't occur on every call to hw_reset, and 
sometimes there are repeated identical calls to set the channel (e.g. at 
22:06:36 in the log).

It associates successfully with my AP on channel 8, but shortly thereafter 
loses the association, scans again, and starts over again, ad nauseam. This 
behavior was made even worse when I upgraded my freeradius server (was 
authenticating with WPA EAP/PEAP) and configured TLS session caching - there 
seems to be a bug in freeradius there so subsequent reassociation attempts 
would always fail until I turned off session caching. (Haven't had time to 
chase that down yet.)
-- 
   -- Howard Chu
   CTO, Symas Corp.           http://www.symas.com
   Director, Highland Sun     http://highlandsun.com/hyc/
   Chief Architect, OpenLDAP  http://www.openldap.org/project/

--------------090504070306030309080202
Content-Type: text/plain;
 name="log.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="log.txt"

Sep 20 22:06:20 violino kernel: [   93.464752] ath_open(hw_reset)
Sep 20 22:06:20 violino kernel: [   93.471354] ForceXPAon: 0
Sep 20 22:06:20 violino kernel: [   93.492748] ath_set_channel: 1 (2412 MHz) -> 1 (2412 MHz), cflags:300e0
Sep 20 22:06:20 violino kernel: [   93.498034] ADDRCONF(NETDEV_UP): wlan0: link is not ready
Sep 20 22:06:20 violino kernel: [   93.540807] ath_set_channel: 1 (2412 MHz) -> 1 (2412 MHz), cflags:300e0
Sep 20 22:06:20 violino kernel: [   93.776742] ath_set_channel: 1 (2412 MHz) -> 2 (2417 MHz), cflags:300e0
Sep 20 22:06:20 violino kernel: [   93.780689] ath_set_channel(hw_reset)
Sep 20 22:06:21 violino kernel: [   94.016723] ath_set_channel: 2 (2417 MHz) -> 3 (2422 MHz), cflags:300e0
Sep 20 22:06:21 violino kernel: [   94.020680] ath_set_channel(hw_reset)
Sep 20 22:06:21 violino kernel: [   94.256713] ath_set_channel: 3 (2422 MHz) -> 4 (2427 MHz), cflags:300e0
Sep 20 22:06:21 violino kernel: [   94.260669] ath_set_channel(hw_reset)
Sep 20 22:06:21 violino kernel: [   94.496735] ath_set_channel: 4 (2427 MHz) -> 5 (2432 MHz), cflags:700e0
Sep 20 22:06:21 violino kernel: [   94.500691] ath_set_channel(hw_reset)
Sep 20 22:06:21 violino kernel: [   94.508674] ForceXPAon: 0
Sep 20 22:06:21 violino kernel: [   94.740724] ath_set_channel: 5 (2432 MHz) -> 6 (2437 MHz), cflags:700e0
Sep 20 22:06:21 violino kernel: [   94.744679] ath_set_channel(hw_reset)
Sep 20 22:06:22 violino kernel: [   94.982307] ath_set_channel: 6 (2437 MHz) -> 7 (2442 MHz), cflags:700e0
Sep 20 22:06:22 violino kernel: [   94.984667] ath_set_channel(hw_reset)
Sep 20 22:06:22 violino kernel: [   95.220698] ath_set_channel: 7 (2442 MHz) -> 8 (2447 MHz), cflags:500e0
Sep 20 22:06:22 violino kernel: [   95.224655] ath_set_channel(hw_reset)
Sep 20 22:06:22 violino kernel: [   95.232639] ForceXPAon: 0
Sep 20 22:06:22 violino kernel: [   95.461077] ath_set_channel: 8 (2447 MHz) -> 9 (2452 MHz), cflags:500e0
Sep 20 22:06:22 violino kernel: [   95.464643] ath_set_channel(hw_reset)
Sep 20 22:06:22 violino kernel: [   95.700797] ath_set_channel: 9 (2452 MHz) -> 10 (2457 MHz), cflags:500e0
Sep 20 22:06:22 violino kernel: [   95.704632] ath_set_channel(hw_reset)
Sep 20 22:06:22 violino kernel: [   95.940667] ath_set_channel: 10 (2457 MHz) -> 11 (2462 MHz), cflags:500e0
Sep 20 22:06:22 violino kernel: [   95.944620] ath_set_channel(hw_reset)
Sep 20 22:06:23 violino kernel: [   96.181106] ath_set_channel: 11 (2462 MHz) -> 1 (2412 MHz), cflags:300e2
Sep 20 22:06:23 violino kernel: [   96.184608] ath_set_channel(hw_reset)
Sep 20 22:06:23 violino kernel: [   96.192556] ForceXPAon: 0
Sep 20 22:06:23 violino kernel: [   96.220652] ath_set_channel: 1 (2412 MHz) -> 1 (2412 MHz), cflags:300e2
Sep 20 22:06:23 violino kernel: [   96.456639] ath_set_channel: 1 (2412 MHz) -> 2 (2417 MHz), cflags:300e2
Sep 20 22:06:23 violino kernel: [   96.460594] ath_set_channel(hw_reset)
Sep 20 22:06:23 violino kernel: [   96.692729] ath_set_channel: 2 (2417 MHz) -> 3 (2422 MHz), cflags:300e2
Sep 20 22:06:23 violino kernel: [   96.696583] ath_set_channel(hw_reset)
Sep 20 22:06:23 violino kernel: [   96.932615] ath_set_channel: 3 (2422 MHz) -> 4 (2427 MHz), cflags:300e2
Sep 20 22:06:23 violino kernel: [   96.936571] ath_set_channel(hw_reset)
Sep 20 22:06:24 violino kernel: [   97.172603] ath_set_channel: 4 (2427 MHz) -> 5 (2432 MHz), cflags:700e2
Sep 20 22:06:24 violino kernel: [   97.176559] ath_set_channel(hw_reset)
Sep 20 22:06:24 violino kernel: [   97.184541] ForceXPAon: 0
Sep 20 22:06:24 violino kernel: [   97.416963] ath_set_channel: 5 (2432 MHz) -> 6 (2437 MHz), cflags:700e2
Sep 20 22:06:24 violino kernel: [   97.420547] ath_set_channel(hw_reset)
Sep 20 22:06:24 violino kernel: [   97.656579] ath_set_channel: 6 (2437 MHz) -> 7 (2442 MHz), cflags:700e2
Sep 20 22:06:24 violino kernel: [   97.660535] ath_set_channel(hw_reset)
Sep 20 22:06:24 violino kernel: [   97.896569] ath_set_channel: 7 (2442 MHz) -> 8 (2447 MHz), cflags:500e2
Sep 20 22:06:24 violino kernel: [   97.900523] ath_set_channel(hw_reset)
Sep 20 22:06:24 violino kernel: [   97.908506] ForceXPAon: 0
Sep 20 22:06:25 violino kernel: [   98.138148] ath_set_channel: 8 (2447 MHz) -> 9 (2452 MHz), cflags:500e2
Sep 20 22:06:25 violino kernel: [   98.140499] ath_set_channel(hw_reset)
Sep 20 22:06:25 violino kernel: [   98.268984] pci 0000:01:00.0: power state changed by ACPI to D0
Sep 20 22:06:25 violino kernel: [   98.269022] pci 0000:01:00.0: PCI INT A -> GSI 18 (level, low) -> IRQ 18
Sep 20 22:06:25 violino kernel: [   98.380451] ath_set_channel: 9 (2452 MHz) -> 10 (2457 MHz), cflags:500e2
Sep 20 22:06:25 violino kernel: [   98.384018] ath_set_channel(hw_reset)
Sep 20 22:06:25 violino kernel: [   98.616500] ath_set_channel: 10 (2457 MHz) -> 11 (2462 MHz), cflags:500e2
Sep 20 22:06:25 violino kernel: [   98.620468] ath_set_channel(hw_reset)
Sep 20 22:06:25 violino kernel: [   98.856621] ath_set_channel: 11 (2462 MHz) -> 1 (2412 MHz), cflags:300e2
Sep 20 22:06:25 violino kernel: [   98.860460] ath_set_channel(hw_reset)
Sep 20 22:06:25 violino kernel: [   98.868459] ForceXPAon: 0
Sep 20 22:06:31 violino pulseaudio[6575]: ltdl-bind-now.c: Failed to find original dlopen loader.
Sep 20 22:06:31 violino pulseaudio[6575]: main.c: setrlimit(RLIMIT_NICE, (31, 31)) failed: Operation not permitted
Sep 20 22:06:31 violino pulseaudio[6575]: main.c: setrlimit(RLIMIT_RTPRIO, (9, 9)) failed: Operation not permitted
Sep 20 22:06:32 violino kernel: [  104.992309] hda-intel: Invalid position buffer, using LPIB read method instead.
Sep 20 22:06:36 violino kernel: [  109.246213] ath_set_channel: 1 (2412 MHz) -> 1 (2412 MHz), cflags:300e2
Sep 20 22:06:36 violino kernel: [  109.476007] ath_set_channel: 1 (2412 MHz) -> 2 (2417 MHz), cflags:300e2
Sep 20 22:06:36 violino kernel: [  109.479939] ath_set_channel(hw_reset)
Sep 20 22:06:36 violino kernel: [  109.712050] ath_set_channel: 2 (2417 MHz) -> 3 (2422 MHz), cflags:300e2
Sep 20 22:06:36 violino kernel: [  109.715940] ath_set_channel(hw_reset)
Sep 20 22:06:36 violino kernel: [  109.951996] ath_set_channel: 3 (2422 MHz) -> 4 (2427 MHz), cflags:300e2
Sep 20 22:06:36 violino kernel: [  109.955928] ath_set_channel(hw_reset)
Sep 20 22:06:37 violino kernel: [  110.192156] ath_set_channel: 4 (2427 MHz) -> 5 (2432 MHz), cflags:700e2
Sep 20 22:06:37 violino kernel: [  110.195920] ath_set_channel(hw_reset)
Sep 20 22:06:37 violino kernel: [  110.203906] ForceXPAon: 0
Sep 20 22:06:37 violino kernel: [  110.435975] ath_set_channel: 5 (2432 MHz) -> 6 (2437 MHz), cflags:700e2
Sep 20 22:06:37 violino kernel: [  110.439906] ath_set_channel(hw_reset)
Sep 20 22:06:37 violino kernel: [  110.675966] ath_set_channel: 6 (2437 MHz) -> 7 (2442 MHz), cflags:700e2
Sep 20 22:06:37 violino kernel: [  110.679891] ath_set_channel(hw_reset)
Sep 20 22:06:37 violino kernel: [  110.915954] ath_set_channel: 7 (2442 MHz) -> 8 (2447 MHz), cflags:500e2
Sep 20 22:06:37 violino kernel: [  110.919880] ath_set_channel(hw_reset)
Sep 20 22:06:37 violino kernel: [  110.927863] ForceXPAon: 0
Sep 20 22:06:38 violino kernel: [  111.159930] ath_set_channel: 8 (2447 MHz) -> 9 (2452 MHz), cflags:500e2
Sep 20 22:06:38 violino kernel: [  111.163868] ath_set_channel(hw_reset)
Sep 20 22:06:38 violino kernel: [  111.399924] ath_set_channel: 9 (2452 MHz) -> 10 (2457 MHz), cflags:500e2
Sep 20 22:06:38 violino kernel: [  111.403856] ath_set_channel(hw_reset)
Sep 20 22:06:38 violino kernel: [  111.639910] ath_set_channel: 10 (2457 MHz) -> 11 (2462 MHz), cflags:500e2
Sep 20 22:06:38 violino kernel: [  111.643845] ath_set_channel(hw_reset)
Sep 20 22:06:38 violino kernel: [  111.879981] ath_set_channel: 11 (2462 MHz) -> 1 (2412 MHz), cflags:300e2
Sep 20 22:06:38 violino kernel: [  111.883833] ath_set_channel(hw_reset)
Sep 20 22:06:38 violino kernel: [  111.883964] ath_set_channel: 11 (2462 MHz) -> 8 (2447 MHz), cflags:500e2
Sep 20 22:06:38 violino kernel: [  111.887835] ath_set_channel(hw_reset)
Sep 20 22:06:38 violino kernel: [  111.891815] ForceXPAon: 0
Sep 20 22:06:38 violino kernel: [  111.902083] ForceXPAon: 0
Sep 20 22:06:38 violino kernel: [  111.919832] ath_set_channel: 8 (2447 MHz) -> 8 (2447 MHz), cflags:500e2
Sep 20 22:06:48 violino kernel: [  121.951373] ath_set_channel: 8 (2447 MHz) -> 1 (2412 MHz), cflags:300e0
Sep 20 22:06:49 violino kernel: [  122.159275] ath_drain_txdata(hw_reset)
Sep 20 22:06:49 violino kernel: [  122.167130] ForceXPAon: 0
Sep 20 22:06:49 violino kernel: [  122.171278] ath_set_channel(hw_reset)
Sep 20 22:06:49 violino kernel: [  122.177869] ForceXPAon: 0
Sep 20 22:06:49 violino kernel: [  122.411389] ath_set_channel: 1 (2412 MHz) -> 2 (2417 MHz), cflags:300e2
Sep 20 22:06:49 violino kernel: [  122.415319] ath_set_channel(hw_reset)
Sep 20 22:06:49 violino kernel: [  122.650298] ath_set_channel: 2 (2417 MHz) -> 3 (2422 MHz), cflags:300e2
Sep 20 22:06:49 violino kernel: [  122.652561] ath_set_channel(hw_reset)
Sep 20 22:06:49 violino kernel: [  122.883389] ath_set_channel: 3 (2422 MHz) -> 4 (2427 MHz), cflags:300e2
Sep 20 22:06:49 violino kernel: [  122.887294] ath_set_channel(hw_reset)
Sep 20 22:06:50 violino kernel: [  123.123459] ath_set_channel: 4 (2427 MHz) -> 5 (2432 MHz), cflags:700e2
Sep 20 22:06:50 violino kernel: [  123.127268] ath_set_channel(hw_reset)
Sep 20 22:06:50 violino kernel: [  123.135261] ForceXPAon: 0
Sep 20 22:06:50 violino kernel: [  123.363361] ath_set_channel: 5 (2432 MHz) -> 6 (2437 MHz), cflags:700e2
Sep 20 22:06:50 violino kernel: [  123.367266] ath_set_channel(hw_reset)
Sep 20 22:06:50 violino kernel: [  123.600055] ath_set_channel: 6 (2437 MHz) -> 7 (2442 MHz), cflags:700e2
Sep 20 22:06:50 violino kernel: [  123.603243] ath_set_channel(hw_reset)
Sep 20 22:06:50 violino kernel: [  123.839344] ath_set_channel: 7 (2442 MHz) -> 8 (2447 MHz), cflags:500e0
Sep 20 22:06:50 violino kernel: [  123.843242] ath_set_channel(hw_reset)
Sep 20 22:06:50 violino kernel: [  123.851225] ForceXPAon: 0
Sep 20 22:06:51 violino kernel: [  124.083311] ath_set_channel: 8 (2447 MHz) -> 9 (2452 MHz), cflags:500e2
Sep 20 22:06:51 violino kernel: [  124.087230] ath_set_channel(hw_reset)
Sep 20 22:06:51 violino kernel: [  124.319636] ath_set_channel: 9 (2452 MHz) -> 10 (2457 MHz), cflags:500e2
Sep 20 22:06:51 violino kernel: [  124.323193] ath_set_channel(hw_reset)
Sep 20 22:06:51 violino kernel: [  124.559373] ath_set_channel: 10 (2457 MHz) -> 11 (2462 MHz), cflags:500e2
Sep 20 22:06:51 violino kernel: [  124.563216] ath_set_channel(hw_reset)
Sep 20 22:06:51 violino kernel: [  124.791358] ath_set_channel: 11 (2462 MHz) -> 8 (2447 MHz), cflags:500e2
Sep 20 22:06:51 violino kernel: [  124.795182] ath_set_channel(hw_reset)
Sep 20 22:06:51 violino kernel: [  124.803005] ath_set_channel: 8 (2447 MHz) -> 8 (2447 MHz), cflags:500e2
Sep 20 22:06:51 violino kernel: [  124.803194] ath_set_channel: 8 (2447 MHz) -> 8 (2447 MHz), cflags:500e2
Sep 20 22:06:51 violino kernel: [  124.807751] ath_set_channel: 8 (2447 MHz) -> 8 (2447 MHz), cflags:500e2
Sep 20 22:06:51 violino kernel: [  124.811518] ath_set_channel(hw_reset)
Sep 20 22:06:51 violino kernel: [  124.819175] ForceXPAon: 0
Sep 20 22:06:51 violino kernel: [  124.819965] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
Sep 20 22:07:10 violino kernel: [  143.645121] ath_set_channel: 8 (2447 MHz) -> 1 (2412 MHz), cflags:300e2
Sep 20 22:07:10 violino kernel: [  143.649050] ath_set_channel(hw_reset)
Sep 20 22:07:10 violino kernel: [  143.657030] ForceXPAon: 0
Sep 20 22:07:10 violino kernel: [  143.889135] ath_set_channel: 1 (2412 MHz) -> 2 (2417 MHz), cflags:300e2
Sep 20 22:07:10 violino kernel: [  143.892870] ath_set_channel(hw_reset)
Sep 20 22:07:11 violino kernel: [  144.125217] ath_set_channel: 2 (2417 MHz) -> 3 (2422 MHz), cflags:300e2
Sep 20 22:07:11 violino kernel: [  144.128754] ath_set_channel(hw_reset)
Sep 20 22:07:11 violino kernel: [  144.362540] ath_set_channel: 3 (2422 MHz) -> 4 (2427 MHz), cflags:300e2
Sep 20 22:07:11 violino kernel: [  144.364644] ath_set_channel(hw_reset)
Sep 20 22:07:11 violino kernel: [  144.601001] ath_set_channel: 4 (2427 MHz) -> 5 (2432 MHz), cflags:700e2
Sep 20 22:07:11 violino kernel: [  144.604531] ath_set_channel(hw_reset)
Sep 20 22:07:11 violino kernel: [  144.612504] ForceXPAon: 0
Sep 20 22:07:11 violino kernel: [  144.836944] ath_set_channel: 5 (2432 MHz) -> 6 (2437 MHz), cflags:700e2
Sep 20 22:07:11 violino kernel: [  144.840343] ath_set_channel(hw_reset)
Sep 20 22:07:12 violino kernel: [  145.072322] ath_set_channel: 6 (2437 MHz) -> 7 (2442 MHz), cflags:700e2
Sep 20 22:07:12 violino kernel: [  145.076255] ath_set_channel(hw_reset)
Sep 20 22:07:12 violino kernel: [  145.312210] ath_set_channel: 7 (2442 MHz) -> 8 (2447 MHz), cflags:500e2
Sep 20 22:07:12 violino kernel: [  145.316119] ath_set_channel(hw_reset)
Sep 20 22:07:12 violino kernel: [  145.324082] ForceXPAon: 0
Sep 20 22:07:12 violino kernel: [  145.556154] ath_set_channel: 8 (2447 MHz) -> 9 (2452 MHz), cflags:500e2
Sep 20 22:07:12 violino kernel: [  145.559988] ath_set_channel(hw_reset)
Sep 20 22:07:12 violino kernel: [  145.797753] ath_set_channel: 9 (2452 MHz) -> 10 (2457 MHz), cflags:500e2
Sep 20 22:07:12 violino kernel: [  145.799855] ath_set_channel(hw_reset)
Sep 20 22:07:13 violino kernel: [  146.035856] ath_set_channel: 10 (2457 MHz) -> 11 (2462 MHz), cflags:500e2
Sep 20 22:07:13 violino kernel: [  146.039723] ath_set_channel(hw_reset)
Sep 20 22:07:13 violino kernel: [  146.277250] ath_set_channel: 11 (2462 MHz) -> 8 (2447 MHz), cflags:500e2
Sep 20 22:07:13 violino kernel: [  146.279565] ath_set_channel(hw_reset)
Sep 20 22:07:13 violino kernel: [  146.435548] ath_set_channel: 8 (2447 MHz) -> 1 (2412 MHz), cflags:300e2
Sep 20 22:07:13 violino kernel: [  146.439515] ath_set_channel(hw_reset)
Sep 20 22:07:13 violino kernel: [  146.447333] ForceXPAon: 0
Sep 20 22:07:13 violino kernel: [  146.671921] ath_set_channel: 1 (2412 MHz) -> 2 (2417 MHz), cflags:300e2
Sep 20 22:07:13 violino kernel: [  146.675349] ath_set_channel(hw_reset)
Sep 20 22:07:13 violino kernel: [  146.903311] ath_set_channel: 2 (2417 MHz) -> 3 (2422 MHz), cflags:300e2
Sep 20 22:07:13 violino kernel: [  146.907267] ath_set_channel(hw_reset)
Sep 20 22:07:14 violino kernel: [  147.135150] ath_set_channel: 3 (2422 MHz) -> 4 (2427 MHz), cflags:300e2
Sep 20 22:07:14 violino kernel: [  147.139122] ath_set_channel(hw_reset)
Sep 20 22:07:14 violino kernel: [  147.367039] ath_set_channel: 4 (2427 MHz) -> 5 (2432 MHz), cflags:700e2
Sep 20 22:07:14 violino kernel: [  147.370998] ath_set_channel(hw_reset)
Sep 20 22:07:14 violino kernel: [  147.378991] ForceXPAon: 0
Sep 20 22:07:14 violino kernel: [  147.602909] ath_set_channel: 5 (2432 MHz) -> 6 (2437 MHz), cflags:700e2
Sep 20 22:07:14 violino kernel: [  147.606870] ath_set_channel(hw_reset)
Sep 20 22:07:14 violino kernel: [  147.834791] ath_set_channel: 6 (2437 MHz) -> 7 (2442 MHz), cflags:700e2
Sep 20 22:07:14 violino kernel: [  147.838746] ath_set_channel(hw_reset)
Sep 20 22:07:15 violino kernel: [  148.066673] ath_set_channel: 7 (2442 MHz) -> 8 (2447 MHz), cflags:500e2
Sep 20 22:07:15 violino kernel: [  148.070630] ath_set_channel(hw_reset)
Sep 20 22:07:15 violino kernel: [  148.078606] ForceXPAon: 0
Sep 20 22:07:15 violino kernel: [  148.302578] ath_set_channel: 8 (2447 MHz) -> 9 (2452 MHz), cflags:500e2
Sep 20 22:07:15 violino kernel: [  148.306498] ath_set_channel(hw_reset)
Sep 20 22:07:15 violino kernel: [  148.538364] ath_set_channel: 9 (2452 MHz) -> 10 (2457 MHz), cflags:500e2
Sep 20 22:07:15 violino kernel: [  148.542317] ath_set_channel(hw_reset)
Sep 20 22:07:15 violino kernel: [  148.770463] ath_set_channel: 10 (2457 MHz) -> 11 (2462 MHz), cflags:500e2
Sep 20 22:07:15 violino kernel: [  148.774236] ath_set_channel(hw_reset)
Sep 20 22:07:16 violino kernel: [  149.002277] ath_set_channel: 11 (2462 MHz) -> 8 (2447 MHz), cflags:500e2
Sep 20 22:07:16 violino kernel: [  149.003940] ath_set_channel: 11 (2462 MHz) -> 8 (2447 MHz), cflags:500e2
Sep 20 22:07:16 violino kernel: [  149.006112] ath_set_channel(hw_reset)
Sep 20 22:07:16 violino kernel: [  149.006342] ath_set_channel(hw_reset)
Sep 20 22:07:16 violino kernel: [  149.010097] ath_set_channel: 8 (2447 MHz) -> 8 (2447 MHz), cflags:500e0
Sep 20 22:07:16 violino kernel: [  149.017537] ForceXPAon: 0
Sep 20 22:07:16 violino kernel: [  149.019365] ath_set_channel: 8 (2447 MHz) -> 8 (2447 MHz), cflags:500e0
Sep 20 22:07:26 violino kernel: [  159.048655] ath_set_channel: 8 (2447 MHz) -> 1 (2412 MHz), cflags:300e2
Sep 20 22:07:26 violino kernel: [  159.256439] ath_drain_txdata(hw_reset)
Sep 20 22:07:26 violino kernel: [  159.263669] ForceXPAon: 0
Sep 20 22:07:26 violino kernel: [  159.268020] ath_set_channel(hw_reset)
Sep 20 22:07:26 violino kernel: [  159.273868] ForceXPAon: 0

--------------090504070306030309080202--
