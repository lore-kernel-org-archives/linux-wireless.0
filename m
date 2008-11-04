Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web23108.mail.ird.yahoo.com ([217.146.189.48]:30809 "HELO
	web23108.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753588AbYKDBOb convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Nov 2008 20:14:31 -0500
Date: Tue, 4 Nov 2008 01:14:28 +0000 (GMT)
From: Hin-Tak Leung <htl10@users.sourceforge.net>
Reply-To: htl10@users.sourceforge.net
Subject: Re: [RFC/RFT PATCH 0/2] rtl8187: implement conf_tx callback/correctly ack tx pkts
To: Herton Ronaldo Krzesinski <herton@mandriva.com.br>
Cc: Larry Finger <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org,
	John W Linville <linville@tuxdriver.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	Michael Wu <flamingice@sourmilk.net>,
	Andrea Merello <andrea.merello@gmail.com>
In-Reply-To: <200811012339.39592.herton@mandriva.com.br>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Message-ID: <118209.17192.qm@web23108.mail.ird.yahoo.com> (sfid-20081104_021436_069909_C3C94C9D)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

--- On Sun, 2/11/08, Herton Ronaldo Krzesinski <herton@mandriva.com.br> wrote:

<snipped>
> Yes, cleanups, minor optimization and fixes, like freeing
> skbs in status queue
> on interface stop, btw this was the patch for
> wireless-testing from some days
> ago while still in 2.6.27 (different from previous version
> I sent privately with
> printks/debug):

<snipped>
	__skb_unlink(skb, &priv->b_tx_status.queue);
> +			if (tok)
> +				info->flags |= IEEE80211_TX_STAT_ACK;
> +			else
> +				info->status.excessive_retries = 1;
> +			info->status.retry_count = pkt_rc;
> +			
> +			ieee80211_tx_status_irqsafe(hw, skb);
<snipped>

okay, I looked through my hard disc and it seems that I have 3 versions of the rate control patch - the first one sent privately, I think, the 2nd one as part of a patch series of 2 with conf-tx, and a 3rd one above
which is supposedly between the two, posted to wireless-testing (which apologies, I don't subscribe). There is a very crucial difference:
I noticed that whenever STAT_ACK is always an alternative to
setting excessive_retries:

---------------
if (condition)
    info->flags |= IEEE80211_TX_STAT_ACK;
else 
    info->status.excessive_retries = 1;
---------------

But the else-clause is missing in the latest patch (of two), which also seems to be where both you and Larry are having rate stuck at 1Mb/s for.
- and the line below
"info->status.rates[0].count = pkt_rc +1 ;" doesn't compile
under 2.6.27, so I changed the rates[0].count to the retry_count,
and simultaneously adding the else-clause back. 

My question is this: is the removal of the else-clause unintensional,
could it result in your 1Mb/s rate?

Hin-Tak


      
