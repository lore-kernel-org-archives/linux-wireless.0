Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from liberdade.minaslivre.org ([72.232.254.139]:52252 "EHLO
	liberdade.minaslivre.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933609Ab0BEBFU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Feb 2010 20:05:20 -0500
From: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
To: linux-wireless@vger.kernel.org
Cc: Thadeu Lima de Souza Cascardo <cascardo@holoscopio.com>
Subject: [PATCH] nl80211: allow adding new station to devices in mesh mode
Date: Thu,  4 Feb 2010 23:00:42 -0200
Message-Id: <1265331642-27773-1-git-send-email-cascardo@holoscopio.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

When trying to use the NEW_STATION command, it fails with -EINVAL,
because there's no STA_SUPPORTED_RATES parameter. However, for mesh
mode, this parameter should be NULL. Besides, it requires
LISTEN_INTERVAL to be negative. We allow it to be ommited in the STA
case too, in which it will be -1.

---

Hello.

I was trying to use iw station set in mesh mode and found out I wanted
to call NEW_STATION. I've quickly added a station new command to iw. I
am experimenting with mesh mode with a mac80211 driver. Then, I
realized nl80211_new_station requires STA_SUPPORTED_RATES to be set and,
then, requires it not to be set for mesh mode. I've patched it to
require STA_SUPPORTED_RATES only for AP mode. But now, I get a warning
on rate_lowest_index (from include/net/mac80211.h) and kernel panics
right after that. I've done it on top of latest rc and I am currently
building a version on top of wireless-testing/master.

I've not got any kdump yet, but here is the oops and the patch for iw
too. I've not signed-off the nl80211 patch yet because I want some
feedback and remove this panic.

static int handle_plink_new(struct nl80211_state *state,
                             struct nl_cb *cb,
                             struct nl_msg *msg,
                             int argc, char **argv)
{
       unsigned char mac_addr[ETH_ALEN];

       if (argc < 1)
               return 1;

       if (mac_addr_a2n(mac_addr, argv[0])) {
               fprintf(stderr, "invalid mac address\n");
               return 2;
       }
       NLA_PUT(msg, NL80211_ATTR_MAC, ETH_ALEN, mac_addr);
       return 0;

 nla_put_failure:
       return -ENOBUFS;
}
COMMAND(station, new, "<MAC address>",
       NL80211_CMD_NEW_STATION, 0, CIB_NETDEV, handle_plink_new,
       "Add new plink.");

Feb  4 20:30:56 vespa kernel: [  368.489565] ------------[ cut here ]------------
Feb  4 20:30:56 vespa kernel: [  368.489835] WARNING: at /home/cascardo/linux-2.6/include/net/mac80211.h:2317 minstrel_rate_init+0x63/0x2be [mac80211]()
Feb  4 20:30:56 vespa kernel: [  368.490886] Hardware name: 2658J3U
Feb  4 20:30:56 vespa kernel: [  368.491255] Modules linked in: ath5k mac80211 ath cfg80211 radeon ttm drm_kms_helper drm i2c_algo_bit sco bridge stp llc bnep rfcomm l2cap crc16 bluetooth nsc_ircc ipv6 arc4 ecb snd_intel8x0 snd_intel8x0m snd_ac97_codec thinkpad_acpi ac97_bus rfkill snd_pcm snd_seq snd_timer snd_seq_device pcmcia mousedev snd led_class soundcore video 8250_pnp irda rtc_cmos processor yenta_socket psmouse crc_ccitt snd_page_alloc rtc_core 8250 button battery ac nvram parport_pc rsrc_nonstatic serio_raw i2c_i801 rtc_lib serial_core parport pcspkr pcmcia_core output evdev i2c_core ext3 jbd mbcache dm_mod sg sr_mod cdrom sd_mod crc_t10dif ata_generic uhci_hcd ata_piix libata ehci_hcd e100 intel_agp mii scsi_mod usbcore nls_base agpgart thermal fan thermal_sys hwmon unix [last unloaded: cfg80211]
Feb  4 20:30:56 vespa kernel: [  368.504638] Pid: 1493, comm: iw Not tainted 2.6.33-rc6-00007-g1c67e56a #11
Feb  4 20:30:56 vespa kernel: [  368.504874] Call Trace:
Feb  4 20:30:56 vespa kernel: [  368.505676]  [<c102d882>] warn_slowpath_common+0x6a/0x81
Feb  4 20:30:56 vespa kernel: [  368.514861]  [<f86f1182>] ? minstrel_rate_init+0x63/0x2be [mac80211]
Feb  4 20:30:56 vespa kernel: [  368.524272]  [<c102d8ab>] warn_slowpath_null+0x12/0x15
Feb  4 20:30:56 vespa kernel: [  368.533846]  [<f86f1182>] minstrel_rate_init+0x63/0x2be [mac80211]
Feb  4 20:30:56 vespa kernel: [  368.543567]  [<c10333f7>] ? local_bh_enable+0x10/0x12
Feb  4 20:30:56 vespa kernel: [  368.553209]  [<f86ccd69>] ? sta_info_alloc+0x150/0x15d [mac80211]
Feb  4 20:30:56 vespa kernel: [  368.562871]  [<f86d8ef5>] ieee80211_add_station+0xe3/0x125 [mac80211]
Feb  4 20:30:56 vespa kernel: [  368.572431]  [<f86d8e12>] ? ieee80211_add_station+0x0/0x125 [mac80211]
Feb  4 20:30:56 vespa kernel: [  368.582076]  [<f814230f>] nl80211_new_station+0x164/0x1a2 [cfg80211]
Feb  4 20:30:56 vespa kernel: [  368.591780]  [<c11eab3c>] genl_rcv_msg+0x1a7/0x1c4
Feb  4 20:30:56 vespa kernel: [  368.601294]  [<c11ea995>] ? genl_rcv_msg+0x0/0x1c4
Feb  4 20:30:56 vespa kernel: [  368.610600]  [<c11e9c8d>] netlink_rcv_skb+0x35/0x7b
Feb  4 20:30:56 vespa kernel: [  368.619710]  [<c11ea98e>] genl_rcv+0x20/0x27
Feb  4 20:30:56 vespa kernel: [  368.628538]  [<c11e9abc>] netlink_unicast+0xeb/0x148
Feb  4 20:30:56 vespa kernel: [  368.637372]  [<c11ea1b8>] netlink_sendmsg+0x216/0x223
Feb  4 20:30:56 vespa kernel: [  368.646265]  [<c10c9392>] ? path_to_nameidata+0x16/0x2f
Feb  4 20:30:56 vespa kernel: [  368.655292]  [<c11c4a85>] __sock_sendmsg+0x4a/0x53
Feb  4 20:30:56 vespa kernel: [  368.664485]  [<c11c4d42>] sock_sendmsg+0x97/0xab
Feb  4 20:30:56 vespa kernel: [  368.673372]  [<c10f85e3>] ? proc_alloc_inode+0x1b/0x6a
Feb  4 20:30:56 vespa kernel: [  368.682160]  [<c1113d8b>] ? security_inode_alloc+0x1e/0x20
Feb  4 20:30:56 vespa kernel: [  368.690878]  [<c12368d7>] ? add_preempt_count+0x9f/0xa2
Feb  4 20:30:56 vespa kernel: [  368.699426]  [<c123682b>] ? sub_preempt_count+0x84/0x91
Feb  4 20:30:56 vespa kernel: [  368.707818]  [<c101e0d4>] ? kunmap_atomic+0x86/0x9d
Feb  4 20:30:56 vespa kernel: [  368.716232]  [<c11cd165>] ? copy_from_user+0xd/0xf
Feb  4 20:30:56 vespa kernel: [  368.724662]  [<c11cd478>] ? verify_iovec+0x43/0x6f
Feb  4 20:30:56 vespa kernel: [  368.732805]  [<c11c4f79>] sys_sendmsg+0x18c/0x1f0
Feb  4 20:30:56 vespa kernel: [  368.740813]  [<c11d4bf6>] ? dev_ioctl+0x524/0x577
Feb  4 20:30:56 vespa kernel: [  368.748870]  [<c12367b0>] ? sub_preempt_count+0x9/0x91
Feb  4 20:30:56 vespa kernel: [  368.756850]  [<c123682b>] ? sub_preempt_count+0x84/0x91
Feb  4 20:30:56 vespa kernel: [  368.764613]  [<c123682b>] ? sub_preempt_count+0x84/0x91
Feb  4 20:30:56 vespa kernel: [  368.772215]  [<c1094678>] ? unlock_page+0x42/0x45
Feb  4 20:30:56 vespa kernel: [  368.779676]  [<c10a6d93>] ? __do_fault+0x31d/0x34d
Feb  4 20:30:56 vespa kernel: [  368.787145]  [<c10a869d>] ? handle_mm_fault+0x380/0x7d7
Feb  4 20:30:56 vespa kernel: [  368.794377]  [<c10d5731>] ? mntput_no_expire+0x1e/0x8c
Feb  4 20:30:56 vespa kernel: [  368.801584]  [<c11c6a87>] sys_socketcall+0x163/0x1aa
Feb  4 20:30:56 vespa kernel: [  368.808628]  [<c113d5f4>] ? trace_hardirqs_on_thunk+0xc/0x10
Feb  4 20:30:56 vespa kernel: [  368.815669]  [<c100329f>] sysenter_do_call+0x12/0x2d
Feb  4 20:30:56 vespa kernel: [  368.822608] ---[ end trace 5ab7f913a209c320 ]---

---
 net/wireless/nl80211.c |   24 +++++++++++++-----------
 1 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/net/wireless/nl80211.c b/net/wireless/nl80211.c
index 5b79ecf..43e0137 100644
--- a/net/wireless/nl80211.c
+++ b/net/wireless/nl80211.c
@@ -2000,23 +2000,23 @@ static int nl80211_new_station(struct sk_buff *skb, struct genl_info *info)
 	u8 *mac_addr = NULL;
 
 	memset(&params, 0, sizeof(params));
+	params.listen_interval = -1;
 
 	if (!info->attrs[NL80211_ATTR_MAC])
 		return -EINVAL;
 
-	if (!info->attrs[NL80211_ATTR_STA_LISTEN_INTERVAL])
-		return -EINVAL;
+	mac_addr = nla_data(info->attrs[NL80211_ATTR_MAC]);
 
-	if (!info->attrs[NL80211_ATTR_STA_SUPPORTED_RATES])
-		return -EINVAL;
+	if (info->attrs[NL80211_ATTR_STA_SUPPORTED_RATES]) {
+		params.supported_rates =
+			nla_data(info->attrs[NL80211_ATTR_STA_SUPPORTED_RATES]);
+		params.supported_rates_len =
+			nla_len(info->attrs[NL80211_ATTR_STA_SUPPORTED_RATES]);
+	}
 
-	mac_addr = nla_data(info->attrs[NL80211_ATTR_MAC]);
-	params.supported_rates =
-		nla_data(info->attrs[NL80211_ATTR_STA_SUPPORTED_RATES]);
-	params.supported_rates_len =
-		nla_len(info->attrs[NL80211_ATTR_STA_SUPPORTED_RATES]);
-	params.listen_interval =
-		nla_get_u16(info->attrs[NL80211_ATTR_STA_LISTEN_INTERVAL]);
+	if (info->attrs[NL80211_ATTR_STA_LISTEN_INTERVAL])
+		params.listen_interval =
+		    nla_get_u16(info->attrs[NL80211_ATTR_STA_LISTEN_INTERVAL]);
 
 	if (info->attrs[NL80211_ATTR_STA_AID]) {
 		params.aid = nla_get_u16(info->attrs[NL80211_ATTR_STA_AID]);
@@ -2050,6 +2050,8 @@ static int nl80211_new_station(struct sk_buff *skb, struct genl_info *info)
 		/* all ok but must have AID */
 		if (!params.aid)
 			err = -EINVAL;
+		if (!params.supported_rates)
+			err = -EINVAL;
 		break;
 	case NL80211_IFTYPE_MESH_POINT:
 		/* disallow things mesh doesn't support */
-- 
1.6.6.1

