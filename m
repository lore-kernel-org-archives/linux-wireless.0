Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine01.qualcomm.com ([199.106.114.254]:3714 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752805Ab2AMRZZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 13 Jan 2012 12:25:25 -0500
Cc: <linux-wireless@vger.kernel.org>, <ath6kl-devel@qualcomm.com>
Message-ID: <4F1068F8.8040800@qca.qualcomm.com> (sfid-20120113_182529_498307_95A8D7C0)
Date: Fri, 13 Jan 2012 19:25:12 +0200
From: Kalle Valo <kvalo@qca.qualcomm.com>
MIME-Version: 1.0
To: Thirumalai Pachamuthu <tpachamu@qca.qualcomm.com>
Subject: Re: [PATCH v2] ath6kl: Add support for uAPSD
References: <1326372699-6344-1-git-send-email-tpachamu@qca.qualcomm.com> <1326372699-6344-2-git-send-email-tpachamu@qca.qualcomm.com> <4F101AA9.90004@qca.qualcomm.com>
In-Reply-To: <4F101AA9.90004@qca.qualcomm.com>
Content-Type: text/plain; charset="ISO-8859-1"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/13/2012 01:51 PM, Kalle Valo wrote:
>> +static bool ath6kl_process_uapsdq(struct ath6kl_sta *conn,
>> > +				struct ath6kl_vif *vif,
>> > +				struct sk_buff *skb,
>> > +				u32 *flags)
>> > +{
>> > +	struct ath6kl *ar = vif->ar;
>> > +	bool is_apsdq_empty = false;
>> > +	struct ethhdr *datap = (struct ethhdr *) skb->data;
>> > +	u8 up = 0;
>
> This is initilised in an else branch I added below.

This actually creates a compiler warning which I missed. I'll send a
separate patch which reverts up initilisation back to the original.

Kalle
