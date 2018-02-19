Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mga18.intel.com ([134.134.136.126]:43153 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751000AbeBSHE1 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Mon, 19 Feb 2018 02:04:27 -0500
Date: Mon, 19 Feb 2018 15:04:09 +0800
From: kbuild test robot <lkp@intel.com>
To: Luca Coelho <luca@coelho.fi>
Cc: kbuild-all@01.org, johannes@sipsolutions.net,
        linux-wireless@vger.kernel.org, Ilan Peer <ilan.peer@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>
Subject: Re: [PATCH 10/13] mac80211: agg-rx: Accept ADDBA request update if
 timeout did not change
Message-ID: <201802191452.c17L6wEj%fengguang.wu@intel.com> (sfid-20180219_080523_604320_C37F65D4)
References: <20180216161301.29339-11-luca@coelho.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180216161301.29339-11-luca@coelho.fi>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Ilan,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on mac80211-next/master]
[also build test WARNING on v4.16-rc2 next-20180216]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Luca-Coelho/cfg80211-mac80211-patches-from-our-internal-tree-2018-02-16/20180219-114128
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git master
reproduce:
        # apt-get install sparse
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)

>> net/mac80211/agg-rx.c:309:51: sparse: dereference of noderef expression

vim +309 net/mac80211/agg-rx.c

   230	
   231	void ___ieee80211_start_rx_ba_session(struct sta_info *sta,
   232					      u8 dialog_token, u16 timeout,
   233					      u16 start_seq_num, u16 ba_policy, u16 tid,
   234					      u16 buf_size, bool tx, bool auto_seq)
   235	{
   236		struct ieee80211_local *local = sta->sdata->local;
   237		struct tid_ampdu_rx *tid_agg_rx;
   238		struct ieee80211_ampdu_params params = {
   239			.sta = &sta->sta,
   240			.action = IEEE80211_AMPDU_RX_START,
   241			.tid = tid,
   242			.amsdu = false,
   243			.timeout = timeout,
   244			.ssn = start_seq_num,
   245		};
   246		int i, ret = -EOPNOTSUPP;
   247		u16 status = WLAN_STATUS_REQUEST_DECLINED;
   248	
   249		if (tid >= IEEE80211_FIRST_TSPEC_TSID) {
   250			ht_dbg(sta->sdata,
   251			       "STA %pM requests BA session on unsupported tid %d\n",
   252			       sta->sta.addr, tid);
   253			goto end;
   254		}
   255	
   256		if (!sta->sta.ht_cap.ht_supported) {
   257			ht_dbg(sta->sdata,
   258			       "STA %pM erroneously requests BA session on tid %d w/o QoS\n",
   259			       sta->sta.addr, tid);
   260			/* send a response anyway, it's an error case if we get here */
   261			goto end;
   262		}
   263	
   264		if (test_sta_flag(sta, WLAN_STA_BLOCK_BA)) {
   265			ht_dbg(sta->sdata,
   266			       "Suspend in progress - Denying ADDBA request (%pM tid %d)\n",
   267			       sta->sta.addr, tid);
   268			goto end;
   269		}
   270	
   271		/* sanity check for incoming parameters:
   272		 * check if configuration can support the BA policy
   273		 * and if buffer size does not exceeds max value */
   274		/* XXX: check own ht delayed BA capability?? */
   275		if (((ba_policy != 1) &&
   276		     (!(sta->sta.ht_cap.cap & IEEE80211_HT_CAP_DELAY_BA))) ||
   277		    (buf_size > IEEE80211_MAX_AMPDU_BUF)) {
   278			status = WLAN_STATUS_INVALID_QOS_PARAM;
   279			ht_dbg_ratelimited(sta->sdata,
   280					   "AddBA Req with bad params from %pM on tid %u. policy %d, buffer size %d\n",
   281					   sta->sta.addr, tid, ba_policy, buf_size);
   282			goto end;
   283		}
   284		/* determine default buffer size */
   285		if (buf_size == 0)
   286			buf_size = IEEE80211_MAX_AMPDU_BUF;
   287	
   288		/* make sure the size doesn't exceed the maximum supported by the hw */
   289		if (buf_size > sta->sta.max_rx_aggregation_subframes)
   290			buf_size = sta->sta.max_rx_aggregation_subframes;
   291		params.buf_size = buf_size;
   292	
   293		ht_dbg(sta->sdata, "AddBA Req buf_size=%d for %pM\n",
   294		       buf_size, sta->sta.addr);
   295	
   296		/* examine state machine */
   297		lockdep_assert_held(&sta->ampdu_mlme.mtx);
   298	
   299		if (test_bit(tid, sta->ampdu_mlme.agg_session_valid)) {
   300			if (sta->ampdu_mlme.tid_rx_token[tid] == dialog_token) {
   301				ht_dbg_ratelimited(sta->sdata,
   302						   "updated AddBA Req from %pM on tid %u\n",
   303						   sta->sta.addr, tid);
   304				/* We have no API to update the timeout value in the
   305				 * driver so reject the timeout update if the timeout
   306				 * changed. If if did not change, i.e., no real update,
   307				 * just reply with success.
   308				 */
 > 309				if (sta->ampdu_mlme.tid_rx[tid]->timeout == timeout)
   310					status = WLAN_STATUS_SUCCESS;
   311				else
   312					status = WLAN_STATUS_REQUEST_DECLINED;
   313				goto end;
   314			}
   315	
   316			ht_dbg_ratelimited(sta->sdata,
   317					   "unexpected AddBA Req from %pM on tid %u\n",
   318					   sta->sta.addr, tid);
   319	
   320			/* delete existing Rx BA session on the same tid */
   321			___ieee80211_stop_rx_ba_session(sta, tid, WLAN_BACK_RECIPIENT,
   322							WLAN_STATUS_UNSPECIFIED_QOS,
   323							false);
   324		}
   325	
   326		if (ieee80211_hw_check(&local->hw, SUPPORTS_REORDERING_BUFFER)) {
   327			ret = drv_ampdu_action(local, sta->sdata, &params);
   328			ht_dbg(sta->sdata,
   329			       "Rx A-MPDU request on %pM tid %d result %d\n",
   330			       sta->sta.addr, tid, ret);
   331			if (!ret)
   332				status = WLAN_STATUS_SUCCESS;
   333			goto end;
   334		}
   335	
   336		/* prepare A-MPDU MLME for Rx aggregation */
   337		tid_agg_rx = kzalloc(sizeof(*tid_agg_rx), GFP_KERNEL);
   338		if (!tid_agg_rx)
   339			goto end;
   340	
   341		spin_lock_init(&tid_agg_rx->reorder_lock);
   342	
   343		/* rx timer */
   344		timer_setup(&tid_agg_rx->session_timer,
   345			    sta_rx_agg_session_timer_expired, TIMER_DEFERRABLE);
   346	
   347		/* rx reorder timer */
   348		timer_setup(&tid_agg_rx->reorder_timer,
   349			    sta_rx_agg_reorder_timer_expired, 0);
   350	
   351		/* prepare reordering buffer */
   352		tid_agg_rx->reorder_buf =
   353			kcalloc(buf_size, sizeof(struct sk_buff_head), GFP_KERNEL);
   354		tid_agg_rx->reorder_time =
   355			kcalloc(buf_size, sizeof(unsigned long), GFP_KERNEL);
   356		if (!tid_agg_rx->reorder_buf || !tid_agg_rx->reorder_time) {
   357			kfree(tid_agg_rx->reorder_buf);
   358			kfree(tid_agg_rx->reorder_time);
   359			kfree(tid_agg_rx);
   360			goto end;
   361		}
   362	
   363		for (i = 0; i < buf_size; i++)
   364			__skb_queue_head_init(&tid_agg_rx->reorder_buf[i]);
   365	
   366		ret = drv_ampdu_action(local, sta->sdata, &params);
   367		ht_dbg(sta->sdata, "Rx A-MPDU request on %pM tid %d result %d\n",
   368		       sta->sta.addr, tid, ret);
   369		if (ret) {
   370			kfree(tid_agg_rx->reorder_buf);
   371			kfree(tid_agg_rx->reorder_time);
   372			kfree(tid_agg_rx);
   373			goto end;
   374		}
   375	
   376		/* update data */
   377		tid_agg_rx->ssn = start_seq_num;
   378		tid_agg_rx->head_seq_num = start_seq_num;
   379		tid_agg_rx->buf_size = buf_size;
   380		tid_agg_rx->timeout = timeout;
   381		tid_agg_rx->stored_mpdu_num = 0;
   382		tid_agg_rx->auto_seq = auto_seq;
   383		tid_agg_rx->started = false;
   384		tid_agg_rx->reorder_buf_filtered = 0;
   385		tid_agg_rx->tid = tid;
   386		tid_agg_rx->sta = sta;
   387		status = WLAN_STATUS_SUCCESS;
   388	
   389		/* activate it for RX */
   390		rcu_assign_pointer(sta->ampdu_mlme.tid_rx[tid], tid_agg_rx);
   391	
   392		if (timeout) {
   393			mod_timer(&tid_agg_rx->session_timer, TU_TO_EXP_TIME(timeout));
   394			tid_agg_rx->last_rx = jiffies;
   395		}
   396	
   397	end:
   398		if (status == WLAN_STATUS_SUCCESS) {
   399			__set_bit(tid, sta->ampdu_mlme.agg_session_valid);
   400			__clear_bit(tid, sta->ampdu_mlme.unexpected_agg);
   401			sta->ampdu_mlme.tid_rx_token[tid] = dialog_token;
   402		}
   403	
   404		if (tx)
   405			ieee80211_send_addba_resp(sta->sdata, sta->sta.addr, tid,
   406						  dialog_token, status, 1, buf_size,
   407						  timeout);
   408	}
   409	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
