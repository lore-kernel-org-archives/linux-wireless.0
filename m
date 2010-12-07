Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:53604 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753038Ab0LGEfx (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 6 Dec 2010 23:35:53 -0500
Message-ID: <4CFDB9A5.1080107@candelatech.com>
Date: Mon, 06 Dec 2010 20:35:49 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"ath9k-devel@lists.ath9k.org" <ath9k-devel@venema.h4ckr.net>
Subject: Re: ath9k: txctl and/or TID corruption in ath_tx_start_dma.
References: <4CFD7CE2.8040706@candelatech.com>
In-Reply-To: <4CFD7CE2.8040706@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 12/06/2010 04:16 PM, Ben Greear wrote:
> This system is running 84 VIFs, WPA encryption, wpa-supplicant scan-sharing
> and some scan-avoidance logic in mac80211.
>
> All stations are trying to run a 56kbps TCP data flow as soon as they
> associate.
>
> I have seen and reported this problem previously, but it seems I finally
> got my debug code right, because now it prints useful information
> and recovers.
>
> Something is corrupting txctl->an, at the least.

I think maybe I found a cause for this.  According to net/mac80211.h, sta
can be null, but this code never checks for that.  If the compiler is being
clever, it may not actually do a dereference, so maybe that's why it never
crashed when assigning txctl->an.

I'm going to test this patch.  This one isn't always easy to hit, so going
to leave lots of debugging in mine...but if this looks correct, I or someone
else can provide a cleaned up patch...

diff --git a/drivers/net/wireless/ath/ath9k/xmit.c b/drivers/net/wireless/ath/ath9k/xmit.c
index 8b0b076..6cdb1d2 100644
--- a/drivers/net/wireless/ath/ath9k/xmit.c
+++ b/drivers/net/wireless/ath/ath9k/xmit.c
@@ -1764,7 +1764,20 @@ int ath_tx_start(struct ieee80211_hw *hw, struct sk_buff *skb,
         int frmlen = skb->len + FCS_LEN;
         int q;

-       txctl->an = (struct ath_node *)sta->drv_priv;
+       /* NOTE:  sta can be NULL according to net/mac80211.h */
+       if (sta) {
+               txctl->an = (struct ath_node *)sta->drv_priv;
+               if (((unsigned long)(txctl->an)) < 4096) {
+                       printk("invalid txctl->an: %p  sta: %p  sta->drv_priv: %p\n",
+                              txctl->an, sta, sta->drv_priv);
+                       WARN_ON(1);
+                       return -EINVAL;
+               }
+       }
+       else {
+               printk("ath9k: sta was NULL in ath_tx_start.\n");
+       }
+
         if (info->control.hw_key)
                 frmlen += info->control.hw_key->icv_len;



> The method with debug looks like this:
>
> /* FIXME: tx power */
> static int ath_tx_start_dma(struct ath_softc *sc, struct ath_buf *bf,
> struct ath_tx_control *txctl)
> {
> struct sk_buff *skb = bf->bf_mpdu;
> struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
> struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
> struct list_head bf_head;
> struct ath_atx_tid *tid;
> u8 tidno;
> int rv = 0;
>
> spin_lock_bh(&txctl->txq->axq_lock);
>
> if ((tx_info->flags & IEEE80211_TX_CTL_AMPDU) && txctl->an) {
> tidno = ieee80211_get_qos_ctl(hdr)[0] &
> IEEE80211_QOS_CTL_TID_MASK;
> BUG_ON(tidno < 0);
> BUG_ON(tidno >= WME_NUM_TID);
> tid = ATH_AN_2_TID(txctl->an, tidno);
>
> if ((!tid) || ((unsigned long)(tid) < 4096)) {
> printk("ERROR: ath9k: tid is NULL, tid: %p tidno: %i txctl->an: %p\n",
> tid, tidno, txctl->an);
> WARN_ON(1);
> rv = -EINVAL;
> goto out;
> }
> if (!tid->ac) {
> printk("ERROR: ath9k: tid->ac is NULL, tid: %p tidno: %i\n",
> tid, tidno);
> WARN_ON(tid->ac == NULL);
> rv = -EINVAL;
> goto out;
> }
> else {
> if (tid->ac->txq != txctl->txq) {
> printk("ERROR: ath9k: tid->ac->txq (%p) != txctl->txq (%p), tidno: %i\n",
> tid->ac->txq, txctl->txq, tidno);
> WARN_ON(tid->ac->txq != txctl->txq);
> rv = -EINVAL;
> goto out;
> }
> }
>
> /*
> * Try aggregation if it's a unicast data frame
> * and the destination is HT capable.
> */
> ath_tx_send_ampdu(sc, tid, bf, txctl);
> } else {
> INIT_LIST_HEAD(&bf_head);
> list_add_tail(&bf->list, &bf_head);
>
> bf->bf_state.bfs_ftype = txctl->frame_type;
> bf->bf_state.bfs_paprd = txctl->paprd;
>
> if (bf->bf_state.bfs_paprd)
> ar9003_hw_set_paprd_txdesc(sc->sc_ah, bf->bf_desc,
> bf->bf_state.bfs_paprd);
>
> ath_tx_send_normal(sc, txctl->txq, NULL, &bf_head);
> }
> out:
> spin_unlock_bh(&txctl->txq->axq_lock);
> return rv;
> }
>
>
>
> Dec 6 15:20:56 localhost kernel: ADDRCONF(NETDEV_UP): sta67: link is not ready
> Dec 6 15:20:56 localhost kernel: start_sw_scan: running-other-vifs: 0 running-station-vifs: 69, associated-stations: 67 scanning current channel: 2437 MHz
> Dec 6 15:20:56 localhost kernel: ADDRCONF(NETDEV_UP): sta68: link is not ready
> Dec 6 15:20:56 localhost kernel: ERROR: ath9k: tid is NULL, tid: 0000002c tidno: 0 txctl->an: 00000028
> Dec 6 15:20:56 localhost kernel: ------------[ cut here ]------------
> Dec 6 15:20:56 localhost kernel: WARNING: at /home/greearb/git/linux.wireless-testing/drivers/net/wireless/ath/ath9k/xmit.c:1708 ath_tx_start+0x4cd/0x69a [ath9k]()
> Dec 6 15:20:56 localhost kernel: Hardware name: PDSBM
> Dec 6 15:20:56 localhost kernel: Modules linked in: aes_i586 aes_generic 8021q garp stp llc michael_mic fuse macvlan pktgen nfs lockd fscache nfs_acl
> auth_rpcgss sunrpc ipv6 uinput arc4 ecb ath9k mac80211 ath9k_common ath9k_hw ath microcode e1000e iTCO_wdt cfg80211 iTCO_vendor_support pcspkr i2c_i801 i915
> drm_kms_helper drm i2c_algo_bit i2c_core video output [last unloaded: michael_mic]
> Dec 6 15:20:56 localhost kernel: Pid: 7652, comm: sh Tainted: P 2.6.37-rc4-wl+ #55
> Dec 6 15:20:56 localhost kernel: Call Trace:
> Dec 6 15:20:56 localhost kernel: [<78436fbd>] warn_slowpath_common+0x77/0x8c
> Dec 6 15:20:56 localhost kernel: [<f9260932>] ? ath_tx_start+0x4cd/0x69a [ath9k]
> Dec 6 15:20:56 localhost kernel: [<f9260932>] ? ath_tx_start+0x4cd/0x69a [ath9k]
> Dec 6 15:20:56 localhost kernel: [<78436fef>] warn_slowpath_null+0x1d/0x1f
> Dec 6 15:20:56 localhost kernel: [<f9260932>] ath_tx_start+0x4cd/0x69a [ath9k]
> Dec 6 15:20:56 localhost kernel: [<f925ac69>] ath9k_tx+0x197/0x1c8 [ath9k]
> Dec 6 15:20:56 localhost kernel: [<f91a93fe>] __ieee80211_tx+0x102/0x167 [mac80211]
> Dec 6 15:20:56 localhost kernel: [<f91aad9b>] ieee80211_tx_pending+0x108/0x1fe [mac80211]
> Dec 6 15:20:57 localhost kernel: [<7843bba5>] tasklet_action+0x88/0xe3
> Dec 6 15:20:57 localhost kernel: [<7843c121>] __do_softirq+0x85/0x142
> Dec 6 15:20:57 localhost kernel: [<7843c09c>] ? __do_softirq+0x0/0x142
> Dec 6 15:20:57 localhost kernel: <IRQ> [<7843bf43>] ? irq_exit+0x35/0x69
> Dec 6 15:20:57 localhost kernel: [<78404245>] ? do_IRQ+0x8e/0xa2
> Dec 6 15:20:57 localhost kernel: [<784cfade>] ? __d_lookup+0x6a/0x10d
> Dec 6 15:20:57 localhost kernel: [<784036ae>] ? common_interrupt+0x2e/0x40
> Dec 6 15:20:57 localhost kernel: [<784c00d8>] ? do_loop_readv_writev+0x20/0x50
> Dec 6 15:20:57 localhost kernel: [<784c7bbb>] ? path_get+0x1/0x23
> Dec 6 15:20:57 localhost kernel: [<784bf42b>] ? nameidata_to_filp+0x2a/0x52
> Dec 6 15:20:57 localhost kernel: [<784c9026>] ? may_open+0x87/0xf9
> Dec 6 15:20:57 localhost kernel: [<784c93d9>] ? do_last+0x341/0x42d
> Dec 6 15:20:57 localhost kernel: [<784cab6b>] ? do_filp_open+0x364/0x409
> Dec 6 15:20:57 localhost kernel: [<784c01e5>] ? fsnotify_access+0x65/0x6d
> Dec 6 15:20:57 localhost kernel: [<784c557d>] ? open_exec+0x28/0x7c
> Dec 6 15:20:57 localhost kernel: [<784f25cd>] ? load_elf_binary+0x1b6/0xf61
> Dec 6 15:20:57 localhost kernel: [<784c49fa>] ? search_binary_handler+0x14d/0x223
> Dec 6 15:20:57 localhost kernel: [<784c4956>] ? search_binary_handler+0xa9/0x223
> Dec 6 15:20:57 localhost kernel: [<784f2417>] ? load_elf_binary+0x0/0xf61
> Dec 6 15:20:57 localhost kernel: [<784c5d6e>] ? do_execve+0x159/0x225
> Dec 6 15:20:57 localhost kernel: [<78408ccb>] ? sys_execve+0x31/0x53
> Dec 6 15:20:57 localhost kernel: [<784031d2>] ? ptregs_execve+0x12/0x20
> Dec 6 15:20:57 localhost kernel: [<784030dc>] ? sysenter_do_call+0x12/0x38
> Dec 6 15:20:57 localhost kernel: ---[ end trace 445c2a46f5f18fe7 ]---
> Dec 6 15:20:57 localhost kernel: ERROR: ath9k: tid is NULL, tid: 0000002c tidno: 0 txctl->an: 00000028
> Dec 6 15:20:57 localhost kernel: ------------[ cut here ]------------
> Dec 6 15:20:57 localhost kernel: WARNING: at /home/greearb/git/linux.wireless-testing/drivers/net/wireless/ath/ath9k/xmit.c:1708 ath_tx_start+0x4cd/0x69a [ath9k]()
> Dec 6 15:20:57 localhost kernel: Hardware name: PDSBM
> Dec 6 15:20:57 localhost kernel: Modules linked in: aes_i586 aes_generic 8021q garp stp llc michael_mic fuse macvlan pktgen nfs lockd fscache nfs_acl
> auth_rpcgss sunrpc ipv6 uinput arc4 ecb ath9k mac80211 ath9k_common ath9k_hw ath microcode e1000e iTCO_wdt cfg80211 iTCO_vendor_support pcspkr i2c_i801 i915
> drm_kms_helper drm i2c_algo_bit i2c_core video output [last unloaded: michael_mic]
> Dec 6 15:20:57 localhost kernel: Pid: 7652, comm: sh Tainted: P W 2.6.37-rc4-wl+ #55
> Dec 6 15:20:57 localhost kernel: Call Trace:
> Dec 6 15:20:57 localhost kernel: [<78436fbd>] warn_slowpath_common+0x77/0x8c
> Dec 6 15:20:57 localhost kernel: [<f9260932>] ? ath_tx_start+0x4cd/0x69a [ath9k]
> Dec 6 15:20:57 localhost kernel: [<f9260932>] ? ath_tx_start+0x4cd/0x69a [ath9k]
> Dec 6 15:20:57 localhost kernel: [<78436fef>] warn_slowpath_null+0x1d/0x1f
> Dec 6 15:20:57 localhost kernel: [<f9260932>] ath_tx_start+0x4cd/0x69a [ath9k]
> Dec 6 15:20:57 localhost kernel: [<f925ac69>] ath9k_tx+0x197/0x1c8 [ath9k]
> Dec 6 15:20:57 localhost kernel: [<f91a93fe>] __ieee80211_tx+0x102/0x167 [mac80211]
> Dec 6 15:20:57 localhost kernel: [<f91aad9b>] ieee80211_tx_pending+0x108/0x1fe [mac80211]
> Dec 6 15:20:57 localhost kernel: [<7843bba5>] tasklet_action+0x88/0xe3
> Dec 6 15:20:57 localhost kernel: [<7843c121>] __do_softirq+0x85/0x142
> Dec 6 15:20:57 localhost kernel: [<7843c09c>] ? __do_softirq+0x0/0x142
> Dec 6 15:20:57 localhost kernel: <IRQ> [<7843bf43>] ? irq_exit+0x35/0x69
> Dec 6 15:20:57 localhost kernel: [<78404245>] ? do_IRQ+0x8e/0xa2
> Dec 6 15:20:57 localhost kernel: [<784cfade>] ? __d_lookup+0x6a/0x10d
> Dec 6 15:20:57 localhost kernel: [<784036ae>] ? common_interrupt+0x2e/0x40
> Dec 6 15:20:57 localhost kernel: [<784c00d8>] ? do_loop_readv_writev+0x20/0x50
> Dec 6 15:20:57 localhost kernel: [<784c7bbb>] ? path_get+0x1/0x23
> Dec 6 15:20:57 localhost kernel: [<784bf42b>] ? nameidata_to_filp+0x2a/0x52
> Dec 6 15:20:57 localhost kernel: [<784c9026>] ? may_open+0x87/0xf9
> Dec 6 15:20:57 localhost kernel: [<784c93d9>] ? do_last+0x341/0x42d
> Dec 6 15:20:57 localhost kernel: [<784cab6b>] ? do_filp_open+0x364/0x409
> Dec 6 15:20:57 localhost kernel: [<784c01e5>] ? fsnotify_access+0x65/0x6d
> Dec 6 15:20:57 localhost kernel: [<784c557d>] ? open_exec+0x28/0x7c
> Dec 6 15:20:57 localhost kernel: [<784f25cd>] ? load_elf_binary+0x1b6/0xf61
> Dec 6 15:20:57 localhost kernel: [<784c49fa>] ? search_binary_handler+0x14d/0x223
> Dec 6 15:20:57 localhost kernel: [<784c4956>] ? search_binary_handler+0xa9/0x223
> Dec 6 15:20:57 localhost kernel: [<784f2417>] ? load_elf_binary+0x0/0xf61
> Dec 6 15:20:57 localhost kernel: [<784c5d6e>] ? do_execve+0x159/0x225
> Dec 6 15:20:57 localhost kernel: [<78408ccb>] ? sys_execve+0x31/0x53
> Dec 6 15:20:57 localhost kernel: [<784031d2>] ? ptregs_execve+0x12/0x20
> Dec 6 15:20:57 localhost kernel: [<784030dc>] ? sysenter_do_call+0x12/0x38
> Dec 6 15:20:57 localhost kernel: ---[ end trace 445c2a46f5f18fe8 ]---
> Dec 6 15:20:57 localhost kernel: ERROR: ath9k: tid is NULL, tid: 0000002c tidno: 0 txctl->an: 00000028


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com
