Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from aurora.create-net.org ([193.206.22.116]:46138 "EHLO
	aurora.create-net.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754070Ab1KYQVt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Nov 2011 11:21:49 -0500
Received: from localhost (localhost.localdomain [127.0.0.1])
	by aurora.create-net.org (Postfix) with ESMTP id 487C92C08177
	for <linux-wireless@vger.kernel.org>; Fri, 25 Nov 2011 17:14:27 +0100 (CET)
Received: from aurora.create-net.org ([127.0.0.1])
	by localhost (aurora.create-net.org [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id lnCp11eixN7y for <linux-wireless@vger.kernel.org>;
	Fri, 25 Nov 2011 17:14:26 +0100 (CET)
Received: from [192.168.1.3] (net-188-216-206-49.cust.dsl.vodafone.it [188.216.206.49])
	by aurora.create-net.org (Postfix) with ESMTPSA id B3D842C08172
	for <linux-wireless@vger.kernel.org>; Fri, 25 Nov 2011 17:14:26 +0100 (CET)
Message-ID: <4ECFBEE1.4040307@create-net.org> (sfid-20111125_172153_907293_F76D2407)
Date: Fri, 25 Nov 2011 17:14:25 +0100
From: Roberto Riggio <roberto.riggio@create-net.org>
MIME-Version: 1.0
To: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Changes in the radiotap parsing method
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


I'm trying to adapt a patch (for specifying the transmission rate for 
injected frames) to the latest changes in compat-wireless.

I saw that the signature of this function changed:

ieee80211_parse_tx_radiotap(struct sk_buff *skb)

While before it was:

__ieee80211_parse_tx_radiotap(struct ieee80211_tx_data *tx, struct 
sk_buff *skb)

is there a way to obtain info to translate the rate as specified into 
the radiotap header to the rate index require by the driver. The 
previous code was:

sband = info->local->hw.wiphy->bands[info->channel->band];

and then:

for (i = 0; i < sband->n_bitrates; i++)
	if (sband->bitrates[i].bitrate == rate) 	
	{
		idx = i;
		break;
	}

Thanks
R.
