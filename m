Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from xc.sipsolutions.net ([83.246.72.84]:38328 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754845AbZJ3HQD (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 30 Oct 2009 03:16:03 -0400
Subject: Re: wpa_supplicant eventual unrecoverable state
From: Johannes Berg <johannes@sipsolutions.net>
To: "Luis R. Rodriguez" <mcgrof@gmail.com>
Cc: "Jouni.Malinen" <Jouni.Malinen@atheros.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <43e72e890910291613u2a00125etfb31c8e95a66a5ea@mail.gmail.com>
References: <43e72e890910291613u2a00125etfb31c8e95a66a5ea@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 30 Oct 2009 08:16:03 +0100
Message-ID: <1256886963.3555.7.camel@johannes.local>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2009-10-29 at 16:13 -0700, Luis R. Rodriguez wrote:
> Following up on the thread I started about some odd state
> wpa_supplicant gets into, I now managed to get the dmesg log of this
> happening.

> [10551.652480] wlan1: deauthenticating from 00:0b:85:6f:12:ac by local
> choice (reason=3)

Please everybody take more care to not line-wrap logs.

> [10551.676034] ------------[ cut here ]------------
> [10551.676057] WARNING: at net/mac80211/scan.c:291
> ieee80211_scan_completed+0x26c/0x280 [mac80211]()
> [10551.676061] Hardware name: 7660A14
> [10551.676064] Modules linked in: ath9k ath9k_hw mac80211 ath cfg80211
> aes_generic i915 drm_kms_helper drm i2c_algo_bit binfmt_misc bridge
> stp bnep lp snd_hda_codec_analog snd_hda_intel snd_hda_codec
> snd_pcm_oss snd_mixer_oss arc4 snd_pcm snd_seq_dummy snd_seq_oss
> snd_seq_midi snd_rawmidi snd_seq_midi_event snd_seq pcmcia snd_timer
> snd_seq_device ppdev joydev psmouse yenta_socket rsrc_nonstatic snd
> parport_pc hid_microsoft video intel_agp thinkpad_acpi soundcore
> parport serio_raw usbhid output pcmcia_core pcspkr agpgart nvram
> iTCO_wdt led_class btusb snd_page_alloc iTCO_vendor_support ohci1394
> ieee1394 [last unloaded: e1000e]
> [10551.676149] Pid: 8068, comm: wpa_supplicant Tainted: G        W
> 2.6.32-rc5-wl #28
> [10551.676153] Call Trace:
> [10551.676162]  [<c05a3a03>] ? printk+0x1d/0x22
> [10551.676176]  [<fce0916c>] ? ieee80211_scan_completed+0x26c/0x280 [mac80211]
> [10551.676184]  [<c0146121>] warn_slowpath_common+0x71/0xd0
> [10551.676198]  [<fce0916c>] ? ieee80211_scan_completed+0x26c/0x280 [mac80211]
> [10551.676204]  [<c014619a>] warn_slowpath_null+0x1a/0x20
> [10551.676218]  [<fce0916c>] ieee80211_scan_completed+0x26c/0x280 [mac80211]
> [10551.676231]  [<fce091c9>] ieee80211_scan_cancel+0x49/0x80 [mac80211]
> [10551.676247]  [<fce1287a>] ieee80211_stop+0x59a/0x5b0 [mac80211]
> [10551.676254]  [<c04e513e>] ? dev_deactivate+0x17e/0x1a0
> [10551.676260]  [<c04d34cb>] dev_close+0x6b/0xc0

This patch should help.

johannes

---
 net/mac80211/scan.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- wireless-testing.orig/net/mac80211/scan.c	2009-10-30 08:11:52.000000000 +0100
+++ wireless-testing/net/mac80211/scan.c	2009-10-30 08:14:42.000000000 +0100
@@ -288,10 +288,14 @@ void ieee80211_scan_completed(struct iee
 
 	mutex_lock(&local->scan_mtx);
 
-	if (WARN_ON(!local->scanning)) {
-		mutex_unlock(&local->scan_mtx);
-		return;
-	}
+	/*
+	 * It's ok to abort a not-yet-running scan (that
+	 * we have one at all will be verified by checking
+	 * local->scan_req next), but not to complete it
+	 * successfully.
+	 */
+	if (WARN_ON(!local->scanning && !aborted))
+		aborted = true;
 
 	if (WARN_ON(!local->scan_req)) {
 		mutex_unlock(&local->scan_mtx);


