Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-qk0-f171.google.com ([209.85.220.171]:35749 "EHLO
        mail-qk0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754746AbdHYRvh (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 25 Aug 2017 13:51:37 -0400
Received: by mail-qk0-f171.google.com with SMTP id p67so2567068qkd.2
        for <linux-wireless@vger.kernel.org>; Fri, 25 Aug 2017 10:51:36 -0700 (PDT)
From: Jes Sorensen <jes.sorensen@gmail.com>
To: linux-wireless@vger.kernel.org
Cc: Larry Finger <larry.finger@lwfinger.net>
Subject: rtlwifi handling of sequence numbers with aggregation
Message-ID: <17ea196f-2f77-5110-8f33-4a25765ad34e@gmail.com> (sfid-20170825_195140_682800_02060257)
Date: Fri, 25 Aug 2017 13:51:33 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

Looking at some bits in rtlwifi I came across a discrepancy between the
PCI and USB code.

Consider the following code:

In rtl_pci_tx():
	if (ieee80211_is_data_qos(fc)) {
		tid = rtl_get_tid(skb);
		if (sta) {
			sta_entry = (struct rtl_sta_info *)sta->drv_priv;
			seq_number = (le16_to_cpu(hdr->seq_ctrl) &
				      IEEE80211_SCTL_SEQ) >> 4;
			seq_number += 1;

			if (!ieee80211_has_morefrags(hdr->frame_control))
				sta_entry->tids[tid].seq_number = seq_number;
		}

In _rtl_usb_tx_preprocess():
	if (ieee80211_is_data_qos(fc)) {
		qc = ieee80211_get_qos_ctl(hdr);
		tid = qc[0] & IEEE80211_QOS_CTL_TID_MASK;
		seq_number = (le16_to_cpu(hdr->seq_ctrl) &
			     IEEE80211_SCTL_SEQ) >> 4;
		seq_number += 1;
		seq_number <<= 4;
	}
[snip]
	if (!ieee80211_has_morefrags(hdr->frame_control)) {
		if (qc)
			mac->tids[tid].seq_number = seq_number;
	}

The seq_number is picked up from ieee80211_ops->ampdu_action()
which calls into rtl_tx_agg_start():
	tid_data = &sta_entry->tids[tid];

	RT_TRACE(rtlpriv, COMP_SEND, DBG_DMESG,
		 "on ra = %pM tid = %d seq:%d\n", sta->addr, tid,
		 tid_data->seq_number);

	*ssn = tid_data->seq_number;

My question here is why does the USB code shift seq_number << 4 while
the PCI code doesn't? I assume one of these is wrong, but which one?

Jes
