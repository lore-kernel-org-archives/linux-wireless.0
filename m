Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bl2nam02on0060.outbound.protection.outlook.com ([104.47.38.60]:28224
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752263AbcKPQr4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Wed, 16 Nov 2016 11:47:56 -0500
Subject: Re: [PATCH V3] qtnfmac: announcement of new FullMAC driver for
 Quantenna chipsets
To: Johannes Berg <johannes@sipsolutions.net>,
        <linux-wireless@vger.kernel.org>
References: <1478700000-11624-1-git-send-email-igor.mitsyanko.os@quantenna.com>
 <1478700000-11624-2-git-send-email-igor.mitsyanko.os@quantenna.com>
 <1479200773.12007.13.camel@sipsolutions.net>
CC: <btherthala@quantenna.com>, <hwang@quantenna.com>,
        <smaksimenko@quantenna.com>, <dlebed@quantenna.com>,
        Sergey Matyukevich <smatyukevich@quantenna.com>,
        Kamlesh Rath <krath@quantenna.com>,
        Avinash Patil <avinashp@quantenna.com>
From: IgorMitsyanko <igor.mitsyanko.os@quantenna.com>
Message-ID: <301c5abc-d28d-41dd-c7d6-4a7d7ec3681c@quantenna.com> (sfid-20161116_174800_994445_5DD3F6EF)
Date: Wed, 16 Nov 2016 19:47:45 +0300
MIME-Version: 1.0
In-Reply-To: <1479200773.12007.13.camel@sipsolutions.net>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/15/2016 12:06 PM, Johannes Berg wrote:
> On Wed, 2016-11-09 at 17:00 +0300, igor.mitsyanko.os@quantenna.com
> wrote:
>
>> +static int
>> +qtnf_change_virtual_intf(struct wiphy *wiphy,
>> +			 struct net_device *dev,
>> +			 enum nl80211_iftype type, u32 *flags,
>> +			 struct vif_params *params)
>> +{
>> +	struct qtnf_vif *vif;
>> +	u8 *mac_addr;
>> +
>> +	vif = qtnf_netdev_get_priv(dev);
>> +
>> +	if (params)
>> +		mac_addr = params->macaddr;
>> +	else
>> +		mac_addr = NULL;
>> +
>> +	if (qtnf_cmd_send_change_intf_type(vif, type, mac_addr)) {
>> +		pr_err("failed to change interface type\n");
>> +		return -EFAULT;
>> +	}
>> +
>> +	vif->wdev.iftype = type;
>> +	return 0;
>> +}
> Do you really support arbitrary type changes?

We do, only if there are no secondary BSSIDs exist on a physical radio 
in AP mode (MBSS is not active).

>
> You might even have to handle ongoing scans, etc.

Point taken, will review how we handle scans and other ongoing 
operations. I guess in case of ongoing operation, we can return "busy" 
error on attempt to change interface type.

>
>> +	/* Clear the vif in mac */
> "mac"? Maybe you mean cfg80211?

It meant to indicate that "vif" is part of "struct qtnf_wmac". I think 
we should remove this comment, don't see how it helps.

>
>> +	vif->netdev->ieee80211_ptr = NULL;
>> +	vif->netdev = NULL;
>> +	vif->wdev.iftype = NL80211_IFTYPE_UNSPECIFIED;
>> +	eth_zero_addr(vif->mac_addr);
>> +
>> +	return 0;
>> +}
> But I'm not sure this makes sense? You're not actually deleting the
> interface here, so why sever all the links/clear all the data?

Setting "iftype = NL80211_IFTYPE_UNSPECIFIED" effectively marks 
interface as free to use. Clearing all the data should not be strictly 
necessary, but should help catch bugs in case inteface that was "freed" 
is used by someone.

>
>
>> +/* concatenate all the beacon IEs into one buffer
>> + * Take IEs from head, tail and beacon_ies fields of
> cfg80211_beacon_data
>> + * and append it to provided buffer.
>> + * Checks total IE buf length to be <= than IEEE80211_MAX_DATA_LEN.
>> + * Checks IE buffers to be valid, so that resulting buffer
>> + * should be a valid IE buffer with length <=
> IEEE80211_MAX_DATA_LEN.
>> + */
> I'm not sure this is right - beacon_ies is head+tail already, I think?

Looking at hostapd sources, looks like you're right. Though it's not 
immediately obvious.. Will review the code and handle this correctly.

>
>> +static int
>> +qtnf_dump_station(struct wiphy *wiphy, struct net_device *dev,
>> +		  int idx, u8 *mac, struct station_info *sinfo)
>> +{
>> +	struct qtnf_vif *vif = qtnf_netdev_get_priv(dev);
>> +	const struct qtnf_sta_node *sta_node;
>> +	int ret;
>> +
>> +	sta_node = qtnf_sta_list_lookup_index(&vif->sta_list, idx);
>> +
>> +	if (unlikely(!sta_node))
>> +		return -ENOENT;
>> +
>> +	ether_addr_copy(mac, sta_node->mac_addr);
>> +
>> +	ret = qtnf_cmd_get_sta_info(vif, sta_node->mac_addr, sinfo);
>> +
>> +	if (unlikely(ret == -ENOENT)) {
>> +		sinfo->filled = 0;
>> +		ret = 0;
>> +	}
> This case seems slightly odd - what does it mean that the station
> existed, but getting the information returned -ENOENT? Is that because
> it's racy, somehow? If so, wouldn't it be better to take this as an
> indication that the station doesn't exist, and skip this entry entirely
> or something?

I see two possibilities here:
- it's possible that STAs will exit on device side while we're 
processing dump_station(), and because commands and events processing is 
serialized, driver will not know about that yet;
- it's a bug in state synchronization between driver and device
In both cases, I agree that we better to remove STAs from the list here 
if returned ENOENT.
>
>> +	/* nofity cfg80211 */
> typo :)
Will fix)

>
>> +	while (payload_len >= sizeof(struct qlink_tlv_hdr)) {
>> +		tlv_type = le16_to_cpu(tlv->type);
>> +		tlv_value_len = le16_to_cpu(tlv->len);
>> +		tlv_full_len = tlv_value_len + sizeof(struct
> qlink_tlv_hdr);
>> +
>> +		if (tlv_full_len > payload_len) {
>> +			pr_warn("malformed TLV 0x%.2X; LEN: %u\n",
>> +				tlv_type, tlv_value_len);
>> +			return -EINVAL;
>> +		}
>> +
>> +		if (tlv_type == QTN_TLV_ID_IE_SET) {
>> +			ies = tlv->val;
>> +			ies_len = tlv_value_len;
>> +		}
>> +
>> +		payload_len -= tlv_full_len;
>> +		tlv = (struct qlink_tlv_hdr *)(tlv->val +
> tlv_value_len);
>> +	}
>> +
>> +	if (payload_len) {
>> +		pr_warn("malformed IEs buf; bytes left: %zu\n",
> payload_len);
>> +		return -EINVAL;
>> +	}
> Don't you mean "malformed TLVs buf"? It's obviously similar, but you
> refer to this encoding as TLV, not IE.
>
> Maybe you should ignore it too, since it's a firmware bug?

Agree, will change to "TLV". As for ignoring or not, there is probably 
no harm in returning error if something went the way we did not expect, 
since we do not do any parameters values validation we can at least 
validate buffer integrity itself.

>
>> +	qdev_vif = netdev_priv(dev);
>> +	*((unsigned long *)qdev_vif) = (unsigned long)vif;
> This seems very strange - why unsigned long, rather than void? I mean
>
>   *(void **)qdev_vif = vif;

Will fix.

>
>> +static int qtnf_pcie_init_shm_ipc(struct qtnf_pcie_bus_priv *priv)
>> +{
>> +	struct qtnf_shm_ipc_region __iomem *ipc_tx_reg;
>> +	struct qtnf_shm_ipc_region __iomem *ipc_rx_reg;
>> +	const struct qtnf_shm_ipc_int ipc_int = {
> qtnf_ipc_gen_ep_int, priv };
>> +	const struct qtnf_shm_ipc_rx_callback rx_callback = {
>> +					qtnf_pcie_control_rx_callbac
> k, priv };
>
> If those are const, why not also static? In fact, it seems they really
> should be, since they're registered below?

Later qtnf_shm_ipc_init() will make a full copy of rx_callback (which 
actually only contains two pointers), it does not expect it to have 
static time of live, so no point in statically allocating it.

>
>> +static int alloc_bd_table(struct qtnf_pcie_bus_priv *priv)
>> +{
>> +	unsigned long vaddr;
>> +	dma_addr_t paddr;
>> +	int len;
>> +
>> +	len = priv->tx_bd_num * sizeof(struct qtnf_tx_bd) +
>> +		priv->rx_bd_num * sizeof(struct qtnf_rx_bd);
>> +
>> +	vaddr = (unsigned long)dmam_alloc_coherent(&priv->pdev->dev,
>> +						   len, &paddr,
> GFP_KERNEL);
>> +	if (!vaddr)
>> +		return -ENOMEM;
>> +
>> +	/* tx bd */
>> +
>> +	memset((void *)vaddr, 0, len);
> Those unsigned long/void * casts look strange too. Why not use a "void
> *vaddr" to start with?

Will review these

>
>> +	priv->bd_table_vaddr = vaddr;
> Maybe need a cast here, if that variable is needed at all (identical to
> tx_bd_vbase), or make that struct member also void *?
>
>> +	priv->bd_table_paddr = paddr;
>> +	priv->bd_table_len = len;
>> +
>> +	priv->tx_bd_vbase = (struct qtnf_tx_bd *)vaddr;
> Don't even need that cast then.
>
>> +	priv->tx_bd_pbase = paddr;
>> +
>> +	pr_debug("TX descriptor table: vaddr=0x%p paddr=%pad\n",
>> +		 (void *)vaddr, &paddr);
>> +
>> +	priv->tx_bd_reclaim_start = 0;
>> +	priv->tx_bd_index = 0;
>> +	priv->tx_queue_len = 0;
>> +
>> +	/* rx bd */
>> +
>> +	vaddr += priv->tx_bd_num * sizeof(struct qtnf_tx_bd);
> Here you can do something like
>
>   vaddr = ((struct qtnf_tx_bd)vaddr) + priv->tx_bd_num;
>
>> +	paddr += priv->tx_bd_num * sizeof(struct qtnf_tx_bd);
>> +
>> +	priv->rx_bd_vbase = (struct qtnf_rx_bd *)vaddr;
> no need for the cast here then.

Ok, we will review to see how to make this code prettier.

>
>> +	priv->rx_bd_pbase = paddr;
>> +
>> +	writel(QTN_HOST_LO32(paddr),
>> +	       PCIE_HDP_TX_HOST_Q_BASE_L(priv->pcie_reg_base));
>> +	writel(QTN_HOST_HI32(paddr),
>> +	       PCIE_HDP_TX_HOST_Q_BASE_H(priv->pcie_reg_base));
>> +	writel(priv->rx_bd_num | (sizeof(struct qtnf_rx_bd)) << 16,
>> +	       PCIE_HDP_TX_HOST_Q_SZ_CTRL(priv->pcie_reg_base));
>> +
>> +	priv->hw_txproc_wr_ptr = priv->rx_bd_num -
> rx_bd_reserved_param;
>> +
>> +	writel(priv->hw_txproc_wr_ptr,
>> +	       PCIE_HDP_TX_HOST_Q_WR_PTR(priv->pcie_reg_base));
>> +
>> +	pr_debug("RX descriptor table: vaddr=0x%p paddr=%pad\n",
>> +		 (void *)vaddr, &paddr);
> Nor here.
>
> On the whole, it probably doesn't really matter (I'd let Kalle decide I
> guess). Just looks odd to me.
>
>> +	/* sync up all descriptor updates before passing them to EP
> */
>> +	wmb();
> I think you need dma_wmb()?

Looks like it, based on documentation. Will confirm and change, if 
necessary.

>
>
> So I mostly looked at the cfg80211 bits, obviously - the other comments
> were just in passing.
>
> I also didn't review the flows - some of these things are tricky (e.g.
> are there races between userspace asking to disconnect, and disconnect
> notification, and similar). Maybe it helps anyway :)

The idea we used for flow synchronization is that all commands/events 
processing is serialized with RTNL mutex. Not very smart approach, but 
simple and in fact can be enough (there are not too much 
commands/notifications going on anyway). In the future it is possible to 
move to a more fine-grained locking.

Thanks for reviewing this, Johannes!

>
> johannes
