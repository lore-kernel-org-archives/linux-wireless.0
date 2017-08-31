Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from [217.148.43.144] ([217.148.43.144]:42060 "EHLO mnementh.co.uk"
        rhost-flags-FAIL-FAIL-OK-OK) by vger.kernel.org with ESMTP
        id S1751532AbdHaPfb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Thu, 31 Aug 2017 11:35:31 -0400
Subject: Re: [PATCH 13/30] brcmfmac: Clarify if using braces.
To: Arend van Spriel <arend.vanspriel@broadcom.com>,
        linux-wireless@vger.kernel.org
References: <20170822112550.60311-1-ian@mnementh.co.uk>
 <20170822112550.60311-14-ian@mnementh.co.uk>
 <78917893-6b3d-9cfc-1f32-e27226ae6189@broadcom.com>
From: Ian Molton <ian@mnementh.co.uk>
Message-ID: <0423e0d1-9ba5-5b06-31fc-e03a656e11b3@mnementh.co.uk> (sfid-20170831_173533_926718_C6B127A2)
Date: Thu, 31 Aug 2017 16:35:28 +0100
MIME-Version: 1.0
In-Reply-To: <78917893-6b3d-9cfc-1f32-e27226ae6189@broadcom.com>
Content-Type: text/plain; charset=windows-1252
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 30/08/17 20:11, Arend van Spriel wrote:
>> Whilst this if () statement is technically correct, it lacks clarity.
> 
> I don't see the unclarity here. In my opinion people reading the code
> should have a good level in C language and a decent level of curiosity
> when they come across a function/macro like skb_queue_walk().

I thought it to be part of the general codingstyle for the kernel that
multi-line ifs and elses should be in braces, although I accept that
technically the if-clause is a single block-level statement.

Having said that, *this* specific example falls into a grey area in the
codingstyle, which covers multi-statement, multi-line if() clauses and
single-statement, single-line ones. It does not cover single-statement,
multi-line examples such as the one here.

Whilst I can't therefore definitively justify my position, I can show,
for example, line 999 in net/mac80211/iface.c where a for() statement
uses braces around the skb_queue_walk()

for (i = 0; i < IEEE80211_MAX_QUEUES; i++) {
        skb_queue_walk_safe(&local->pending[i], skb, tmp) {
                struct ieee80211_tx_info *info = IEEE80211_SKB_CB(skb);
                if (info->control.vif == &sdata->vif) {
                        __skb_unlink(skb, &local->pending[i]);
                        ieee80211_free_txskb(&local->hw, skb);
                }
        }
}


And the following in ath9k_htc_tx_cleanup_queue()

if (process) {
        skb_queue_walk_safe(&queue, skb, tmp) {
                __skb_unlink(skb, &queue);
                ath9k_htc_tx_process(priv, skb, NULL);
        }
}

So I feel that we should do the same.

-Ian
