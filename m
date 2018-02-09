Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wm0-f67.google.com ([74.125.82.67]:37133 "EHLO
        mail-wm0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750942AbeBIJtY (ORCPT
        <rfc822;linux-wireless@vger.kernel.org>);
        Fri, 9 Feb 2018 04:49:24 -0500
Received: by mail-wm0-f67.google.com with SMTP id v71so15097702wmv.2
        for <linux-wireless@vger.kernel.org>; Fri, 09 Feb 2018 01:49:24 -0800 (PST)
Date: Fri, 9 Feb 2018 10:49:21 +0100
From: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To: Jakub Kicinski <kubakici@wp.pl>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [PATCH 2/2] mt7601u: set device mac address in
 mt7601u_add_interface()
Message-ID: <20180209094920.GA2895@localhost.localdomain> (sfid-20180209_104930_896053_F735B7AA)
References: <cover.1518126991.git.lorenzo.bianconi@redhat.com>
 <c2fe73b04dac0827adf135e669ed441f9ed1d13c.1518126991.git.lorenzo.bianconi@redhat.com>
 <20180208150101.0e069f65@cakuba.netronome.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20180208150101.0e069f65@cakuba.netronome.com>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Feb 08, Jakub Kicinski wrote:
> On Thu,  8 Feb 2018 23:08:09 +0100, Lorenzo Bianconi wrote:
> > If mac80211 adds a vif with a different mac address respect to
> > the eeprom one, the device will not be able to connect to the ap
> > since the hw address has not been updated.
> > Fix the issue updating hw mac address in mt7601u_add_interface routine
> > 
> > BugLink: https://bugzilla.redhat.com/show_bug.cgi?id=1516935
> > Signed-off-by: Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
> > ---
> >  drivers/net/wireless/mediatek/mt7601u/main.c | 3 +++
> >  1 file changed, 3 insertions(+)
> > 
> > diff --git a/drivers/net/wireless/mediatek/mt7601u/main.c b/drivers/net/wireless/mediatek/mt7601u/main.c
> > index 43ebd460ba86..3c9ea40d9584 100644
> > --- a/drivers/net/wireless/mediatek/mt7601u/main.c
> > +++ b/drivers/net/wireless/mediatek/mt7601u/main.c
> > @@ -64,6 +64,9 @@ static int mt7601u_add_interface(struct ieee80211_hw *hw,
> >  	 */
> >  	mvif->idx = idx;
> >  
> > +	if (!ether_addr_equal(dev->macaddr, vif->addr))
> > +		mt7601u_set_macaddr(dev, vif->addr);
> > +
> >  	if (dev->wcid_mask[wcid / BITS_PER_LONG] & BIT(wcid % BITS_PER_LONG))
> >  		return -ENOSPC;
> >  	dev->wcid_mask[wcid / BITS_PER_LONG] |= BIT(wcid % BITS_PER_LONG);
> 
> Sorry, my recollection of mac80211 code is waning, but can't we have
> more than one vif as long as they are on the same channel?

Hi Jakub,

yep, you are right, but according to my understanding (please correct me if
it is wrong) current implementation supports just one interface in sta mode
(i.e. mvif->idx is always 0) so my patchset just fixes the issue highlighted
in the bugzilla since I do not know if the hw supports multiple concurrent vifs
in client mode. If so, I can extend the support to multiple client vifs if it is
a way to properly configure the rx filters to allow reception from multiple mac
addresses.

Regards,
Lorenzo
