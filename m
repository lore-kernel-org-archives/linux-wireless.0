Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wolverine02.qualcomm.com ([199.106.114.251]:48637 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759917Ab2FUROi (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 21 Jun 2012 13:14:38 -0400
Date: Thu, 21 Jun 2012 10:14:34 -0700
From: "Pedersen, Thomas" <c_tpeder@qca.qualcomm.com>
To: Johannes Berg <johannes@sipsolutions.net>
CC: <linux-wireless@vger.kernel.org>
Subject: Re: [PATCH v3] nl80211: specify RSSI threshold in scheduled scan
Message-ID: <20120621171434.GA2822@pista> (sfid-20120621_191442_763279_6415E332)
References: <1340127208-3266-1-git-send-email-c_tpeder@qca.qualcomm.com>
 <1340180819.4655.27.camel@jlt3.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
In-Reply-To: <1340180819.4655.27.camel@jlt3.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jun 20, 2012 at 10:26:59AM +0200, Johannes Berg wrote:
> On Tue, 2012-06-19 at 10:33 -0700, Thomas Pedersen wrote:
> > Support configuring an RSSI threshold in dBm (s32) when requesting
> > scheduled scan, below which a BSS won't be reported by the cfg80211
> > driver.
> 
> > @@ -4241,7 +4242,7 @@ static int nl80211_start_sched_scan(struct sk_buff *skb,
> >  		nla_for_each_nested(attr,
> >  				    info->attrs[NL80211_ATTR_SCHED_SCAN_MATCH],
> >  				    tmp) {
> > -			struct nlattr *ssid;
> > +			struct nlattr *ssid, *rssi;
> >  
> >  			nla_parse(tb, NL80211_SCHED_SCAN_MATCH_ATTR_MAX,
> >  				  nla_data(attr), nla_len(attr),
> > @@ -4257,6 +4258,9 @@ static int nl80211_start_sched_scan(struct sk_buff *skb,
> >  				request->match_sets[i].ssid.ssid_len =
> >  					nla_len(ssid);
> >  			}
> > +			rssi = tb[NL80211_SCHED_SCAN_MATCH_ATTR_RSSI];
> > +			if (rssi)
> > +				request->rssi_thold = nla_get_u32(rssi);
> 
> I was going to apply this, but then I realized ... if userspace doesn't
> set the value then the default is 0 which is a bit useless, better set
> to a very small negative value or something, right?

OK. I was still treating the '0' threshold as "off" in the driver, but
this is more consistent. Will submit a v4 shortly.

Thanks,
Thomas
