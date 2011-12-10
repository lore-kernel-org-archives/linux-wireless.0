Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mailout-de.gmx.net ([213.165.64.23]:36248 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751046Ab1LJNCw (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 10 Dec 2011 08:02:52 -0500
Message-ID: <4EE35877.1060507@gmx.net> (sfid-20111210_140255_490293_C3C0F113)
Date: Sat, 10 Dec 2011 14:02:47 +0100
From: Wolfgang Breyha <wbreyha@gmx.net>
MIME-Version: 1.0
To: Johannes Berg <johannes.berg@intel.com>,
	"Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: iwlwifi havoc on some APs (rekeying?)
References: <4EE2202A.4080303@gmx.net>  <1323446534.13074.96.camel@wwguy-huron>  <4EE24DF4.4020301@gmx.net>  <1323451436.13074.158.camel@wwguy-huron>  (sfid-20111209_192243_598986_F6275AE2) <1323455216.3622.21.camel@jlt3.sipsolutions.net>
In-Reply-To: <1323455216.3622.21.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/12/11 19:26, Johannes Berg wrote:
> What's "this area"? This isn't exactly the first report of random memory
> corruption ... I think the last one was something with 32/64 bit but I
> don't remember.

To narrow down "this area" I tried the following:

*) I reconfigured my soekris AP hostapd to use wpa_group_rekey=0
   .... and it works like a charm since then

*) I reconfigured the ubiquiti UniFi AP to use wpa_group_rekey=120
   ... and I'am pretty sure now that it is exactly the second rekeying
   that starts messing up the system. Exactly after wpa_supplicant logs
WPA: Group rekeying completed with 06:27:22:xx:xx:xx [GTK=TKIP]
   the second time, video streaming with VLC immediatly leeds to all the
   mentioned sideeffects.

Maybe it's possible to reproduce it with any hostapd based AP with
active wpa_group_rekey.

Greetings, Wolfgang
