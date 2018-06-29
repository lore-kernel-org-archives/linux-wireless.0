Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.63.242]:34176 "EHLO
        sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933949AbeF2H6D (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 29 Jun 2018 03:58:03 -0400
Message-ID: <1530259080.3481.7.camel@sipsolutions.net> (sfid-20180629_095807_076424_FD033236)
Subject: Re: [PATCH] mac80211: add stop/start logic for software TXQs
From: Johannes Berg <johannes@sipsolutions.net>
To: Manikanta Pubbisetty <mpubbise@codeaurora.org>,
        Toke =?ISO-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>
Cc: linux-wireless@vger.kernel.org
Date: Fri, 29 Jun 2018 09:58:00 +0200
In-Reply-To: <5adc5faf-8af0-7af9-8261-784a7ec0e4f7@codeaurora.org>
References: <1529997415-20551-1-git-send-email-mpubbise@codeaurora.org>
         <878t71n611.fsf@toke.dk>
         <5adc5faf-8af0-7af9-8261-784a7ec0e4f7@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2018-06-26 at 18:01 +0530, Manikanta Pubbisetty wrote:
> 
> Valid point, txqs_paused is set in ieee80211_tx_dequeue; I was thinking 
> a case where tx_dequeue is called without rcu_read_lock but seems that 
> is not the case. All drivers using wake_tx_queue seems are using 
> rcu_read_lock before tx_dequeue; can there be a case where tx_dequeue is 
> called without rcu_read_lock?

FWIW, the rcu_read_lock() isn't relevant at all - multiple threads can
well (and will for sure!) enter it.

johannes
