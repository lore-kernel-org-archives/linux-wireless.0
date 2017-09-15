Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:34342 "EHLO sipsolutions.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751152AbdIOHgN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 15 Sep 2017 03:36:13 -0400
Message-ID: <1505460971.31630.33.camel@sipsolutions.net> (sfid-20170915_093616_353975_6A76ABAB)
Subject: Re: [RFC 2/4] mac80211_hwsim: add hwsim_tx_rate_flags to Netlink
 Attributes
From: Johannes Berg <johannes@sipsolutions.net>
To: Benjamin Beichler <Benjamin.Beichler@uni-rostock.de>,
        linux-wireless@vger.kernel.org
Date: Fri, 15 Sep 2017 09:36:11 +0200
In-Reply-To: <91d055d9-0974-1d18-02d0-fc5dc59b949c@uni-rostock.de>
References: <20170908141137.3941-1-benjamin.beichler@uni-rostock.de>
         <fb18fe18-c780-4073-886f-9c16788391ee@MAIL1.uni-rostock.de>
         <1504880794.20347.3.camel@sipsolutions.net>
         <91d055d9-0974-1d18-02d0-fc5dc59b949c@uni-rostock.de>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, 2017-09-11 at 11:49 +0200, Benjamin Beichler wrote:

> I don't know what is the problem with the details. The only flag,
> which is a bit to verbose is  MAC80211_HWSIM_TX_RC_DUP_DATA, which we
> may omit. All others describe directly terms used in the IEEE 802.11
> standard. Also the representation, that a rate is an MCS-index is
> quite good. If you take look here http://mcsindex.com/ , the bitrate
> would be not sufficient to get the exact coding and fec rate,
> therefore you would also need additional flags. You are right
> regarding legacy rates, which are in an encoded table. I tried to
> decouple internal and external API, but currently there is no big
> difference.

Yeah, I was just concerned that maybe this API was too tightly coupled
to mac80211, but I guess it should be fine.

> Nonetheless the whole hwsim API is highly specialized and only usable
> with the linux kernel. Of course the Userland API should be more or
> less stable, but the backward compatibility is not touched by this
> change. As I already said, this is nearly a fix for hwsim, since
> currently it's impossible to differentiate between legacy and MCS-
> rates, although they could appear in a single tx_rates array. I think
> currently minstrel does not mix HT and legacy rates for data frames,
> but AFAIK Management/Action frames are always sent with legacy rates,
> so there are mixed already.

Ok.

johannes
