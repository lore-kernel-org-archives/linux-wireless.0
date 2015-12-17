Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f42.google.com ([74.125.82.42]:34743 "EHLO
	mail-wm0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965899AbbLQH3o convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Dec 2015 02:29:44 -0500
Received: by mail-wm0-f42.google.com with SMTP id l126so10510323wml.1
        for <linux-wireless@vger.kernel.org>; Wed, 16 Dec 2015 23:29:44 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <5671F8B7.2060801@codeaurora.org>
References: <1450290051-15593-1-git-send-email-poh@qca.qualcomm.com>
	<5671AD10.70004@openwrt.org>
	<5671C99A.703@codeaurora.org>
	<5671CAF5.6010606@openwrt.org>
	<5671CDBD.5060006@codeaurora.org>
	<5671CF63.9040308@openwrt.org>
	<5671D56F.8030903@codeaurora.org>
	<5671DDA1.5030709@openwrt.org>
	<5671F8B7.2060801@codeaurora.org>
Date: Thu, 17 Dec 2015 08:29:43 +0100
Message-ID: <CA+BoTQmOg3gACzk5PAtkyDo1a5WJuCauOXPZKqL+cgVi+n1HCg@mail.gmail.com> (sfid-20151217_083020_059595_FEF9751E)
Subject: Re: [PATCH] ath10k: add modparam 'hw_csum' to make HW checksum configurable
From: Michal Kazior <michal.kazior@tieto.com>
To: Peter Oh <poh@codeaurora.org>
Cc: Felix Fietkau <nbd@openwrt.org>, Peter Oh <poh@qca.qualcomm.com>,
	"ath10k@lists.infradead.org" <ath10k@lists.infradead.org>,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 17 December 2015 at 00:50, Peter Oh <poh@codeaurora.org> wrote:
> On 12/16/2015 01:54 PM, Felix Fietkau wrote:
>> On 2015-12-16 22:19, Peter Oh wrote:
[...]
>>> If mentioned to use the function to mesh frame only without touching
>>> mac80211, then how do you suggest it to apply it only to mesh frame
>>> without interfere other data frames?
>>> Can you share your example?
>>
>> It's trivial - in ath10k_tx you do this:
>>
>> if (vif->type == NL80211_IFTYPE_MESH_POINT &&
>>      skb->ip_summed == CHECKSUM_PARTIAL)
>>         skb_checksum_help(skb);
>
> Thank you Felix for the quick response.
> I agree on your user experience opinion,
> but what do you think when ath10k has a new chip supporting HW checksum for
> Mesh?

You can simply introduce a fw-feature flag saying
"supports_mesh_csum_offload" later and skip the skb_checksum_help() if
it's set.


Michał
