Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-bk0-f52.google.com ([209.85.214.52]:43201 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752588Ab3IKFGr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 11 Sep 2013 01:06:47 -0400
Received: by mail-bk0-f52.google.com with SMTP id e11so3239486bkh.25
        for <linux-wireless@vger.kernel.org>; Tue, 10 Sep 2013 22:06:46 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20130910141413.GE29385@localhost>
References: <1378821003-22925-1-git-send-email-michal.kazior@tieto.com>
	<1378821003-22925-2-git-send-email-michal.kazior@tieto.com>
	<20130910141413.GE29385@localhost>
Date: Wed, 11 Sep 2013 07:06:46 +0200
Message-ID: <CA+BoTQ=E6NpACFWkgFthbY4AjNp_nbfF1kKkQb9iPrAkD6SBfw@mail.gmail.com> (sfid-20130911_070700_912343_7D36BEB6)
Subject: Re: [PATCH 1/7] ath10k: simplify HTC credits calculation
From: Michal Kazior <michal.kazior@tieto.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: ath10k@lists.infradead.org,
	linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 10 September 2013 16:14, Bob Copeland <me@bobcopeland.com> wrote:
> On Tue, Sep 10, 2013 at 03:49:57PM +0200, Michal Kazior wrote:
>> +             skb = __skb_dequeue(&ep->tx_queue);
>> +
>> +             if (ep->tx_credit_flow_enabled) {
>> +                     /* integer division w/ round-up */
>> +                     credits = (skb->len + htc->target_credit_size - 1) /
>> +                               htc->target_credit_size;
>
> There's a macro for that...
>
>             credits = DIV_ROUND_UP(skb->len, htc->target_credit_size);

I didn't know that. Thanks!


Michał.
