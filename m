Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ebb06.tieto.com ([131.207.168.38]:58852 "EHLO ebb06.tieto.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752088Ab2IGINb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 7 Sep 2012 04:13:31 -0400
Message-ID: <5049AC3F.2000704@tieto.com> (sfid-20120907_101337_129556_321F625D)
Date: Fri, 7 Sep 2012 10:11:43 +0200
From: Rymarkiewicz Waldemar <waldemar.rymarkiewicz@tieto.com>
MIME-Version: 1.0
To: Eric Lapuyade <eric.lapuyade@linux.intel.com>
CC: "eric.lapuyade@intel.com" <eric.lapuyade@intel.com>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
	"linux-nfc@lists.01.org" <linux-nfc@lists.01.org>
Subject: Re: [linux-nfc] [PATCH 1/2] NFC: Remove crc generation from shdlc
 layer
References: <1346926937-4968-1-git-send-email-waldemar.rymarkiewicz@tieto.com> <5048C901.5010704@linux.intel.com> <5049AB7C.1020103@linux.intel.com>
In-Reply-To: <5049AB7C.1020103@linux.intel.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Eric,

> As a side effect of my comment on the second patch, this should be
> defined like this:
>
>   #define PN544_CMDS_HEADROOM	2
> +#define PN544_FRAME_HEADROOM	1
> +#define PN544_FRAME_TAILROOM	2
>
>>>   static int pn544_hci_xmit(struct nfc_shdlc *shdlc, struct sk_buff *skb)
>>>   {
>>>   	struct pn544_hci_info *info = nfc_shdlc_get_clientdata(shdlc);
>>> @@ -584,6 +599,8 @@ static int pn544_hci_xmit(struct nfc_shdlc
> *shdlc, struct sk_buff *skb)
>>>   	if (info->hard_fault != 0)
>>>   		return info->hard_fault;
>>>
>>> +	pn544_hci_add_len_crc(skb);
>>> +
>>>   	return pn544_hci_i2c_write(client, skb->data, skb->len);
>
> Here, we would have:
>
> 	r = pn544_hci_i2c_write(client, skb->data, skb->len);
> 	pn544_hci_remove_len_crc(skb);
> 	return r;
>
>>>   	info->shdlc = nfc_shdlc_allocate(&pn544_shdlc_ops,
>>>   					 &init_data, protocols,
>>> -					 PN544_CMDS_HEADROOM, 0,
>>> +					 PN544_CMDS_HEADROOM, PN544_CMDS_TAILROOM,
>>>   					 PN544_HCI_LLC_MAX_PAYLOAD,
>>>   					 dev_name(&client->dev));
>
> And this should be:
>
>    	info->shdlc = nfc_shdlc_allocate(&pn544_shdlc_ops,
>    					 &init_data, protocols,
>   					 PN544_CMDS_HEADROOM +
> 					 PN544_FRAME_HEADROOM,
> 					 PN544_FRAME_TAILROOM,
>    					 PN544_HCI_LLC_MAX_PAYLOAD,
>    					 dev_name(&client->dev));
>
> note that PN544_CMDS_HEADROOM is really only for skb allocated by HCI
> (or NFC Core), not by those allocated by shdlc, but we aggregate it all
> in a single parameter for simplicity.

Now, I see the point. Will update the patch.

Thanks,
/Waldek
