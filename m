Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nbd.name ([46.4.11.11]:38325 "EHLO nbd.name"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754752Ab1BJUBw (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 10 Feb 2011 15:01:52 -0500
Message-ID: <4D54442C.4060907@openwrt.org>
Date: Thu, 10 Feb 2011 21:01:48 +0100
From: Felix Fietkau <nbd@openwrt.org>
MIME-Version: 1.0
To: Ben Greear <greearb@candelatech.com>
CC: Helmut Schaa <helmut.schaa@googlemail.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: ath9k and pktgen generate WARNings.
References: <4D531CA6.8010903@candelatech.com> <201102100931.38777.helmut.schaa@googlemail.com> <4D541E1B.5030707@candelatech.com> <201102101854.41627.helmut.schaa@googlemail.com> <4D5427A0.20806@candelatech.com> <4D543B18.5000404@openwrt.org> <4D543FF7.3060305@candelatech.com>
In-Reply-To: <4D543FF7.3060305@candelatech.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 2011-02-10 8:43 PM, Ben Greear wrote:
> On 02/10/2011 11:23 AM, Felix Fietkau wrote:
>> On 2011-02-10 7:00 PM, Ben Greear wrote:
>>> On 02/10/2011 09:54 AM, Helmut Schaa wrote:
>>>> Am Donnerstag, 10. Februar 2011 schrieb Ben Greear:
>>>>> On 02/10/2011 12:31 AM, Helmut Schaa wrote:
>>>>>> Am Donnerstag, 10. Februar 2011 schrieb Ben Greear:
>>>>>>> I see this warning when I generate traffic with a hacked version
>>>>>>> of pktgen.  This works with various other interfaces w/out problems,
>>>>>>> so I think it's probably an ath9k and/or mac80211 bug.
>>>>>>>
>>>>>>>
>>>>>>> WARNING: at /home/greearb/git/linux.wireless-testing-ct/drivers/net/wireless/ath/ath9k/xmit.c:1735 ath_tx_start+0x43c/0x607 [ath9k]()
>>>>>>> Hardware name: To Be Filled By O.E.M.
>>>>>>> Modules linked in: bridge nfs lockd bluetooth cryptd aes_i586 aes_generic veth 8021q garp stp llc fuse macvlan pktgen coretemp hwmon fscache nfs_acl auth_rpcgss
>>>>>>> sunrpc ipv6 uinput arc4 ecb snd_hda_codec_realtek ath9k snd_hda_intel snd_hda_codec mac80211 snd_hwdep snd_seq snd_seq_device ath9k_common ath9k_hw snd_pcm ath
>>>>>>> cfg80211 microcode snd_timer iTCO_wdt snd iTCO_vendor_support i2c_i801 serio_raw pcspkr soundcore r8169 snd_page_alloc mii i915 drm_kms_helper drm i2c_algo_bit
>>>>>>> video [last unloaded: lockd]
>>>>>>> Pid: 1729, comm: kpktgend_0 Tainted: G        W   2.6.38-rc4-wl+ #21
>>>>>>> Call Trace:
>>>>>>>      [<c043091b>] ? warn_slowpath_common+0x65/0x7a
>>>>>>>      [<f8ded7e8>] ? ath_tx_start+0x43c/0x607 [ath9k]
>>>>>>>      [<c043093f>] ? warn_slowpath_null+0xf/0x13
>>>>>>>      [<f8ded7e8>] ? ath_tx_start+0x43c/0x607 [ath9k]
>>>>>>>      [<f8de74d0>] ? ath9k_tx+0x14f/0x183 [ath9k]
>>>>>>>      [<f8d1326d>] ? __ieee80211_tx+0x10c/0x18c [mac80211]
>>>>>>>      [<f8d13397>] ? ieee80211_tx+0xaa/0x188 [mac80211]
>>>>>>>      [<f8d135f3>] ? ieee80211_xmit+0x17e/0x186 [mac80211]
>>>>>>>      [<f8d11cc0>] ? ieee80211_skb_resize+0x8e/0xd2 [mac80211]
>>>>>>>      [<f8d1448b>] ? ieee80211_subif_start_xmit+0x643/0x65c [mac80211]
>>>>>>>      [<c0440000>] ? rescuer_thread+0x25/0x1c8
>>>>>>>      [<f92cd354>] ? pktgen_thread_worker+0x114c/0x1b44 [pktgen]
>>>>>>>      [<f8d13e48>] ? ieee80211_subif_start_xmit+0x0/0x65c [mac80211]
>>>>>>>      [<c042d612>] ? default_wake_function+0xb/0xd
>>>>>>>      [<c04254c7>] ? __wake_up_common+0x34/0x5c
>>>>>>>      [<c0443a29>] ? autoremove_wake_function+0x0/0x2f
>>>>>>>      [<f92cc208>] ? pktgen_thread_worker+0x0/0x1b44 [pktgen]
>>>>>>>      [<c044371a>] ? kthread+0x62/0x67
>>>>>>>      [<c04436b8>] ? kthread+0x0/0x67
>>>>>>>      [<c04035f6>] ? kernel_thread_helper+0x6/0x10
>>>>>>>
>>>>>>>
>>>>>>> /* FIXME: tx power */
>>>>>>> static void ath_tx_start_dma(struct ath_softc *sc, struct ath_buf *bf,
>>>>>>> 			     struct ath_tx_control *txctl)
>>>>>>> {
>>>>>>> 	struct sk_buff *skb = bf->bf_mpdu;
>>>>>>> 	struct ieee80211_tx_info *tx_info = IEEE80211_SKB_CB(skb);
>>>>>>> 	struct ieee80211_hdr *hdr = (struct ieee80211_hdr *)skb->data;
>>>>>>> 	struct list_head bf_head;
>>>>>>> 	struct ath_atx_tid *tid = NULL;
>>>>>>> 	u8 tidno;
>>>>>>>
>>>>>>> 	spin_lock_bh(&txctl->txq->axq_lock);
>>>>>>>
>>>>>>> 	if (ieee80211_is_data_qos(hdr->frame_control)&&    txctl->an) {
>>>>>>> 		tidno = ieee80211_get_qos_ctl(hdr)[0]&
>>>>>>> 			IEEE80211_QOS_CTL_TID_MASK;
>>>>>>> 		tid = ATH_AN_2_TID(txctl->an, tidno);
>>>>>>>
>>>>>>> 		WARN_ON(tid->ac->txq != txctl->txq);
>>>>>>> 	}
>>>>>>>
>>>>>>> Anyone have any ideas on this one?
>>>>>>
>>>>>> pktgen seems to directly inject frames via the xmit callback and hence
>>>>>> mac80211's select_queue callback isn't used for proper queue assignment.
>>>>>>
>>>>>> However, you should be able to specify the queue manuelly with
>>>>>> "cur_queue_map".
>>>>>
>>>>> Yes, but I don't think I should have to know this detail.
>>>>>
>>>>> Once you send pkts with queue-map of 0 to ath9k, it spews
>>>>> kernel warnings and then you have to rmmod the NIC before
>>>>> it will start working again (because it's queues are
>>>>> messed up probably).
>>>>>
>>>>> I'm not sure my patch is the correct way to fix it, but
>>>>> we need to do _something_ in mac80211 and/or ath9k I think.
>>>>
>>>> Why not make pktgen use the select_queue callback instead?
>>>
>>> It's a test tool and should be able to force queue selection
>>> if it wants to.  I'd rather not have special case code to
>>> know if underlying interface is wifi (and thus need special
>>> queue selection).
>>>
>>> I'd rather carry that hack to mac80211 I posted instead,
>>> if it comes to that.
>> How about adding a patch that makes mac80211 detect a mismatch between
>> skb->priority and the queue mapping and then adjust the skb priority
>> based on that.
> 
> I'd by happy to test one..but I get seriously confused in this code.
> 
> I *think* that maybe this would entail modifying the qos field a few lines
> above my hack..but I'm not sure, and not sure to what value it should
> be set.
No, you should not modify the QoS header. Modify skb->priority before
the 802.11 header is generated.

- Felix
