Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:34627 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751455Ab1BIXAz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Feb 2011 18:00:55 -0500
Received: from [192.168.100.195] (firewall.candelatech.com [70.89.124.249])
	(authenticated bits=0)
	by ns3.lanforge.com (8.14.2/8.14.2) with ESMTP id p19N0sHj016840
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-wireless@vger.kernel.org>; Wed, 9 Feb 2011 15:00:54 -0800
Message-ID: <4D531CA6.8010903@candelatech.com>
Date: Wed, 09 Feb 2011 15:00:54 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: ath9k and pktgen generate WARNings.
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I see this warning when I generate traffic with a hacked version
of pktgen.  This works with various other interfaces w/out problems,
so I think it's probably an ath9k and/or mac80211 bug.


WARNING: at /home/greearb/git/linux.wireless-testing-ct/drivers/net/wireless/ath/ath9k/xmit.c:1735 ath_tx_start+0x43c/0x607 [ath9k]()
Hardware name: To Be Filled By O.E.M.
Modules linked in: bridge nfs lockd bluetooth cryptd aes_i586 aes_generic veth 8021q garp stp llc fuse macvlan pktgen coretemp hwmon fscache nfs_acl auth_rpcgss 
sunrpc ipv6 uinput arc4 ecb snd_hda_codec_realtek ath9k snd_hda_intel snd_hda_codec mac80211 snd_hwdep snd_seq snd_seq_device ath9k_common ath9k_hw snd_pcm ath 
cfg80211 microcode snd_timer iTCO_wdt snd iTCO_vendor_support i2c_i801 serio_raw pcspkr soundcore r8169 snd_page_alloc mii i915 drm_kms_helper drm i2c_algo_bit 
video [last unloaded: lockd]
Pid: 1729, comm: kpktgend_0 Tainted: G        W   2.6.38-rc4-wl+ #21
Call Trace:
  [<c043091b>] ? warn_slowpath_common+0x65/0x7a
  [<f8ded7e8>] ? ath_tx_start+0x43c/0x607 [ath9k]
  [<c043093f>] ? warn_slowpath_null+0xf/0x13
  [<f8ded7e8>] ? ath_tx_start+0x43c/0x607 [ath9k]
  [<f8de74d0>] ? ath9k_tx+0x14f/0x183 [ath9k]
  [<f8d1326d>] ? __ieee80211_tx+0x10c/0x18c [mac80211]
  [<f8d13397>] ? ieee80211_tx+0xaa/0x188 [mac80211]
  [<f8d135f3>] ? ieee80211_xmit+0x17e/0x186 [mac80211]
  [<f8d11cc0>] ? ieee80211_skb_resize+0x8e/0xd2 [mac80211]
  [<f8d1448b>] ? ieee80211_subif_start_xmit+0x643/0x65c [mac80211]
  [<c0440000>] ? rescuer_thread+0x25/0x1c8
  [<f92cd354>] ? pktgen_thread_worker+0x114c/0x1b44 [pktgen]
  [<f8d13e48>] ? ieee80211_subif_start_xmit+0x0/0x65c [mac80211]
  [<c042d612>] ? default_wake_function+0xb/0xd
  [<c04254c7>] ? __wake_up_common+0x34/0x5c
  [<c0443a29>] ? autoremove_wake_function+0x0/0x2f
  [<f92cc208>] ? pktgen_thread_worker+0x0/0x1b44 [pktgen]
  [<c044371a>] ? kthread+0x62/0x67
  [<c04436b8>] ? kthread+0x0/0x67
  [<c04035f6>] ? kernel_thread_helper+0x6/0x10


/* FIXME: tx power */
static void ath_tx_start_dma(struct ath_softc *sc, struct ath_buf *bf,
			     struct ath_tx_control *txctl)
{
	struct sk_buff *skb = bf->bf_mpdu;
	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
	struct list_head bf_head;
	struct ath_atx_tid *tid = NULL;
	u8 tidno;

	spin_lock_bh(&txctl->txq->axq_lock);

	if (ieee80211_is_data_qos(hdr->frame_control) && txctl->an) {
		tidno = ieee80211_get_qos_ctl(hdr)[0] &
			IEEE80211_QOS_CTL_TID_MASK;
		tid = ATH_AN_2_TID(txctl->an, tidno);

		WARN_ON(tid->ac->txq != txctl->txq);
	}

Anyone have any ideas on this one?

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

