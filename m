Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:61957 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750748Ab2GSM3n (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Jul 2012 08:29:43 -0400
Received: by ghrr11 with SMTP id r11so2677353ghr.19
        for <linux-wireless@vger.kernel.org>; Thu, 19 Jul 2012 05:29:42 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <20120719113628.GA32727@elgon.mountain>
References: <20120719113628.GA32727@elgon.mountain>
Date: Thu, 19 Jul 2012 14:29:41 +0200
Message-ID: <CAAd0S9CeFhDi0AZAX7zqcLFkNtiK6vv4i4UCMs8oB5Z0pKe+mA@mail.gmail.com> (sfid-20120719_142946_924703_FD9A4DBF)
Subject: Re: carl9170: improve unicast PS buffering
From: Christian Lamparter <chunkeey@googlemail.com>
To: Dan Carpenter <dan.carpenter@oracle.com>
Cc: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello Dan,

On Thu, Jul 19, 2012 at 1:36 PM, Dan Carpenter <dan.carpenter@oracle.com> wrote:
> Sorry this is so old.  I was going through some old Smatch warnings.
>
> This is a semi-automatic email about new static checker warnings.
>
> The patch caf1eae20668: "carl9170: improve unicast PS buffering" from
> Apr 24, 2011, leads to the following Smatch complaint:
>
> drivers/net/wireless/ath/carl9170/tx.c:1488 carl9170_op_tx()
>          error: we previously assumed 'sta' could be null (see line 1482)
>
> drivers/net/wireless/ath/carl9170/tx.c
>   1481
>   1482          if (sta) {
>                    ^^^^^
> New check.
>
>   1483                  struct carl9170_sta_info *stai = (void *) sta->drv_priv;
>   1484                  atomic_inc(&stai->pending_frames);
>   1485          }
>   1486
>   1487          if (info->flags & IEEE80211_TX_CTL_AMPDU) {
>   1488                  run = carl9170_tx_ampdu_queue(ar, sta, skb);
>                               ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> Old dereference of "sta" inside the call to carl9170_tx_ampdu_queue().
>
>   1489                  if (run)
>   1490                          carl9170_tx_ampdu(ar);
>
> Probably we can remove the check?
What check do you want to remove? The check in smatch
which produces the warning/error. Or the "if (sta) {" in line
1482?

Or do you mean I should extend the check in 1487 to:
if (sta) {
     ...
     if (info->flags & IEEE80211_TX_CTL_AMPDU) {
     ....
     }
}

Regards,
    Chr
