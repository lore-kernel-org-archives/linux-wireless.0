Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:34719 "EHLO
        wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750879AbdAaIke (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Tue, 31 Jan 2017 03:40:34 -0500
From: "Thiagarajan, Vasanthakumar" <vthiagar@qti.qualcomm.com>
To: Jean-Pierre Tosoni <jp.tosoni@acksys.fr>
CC: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
Subject: Re: [RFC 2/3] cfg80211: Disallow moving out of operating DFS channel
 in non-ETSI
Date: Tue, 31 Jan 2017 08:40:06 +0000
Message-ID: <58904CB0.10405@qti.qualcomm.com> (sfid-20170131_094105_167976_EC0D3A07)
References: <1485343870-23601-1-git-send-email-vthiagar@qti.qualcomm.com>
 <1485343870-23601-3-git-send-email-vthiagar@qti.qualcomm.com>
 <014301d27737$b693eca0$23bbc5e0$@acksys.fr>
In-Reply-To: <014301d27737$b693eca0$23bbc5e0$@acksys.fr>
Content-Type: text/plain; charset="Windows-1252"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wednesday 25 January 2017 11:50 PM, Jean-Pierre Tosoni wrote:
>> -----Message d'origine-----
>> De : linux-wireless-owner@vger.kernel.org [mailto:linux-wireless-
>> owner@vger.kernel.org] De la part de Vasanthakumar Thiagarajan
>> Envoy=E9 : mercredi 25 janvier 2017 12:31
>> =C0 : johannes@sipsolutions.net
>> Cc : linux-wireless@vger.kernel.org; Vasanthakumar Thiagarajan
>> Objet : [RFC 2/3] cfg80211: Disallow moving out of operating DFS channel
>> in non-ETSI
>>
>> For non-ETSI regulatory domain, CAC result on DFS channel may not be val=
id
>> once moving out of that channel (as done during remain-on-channel,
>> scannning and off-channel tx).
>> Running CAC on an operating DFS channel after every off-channel operatio=
n
>> will only add complexity and disturb the current link. Better do not all=
ow
>> any off-channel switch from a DFS operating channel in non-ETSI domain.
>>
>
> Moving out should be forbidden only to "master" devices i.e. AP, mesh,
> ad-hoc.
> "Slave" devices i.e. client stations, are not responsible for detecting
> radars, hence, they can do an off-channel scan and go back to a "DFS
> operating channel" without waiting for CAC.
>
> It looks like your patch would forbid multichannel scan ?
>
>

No, this patch forbids off-channel switch only for DFS master device.
cfg80211_beaconing_iface_active() checks if it is a beaconing interface.
I'll mention this in the commit log.

Vasanth
