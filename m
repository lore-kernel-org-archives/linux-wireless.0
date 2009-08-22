Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from rhlx01.hs-esslingen.de ([129.143.116.10]:36677 "EHLO
	rhlx01.hs-esslingen.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755252AbZHVPKJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 22 Aug 2009 11:10:09 -0400
Date: Sat, 22 Aug 2009 17:10:09 +0200
From: Andreas Mohr <andi@lisas.de>
To: Bob Copeland <me@bobcopeland.com>
Cc: Andreas Mohr <andi@lisas.de>, ath5k-devel@lists.ath5k.org,
	linux-wireless@vger.kernel.org, Johannes Stezenbach <js@sig21.net>
Subject: Re: ath5k: ath5k_pci_probe(): weirdo code
Message-ID: <20090822151009.GA7779@rhlx01.hs-esslingen.de>
References: <20090821094732.GA970@rhlx01.hs-esslingen.de> <20090822133557.GB6762@hash.localnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
In-Reply-To: <20090822133557.GB6762@hash.localnet>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

On Sat, Aug 22, 2009 at 09:35:57AM -0400, Bob Copeland wrote:
> On Fri, Aug 21, 2009 at 11:47:32AM +0200, Andreas Mohr wrote:
> > Hello all,
> > 
> > that 2GHz/5GHz radio information code in ath5k_pci_probe() in 2.6.31-rc6
> > source seems VERY weird.

> ah_radio_{2,5}ghz_revision is what is in the appropriate registers in
> the card, but e.g. the revision in the 5ghz radio register may actually
> refer to the 2ghz radio on some 802.11B-only devices, depending on what
> is in the eeprom.

Ah, that explains why the logic was rather counter-intuitive.
Still, in OSS it is very common to have _other_ people modify code,
and with that kind of clarity things can thus go haywire easily
(unless a core maintainer happens to catch it after submission).

> Can you verify that the patch mentioned in the bug report works?

YES, I can verify that replacing those 2 §"§$%>: Hermei capacitors
with good Rubycon ones in one of my three WRT54G(S) worked. :-P
(global series failure, "Defective By Design _without_ even needing
to make use of DRM"). aka "Planned failure one year post warranty" ;)

It seems MUCH more reliable now, after some short testing...

> Can you supply /debug/ieee80211/phy0/stations/<...>/rc_stats?

[NOTE: not sure whether these ath5k module stats are (partially) still pre-repair]

root@andinet:/sys/kernel/debug/ieee80211/phy19/stations/00:0f:66:4c:c4:44# cat rc_stats

                                         ^^^^^ *wink* ;-)

rate     throughput  ewma prob   this prob  this succ/attempt   success    attempts
     1         0.9       97.6      100.0          0(  0)         20          20
     2         0.4       25.0      100.0          0(  0)          1           1
     5.5       0.0        0.0        0.0          0(  0)          0           0
    11         9.1       95.5      100.0          0(  0)         78          82
     6         0.0        0.0        0.0          0(  0)          0           0
     9         0.0        0.0        0.0          0(  0)          0           0
    12         2.7       25.0      100.0          0(  0)          1           1
    18         4.0       25.0      100.0          0(  0)          1           1
    24         5.3       25.0      100.0          0(  0)          1           1
    36         7.6       25.0      100.0          0(  0)          1           1
 t  48         7.0       77.6       50.0          0(  0)       1543        1685
T P 54        20.0       99.9      100.0          1(  1)     357588      398612

Total packet count::    ideal 8186      lookaround 909

> We need to queue that for 2.6.31.

Cannot test the patch right now since I cannot do a kernel build at this place.

> As do I.  I don't have a 2425 though, and there are quite some variations
> between each HW revision.

Which is quite the norm with todays hardware :-P
(I even once bought an ACX100 hardware with the wrong revision
- read: COMPLETELY different hardware - where I then found that the seller
had _both_ revision variants in the _SAME_ shelf box at the same time
and they were friggin' out themselves when I enlightened them about this fact...)
Not to mention the even much more HORRIBLE CRIME of assigning the SAME PCI ID even,
to DIFFERENT hardware, that some vendors dare to commit.

Andreas Mohr
