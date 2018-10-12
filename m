Return-Path: <SRS0=XVRH=MY=vger.kernel.org=linux-wireless-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C2421C43441
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 07:38:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 11EBC2087D
	for <linux-wireless@archiver.kernel.org>; Fri, 12 Oct 2018 07:38:51 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="OGsR461b";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="cIpSNrRM"
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 11EBC2087D
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-wireless-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727370AbeJLPJ6 (ORCPT
        <rfc822;linux-wireless@archiver.kernel.org>);
        Fri, 12 Oct 2018 11:09:58 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:57650 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726761AbeJLPJ6 (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 12 Oct 2018 11:09:58 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 5E786607DC; Fri, 12 Oct 2018 07:38:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539329929;
        bh=UPR2rC1CQYlhPapBHm90Lll5j170TxOHypSCuubpMcw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=OGsR461bFKdd3F5OfVx+IB2MLgruLM924uQ9AC8cMvUbUutPwg1Ounsh+u7ujlzOY
         cpJntssjfosTGUUOxj2qcYsOGm772DLghhmYytr5kT9kWtNL688+4CGN+5MNXjeQFD
         AwidxSmBrqygLZXCvLvhen37Sao4LyEFZlqiexdg=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id BE97F605A2;
        Fri, 12 Oct 2018 07:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1539329928;
        bh=UPR2rC1CQYlhPapBHm90Lll5j170TxOHypSCuubpMcw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cIpSNrRMzfp3ez34uVJLSep/JV7I9VGxXJ6z1plX8bqlUEmkTZp7T2SCE3/3tWQAN
         aGN4wQio/NGneRcPwHdOoqU8lgFRaWxBDv927204hQ9mT1h4p//uOly47Wc/MX2X8V
         kTCS0QWAkZc8es0l4j83Iupu9yjco0Ubp6pLAh2o=
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 8bit
Date:   Fri, 12 Oct 2018 00:38:48 -0700
From:   Rajkumar Manoharan <rmanohar@codeaurora.org>
To:     =?UTF-8?Q?Toke_H=C3=B8iland-J=C3=B8rgensen?= <toke@toke.dk>
Cc:     linux-wireless@vger.kernel.org,
        make-wifi-fast@lists.bufferbloat.net, Felix Fietkau <nbd@nbd.name>,
        Kan Yan <kyan@google.com>, linux-wireless-owner@vger.kernel.org
Subject: Re: [PATCH RFC v5 3/4] mac80211: Add airtime accounting and
 scheduling to TXQs
In-Reply-To: <87pnwg93at.fsf@toke.dk>
References: <153908805217.9471.9290979918041653328.stgit@alrua-kau>
 <153908837900.9471.5394468800857658136.stgit@alrua-kau>
 <a65909ee425585a49d9e17f6504cf0ba@codeaurora.org> <87zhvm832s.fsf@toke.dk>
 <187bade306627912c70d800819ef0b87@codeaurora.org> <87pnwg93at.fsf@toke.dk>
Message-ID: <7dfcb7a13a3f75f01f7b88163f2c33d6@codeaurora.org>
X-Sender: rmanohar@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: linux-wireless-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-wireless.vger.kernel.org>
X-Mailing-List: linux-wireless@vger.kernel.org

On 2018-10-11 03:38, Toke Høiland-Jørgensen wrote:
> Rajkumar Manoharan <rmanohar@codeaurora.org> writes:
> 
>> Hmm... mine is bit different. txqs are refilled only once for all 
>> txqs.
>> It will give more opportunity for non-served txqs. drv_wake_tx_queue
>> won't be
>> called from may_tx as the driver anyway will not push packets in
>> pull-mode.
> 
> So, as far as I can tell, this requires the hardware to "keep trying"?
> I.e., if it just stops scheduling a TXQ after may_transmit() returns
> false, there is no guarantee that that TXQ will ever get re-awoken
> unless a new packet arrives for it?
> 
That is true and even now ath10k operates the same way in pull mode. Not
just packet arrival, even napi poll routine tries to pushes the packets.
One more thing, fetch indication may pull ~4ms/8ms of packets from each 
tid.
This makes deficit too low and so refilling txqs by just airtime_weight 
becomes
cumbersome. In may_transmit, the deficit are incremented by 20 * 
airtime_weight.
In future this will be also replaced by station specific quantum. we can 
revisit
this once BQL in place. Performance issue is resolved by this approach.
Do you foresee any issues?


#define IEEE80211_TXQ_MAY_TX_QUANTUM  20
bool ieee80211_txq_may_transmit(struct ieee80211_hw *hw,
                                 struct ieee80211_txq *txq)
{
         struct ieee80211_local *local = hw_to_local(hw);
         struct txq_info *txqi = to_txq_info(txq);
         struct sta_info *sta;
         u8 ac = txq->ac;

         lockdep_assert_held(&local->active_txq_lock[ac]);

         if (!txqi->txq.sta)
                 goto out;

         sta = container_of(txqi->txq.sta, struct sta_info, sta);
         if (sta->airtime[ac].deficit >= 0)
                 goto out;

         list_for_each_entry(txqi, &local->active_txqs[ac], 
schedule_order) {
                 if (!txqi->txq.sta)
                         continue;
                 sta = container_of(txqi->txq.sta, struct sta_info, sta);
                 sta->airtime[ac].deficit +=
                         (IEEE80211_TXQ_MAY_TX_QUANTUM * 
sta->airtime_weight);
         }

         return false;

  out:
         list_del_init(&txqi->schedule_order);
         return true;
}

-Rajkumar
