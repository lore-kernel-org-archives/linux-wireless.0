Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:32131 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750878AbeDNG46 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Sat, 14 Apr 2018 02:56:58 -0400
Date: Sat, 14 Apr 2018 14:56:07 +0800
From: kbuild test robot <lkp@intel.com>
To: Balaji Pothunoori <bpothuno@codeaurora.org>
Cc: kbuild-all@01.org, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org, bpothuno@codeaurora.org
Subject: Re: [PATCH 3/3] ath10k: average ack rssi support for data frames
Message-ID: <201804141443.kfAcfemD%fengguang.wu@intel.com> (sfid-20180414_085702_342088_518C4FE3)
References: <1523619357-1963-4-git-send-email-bpothuno@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1523619357-1963-4-git-send-email-bpothuno@codeaurora.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Balaji,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on next-20180411]
[cannot apply to ath6kl/ath-next v4.16 v4.16-rc7 v4.16-rc6 v4.16]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Balaji-Pothunoori/cfg80211-average-ack-rssi-support-for-data-frames/20180414-115825
reproduce:
        # apt-get install sparse
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

   drivers/net/wireless/ath/ath10k/htt_rx.c:236:23: sparse: expression using sizeof(void)
   drivers/net/wireless/ath/ath10k/htt_rx.c:389:31: sparse: expression using sizeof(void)
   drivers/net/wireless/ath/ath10k/htt_rx.c:402:39: sparse: expression using sizeof(void)
>> drivers/net/wireless/ath/ath10k/htt_rx.c:1911:30: sparse: cast to restricted __le16
>> drivers/net/wireless/ath/ath10k/htt_rx.c:1911:28: sparse: incorrect type in assignment (different base types) @@    expected restricted __le16 [usertype] msdu_count @@    got unsignedrestricted __le16 [usertype] msdu_count @@
   drivers/net/wireless/ath/ath10k/htt_rx.c:1911:28:    expected restricted __le16 [usertype] msdu_count
   drivers/net/wireless/ath/ath10k/htt_rx.c:1911:28:    got unsigned short [unsigned] [usertype] <noident>
>> drivers/net/wireless/ath/ath10k/htt_rx.c:1925:29: sparse: restricted __le16 degrades to integer
   drivers/net/wireless/ath/ath10k/htt_rx.c:1927:64: sparse: restricted __le16 degrades to integer
>> drivers/net/wireless/ath/ath10k/htt_rx.c:1926:50: sparse: incorrect type in assignment (different base types) @@    expected unsigned char [unsigned] [assigned] [usertype] ack_rssi @@    got igned] [usertype] ack_rssi @@
   drivers/net/wireless/ath/ath10k/htt_rx.c:1926:50:    expected unsigned char [unsigned] [assigned] [usertype] ack_rssi
   drivers/net/wireless/ath/ath10k/htt_rx.c:1926:50:    got restricted __le16 <noident>
   drivers/net/wireless/ath/ath10k/htt_rx.c:1930:64: sparse: restricted __le16 degrades to integer
   drivers/net/wireless/ath/ath10k/htt_rx.c:1929:50: sparse: incorrect type in assignment (different base types) @@    expected unsigned char [unsigned] [assigned] [usertype] ack_rssi @@    got igned] [usertype] ack_rssi @@
   drivers/net/wireless/ath/ath10k/htt_rx.c:1929:50:    expected unsigned char [unsigned] [assigned] [usertype] ack_rssi
   drivers/net/wireless/ath/ath10k/htt_rx.c:1929:50:    got restricted __le16 <noident>
   drivers/net/wireless/ath/ath10k/htt_rx.c: In function 'ath10k_htt_t2h_msg_handler':
   drivers/net/wireless/ath/ath10k/htt_rx.c:1886:9: warning: 'msdu_count' may be used uninitialized in this function [-Wmaybe-uninitialized]
     __le16 msdu_count;
            ^~~~~~~~~~

vim +1911 drivers/net/wireless/ath/ath10k/htt_rx.c

  1875	
  1876	static void ath10k_htt_rx_tx_compl_ind(struct ath10k *ar,
  1877					       struct sk_buff *skb)
  1878	{
  1879		struct ath10k_htt *htt = &ar->htt;
  1880		struct htt_resp *resp = (struct htt_resp *)skb->data;
  1881		struct htt_tx_done tx_done = {};
  1882		int status = MS(resp->data_tx_completion.flags, HTT_DATA_TX_STATUS);
  1883		__le16 msdu_id;
  1884		int i;
  1885		bool rssi_enabled;
  1886		__le16 msdu_count;
  1887	
  1888		switch (status) {
  1889		case HTT_DATA_TX_STATUS_NO_ACK:
  1890			tx_done.status = HTT_TX_COMPL_STATE_NOACK;
  1891			break;
  1892		case HTT_DATA_TX_STATUS_OK:
  1893			tx_done.status = HTT_TX_COMPL_STATE_ACK;
  1894			break;
  1895		case HTT_DATA_TX_STATUS_DISCARD:
  1896		case HTT_DATA_TX_STATUS_POSTPONE:
  1897		case HTT_DATA_TX_STATUS_DOWNLOAD_FAIL:
  1898			tx_done.status = HTT_TX_COMPL_STATE_DISCARD;
  1899			break;
  1900		default:
  1901			ath10k_warn(ar, "unhandled tx completion status %d\n", status);
  1902			tx_done.status = HTT_TX_COMPL_STATE_DISCARD;
  1903			break;
  1904		}
  1905	
  1906		ath10k_dbg(ar, ATH10K_DBG_HTT, "htt tx completion num_msdus %d\n",
  1907			   resp->data_tx_completion.num_msdus);
  1908	
  1909		if (resp->data_tx_completion.flags2 & HTT_TX_CMPL_FLAG_DATA_RSSI) {
  1910			rssi_enabled = true;
> 1911			msdu_count = __le16_to_cpu(resp->data_tx_completion.num_msdus);
  1912		} else {
  1913			rssi_enabled = false;
  1914		}
  1915	
  1916		for (i = 0; i < resp->data_tx_completion.num_msdus; i++) {
  1917			msdu_id = resp->data_tx_completion.msdus[i];
  1918			tx_done.msdu_id = __le16_to_cpu(msdu_id);
  1919	
  1920			if (rssi_enabled) {
  1921				/* Total no of MSDUs should be even,
  1922				 * if odd MSDUs are sent firmware fills
  1923				 * last msdu id with 0xffff
  1924				 */
> 1925				if (msdu_count & 0x01)
> 1926					tx_done.ack_rssi =
  1927					resp->data_tx_completion.msdus[msdu_count +  i + 1];
  1928				else
  1929					tx_done.ack_rssi =
  1930					resp->data_tx_completion.msdus[msdu_count + i];
  1931			}
  1932			/* kfifo_put: In practice firmware shouldn't fire off per-CE
  1933			 * interrupt and main interrupt (MSI/-X range case) for the same
  1934			 * HTC service so it should be safe to use kfifo_put w/o lock.
  1935			 *
  1936			 * From kfifo_put() documentation:
  1937			 *  Note that with only one concurrent reader and one concurrent
  1938			 *  writer, you don't need extra locking to use these macro.
  1939			 */
  1940			if (!kfifo_put(&htt->txdone_fifo, tx_done)) {
  1941				ath10k_warn(ar, "txdone fifo overrun, msdu_id %d status %d\n",
  1942					    tx_done.msdu_id, tx_done.status);
  1943				ath10k_txrx_tx_unref(htt, &tx_done);
  1944			}
  1945		}
  1946	}
  1947	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
