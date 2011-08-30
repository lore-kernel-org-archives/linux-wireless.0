Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:29671 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752857Ab1H3OOa (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 30 Aug 2011 10:14:30 -0400
Date: Tue, 30 Aug 2011 17:13:19 +0300
From: Jouni Malinen <jouni@qca.qualcomm.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH 07/20] ath6kl: Implement mgmt_tx
Message-ID: <20110830141319.GC8163@jouni.qca.qualcomm.com> (sfid-20110830_161433_237046_CDAB3589)
References: <1314620641-24257-1-git-send-email-jouni@qca.qualcomm.com>
 <1314620641-24257-8-git-send-email-jouni@qca.qualcomm.com>
 <4E5CABF8.901@qca.qualcomm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <4E5CABF8.901@qca.qualcomm.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Aug 30, 2011 at 12:23:04PM +0300, Kalle Valo wrote:
> On 08/29/2011 03:23 PM, Jouni Malinen wrote:
> > +static int ath6kl_mgmt_tx(struct wiphy *wiphy, struct net_device *dev,

> > +	id = ar->send_action_id++;
> > +	if (id == 0)
> > +		id = ar->send_action_id++;

> > +	*cookie = id;
> > +	return ath6kl_wmi_send_action_cmd(ar->wmi, id, chan->center_freq, wait,
> > +					  buf, len);

> I don't understand the "if (id == 0)" check. It would be nice to get a
> comment giving some background info about the situation.

0 is a reserved value in the target implementation and shall not be used
in the WMI command. I'll add a comment on this.

-- 
Jouni Malinen                                            PGP id EFC895FA
