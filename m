Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:57445 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757300AbXEWBGn (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 May 2007 21:06:43 -0400
Message-ID: <4653939B.9020904@garzik.org>
Date: Tue, 22 May 2007 21:06:35 -0400
From: Jeff Garzik <jeff@garzik.org>
MIME-Version: 1.0
To: James Ketrenos <jketreno@linux.intel.com>
CC: "John W. Linville" <linville@tuxdriver.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Randy Dunlap <randy.dunlap@oracle.com>,
	Michael Wu <flamingice@sourmilk.net>
Subject: Re: [PATCH v3]  Add iwlwifi wireless drivers
References: <464B7B7C.5080800@linux.intel.com> <465365B3.4090408@linux.intel.com>
In-Reply-To: <465365B3.4090408@linux.intel.com>
Content-Type: multipart/mixed;
 boundary="------------010902050308000006080600"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------010902050308000006080600
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

James Ketrenos wrote:
> An updated full patch (v3) to add the driver is available at:
>     
>     http://intellinuxwireless.org/iwlwifi/0001-v3-Add-iwlwifi-wireless-drivers.patch 

Quick review attached.

	Jeff




--------------010902050308000006080600
Content-Type: text/plain;
 name="notes.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="notes.txt"


1) iwl_queue_inc_wrap and iwl_queue_dec_wrap can usually avoid a branch,
if you use power-of-two queue size.

2) Using '%' to calculate index is more expensive than a mask

3) delete all casts to/from void pointers, such as

	txq->bd = (u8 *)
		pci_alloc_consistent(dev,

4) the difference in the TX queue size calculations is very error-prone:

	len = (sizeof(struct iwl_cmd) * count) + IWL_MAX_SCAN_SIZE;
		and
	len = (sizeof(txq->cmd[0]) * q->n_window) + IWL_MAX_SCAN_SIZE;

5) more Lindent damage to undo, in iwl_remove_station():

+               for (i = IWL_STA_ID; i < (priv->num_stations + IWL_STA_ID);
+                    i++) {
+                       if ((priv->stations[i].used)
+                           &&
+                           (!compare_ether_addr(
+                                   priv->stations[i].sta.sta.addr, bssid))) {
+                               index = i;
+                               priv->stations[index].used = 0;
+                               break;
+                       }
+               }

6) iwl_delete_stations_table() and iwl_clear_stations_table()
   are exactly the same implementation.  remove one.

7) ditto #5 in iwl_add_station()

8) obtain a ptr rather than repeatedly referencing priv->stations[i],
   in iwl_add_station()

9) de-indent the primary code block in iwl_sync_station(),
   by returning immediately if the sta_id is invalid

10) remove a lot of the 'inline' markers.  let the compiler decide that.

11) eliminate this compile-the-code-twice scheme

12) delete the myriad checks in iwl_send_cmd() that are never
    hit in real life.  Mark others WARN_ON() or whatever.

    That is just way too many needless checks in a hot path.

13) delete the conditional locking in iwl_send_cmd().  spinlocking
    should not be conditional.  it's error prone and usually wrong.  the
    spinlocking in this routine is an excellent example of that.
    [reads further]
    Yuck, it is -even worse- than I thought.

14) you don't need a prototype right before the function def:
+static int iwl_send_cmd_u32(struct iwl_priv *priv, u8 id, u32 val)
+    __attribute__ ((warn_unused_result));
+static int iwl_send_cmd_u32(struct iwl_priv *priv, u8 id, u32 val)
+{

15) more Lindent damage in iwl_check_rxon_cmd():
+       error |=
+           ((rxon->
+             flags & (RXON_FLG_AUTO_DETECT_MSK |

16) This whole CMD_ASYNC paradigm is problematic.  Use the standard
Linux style:  Make EVERYTHING async, and then have separate helpers that
allow the code to wait for completion.

17) more Lindent damage:
+       if (priv->frames_count) {
+               IWL_WARNING
+                   ("%d frames still in use.  Did we lose one?\n",
+                    priv->frames_count);

18) remove nonsense tests:
+       if (list_empty(&priv->free_frames)) {
...
+               if (priv->frames_count >= FREE_FRAME_THRESHOLD) {
+                       IWL_WARNING("%d frames allocated.  "
+                                   "Are we losing them?\n",
+                                   priv->frames_count);

19) iwl_free_frame() does not pay attention to FREE_FRAME_THRESHOLD

20) Lindent damage:
+               IWL_ERROR
+                   ("Coult not obtain free frame buffer for beacon "
+                    "command.\n");
+               return -ENOMEM;
+       }
+
+       if (!(priv->staging_rxon.flags & RXON_FLG_BAND_24G_MSK)) {
+               rate =
+                   iwl_rate_get_lowest_plcp(priv->active_rate_basic & 0xFF0);

21) poorly named function:
+static void eeprom_parse_mac(struct iwl_priv *priv, u8 * mac)
+{
+       memcpy(mac, priv->eeprom.mac_address, 6);
+}

22) kill magic numbers in iwl_eeprom_init()

23) bogus comment and messy declarations in iwl_report_frame():
+       /* these are declared without "=" to avoid compiler warnings if
we
+        *   don't use them in the debug messages below */
+       u16 frame_ctl;
+       u16 seq_ctl;
+       u16 channel;

    CLEARLY you will get 'unused variable' warnings, if you don't use them

24) as akpm said, don't break up variables, it makes decls look like
code blocks:
+       u8 agc;
+       u16 sig_avg;
+       u16 noise_diff;
+
+       struct iwl_rx_frame_stats *rx_stats = IWL_RX_STATS(pkt);
+       struct iwl_rx_frame_hdr *rx_hdr = IWL_RX_HDR(pkt);
+       struct iwl_rx_frame_end *rx_end = IWL_RX_END(pkt);
+       u8 *data = IWL_RX_DATA(pkt);


25) this loop needs some sort of fencing:
+               mutex_unlock(&priv->mutex);
+               if (ms)
+                       while (!time_after(jiffies,
+                                          now + msecs_to_jiffies(ms)) &&
+                              priv->status & STATUS_SCANNING)
+                               msleep(1);
+
+               mutex_lock(&priv->mutex);

26) overall, priv->status accesses look racy in many instances

27) ditch private workqueue

28) weird indentation:
+       IWL_DEBUG_RATE("station Id %d\n", sta_id);
+
+       qc = ieee80211_get_qos_ctrl(hdr);
+        if (qc) {
+               u8 tid = (u8)(*qc & 0xf);

29) are some uses of control_flags in iwl_tx_skb() endian-unsafe?

30) replace "todoG" with something standard to Linux like FIXME or TODO

31) iwl_rx_reply_scan() does nothing

32) racy priv->status manipulation in iwl_rx_scan_complete_notif()

33) kill braces around single C statements:
+       if (rxq->free_count <= RX_LOW_WATERMARK) {
+               queue_work(priv->workqueue, &priv->rx_replenish);
+       }

34) dont do this in your interrupt handler:
	* mask events
	* handle events
	* unmask events
    delete the mask/unmask stuff

35) your irq tasklet is unneeded.  just do it in the irq handler,
    and eliminate the races.

36) way too many allocations are GFP_ATOMIC.  that tells me you are
    often doing initialization in the wrong context

37) looks like iwl_read_ucode() needs endian accessors?

38) after disabling interrupts you need to do a read, to ensure your
request is flushed to the hardware

39) rename d_xxx functions.  those are ambiguous in a trace

40) no need to zero stuff in iwl_pci_probe(), priv should already be
zeroed for you

41) use pci_iomap() rather than ioremap_nocache()

42) you queue stuff to a workqueue, when it is obvious from context
(e.g. iwl_pci_probe) it can sleep

43) naming your module parameters param_xxx, and making them global
symbols, pollutes the global namespace and potentially introduces
conflicts

44) don't use reg_xxx as a function prefix, that is ambiguous in a trace

45) fix long function names:
	reg_txpower_compensate_for_temperature_dif()

46) ditto:
	iwl_write_restricted(), iwl_release_restricted_access()

47) kill magic numbers in pci_{read,write}_config_xxx calls

48) shorten too-long constant names:
	CSR_GP_CNTRL_REG_MSK_POWER_SAVE_TYPE
	CSR_RESET_REG_FLAG_MASTER_DISABLED,

49) PCI posting bug?
+
+       iwl_set_bit(priv, CSR_RESET, CSR_RESET_REG_FLAG_SW_RESET);
+
+       udelay(10);
+
+       iwl_set_bit(priv, CSR_GP_CNTRL, CSR_GP_CNTRL_REG_FLAG_INIT_DONE);

50) this is just silly:
+
+       spin_unlock_irqrestore(&priv->lock, flags);
+
+       spin_lock_irqsave(&priv->lock, flags);
+

51) fix long struct names:
	struct iwl_eeprom_calib_measurement

52) and struct member names:
	ch_i1 = priv->eeprom.calib_info.band_info_tbl[s].ch1.ch_num;

53) etc.
	iwl4965_get_txatten_group_from_channel()

54) magic number
+       if (-40 > current_temp) {
+               IWL_WARNING("Invalid temperature %d, can't calculate "

55) no need for all this casting and masking:
+static inline u32 iwl4965_get_dma_lo_address(dma_addr_t addr)
+{
+       return (u32) (addr & 0xffffffff);
+}

56) endian-ness in iwl4965_load_bsm()

57) no need to lock around a single MMIO write:
+       spin_lock_irqsave(&priv->lock, flags);
+
+       iwl_write32(priv, CSR_RESET, 0);
+
+       spin_unlock_irqrestore(&priv->lock, flags);

58) separate declarations and code:
+       };
+       u8 network_packet;
+       if ((unlikely(rx_start->cfg_mib_cnt > 20))) {

59) too long:
	iwl_write_restricted_reg_buffer()


--------------010902050308000006080600--
-: 
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org: 
More majordomo info at  http: //vger.kernel.org/majordomo-info.html
