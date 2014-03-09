Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtprelay0205.hostedemail.com ([216.40.44.205]:38752 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751897AbaCIHo1 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 9 Mar 2014 03:44:27 -0400
Message-ID: <1394351064.6972.41.camel@joe-AO722> (sfid-20140309_084431_199064_86EA3A99)
Subject: Re: [PATCH 5/6] ath6kl: remove a warning on a macro
From: Joe Perches <joe@perches.com>
To: Kalle Valo <kvalo@qca.qualcomm.com>
Cc: linux-wireless@vger.kernel.org, ath6kl@lists.infradead.org
Date: Sat, 08 Mar 2014 23:44:24 -0800
In-Reply-To: <1394349609.6972.39.camel@joe-AO722>
References: <20140309065606.10793.67068.stgit@x230>
	 <20140309065735.10793.45835.stgit@x230>
	 <87iornn8xx.fsf@kamboji.qca.qualcomm.com>
	 <1394349609.6972.39.camel@joe-AO722>
Content-Type: text/plain; charset="ISO-8859-1"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2014-03-08 at 23:20 -0800, Joe Perches wrote:
> On Sun, 2014-03-09 at 09:10 +0200, Kalle Valo wrote:
> > Hi Joe,
> 
> Hi Kalle.
> 
> > I would need help with this checkpatch warning:
> 
> No idea what the warning is.
> 
> > > --- a/drivers/net/wireless/ath/ath6kl/debug.c
> > > +++ b/drivers/net/wireless/ath/ath6kl/debug.c
> > > @@ -798,12 +798,10 @@ static ssize_t ath6kl_endpoint_stats_read(struct file *file,
> > >  		return -ENOMEM;
> > >  
> > >  #define EPSTAT(name)							\
> > > -	do {								\
> > > -		len = print_endpoint_stat(target, buf, buf_len, len,	\
> > > -					  offsetof(struct htc_endpoint_stats, \
> > > -						   name),		\
> > > -					  #name);			\
> > > -	} while (0)
> > > +	(len = print_endpoint_stat(target, buf, buf_len, len,		\
> > > +				   offsetof(struct htc_endpoint_stats,	\
> > > +					    name),			\
> > > +				   #name))
> > 
> > I wasn't quite able to figure out what is the preferred style here. I
> > don't see how the () style is any better, but checkpatch didn't complain
> > at least.
> 
> No idea what the preferred style is, but
> I'd probably change the #define to
> 
> #define EPSTAT(name)							\
> 	print_endpoint_stat(target, buf, buf_len, len,			\
> 			    offsetof(struct htc_endpoint_stats, name),	\
> 			    #name)
> 
> and the uses to
> 
> 	len = EPSTAT(whatever);

Or maybe this:

 drivers/net/wireless/ath/ath6kl/debug.c | 62 ++++++++++++++++-----------------
 1 file changed, 30 insertions(+), 32 deletions(-)

diff --git a/drivers/net/wireless/ath/ath6kl/debug.c b/drivers/net/wireless/ath/ath6kl/debug.c
index dbfd17d..7a6b476 100644
--- a/drivers/net/wireless/ath/ath6kl/debug.c
+++ b/drivers/net/wireless/ath/ath6kl/debug.c
@@ -771,16 +771,17 @@ static unsigned int print_endpoint_stat(struct htc_target *target, char *buf,
 	int i;
 	struct htc_endpoint_stats *ep_st;
 	u32 *counter;
+	unsigned int nlen = len;
 
-	len += scnprintf(buf + len, buf_len - len, "%s:", name);
+	nlen += scnprintf(buf + nlen, buf_len - nlen, "%s:", name);
 	for (i = 0; i < ENDPOINT_MAX; i++) {
 		ep_st = &target->endpoint[i].ep_st;
 		counter = ((u32 *) ep_st) + (offset / 4);
-		len += scnprintf(buf + len, buf_len - len, " %u", *counter);
+		nlen += scnprintf(buf + nlen, buf_len - nlen, " %u", *counter);
 	}
-	len += scnprintf(buf + len, buf_len - len, "\n");
+	nlen += scnprintf(buf + nlen, buf_len - nlen, "\n");
 
-	return len;
+	return nlen - len;
 }
 
 static ssize_t ath6kl_endpoint_stats_read(struct file *file,
@@ -800,34 +801,31 @@ static ssize_t ath6kl_endpoint_stats_read(struct file *file,
 		return -ENOMEM;
 
 #define EPSTAT(name)							\
-	do {								\
-		len = print_endpoint_stat(target, buf, buf_len, len,	\
-					  offsetof(struct htc_endpoint_stats, \
-						   name),		\
-					  #name);			\
-	} while (0)
-
-	EPSTAT(cred_low_indicate);
-	EPSTAT(tx_issued);
-	EPSTAT(tx_pkt_bundled);
-	EPSTAT(tx_bundles);
-	EPSTAT(tx_dropped);
-	EPSTAT(tx_cred_rpt);
-	EPSTAT(cred_rpt_from_rx);
-	EPSTAT(cred_rpt_from_other);
-	EPSTAT(cred_rpt_ep0);
-	EPSTAT(cred_from_rx);
-	EPSTAT(cred_from_other);
-	EPSTAT(cred_from_ep0);
-	EPSTAT(cred_cosumd);
-	EPSTAT(cred_retnd);
-	EPSTAT(rx_pkts);
-	EPSTAT(rx_lkahds);
-	EPSTAT(rx_bundl);
-	EPSTAT(rx_bundle_lkahd);
-	EPSTAT(rx_bundle_from_hdr);
-	EPSTAT(rx_alloc_thresh_hit);
-	EPSTAT(rxalloc_thresh_byte);
+	print_endpoint_stat(target, buf, buf_len, len,			\
+			    offsetof(struct htc_endpoint_stats, name),	\
+			    #name)
+
+	len += EPSTAT(cred_low_indicate);
+	len += EPSTAT(tx_issued);
+	len += EPSTAT(tx_pkt_bundled);
+	len += EPSTAT(tx_bundles);
+	len += EPSTAT(tx_dropped);
+	len += EPSTAT(tx_cred_rpt);
+	len += EPSTAT(cred_rpt_from_rx);
+	len += EPSTAT(cred_rpt_from_other);
+	len += EPSTAT(cred_rpt_ep0);
+	len += EPSTAT(cred_from_rx);
+	len += EPSTAT(cred_from_other);
+	len += EPSTAT(cred_from_ep0);
+	len += EPSTAT(cred_cosumd);
+	len += EPSTAT(cred_retnd);
+	len += EPSTAT(rx_pkts);
+	len += EPSTAT(rx_lkahds);
+	len += EPSTAT(rx_bundl);
+	len += EPSTAT(rx_bundle_lkahd);
+	len += EPSTAT(rx_bundle_from_hdr);
+	len += EPSTAT(rx_alloc_thresh_hit);
+	len += EPSTAT(rxalloc_thresh_byte);
 #undef EPSTAT
 
 	if (len > buf_len)


