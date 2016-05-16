Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtp.codeaurora.org ([198.145.29.96]:38312 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753410AbcEPN6X (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 16 May 2016 09:58:23 -0400
From: Kalle Valo <kvalo@codeaurora.org>
To: "Coelho\, Luciano" <luciano.coelho@intel.com>
Cc: "sfr\@canb.auug.org.au" <sfr@canb.auug.org.au>,
	"linux-wireless\@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"davem\@davemloft.net" <davem@davemloft.net>,
	"netdev\@vger.kernel.org" <netdev@vger.kernel.org>,
	"linux-next\@vger.kernel.org" <linux-next@vger.kernel.org>,
	"linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	emmanuel.grumbach@intel.com
Subject: Re: linux-next: manual merge of the wireless-drivers-next tree with the net-next tree
References: <20160516101606.751f9613@canb.auug.org.au>
	<871t529mik.fsf@kamboji.qca.qualcomm.com>
	<1463405875.25219.98.camel@intel.com>
Date: Mon, 16 May 2016 16:58:17 +0300
In-Reply-To: <1463405875.25219.98.camel@intel.com> (Luciano Coelho's message
	of "Mon, 16 May 2016 13:37:55 +0000")
Message-ID: <87shxi85qe.fsf@kamboji.qca.qualcomm.com> (sfid-20160516_155851_770558_3256D6BA)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

"Coelho, Luciano" <luciano.coelho@intel.com> writes:

(dropping damaged diffs etc, adding Emmanuel as the author of
5c08b0f5026f ("iwlwifi: mvm: don't override the rate with the AMSDU
len"))

>> I wasn't expecting that skb_info variable is removed. Do we now have
>> merge damage somewhere? Luca, what do you think?
>
> As we discussed on IRC, it seems to me that there was a merge damage
> when Dave merged net.git into net-next.git (as you mostly found out ;).
>
> I'm not sure how to solve that, but I'm sure you and Dave can figure
> something out. :) Please let me know if you need any help with it.

Yeah, I guess in net-next.git Dave assumed that 'info == skb_info' is
always valid in iwl_mvm_set_tx_cmd(), but I don't that's the case. So I
think the end case, after a merge, should look like this:

void iwl_mvm_set_tx_cmd(struct iwl_mvm *mvm, struct sk_buff *skb,
			struct iwl_tx_cmd *tx_cmd,
			struct ieee80211_tx_info *info, u8 sta_id)
{
	struct ieee80211_tx_info *skb_info = IEEE80211_SKB_CB(skb);
	struct ieee80211_hdr *hdr = (void *)skb->data;
	__le16 fc = hdr->frame_control;
	u32 tx_flags = le32_to_cpu(tx_cmd->tx_flags);
	u32 len = skb->len + FCS_LEN;
	u8 ac;

[...]

	tx_cmd->tx_flags = cpu_to_le32(tx_flags);
	/* Total # bytes to be transmitted */
	tx_cmd->len = cpu_to_le16((u16)skb->len +
		(uintptr_t)skb_info->driver_data[0]);
	tx_cmd->life_time = cpu_to_le32(TX_CMD_LIFE_TIME_INFINITE);
	tx_cmd->sta_id = sta_id;

I'm going to propose this to Dave in my pending pull request[1]. But I
would appreciate if someone else would double check this.

[1] https://patchwork.ozlabs.org/patch/621953/

-- 
Kalle Valo
