Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:59190 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751178Ab0HTJUX (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Aug 2010 05:20:23 -0400
Subject: Re: [PATCH 3/3] nl80211: New command for setting TX rate mask for
 rate control
From: Johannes Berg <johannes@sipsolutions.net>
To: Philip Prindeville <philipp_subx@redfish-solutions.com>
Cc: Jouni Malinen <jouni.malinen@atheros.com>,
	"John W. Linville" <linville@tuxdriver.com>,
	linux-wireless@vger.kernel.org, Jouni Malinen <j@w1.fi>
In-Reply-To: <4C6DA19B.7010606@redfish-solutions.com>
References: <20091229105945.GD18493@jm.kir.nu>
	 <4C6DA19B.7010606@redfish-solutions.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 20 Aug 2010 11:20:04 +0200
Message-ID: <1282296004.3785.25.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2010-08-19 at 14:26 -0700, Philip Prindeville wrote:

> > +	/*
> > +	 * The nested attribute uses enum nl80211_band as the index. This maps
> > +	 * directly to the enum ieee80211_band values used in cfg80211.
> > +	 */
> > +	nla_for_each_nested(tx_rates, info->attrs[NL80211_ATTR_TX_RATES], rem)
> > +	{
> > +		enum ieee80211_band band = nla_type(tx_rates);
> 
> Can this even work?  The first entry in nl80211_band is NL80211_BAND_2GHZ, i.e. zero.
> 
> Yet looking at libnl-1.1/lib/attr.c there's:
> 
> int nla_parse(struct nlattr *tb[], int maxtype, struct nlattr *head, int len,
>                struct nla_policy *policy)
> {
> ...
>          nla_for_each_attr(nla, head, len, rem) {
>                  int type = nla_type(nla);
> 
>                  if (type == 0) {

Well, notice how you're quoting code that does the same thing
(for_each_attr), but the latter code does the extra non-zero check,
which we don't.

We don't use nla_parse for this, we have to use
nla_parse_nested/for_each_attr. Yeah, it's a little quirky, but still
works fine.

johannes

