Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from miranda.se.axis.com ([193.13.178.8]:55244 "EHLO
	miranda.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754159AbYEWOgz (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 23 May 2008 10:36:55 -0400
From: "Johan Adolfsson" <Johan.Adolfsson@axis.com>
To: "'Holger Schurig'" <hs4233@mail.mn-solutions.de>,
	<libertas-dev@lists.infradead.org>,
	"'Dan Williams'" <dcbw@redhat.com>,
	<linux-wireless@vger.kernel.org>,
	"'John W. Linville'" <linville@tuxdriver.com>
Subject: RE: [PATCH] libertas: before sleeping, check for a command result
Date: Fri, 23 May 2008 16:26:40 +0200
Message-ID: <002701c8bce1$04097010$0137550a@se.axis.com> (sfid-20080523_163658_572568_60C373F4)
MIME-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
In-Reply-To: <200805231604.13144.hs4233@mail.mn-solutions.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


> -----Original Message-----
> From: libertas-dev-bounces@lists.infradead.org 
> [mailto:libertas-dev-bounces@lists.infradead.org] On Behalf 
> Of Holger Schurig
> Sent: den 23 maj 2008 16:04
> To: libertas-dev@lists.infradead.org; Dan Williams; 
> linux-wireless@vger.kernel.org; John W. Linville
> Subject: [PATCH] libertas: before sleeping, check for a command result
> 
> 
> If we don't check for a command response early, but rather sleep,
> then we might sleep despite an already-received command response.
> This will lead to a command-timeout.
> 
> Signed-off-by: Holger Schurig <hs4233@mail.mn-solutions.de>
> 
> Index: wireless-testing/drivers/net/wireless/libertas/main.c
> ===================================================================
> --- 
> wireless-testing.orig/drivers/net/wireless/libertas/main.c	
> 2008-05-23 14:25:16.000000000 +0200
> +++ wireless-testing/drivers/net/wireless/libertas/main.c	
> 2008-05-23 14:25:51.000000000 +0200
> @@ -722,14 +722,14 @@ static int lbs_thread(void *data)
>  			shouldsleep = 1;	/* Something is 
> en route to the device already */
>  		else if (priv->tx_pending_len > 0)
>  			shouldsleep = 0;	/* We've a 
> packet to send */
> +		else if (priv->resp_len[priv->resp_idx])
> +			shouldsleep = 0;	/* We have a 
> command response */
>  		else if (priv->cur_cmd)
>  			shouldsleep = 1;	/* Can't send a 
> command; one already running */
>  		else if (!list_empty(&priv->cmdpendingq))
>  			shouldsleep = 0;	/* We have a 
> command to send */
>  		else if (__kfifo_len(priv->event_fifo))
>  			shouldsleep = 0;	/* We have an 
> event to process */


Hi,
I have experience a couple of timeout and resends and after 
sending another commands I get the response from the previous one, 
and the patch seems to solve a couple of those for me - 
still se some problem fetching packet from  firmware with ret = -22 though.
And it could be dependant on how much debug I have turned on..

But, shouldn't the above priv->event_fifo check move before
cur_cmd  as well?

I have no clue what kind of events we are talking about here and
if those can be processed independent of if a cmd is running or not,
just trigged on the comment.

Best regards
/Johan


