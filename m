Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:51214 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750944AbXLDRr4 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Dec 2007 12:47:56 -0500
Subject: Re: [RFC PATCH] [try 2] orinoco: more reliable scan handling
From: Dan Williams <dcbw@redhat.com>
To: Dave <kilroyd@googlemail.com>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <47489C2D.7030606@gmail.com>
References: <1191946643.20183.2.camel@localhost.localdomain>
	 <20071010183251.GK5962@tuxdriver.com>
	 <1192074985.31110.4.camel@localhost.localdomain>
	 <47489C2D.7030606@gmail.com>
Content-Type: text/plain
Date: Tue, 04 Dec 2007 12:42:46 -0500
Message-Id: <1196790166.14628.2.camel@localhost.localdomain> (sfid-20071204_174758_658024_709BE112)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sat, 2007-11-24 at 21:48 +0000, Dave wrote:
> 
> 
> Dan Williams wrote:
> > Bring scan result handling more in line with drivers like ipw.  Scan
> > results are aggregated and a BSS dropped after 15 seconds if no beacon
> > is received.  This allows the driver to interact better with userspace
> > where more than one process may request scans or results at any time.
> 
> I've only seen this recently, and am using it as a basis for some other changes. However I've noticed a couple issues:

Will clean up these and submit for 2.6.25 then, thanks.

Dan

> > +static int orinoco_process_scan_results(struct net_device *dev,
> > +					unsigned char *buf,
> > +					int len)
> > +{
>  <snip>
> > +		/* Try to update an existing bss first */
> > +		list_for_each_entry(bss, &priv->bss_list, list) {
> > +			if (compare_ether_addr(bss->bss.a.bssid, atom->a.bssid))
>                         if (!compare_ether_addr(bss->bss.a.bssid, atom->a.bssid))
> 
> So that we proceed to the next bss when ether_addr doesn't match. Otherwise this loop never matches.
> 
> > +				continue;
> > +			if (le16_to_cpu(bss->bss.a.essid_len) !=
> > +			      le16_to_cpu(atom->a.essid_len))
> > +				continue;
> > +			if (memcmp(bss->bss.a.essid, atom->a.essid,
> > +			      le16_to_cpu(atom->a.essid_len)))
> > +				continue;
>                         memcpy(&bss->bss, atom, sizeof(bss->bss);
> 
> So we actually update the scan results when we find an older set.
> 
> 
> HTH,
> 
> Dave.
> 
> PS. I couldn't figure how I could get a copy of this message to reply to, so this is going through gmane. Apologies if this confuses things, or doesn't come out right.
> 
> 
> -
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

