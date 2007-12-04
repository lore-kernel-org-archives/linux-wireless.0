Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:56315 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753806AbXLDPJY (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 4 Dec 2007 10:09:24 -0500
Subject: Re: questions regarding removing the depencency on CONFIG_IEEE80211
From: Dan Williams <dcbw@redhat.com>
To: Holger Schurig <hs4233@mail.mn-solutions.de>
Cc: linux-wireless <linux-wireless@vger.kernel.org>,
	libertas-dev@lists.infradead.org
In-Reply-To: <200712041140.07516.hs4233@mail.mn-solutions.de>
References: <200712041140.07516.hs4233@mail.mn-solutions.de>
Content-Type: text/plain
Date: Tue, 04 Dec 2007 10:04:10 -0500
Message-Id: <1196780650.26155.26.camel@localhost.localdomain> (sfid-20071204_150929_492480_F537B2FD)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2007-12-04 at 11:40 +0100, Holger Schurig wrote:
> Last friday I was asked on IRC about the dependency of libertas 
> on CONFIG_IEEE80211. I gave a quick question, but today I had 
> time to look into this further.

The whole point of ripping all this stuff out of libertas and using the
stuff that was already out there was to avoid code duplication.  If you
can remove the dependency on ieee80211 without adding a whole bunch of
stuff back to libertas, that's great, go for it.  In the end, I think
the only actual symbols used are escape_essid and maybe one more.

> 1. simply things
> 
> * remove "select IEEE80211" in wireless/KConfig
> * remove "#include <net/ieee80211.h>"
> 
> 
> 2. MAX_WPA_IE_LEN
> 
> This was defined in net/ieee80211.h, but is not defined in 
> linux/ieee80211.h. I have two options, which one should I go:
> 
> * define it locally in some libertas header file
> * define it as IEEE80211_MAX_WPA_IE_LEN in linux/ieee80211.h

#2 is better here.  But I'm not actually sure that there _is_ a standard
defined maximum IE length.  I used this define because there was a
similar one in libertas and it was pointless to have two.

> 
> 3. MAX_NETWORK_COUNT
> 
> libertas has a list of found BSSses during scanning. It keeps 
> them in an kzalloc()'ed array. However, it doesn't use any of
> ieee80211's code for BSS or associating, so I guess I make this a 
> private define, e.g. LBS_MAX_BSS_COUNT.

Again, the point of using already defined stuff was to take code out of
libertas.  If this is in a header, it's pointless to move it back into
libertas.  I assume that the reason you want to remove the dep on
ieee80211 is to remove the requirement to load that module, which moving
this define back to libertas wouldn't accomplish.

If you'd like to propose moving this define to some other shared header
that would be better (linux/ieee80211.h?).  Libertas is not the only
driver that uses this define (ipw*, airo, libertas).


> 4. DEFAULT_MAX_SCAN_AGE
> 
> Again, libertas doesn't use any aging code from ieee80211, so I 
> guess I make this a libertas-private define.

No, but it does age the scan results after 15 seconds or something.  Or
at least it should.  It shouldn't be throwing any AP in the scan list
away until it's 15 seconds old.  This define was picked because it was
pointless to create yet another define when there was already a usable
and established one.

> 
> 5. MFIE_TYPE_xxxx enum
> 
> They are easily substituded with the proper WLAN_EID_xxx ones.

Yup; good catch.

> 6. struct ieee80211_info_element
> 
> In scan.c, libertas uses heavily the "struct 
> ieee80211_info_element". As this struct might be useful for 
> other non-max80211 drivers, I'd suggest putting it in 
> include/linux/ieee80211.h.

Probably good; again this was picked because it was already around and
contributed to code removal from libertas.  It was pointless to create
yet another structure for each BSS in libertas when there was already a
usable one sitting there.

> 7. RADIOTAP
> 
> Libertas contains lot's of code for it's monitoring mode, which 
> uses radiotap. It used "struct net_device *rtap_net_dev" 
> and "struct ieee80211_device *ieee". It contains code like
> 
>    priv->rtap_net_dev = alloc_ieee80211(0);
>    priv->ieee = netdev_priv(priv->rtap_net_dev);
> 
> and I don't have any knowledge about radiotap and how to 
> substitue the alloc_ieee80211(). All I could currently to is to 
> put those sections into #ifdef CONFIG_IEEE80211.

Javier might have more comments on this.

dan


