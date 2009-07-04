Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmailhost05.isp.att.net ([207.115.11.55]:60173 "EHLO
	fmailhost05.isp.att.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752275AbZGDVNs (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 4 Jul 2009 17:13:48 -0400
Message-ID: <4A4FC61A.30004@lwfinger.net>
Date: Sat, 04 Jul 2009 16:14:02 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: Christian Lamparter <chunkeey@web.de>
CC: linux-wireless <linux-wireless@vger.kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>
Subject: Re: [WIP] p54: deal with allocation failures in rx path
References: <200907040053.05654.chunkeey@web.de> <200907041211.49115.chunkeey@web.de> <4A4F85EE.5090007@lwfinger.net> <200907041928.32269.chunkeey@web.de> <4A4FB3F2.5050405@lwfinger.net>
In-Reply-To: <4A4FB3F2.5050405@lwfinger.net>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger wrote:
> @@ -224,6 +236,7 @@ static void p54_tx_qos_accounting_free(s
>                 struct p54_tx_data *data = (void *) hdr->data;
> 
>                 priv->tx_stats[data->hw_queue].len--;
> +               WARN_ON(priv->tx_stats[data->hw_queue].len < 0);
>         }
>         p54_wake_queues(priv);
>  }
> 

The new WARN_ON did _NOT_ trigger when the len went negative.

The only other place where len could be decremented is through
txhdr->backlog. I noticed that the p54common.c had

txhdr->backlog = current_queue->len;

This was replaced in txrx.c by

txhdr->backlog = priv->tx_stats[queue].len - 1;

Was this intentional?

To test if this is the problem, I added the following hunk:

@@ -840,6 +853,7 @@ int p54_tx_80211(struct ieee80211_hw *de
        txhdr->crypt_offset = crypt_offset;
        txhdr->hw_queue = queue;
        txhdr->backlog = priv->tx_stats[queue].len - 1;
+       WARN_ON(!priv->tx_stats[queue].len);
        memset(txhdr->durations, 0, sizeof(txhdr->durations));
        txhdr->tx_antenna = ((info->antenna_sel_tx == 0) ?
                2 : info->antenna_sel_tx - 1) & priv->tx_diversity_mask;

This WARN_ON did trigger just before txq[6].len went negative. I'm now
testing with that changed as follows:

@@ -839,7 +852,8 @@ int p54_tx_80211(struct ieee80211_hw *de
        }
        txhdr->crypt_offset = crypt_offset;
        txhdr->hw_queue = queue;
-       txhdr->backlog = priv->tx_stats[queue].len - 1;
+       txhdr->backlog = priv->tx_stats[queue].len;
+       WARN_ON(priv->tx_stats[queue].len < 0);
        memset(txhdr->durations, 0, sizeof(txhdr->durations));
        txhdr->tx_antenna = ((info->antenna_sel_tx == 0) ?
                2 : info->antenna_sel_tx - 1) & priv->tx_diversity_mask;

This WARN_ON did not trigger, but I still had the queue len go negative.

One other question: struct p54_burst is defined in lmac.h, but it
doesn't seem to be used anywhere. Will it be needed later?

Larry

