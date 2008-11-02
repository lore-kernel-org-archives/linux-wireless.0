Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.deathmatch.net ([70.167.247.36]:2001 "EHLO
	mail.deathmatch.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754124AbYKBSmZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 2 Nov 2008 13:42:25 -0500
Date: Sun, 2 Nov 2008 13:41:46 -0500
From: Bob Copeland <me@bobcopeland.com>
To: Nick Kossifidis <mickflemm@gmail.com>
Cc: "Luis R. Rodriguez" <mcgrof@gmail.com>, tim.gardner@canonical.com,
	mick@madwifi.org, linux-wireless@vger.kernel.org,
	"John W. Linville" <linville@tuxdriver.com>
Subject: Re: wireless-testing commit eb9d4e8399181357cb6f6625ba7f849987432c6c causes stalls
Message-ID: <20081102184146.GA6065@hash.localnet> (sfid-20081102_194254_320749_3B9A2984)
References: <4908B754.1050400@tpi.com> <43e72e890811011419k460b11e0he08d66022cbd606e@mail.gmail.com> <40f31dec0811020132o640afa49u56791b4122013463@mail.gmail.com> <40f31dec0811020110t6ec94c57gd91adc44f759bf45@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <40f31dec0811020110t6ec94c57gd91adc44f759bf45@mail.gmail.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, Nov 02, 2008 at 11:10:04AM +0200, Nick Kossifidis wrote:
> Can you test the attached patch ?
> 
> It works for me (tested on a AR5413)...
> 
> makis linux # iperf -s
> ------------------------------------------------------------
> Server listening on TCP port 5001
> TCP window size: 85.3 KByte (default)
> ------------------------------------------------------------
> [  4] local 192.168.1.104 port 5001 connected with 192.168.1.10 port 43192
> [ ID] Interval       Transfer     Bandwidth
> [  4]  0.0-10.6 sec  21.8 MBytes  17.2 Mbits/sec

This patch works for me (I was seeing the same stalls).

I somehow managed to trigger this after reloading the module:

Nov  2 13:12:05 sludge kernel: ------------[ cut here ]------------
Nov  2 13:12:05 sludge kernel: WARNING: at net/mac80211/main.c:236
ieee80211_hw_config+0x82/0x8c [mac80211]()
Nov  2 13:12:05 sludge kernel: Modules linked in: ath5k af_packet
sha256_generic aes_i586 aes_generic cbc loop i915 drm binfmt_misc
acpi_cpufreq fan container nls_utf8 hfsplus dm_crypt dm_mod kvm_intel
kvm fuse sbp2 snd_hda_intel snd_pcm_oss snd_pcm snd_mixer_oss appletouch
hid_apple snd_seq_dummy snd_seq_oss arc4 ecb snd_seq_midi usbhid
snd_rawmidi snd_seq_midi_event mac80211 snd_seq ohci1394 snd_timer
snd_seq_device sr_mod ieee1394 sky2 cfg80211 sg cdrom rtc ehci_hcd
uhci_hcd thermal bitrev crc32 snd snd_page_alloc battery ac processor
button evdev unix [last unloaded: ath5k]
Nov  2 13:12:05 sludge kernel: Pid: 9748, comm: ath5k_pci Tainted: G
W  2.6.28-rc2-wl #19
[...]

But I think that was just a coincidence with the hardware getting
stuck in a bad state -- after reboot it was fine.  If not, this at least 
papers over the warning :)

diff --git a/drivers/net/wireless/ath5k/base.c b/drivers/net/wireless/ath5k/base.c
index a298e8a..0308165 100644
--- a/drivers/net/wireless/ath5k/base.c
+++ b/drivers/net/wireless/ath5k/base.c
@@ -2796,7 +2796,8 @@ ath5k_config(struct ieee80211_hw *hw, u32 changed)
 	sc->bintval = conf->beacon_int;
 	sc->power_level = conf->power_level;
 
-	return ath5k_chan_set(sc, conf->channel);
+	ath5k_chan_set(sc, conf->channel);
+	return 0;
 }
 
 static int
-- 
1.5.4.2.182.gb3092

-- 
Bob Copeland %% www.bobcopeland.com

